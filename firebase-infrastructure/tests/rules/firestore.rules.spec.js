const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
  cleanupTestEnvironment,
  withFunctionAuth,
} = require('@firebase/rules-unit-testing');
const { setDoc, getDoc, updateDoc, deleteDoc, doc } = require('firebase/firestore');
const fs = require('fs');
const path = require('path');

const PROJECT_ID = 'attendance-app-dev';
const firestoreRules = fs.readFileSync(path.resolve(__dirname, '../../rules/firestore.rules'), 'utf8');

describe('Firestore Security Rules', () => {
  let testEnv;

  beforeAll(async () => {
    testEnv = await initializeTestEnvironment({
      projectId: PROJECT_ID,
      firestore: {
        rules: firestoreRules,
        host: 'localhost',
        port: 8080,
      },
    });
  });

  afterAll(async () => {
    await cleanupTestEnvironment();
  });

  afterEach(async () => {
    await testEnv.clearFirestore();
  });

  const getFirestoreAs = (auth) => {
    if (!auth) {
      return testEnv.unauthenticatedContext().firestore();
    }
    return testEnv.authenticatedContext(auth.uid, auth.token).firestore();
  };

  // User definitions
  const TENANT_A_ID = 'tenant-a';
  const TENANT_B_ID = 'tenant-b';

  const tenantA_Admin = { uid: 'admin_a', token: { tenantId: TENANT_A_ID, role: 'Admin' } };
  const tenantA_Supervisor = { uid: 'supervisor_a', token: { tenantId: TENANT_A_ID, role: 'Supervisor' } };
  const tenantA_Subordinate = { uid: 'subordinate_a', token: { tenantId: TENANT_A_ID, role: 'Subordinate' } };
  const tenantA_Subordinate2 = { uid: 'subordinate_a2', token: { tenantId: TENANT_A_ID, role: 'Subordinate' } };

  const tenantB_Admin = { uid: 'admin_b', token: { tenantId: TENANT_B_ID, role: 'Admin' } };

  describe('Multi-tenancy Enforcement', () => {
    it('should DENY read/write access to data in another tenant', async () => {
      // Setup: Admin from Tenant B tries to access data in Tenant A
      const db = getFirestoreAs(tenantB_Admin);
      const userPath = `tenants/${TENANT_A_ID}/users/${tenantA_Admin.uid}`;
      const docRef = doc(db, userPath);
      
      await assertFails(getDoc(docRef));
      await assertFails(setDoc(docRef, { name: 'cross-tenant-write' }));
    });

    it('should ALLOW read/write access to data within the same tenant', async () => {
        // Setup: Admin from Tenant A tries to access data in Tenant A
        const adminDb = getFirestoreAs(tenantA_Admin);
        const userPath = `tenants/${TENANT_A_ID}/users/${tenantA_Subordinate.uid}`;
        const docRef = doc(adminDb, userPath);
        
        await testEnv.withSecurityRulesDisabled(async (context) => {
            await setDoc(doc(context.firestore(), userPath), { tenantId: TENANT_A_ID });
        });
        
        await assertSucceeds(getDoc(docRef));
    });
  });

  describe('AuditLog Collection Rules (REQ-1-028)', () => {
    const auditLogPath = `tenants/${TENANT_A_ID}/auditLog/log123`;

    beforeEach(async () => {
        await testEnv.withSecurityRulesDisabled(async (context) => {
            await setDoc(doc(context.firestore(), auditLogPath), {
                tenantId: TENANT_A_ID,
                action: 'test-create'
            });
        });
    });

    it('should ALLOW an Admin to read an audit log', async () => {
      const db = getFirestoreAs(tenantA_Admin);
      await assertSucceeds(getDoc(doc(db, auditLogPath)));
    });

    it('should DENY non-Admins from reading an audit log', async () => {
        const supervisorDb = getFirestoreAs(tenantA_Supervisor);
        const subordinateDb = getFirestoreAs(tenantA_Subordinate);
        await assertFails(getDoc(doc(supervisorDb, auditLogPath)));
        await assertFails(getDoc(doc(subordinateDb, auditLogPath)));
    });

    it('should DENY any user, including Admin, from updating an audit log', async () => {
      const db = getFirestoreAs(tenantA_Admin);
      await assertFails(updateDoc(doc(db, auditLogPath), { action: 'updated-action' }));
    });

    it('should DENY any user, including Admin, from deleting an audit log', async () => {
      const db = getFirestoreAs(tenantA_Admin);
      await assertFails(deleteDoc(doc(db, auditLogPath)));
    });

    it('should ALLOW creation of audit logs (simulating server/function role)', async () => {
        // This simulates a privileged environment like a Cloud Function
        const functionDb = withFunctionAuth(testEnv.authenticatedContext('function-runner')).firestore();
        const newLogPath = `tenants/${TENANT_A_ID}/auditLog/newLog`;
        await assertSucceeds(setDoc(doc(functionDb, newLogPath), { tenantId: TENANT_A_ID }));
    });
  });

  describe('Users Collection Rules', () => {
    const userPath = `tenants/${TENANT_A_ID}/users/${tenantA_Subordinate.uid}`;
    const supervisorPath = `tenants/${TENANT_A_ID}/users/${tenantA_Supervisor.uid}`;
    
    beforeEach(async () => {
      await testEnv.withSecurityRulesDisabled(async (context) => {
        const fs = context.firestore();
        await setDoc(doc(fs, userPath), { 
            tenantId: TENANT_A_ID, 
            supervisorId: tenantA_Supervisor.uid, 
            role: 'Subordinate' 
        });
        await setDoc(doc(fs, supervisorPath), {
            tenantId: TENANT_A_ID,
            role: 'Supervisor'
        });
      });
    });

    // Subordinate rules
    it('should ALLOW a Subordinate to read their own user document', async () => {
        const db = getFirestoreAs(tenantA_Subordinate);
        await assertSucceeds(getDoc(doc(db, userPath)));
    });

    it('should DENY a Subordinate from reading another user document', async () => {
        const db = getFirestoreAs(tenantA_Subordinate);
        await assertFails(getDoc(doc(db, supervisorPath)));
    });

    it('should ALLOW a Subordinate to update their own non-critical profile fields', async () => {
        const db = getFirestoreAs(tenantA_Subordinate);
        await assertSucceeds(updateDoc(doc(db, userPath), { phone: '123-456-7890' }));
    });

    it('should DENY a Subordinate from changing their role or supervisorId', async () => {
        const db = getFirestoreAs(tenantA_Subordinate);
        await assertFails(updateDoc(doc(db, userPath), { role: 'Admin' }));
        await assertFails(updateDoc(doc(db, userPath), { supervisorId: 'new-supervisor' }));
    });

    // Supervisor rules
    it('should ALLOW a Supervisor to read their own user document', async () => {
        const db = getFirestoreAs(tenantA_Supervisor);
        await assertSucceeds(getDoc(doc(db, supervisorPath)));
    });

    it('should ALLOW a Supervisor to read their direct subordinate user document', async () => {
        const db = getFirestoreAs(tenantA_Supervisor);
        await assertSucceeds(getDoc(doc(db, userPath)));
    });

    it('should DENY a Supervisor from reading a user who is not their subordinate', async () => {
        const otherUserPath = `tenants/${TENANT_A_ID}/users/other_user`;
        await testEnv.withSecurityRulesDisabled(async (context) => {
            await setDoc(doc(context.firestore(), otherUserPath), { tenantId: TENANT_A_ID, supervisorId: 'another_supervisor' });
        });
        const db = getFirestoreAs(tenantA_Supervisor);
        await assertFails(getDoc(doc(db, otherUserPath)));
    });

    // Admin rules
    it('should ALLOW an Admin to read any user document in their tenant', async () => {
        const db = getFirestoreAs(tenantA_Admin);
        await assertSucceeds(getDoc(doc(db, userPath)));
        await assertSucceeds(getDoc(doc(db, supervisorPath)));
    });

    it('should ALLOW an Admin to write to any user document in their tenant', async () => {
        const db = getFirestoreAs(tenantA_Admin);
        await assertSucceeds(updateDoc(doc(db, userPath), { role: 'Supervisor', supervisorId: 'new-supervisor' }));
    });
  });

  describe('Attendance Collection Rules', () => {
    const attendancePath = `tenants/${TENANT_A_ID}/attendance/att123`;
    const otherAttendancePath = `tenants/${TENANT_A_ID}/attendance/att456`;
    
    beforeEach(async () => {
      await testEnv.withSecurityRulesDisabled(async (context) => {
        const fs = context.firestore();
        await setDoc(doc(fs, attendancePath), { 
            tenantId: TENANT_A_ID,
            userId: tenantA_Subordinate.uid,
            supervisorId: tenantA_Supervisor.uid, 
            status: 'pending' 
        });
        await setDoc(doc(fs, otherAttendancePath), { 
            tenantId: TENANT_A_ID,
            userId: tenantA_Subordinate2.uid, // Different user
            supervisorId: 'another_supervisor', 
            status: 'pending' 
        });
        // Need user doc for supervisor check
        await setDoc(doc(fs, `tenants/${TENANT_A_ID}/users/${tenantA_Subordinate.uid}`), { supervisorId: tenantA_Supervisor.uid });
      });
    });

    it('should ALLOW a Subordinate to create their own attendance record', async () => {
        const db = getFirestoreAs(tenantA_Subordinate);
        const newRecordRef = doc(db, `tenants/${TENANT_A_ID}/attendance/new_att`);
        await assertSucceeds(setDoc(newRecordRef, { 
            tenantId: TENANT_A_ID, 
            userId: tenantA_Subordinate.uid, 
            status: 'pending'
        }));
    });

    it('should DENY a Subordinate from creating an attendance record for someone else', async () => {
        const db = getFirestoreAs(tenantA_Subordinate);
        const newRecordRef = doc(db, `tenants/${TENANT_A_ID}/attendance/new_att_fraud`);
        await assertFails(setDoc(newRecordRef, { 
            tenantId: TENANT_A_ID, 
            userId: tenantA_Supervisor.uid, // Trying to create for supervisor
            status: 'pending'
        }));
    });
    
    it('should ALLOW a Subordinate to read their own attendance records', async () => {
        const db = getFirestoreAs(tenantA_Subordinate);
        await assertSucceeds(getDoc(doc(db, attendancePath)));
    });

    it('should ALLOW a Supervisor to read their subordinate attendance records', async () => {
        const db = getFirestoreAs(tenantA_Supervisor);
        await assertSucceeds(getDoc(doc(db, attendancePath)));
    });

    it('should DENY a Supervisor from reading attendance of users not in their team', async () => {
        const db = getFirestoreAs(tenantA_Supervisor);
        await assertFails(getDoc(doc(db, otherAttendancePath)));
    });

    it('should ALLOW a Supervisor to update (approve/reject) their subordinate attendance record', async () => {
        const db = getFirestoreAs(tenantA_Supervisor);
        await assertSucceeds(updateDoc(doc(db, attendancePath), { status: 'approved' }));
    });
    
    it('should ALLOW an Admin to read and update any attendance record', async () => {
        const db = getFirestoreAs(tenantA_Admin);
        await assertSucceeds(getDoc(doc(db, attendancePath)));
        await assertSucceeds(getDoc(doc(db, otherAttendancePath)));
        await assertSucceeds(updateDoc(doc(db, attendancePath), { status: 'approved', notes: 'Admin override' }));
    });
  });

  describe('Teams Collection Rules', () => {
    const teamPath = `tenants/${TENANT_A_ID}/teams/team123`;
    
    beforeEach(async () => {
      await testEnv.withSecurityRulesDisabled(async (context) => {
        await setDoc(doc(context.firestore(), teamPath), { 
            tenantId: TENANT_A_ID,
            supervisorId: tenantA_Supervisor.uid
        });
      });
    });

    it('should ALLOW any tenant member to read team data', async () => {
        const subordinateDb = getFirestoreAs(tenantA_Subordinate);
        const supervisorDb = getFirestoreAs(tenantA_Supervisor);
        await assertSucceeds(getDoc(doc(subordinateDb, teamPath)));
        await assertSucceeds(getDoc(doc(supervisorDb, teamPath)));
    });

    it('should ALLOW an Admin to create and delete teams', async () => {
        const db = getFirestoreAs(tenantA_Admin);
        const newTeamPath = `tenants/${TENANT_A_ID}/teams/new_team`;
        await assertSucceeds(setDoc(doc(db, newTeamPath), { tenantId: TENANT_A_ID, supervisorId: tenantA_Supervisor.uid }));
        await assertSucceeds(deleteDoc(doc(db, teamPath)));
    });

    it('should DENY a Supervisor from creating or deleting teams', async () => {
        const db = getFirestoreAs(tenantA_Supervisor);
        const newTeamPath = `tenants/${TENANT_A_ID}/teams/new_team_fail`;
        await assertFails(setDoc(doc(db, newTeamPath), { tenantId: TENANT_A_ID, supervisorId: tenantA_Supervisor.uid }));
        await assertFails(deleteDoc(doc(db, teamPath)));
    });

    it('should ALLOW the assigned Supervisor to update their own team', async () => {
        const db = getFirestoreAs(tenantA_Supervisor);
        await assertSucceeds(updateDoc(doc(db, teamPath), { name: 'Updated Team Name' }));
    });

    it('should DENY a different Supervisor from updating a team they do not manage', async () => {
        const anotherSupervisor = { uid: 'supervisor_b', token: { tenantId: TENANT_A_ID, role: 'Supervisor' } };
        const db = getFirestoreAs(anotherSupervisor);
        await assertFails(updateDoc(doc(db, teamPath), { name: 'Failed Update' }));
    });
  });

  describe('Config Collection Rules', () => {
    const configPath = `tenants/${TENANT_A_ID}/config/settings`;
    
    beforeEach(async () => {
        await testEnv.withSecurityRulesDisabled(async (context) => {
            await setDoc(doc(context.firestore(), configPath), { tenantId: TENANT_A_ID, timezone: 'UTC' });
        });
    });

    it('should ALLOW an Admin to read and write config', async () => {
        const db = getFirestoreAs(tenantA_Admin);
        await assertSucceeds(getDoc(doc(db, configPath)));
        await assertSucceeds(updateDoc(doc(db, configPath), { timezone: 'America/New_York' }));
    });

    it('should DENY non-Admins from reading or writing config', async () => {
        const supervisorDb = getFirestoreAs(tenantA_Supervisor);
        const subordinateDb = getFirestoreAs(tenantA_Subordinate);
        
        await assertFails(getDoc(doc(supervisorDb, configPath)));
        await assertFails(updateDoc(doc(supervisorDb, configPath), { timezone: 'fail' }));
        
        await assertFails(getDoc(doc(subordinateDb, configPath)));
        await assertFails(updateDoc(doc(subordinateDb, configPath), { timezone: 'fail' }));
    });
  });
});