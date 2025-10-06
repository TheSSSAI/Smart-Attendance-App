# 1 Title

Primary Application Database (Firestore)

# 2 Name

app_main_firestore_db

# 3 Db Type

- document
- multimodel

# 4 Db Technology

Firestore

# 5 Entities

## 5.1 Tenant

### 5.1.1 Name

Tenant

### 5.1.2 Description

Top-level document representing a single customer organization. Acts as the root for all of that organization's data via sub-collections. (REQ-1-002, REQ-DAT-001)

### 5.1.3 Attributes

#### 5.1.3.1 tenantId

##### 5.1.3.1.1 Name

tenantId

##### 5.1.3.1.2 Type

🔹 String

##### 5.1.3.1.3 Is Required

✅ Yes

##### 5.1.3.1.4 Is Primary Key

✅ Yes

##### 5.1.3.1.5 Size

0

##### 5.1.3.1.6 Is Unique

✅ Yes

##### 5.1.3.1.7 Constraints

- Document ID

##### 5.1.3.1.8 Precision

0

##### 5.1.3.1.9 Scale

0

##### 5.1.3.1.10 Is Foreign Key

❌ No

#### 5.1.3.2.0 name

##### 5.1.3.2.1 Name

name

##### 5.1.3.2.2 Type

🔹 String

##### 5.1.3.2.3 Is Required

✅ Yes

##### 5.1.3.2.4 Is Primary Key

❌ No

##### 5.1.3.2.5 Size

255

##### 5.1.3.2.6 Is Unique

✅ Yes

##### 5.1.3.2.7 Constraints

*No items available*

##### 5.1.3.2.8 Precision

0

##### 5.1.3.2.9 Scale

0

##### 5.1.3.2.10 Is Foreign Key

❌ No

#### 5.1.3.3.0 status

##### 5.1.3.3.1 Name

status

##### 5.1.3.3.2 Type

🔹 String

##### 5.1.3.3.3 Is Required

✅ Yes

##### 5.1.3.3.4 Is Primary Key

❌ No

##### 5.1.3.3.5 Size

50

##### 5.1.3.3.6 Is Unique

❌ No

##### 5.1.3.3.7 Constraints

- Allowed values: 'active', 'pending_deletion', 'deleted'

##### 5.1.3.3.8 Precision

0

##### 5.1.3.3.9 Scale

0

##### 5.1.3.3.10 Is Foreign Key

❌ No

#### 5.1.3.4.0 deletionRequestedAt

##### 5.1.3.4.1 Name

deletionRequestedAt

##### 5.1.3.4.2 Type

🔹 Timestamp

##### 5.1.3.4.3 Is Required

❌ No

##### 5.1.3.4.4 Is Primary Key

❌ No

##### 5.1.3.4.5 Size

0

##### 5.1.3.4.6 Is Unique

❌ No

##### 5.1.3.4.7 Constraints

*No items available*

##### 5.1.3.4.8 Precision

0

##### 5.1.3.4.9 Scale

0

##### 5.1.3.4.10 Is Foreign Key

❌ No

#### 5.1.3.5.0 gcpRegion

##### 5.1.3.5.1 Name

gcpRegion

##### 5.1.3.5.2 Type

🔹 String

##### 5.1.3.5.3 Is Required

✅ Yes

##### 5.1.3.5.4 Is Primary Key

❌ No

##### 5.1.3.5.5 Size

100

##### 5.1.3.5.6 Is Unique

❌ No

##### 5.1.3.5.7 Constraints

*No items available*

##### 5.1.3.5.8 Precision

0

##### 5.1.3.5.9 Scale

0

##### 5.1.3.5.10 Is Foreign Key

❌ No

#### 5.1.3.6.0 subscriptionPlanId

##### 5.1.3.6.1 Name

subscriptionPlanId

##### 5.1.3.6.2 Type

🔹 String

##### 5.1.3.6.3 Is Required

✅ Yes

##### 5.1.3.6.4 Is Primary Key

❌ No

##### 5.1.3.6.5 Size

0

##### 5.1.3.6.6 Is Unique

❌ No

##### 5.1.3.6.7 Constraints

*No items available*

##### 5.1.3.6.8 Precision

0

##### 5.1.3.6.9 Scale

0

##### 5.1.3.6.10 Is Foreign Key

✅ Yes

#### 5.1.3.7.0 createdAt

##### 5.1.3.7.1 Name

createdAt

##### 5.1.3.7.2 Type

🔹 Timestamp

##### 5.1.3.7.3 Is Required

✅ Yes

##### 5.1.3.7.4 Is Primary Key

❌ No

##### 5.1.3.7.5 Size

0

##### 5.1.3.7.6 Is Unique

❌ No

##### 5.1.3.7.7 Constraints

*No items available*

##### 5.1.3.7.8 Precision

0

##### 5.1.3.7.9 Scale

0

##### 5.1.3.7.10 Is Foreign Key

❌ No

#### 5.1.3.8.0 updatedAt

##### 5.1.3.8.1 Name

updatedAt

##### 5.1.3.8.2 Type

🔹 Timestamp

##### 5.1.3.8.3 Is Required

✅ Yes

##### 5.1.3.8.4 Is Primary Key

❌ No

##### 5.1.3.8.5 Size

0

##### 5.1.3.8.6 Is Unique

❌ No

##### 5.1.3.8.7 Constraints

*No items available*

##### 5.1.3.8.8 Precision

0

##### 5.1.3.8.9 Scale

0

##### 5.1.3.8.10 Is Foreign Key

❌ No

### 5.1.4.0.0 Primary Keys

- tenantId

### 5.1.5.0.0 Unique Constraints

- {'name': 'UC_Tenant_Name', 'columns': ['name']}

### 5.1.6.0.0 Indexes

- {'name': 'IX_Tenant_Status_DeletionTime', 'columns': ['status', 'deletionRequestedAt'], 'type': 'Composite'}

## 5.2.0.0.0 User

### 5.2.1.0.0 Name

User

### 5.2.2.0.0 Description

Represents a user within a tenant. Stored in a sub-collection: /tenants/{tenantId}/users/{userId}. The document ID {userId} matches the Firebase Auth UID. (REQ-1-003)

### 5.2.3.0.0 Attributes

#### 5.2.3.1.0 userId

##### 5.2.3.1.1 Name

userId

##### 5.2.3.1.2 Type

🔹 String

##### 5.2.3.1.3 Is Required

✅ Yes

##### 5.2.3.1.4 Is Primary Key

✅ Yes

##### 5.2.3.1.5 Size

0

##### 5.2.3.1.6 Is Unique

✅ Yes

##### 5.2.3.1.7 Constraints

- Document ID, matches Firebase Auth UID

##### 5.2.3.1.8 Precision

0

##### 5.2.3.1.9 Scale

0

##### 5.2.3.1.10 Is Foreign Key

❌ No

#### 5.2.3.2.0 email

##### 5.2.3.2.1 Name

email

##### 5.2.3.2.2 Type

🔹 String

##### 5.2.3.2.3 Is Required

✅ Yes

##### 5.2.3.2.4 Is Primary Key

❌ No

##### 5.2.3.2.5 Size

255

##### 5.2.3.2.6 Is Unique

❌ No

##### 5.2.3.2.7 Constraints

- Uniqueness is scoped to the tenant

##### 5.2.3.2.8 Precision

0

##### 5.2.3.2.9 Scale

0

##### 5.2.3.2.10 Is Foreign Key

❌ No

#### 5.2.3.3.0 firstName

##### 5.2.3.3.1 Name

firstName

##### 5.2.3.3.2 Type

🔹 String

##### 5.2.3.3.3 Is Required

✅ Yes

##### 5.2.3.3.4 Is Primary Key

❌ No

##### 5.2.3.3.5 Size

100

##### 5.2.3.3.6 Is Unique

❌ No

##### 5.2.3.3.7 Constraints

*No items available*

##### 5.2.3.3.8 Precision

0

##### 5.2.3.3.9 Scale

0

##### 5.2.3.3.10 Is Foreign Key

❌ No

#### 5.2.3.4.0 lastName

##### 5.2.3.4.1 Name

lastName

##### 5.2.3.4.2 Type

🔹 String

##### 5.2.3.4.3 Is Required

✅ Yes

##### 5.2.3.4.4 Is Primary Key

❌ No

##### 5.2.3.4.5 Size

100

##### 5.2.3.4.6 Is Unique

❌ No

##### 5.2.3.4.7 Constraints

*No items available*

##### 5.2.3.4.8 Precision

0

##### 5.2.3.4.9 Scale

0

##### 5.2.3.4.10 Is Foreign Key

❌ No

#### 5.2.3.5.0 fullName

##### 5.2.3.5.1 Name

fullName

##### 5.2.3.5.2 Type

🔹 String

##### 5.2.3.5.3 Is Required

✅ Yes

##### 5.2.3.5.4 Is Primary Key

❌ No

##### 5.2.3.5.5 Size

201

##### 5.2.3.5.6 Is Unique

❌ No

##### 5.2.3.5.7 Constraints

- Denormalized for search and display

##### 5.2.3.5.8 Precision

0

##### 5.2.3.5.9 Scale

0

##### 5.2.3.5.10 Is Foreign Key

❌ No

#### 5.2.3.6.0 phoneNumber

##### 5.2.3.6.1 Name

phoneNumber

##### 5.2.3.6.2 Type

🔹 String

##### 5.2.3.6.3 Is Required

❌ No

##### 5.2.3.6.4 Is Primary Key

❌ No

##### 5.2.3.6.5 Size

20

##### 5.2.3.6.6 Is Unique

❌ No

##### 5.2.3.6.7 Constraints

*No items available*

##### 5.2.3.6.8 Precision

0

##### 5.2.3.6.9 Scale

0

##### 5.2.3.6.10 Is Foreign Key

❌ No

#### 5.2.3.7.0 role

##### 5.2.3.7.1 Name

role

##### 5.2.3.7.2 Type

🔹 String

##### 5.2.3.7.3 Is Required

✅ Yes

##### 5.2.3.7.4 Is Primary Key

❌ No

##### 5.2.3.7.5 Size

50

##### 5.2.3.7.6 Is Unique

❌ No

##### 5.2.3.7.7 Constraints

- Allowed values: 'Admin', 'Supervisor', 'Subordinate'

##### 5.2.3.7.8 Precision

0

##### 5.2.3.7.9 Scale

0

##### 5.2.3.7.10 Is Foreign Key

❌ No

#### 5.2.3.8.0 status

##### 5.2.3.8.1 Name

status

##### 5.2.3.8.2 Type

🔹 String

##### 5.2.3.8.3 Is Required

✅ Yes

##### 5.2.3.8.4 Is Primary Key

❌ No

##### 5.2.3.8.5 Size

50

##### 5.2.3.8.6 Is Unique

❌ No

##### 5.2.3.8.7 Constraints

- Allowed values: 'invited', 'active', 'deactivated'

##### 5.2.3.8.8 Precision

0

##### 5.2.3.8.9 Scale

0

##### 5.2.3.8.10 Is Foreign Key

❌ No

#### 5.2.3.9.0 supervisorId

##### 5.2.3.9.1 Name

supervisorId

##### 5.2.3.9.2 Type

🔹 String

##### 5.2.3.9.3 Is Required

❌ No

##### 5.2.3.9.4 Is Primary Key

❌ No

##### 5.2.3.9.5 Size

0

##### 5.2.3.9.6 Is Unique

❌ No

##### 5.2.3.9.7 Constraints

*No items available*

##### 5.2.3.9.8 Precision

0

##### 5.2.3.9.9 Scale

0

##### 5.2.3.9.10 Is Foreign Key

✅ Yes

#### 5.2.3.10.0 hierarchyPath

##### 5.2.3.10.1 Name

hierarchyPath

##### 5.2.3.10.2 Type

🔹 Array<String>

##### 5.2.3.10.3 Is Required

❌ No

##### 5.2.3.10.4 Is Primary Key

❌ No

##### 5.2.3.10.5 Size

0

##### 5.2.3.10.6 Is Unique

❌ No

##### 5.2.3.10.7 Constraints

- Denormalized array of supervisor UIDs for efficient hierarchy queries

##### 5.2.3.10.8 Precision

0

##### 5.2.3.10.9 Scale

0

##### 5.2.3.10.10 Is Foreign Key

❌ No

#### 5.2.3.11.0 teamIds

##### 5.2.3.11.1 Name

teamIds

##### 5.2.3.11.2 Type

🔹 Array<String>

##### 5.2.3.11.3 Is Required

❌ No

##### 5.2.3.11.4 Is Primary Key

❌ No

##### 5.2.3.11.5 Size

0

##### 5.2.3.11.6 Is Unique

❌ No

##### 5.2.3.11.7 Constraints

- Denormalized list of team IDs the user belongs to

##### 5.2.3.11.8 Precision

0

##### 5.2.3.11.9 Scale

0

##### 5.2.3.11.10 Is Foreign Key

❌ No

#### 5.2.3.12.0 invitationToken

##### 5.2.3.12.1 Name

invitationToken

##### 5.2.3.12.2 Type

🔹 String

##### 5.2.3.12.3 Is Required

❌ No

##### 5.2.3.12.4 Is Primary Key

❌ No

##### 5.2.3.12.5 Size

255

##### 5.2.3.12.6 Is Unique

✅ Yes

##### 5.2.3.12.7 Constraints

*No items available*

##### 5.2.3.12.8 Precision

0

##### 5.2.3.12.9 Scale

0

##### 5.2.3.12.10 Is Foreign Key

❌ No

#### 5.2.3.13.0 invitationExpiresAt

##### 5.2.3.13.1 Name

invitationExpiresAt

##### 5.2.3.13.2 Type

🔹 Timestamp

##### 5.2.3.13.3 Is Required

❌ No

##### 5.2.3.13.4 Is Primary Key

❌ No

##### 5.2.3.13.5 Size

0

##### 5.2.3.13.6 Is Unique

❌ No

##### 5.2.3.13.7 Constraints

*No items available*

##### 5.2.3.13.8 Precision

0

##### 5.2.3.13.9 Scale

0

##### 5.2.3.13.10 Is Foreign Key

❌ No

#### 5.2.3.14.0 deactivatedAt

##### 5.2.3.14.1 Name

deactivatedAt

##### 5.2.3.14.2 Type

🔹 Timestamp

##### 5.2.3.14.3 Is Required

❌ No

##### 5.2.3.14.4 Is Primary Key

❌ No

##### 5.2.3.14.5 Size

0

##### 5.2.3.14.6 Is Unique

❌ No

##### 5.2.3.14.7 Constraints

*No items available*

##### 5.2.3.14.8 Precision

0

##### 5.2.3.14.9 Scale

0

##### 5.2.3.14.10 Is Foreign Key

❌ No

#### 5.2.3.15.0 createdAt

##### 5.2.3.15.1 Name

createdAt

##### 5.2.3.15.2 Type

🔹 Timestamp

##### 5.2.3.15.3 Is Required

✅ Yes

##### 5.2.3.15.4 Is Primary Key

❌ No

##### 5.2.3.15.5 Size

0

##### 5.2.3.15.6 Is Unique

❌ No

##### 5.2.3.15.7 Constraints

*No items available*

##### 5.2.3.15.8 Precision

0

##### 5.2.3.15.9 Scale

0

##### 5.2.3.15.10 Is Foreign Key

❌ No

#### 5.2.3.16.0 updatedAt

##### 5.2.3.16.1 Name

updatedAt

##### 5.2.3.16.2 Type

🔹 Timestamp

##### 5.2.3.16.3 Is Required

✅ Yes

##### 5.2.3.16.4 Is Primary Key

❌ No

##### 5.2.3.16.5 Size

0

##### 5.2.3.16.6 Is Unique

❌ No

##### 5.2.3.16.7 Constraints

*No items available*

##### 5.2.3.16.8 Precision

0

##### 5.2.3.16.9 Scale

0

##### 5.2.3.16.10 Is Foreign Key

❌ No

### 5.2.4.0.0 Primary Keys

- userId

### 5.2.5.0.0 Unique Constraints

*No items available*

### 5.2.6.0.0 Indexes

#### 5.2.6.1.0 IX_User_Email

##### 5.2.6.1.1 Name

IX_User_Email

##### 5.2.6.1.2 Columns

- email

##### 5.2.6.1.3 Type

🔹 Single-Field

#### 5.2.6.2.0 IX_User_SupervisorId

##### 5.2.6.2.1 Name

IX_User_SupervisorId

##### 5.2.6.2.2 Columns

- supervisorId

##### 5.2.6.2.3 Type

🔹 Single-Field

#### 5.2.6.3.0 IX_User_TeamIds

##### 5.2.6.3.1 Name

IX_User_TeamIds

##### 5.2.6.3.2 Columns

- teamIds

##### 5.2.6.3.3 Type

🔹 Array-Contains

#### 5.2.6.4.0 IX_User_Status_DeactivatedAt

##### 5.2.6.4.1 Name

IX_User_Status_DeactivatedAt

##### 5.2.6.4.2 Columns

- status
- deactivatedAt

##### 5.2.6.4.3 Type

🔹 Composite

## 5.3.0.0.0 Team

### 5.3.1.0.0 Name

Team

### 5.3.2.0.0 Description

A logical grouping of users. Stored in a sub-collection: /tenants/{tenantId}/teams/{teamId}. (REQ-1-015)

### 5.3.3.0.0 Attributes

#### 5.3.3.1.0 teamId

##### 5.3.3.1.1 Name

teamId

##### 5.3.3.1.2 Type

🔹 String

##### 5.3.3.1.3 Is Required

✅ Yes

##### 5.3.3.1.4 Is Primary Key

✅ Yes

##### 5.3.3.1.5 Size

0

##### 5.3.3.1.6 Is Unique

✅ Yes

##### 5.3.3.1.7 Constraints

- Document ID

##### 5.3.3.1.8 Precision

0

##### 5.3.3.1.9 Scale

0

##### 5.3.3.1.10 Is Foreign Key

❌ No

#### 5.3.3.2.0 name

##### 5.3.3.2.1 Name

name

##### 5.3.3.2.2 Type

🔹 String

##### 5.3.3.2.3 Is Required

✅ Yes

##### 5.3.3.2.4 Is Primary Key

❌ No

##### 5.3.3.2.5 Size

255

##### 5.3.3.2.6 Is Unique

❌ No

##### 5.3.3.2.7 Constraints

*No items available*

##### 5.3.3.2.8 Precision

0

##### 5.3.3.2.9 Scale

0

##### 5.3.3.2.10 Is Foreign Key

❌ No

#### 5.3.3.3.0 supervisorId

##### 5.3.3.3.1 Name

supervisorId

##### 5.3.3.3.2 Type

🔹 String

##### 5.3.3.3.3 Is Required

✅ Yes

##### 5.3.3.3.4 Is Primary Key

❌ No

##### 5.3.3.3.5 Size

0

##### 5.3.3.3.6 Is Unique

❌ No

##### 5.3.3.3.7 Constraints

*No items available*

##### 5.3.3.3.8 Precision

0

##### 5.3.3.3.9 Scale

0

##### 5.3.3.3.10 Is Foreign Key

✅ Yes

#### 5.3.3.4.0 memberIds

##### 5.3.3.4.1 Name

memberIds

##### 5.3.3.4.2 Type

🔹 Array<String>

##### 5.3.3.4.3 Is Required

❌ No

##### 5.3.3.4.4 Is Primary Key

❌ No

##### 5.3.3.4.5 Size

0

##### 5.3.3.4.6 Is Unique

❌ No

##### 5.3.3.4.7 Constraints

- Denormalized list of user IDs who are members

##### 5.3.3.4.8 Precision

0

##### 5.3.3.4.9 Scale

0

##### 5.3.3.4.10 Is Foreign Key

❌ No

#### 5.3.3.5.0 createdAt

##### 5.3.3.5.1 Name

createdAt

##### 5.3.3.5.2 Type

🔹 Timestamp

##### 5.3.3.5.3 Is Required

✅ Yes

##### 5.3.3.5.4 Is Primary Key

❌ No

##### 5.3.3.5.5 Size

0

##### 5.3.3.5.6 Is Unique

❌ No

##### 5.3.3.5.7 Constraints

*No items available*

##### 5.3.3.5.8 Precision

0

##### 5.3.3.5.9 Scale

0

##### 5.3.3.5.10 Is Foreign Key

❌ No

#### 5.3.3.6.0 updatedAt

##### 5.3.3.6.1 Name

updatedAt

##### 5.3.3.6.2 Type

🔹 Timestamp

##### 5.3.3.6.3 Is Required

✅ Yes

##### 5.3.3.6.4 Is Primary Key

❌ No

##### 5.3.3.6.5 Size

0

##### 5.3.3.6.6 Is Unique

❌ No

##### 5.3.3.6.7 Constraints

*No items available*

##### 5.3.3.6.8 Precision

0

##### 5.3.3.6.9 Scale

0

##### 5.3.3.6.10 Is Foreign Key

❌ No

### 5.3.4.0.0 Primary Keys

- teamId

### 5.3.5.0.0 Unique Constraints

*No items available*

### 5.3.6.0.0 Indexes

#### 5.3.6.1.0 IX_Team_SupervisorId

##### 5.3.6.1.1 Name

IX_Team_SupervisorId

##### 5.3.6.1.2 Columns

- supervisorId

##### 5.3.6.1.3 Type

🔹 Single-Field

#### 5.3.6.2.0 IX_Team_MemberIds

##### 5.3.6.2.1 Name

IX_Team_MemberIds

##### 5.3.6.2.2 Columns

- memberIds

##### 5.3.6.2.3 Type

🔹 Array-Contains

## 5.4.0.0.0 AttendanceRecord

### 5.4.1.0.0 Name

AttendanceRecord

### 5.4.2.0.0 Description

A single attendance entry. Stored in a tenant-level sub-collection for efficient querying by supervisors: /tenants/{tenantId}/attendanceRecords/{attendanceRecordId}. (REQ-1-004)

### 5.4.3.0.0 Attributes

#### 5.4.3.1.0 attendanceRecordId

##### 5.4.3.1.1 Name

attendanceRecordId

##### 5.4.3.1.2 Type

🔹 String

##### 5.4.3.1.3 Is Required

✅ Yes

##### 5.4.3.1.4 Is Primary Key

✅ Yes

##### 5.4.3.1.5 Size

0

##### 5.4.3.1.6 Is Unique

✅ Yes

##### 5.4.3.1.7 Constraints

- Document ID

##### 5.4.3.1.8 Precision

0

##### 5.4.3.1.9 Scale

0

##### 5.4.3.1.10 Is Foreign Key

❌ No

#### 5.4.3.2.0 userId

##### 5.4.3.2.1 Name

userId

##### 5.4.3.2.2 Type

🔹 String

##### 5.4.3.2.3 Is Required

✅ Yes

##### 5.4.3.2.4 Is Primary Key

❌ No

##### 5.4.3.2.5 Size

0

##### 5.4.3.2.6 Is Unique

❌ No

##### 5.4.3.2.7 Constraints

*No items available*

##### 5.4.3.2.8 Precision

0

##### 5.4.3.2.9 Scale

0

##### 5.4.3.2.10 Is Foreign Key

✅ Yes

#### 5.4.3.3.0 userFullName

##### 5.4.3.3.1 Name

userFullName

##### 5.4.3.3.2 Type

🔹 String

##### 5.4.3.3.3 Is Required

✅ Yes

##### 5.4.3.3.4 Is Primary Key

❌ No

##### 5.4.3.3.5 Size

201

##### 5.4.3.3.6 Is Unique

❌ No

##### 5.4.3.3.7 Constraints

- Denormalized for display in reports and dashboards

##### 5.4.3.3.8 Precision

0

##### 5.4.3.3.9 Scale

0

##### 5.4.3.3.10 Is Foreign Key

❌ No

#### 5.4.3.4.0 checkInTime

##### 5.4.3.4.1 Name

checkInTime

##### 5.4.3.4.2 Type

🔹 Timestamp

##### 5.4.3.4.3 Is Required

✅ Yes

##### 5.4.3.4.4 Is Primary Key

❌ No

##### 5.4.3.4.5 Size

0

##### 5.4.3.4.6 Is Unique

❌ No

##### 5.4.3.4.7 Constraints

*No items available*

##### 5.4.3.4.8 Precision

0

##### 5.4.3.4.9 Scale

0

##### 5.4.3.4.10 Is Foreign Key

❌ No

#### 5.4.3.5.0 checkInGps

##### 5.4.3.5.1 Name

checkInGps

##### 5.4.3.5.2 Type

🔹 GeoPoint

##### 5.4.3.5.3 Is Required

✅ Yes

##### 5.4.3.5.4 Is Primary Key

❌ No

##### 5.4.3.5.5 Size

0

##### 5.4.3.5.6 Is Unique

❌ No

##### 5.4.3.5.7 Constraints

*No items available*

##### 5.4.3.5.8 Precision

0

##### 5.4.3.5.9 Scale

0

##### 5.4.3.5.10 Is Foreign Key

❌ No

#### 5.4.3.6.0 checkOutTime

##### 5.4.3.6.1 Name

checkOutTime

##### 5.4.3.6.2 Type

🔹 Timestamp

##### 5.4.3.6.3 Is Required

❌ No

##### 5.4.3.6.4 Is Primary Key

❌ No

##### 5.4.3.6.5 Size

0

##### 5.4.3.6.6 Is Unique

❌ No

##### 5.4.3.6.7 Constraints

*No items available*

##### 5.4.3.6.8 Precision

0

##### 5.4.3.6.9 Scale

0

##### 5.4.3.6.10 Is Foreign Key

❌ No

#### 5.4.3.7.0 checkOutGps

##### 5.4.3.7.1 Name

checkOutGps

##### 5.4.3.7.2 Type

🔹 GeoPoint

##### 5.4.3.7.3 Is Required

❌ No

##### 5.4.3.7.4 Is Primary Key

❌ No

##### 5.4.3.7.5 Size

0

##### 5.4.3.7.6 Is Unique

❌ No

##### 5.4.3.7.7 Constraints

*No items available*

##### 5.4.3.7.8 Precision

0

##### 5.4.3.7.9 Scale

0

##### 5.4.3.7.10 Is Foreign Key

❌ No

#### 5.4.3.8.0 status

##### 5.4.3.8.1 Name

status

##### 5.4.3.8.2 Type

🔹 String

##### 5.4.3.8.3 Is Required

✅ Yes

##### 5.4.3.8.4 Is Primary Key

❌ No

##### 5.4.3.8.5 Size

50

##### 5.4.3.8.6 Is Unique

❌ No

##### 5.4.3.8.7 Constraints

- Allowed values: 'pending', 'approved', 'rejected', 'correction_pending'

##### 5.4.3.8.8 Precision

0

##### 5.4.3.8.9 Scale

0

##### 5.4.3.8.10 Is Foreign Key

❌ No

#### 5.4.3.9.0 supervisorId

##### 5.4.3.9.1 Name

supervisorId

##### 5.4.3.9.2 Type

🔹 String

##### 5.4.3.9.3 Is Required

✅ Yes

##### 5.4.3.9.4 Is Primary Key

❌ No

##### 5.4.3.9.5 Size

0

##### 5.4.3.9.6 Is Unique

❌ No

##### 5.4.3.9.7 Constraints

*No items available*

##### 5.4.3.9.8 Precision

0

##### 5.4.3.9.9 Scale

0

##### 5.4.3.9.10 Is Foreign Key

✅ Yes

#### 5.4.3.10.0 rejectionReason

##### 5.4.3.10.1 Name

rejectionReason

##### 5.4.3.10.2 Type

🔹 String

##### 5.4.3.10.3 Is Required

❌ No

##### 5.4.3.10.4 Is Primary Key

❌ No

##### 5.4.3.10.5 Size

1,000

##### 5.4.3.10.6 Is Unique

❌ No

##### 5.4.3.10.7 Constraints

*No items available*

##### 5.4.3.10.8 Precision

0

##### 5.4.3.10.9 Scale

0

##### 5.4.3.10.10 Is Foreign Key

❌ No

#### 5.4.3.11.0 flags

##### 5.4.3.11.1 Name

flags

##### 5.4.3.11.2 Type

🔹 Array<String>

##### 5.4.3.11.3 Is Required

❌ No

##### 5.4.3.11.4 Is Primary Key

❌ No

##### 5.4.3.11.5 Size

0

##### 5.4.3.11.6 Is Unique

❌ No

##### 5.4.3.11.7 Constraints

- Example flags: 'clock_discrepancy', 'auto-checked-out', 'isOfflineEntry', 'manually-corrected'

##### 5.4.3.11.8 Precision

0

##### 5.4.3.11.9 Scale

0

##### 5.4.3.11.10 Is Foreign Key

❌ No

#### 5.4.3.12.0 eventId

##### 5.4.3.12.1 Name

eventId

##### 5.4.3.12.2 Type

🔹 String

##### 5.4.3.12.3 Is Required

❌ No

##### 5.4.3.12.4 Is Primary Key

❌ No

##### 5.4.3.12.5 Size

0

##### 5.4.3.12.6 Is Unique

❌ No

##### 5.4.3.12.7 Constraints

*No items available*

##### 5.4.3.12.8 Precision

0

##### 5.4.3.12.9 Scale

0

##### 5.4.3.12.10 Is Foreign Key

✅ Yes

#### 5.4.3.13.0 createdAt

##### 5.4.3.13.1 Name

createdAt

##### 5.4.3.13.2 Type

🔹 Timestamp

##### 5.4.3.13.3 Is Required

✅ Yes

##### 5.4.3.13.4 Is Primary Key

❌ No

##### 5.4.3.13.5 Size

0

##### 5.4.3.13.6 Is Unique

❌ No

##### 5.4.3.13.7 Constraints

*No items available*

##### 5.4.3.13.8 Precision

0

##### 5.4.3.13.9 Scale

0

##### 5.4.3.13.10 Is Foreign Key

❌ No

#### 5.4.3.14.0 updatedAt

##### 5.4.3.14.1 Name

updatedAt

##### 5.4.3.14.2 Type

🔹 Timestamp

##### 5.4.3.14.3 Is Required

✅ Yes

##### 5.4.3.14.4 Is Primary Key

❌ No

##### 5.4.3.14.5 Size

0

##### 5.4.3.14.6 Is Unique

❌ No

##### 5.4.3.14.7 Constraints

*No items available*

##### 5.4.3.14.8 Precision

0

##### 5.4.3.14.9 Scale

0

##### 5.4.3.14.10 Is Foreign Key

❌ No

### 5.4.4.0.0 Primary Keys

- attendanceRecordId

### 5.4.5.0.0 Unique Constraints

*No items available*

### 5.4.6.0.0 Indexes

#### 5.4.6.1.0 IX_AttendanceRecord_User_CheckInTime

##### 5.4.6.1.1 Name

IX_AttendanceRecord_User_CheckInTime

##### 5.4.6.1.2 Columns

- userId
- checkInTime

##### 5.4.6.1.3 Type

🔹 Composite

#### 5.4.6.2.0 IX_AttendanceRecord_Supervisor_Status_CheckInTime

##### 5.4.6.2.1 Name

IX_AttendanceRecord_Supervisor_Status_CheckInTime

##### 5.4.6.2.2 Columns

- supervisorId
- status
- checkInTime

##### 5.4.6.2.3 Type

🔹 Composite

#### 5.4.6.3.0 IX_AttendanceRecord_Status_UpdatedAt

##### 5.4.6.3.1 Name

IX_AttendanceRecord_Status_UpdatedAt

##### 5.4.6.3.2 Columns

- status
- updatedAt

##### 5.4.6.3.3 Type

🔹 Composite

## 5.5.0.0.0 Event

### 5.5.1.0.0 Name

Event

### 5.5.2.0.0 Description

Represents a calendar event. Stored in a sub-collection: /tenants/{tenantId}/events/{eventId}. (REQ-1-007)

### 5.5.3.0.0 Attributes

#### 5.5.3.1.0 eventId

##### 5.5.3.1.1 Name

eventId

##### 5.5.3.1.2 Type

🔹 String

##### 5.5.3.1.3 Is Required

✅ Yes

##### 5.5.3.1.4 Is Primary Key

✅ Yes

##### 5.5.3.1.5 Size

0

##### 5.5.3.1.6 Is Unique

✅ Yes

##### 5.5.3.1.7 Constraints

- Document ID

##### 5.5.3.1.8 Precision

0

##### 5.5.3.1.9 Scale

0

##### 5.5.3.1.10 Is Foreign Key

❌ No

#### 5.5.3.2.0 title

##### 5.5.3.2.1 Name

title

##### 5.5.3.2.2 Type

🔹 String

##### 5.5.3.2.3 Is Required

✅ Yes

##### 5.5.3.2.4 Is Primary Key

❌ No

##### 5.5.3.2.5 Size

255

##### 5.5.3.2.6 Is Unique

❌ No

##### 5.5.3.2.7 Constraints

*No items available*

##### 5.5.3.2.8 Precision

0

##### 5.5.3.2.9 Scale

0

##### 5.5.3.2.10 Is Foreign Key

❌ No

#### 5.5.3.3.0 description

##### 5.5.3.3.1 Name

description

##### 5.5.3.3.2 Type

🔹 String

##### 5.5.3.3.3 Is Required

❌ No

##### 5.5.3.3.4 Is Primary Key

❌ No

##### 5.5.3.3.5 Size

2,000

##### 5.5.3.3.6 Is Unique

❌ No

##### 5.5.3.3.7 Constraints

*No items available*

##### 5.5.3.3.8 Precision

0

##### 5.5.3.3.9 Scale

0

##### 5.5.3.3.10 Is Foreign Key

❌ No

#### 5.5.3.4.0 startTime

##### 5.5.3.4.1 Name

startTime

##### 5.5.3.4.2 Type

🔹 Timestamp

##### 5.5.3.4.3 Is Required

✅ Yes

##### 5.5.3.4.4 Is Primary Key

❌ No

##### 5.5.3.4.5 Size

0

##### 5.5.3.4.6 Is Unique

❌ No

##### 5.5.3.4.7 Constraints

*No items available*

##### 5.5.3.4.8 Precision

0

##### 5.5.3.4.9 Scale

0

##### 5.5.3.4.10 Is Foreign Key

❌ No

#### 5.5.3.5.0 endTime

##### 5.5.3.5.1 Name

endTime

##### 5.5.3.5.2 Type

🔹 Timestamp

##### 5.5.3.5.3 Is Required

✅ Yes

##### 5.5.3.5.4 Is Primary Key

❌ No

##### 5.5.3.5.5 Size

0

##### 5.5.3.5.6 Is Unique

❌ No

##### 5.5.3.5.7 Constraints

*No items available*

##### 5.5.3.5.8 Precision

0

##### 5.5.3.5.9 Scale

0

##### 5.5.3.5.10 Is Foreign Key

❌ No

#### 5.5.3.6.0 isRecurring

##### 5.5.3.6.1 Name

isRecurring

##### 5.5.3.6.2 Type

🔹 Boolean

##### 5.5.3.6.3 Is Required

✅ Yes

##### 5.5.3.6.4 Is Primary Key

❌ No

##### 5.5.3.6.5 Size

0

##### 5.5.3.6.6 Is Unique

❌ No

##### 5.5.3.6.7 Constraints

*No items available*

##### 5.5.3.6.8 Precision

0

##### 5.5.3.6.9 Scale

0

##### 5.5.3.6.10 Is Foreign Key

❌ No

#### 5.5.3.7.0 recurrenceRule

##### 5.5.3.7.1 Name

recurrenceRule

##### 5.5.3.7.2 Type

🔹 String

##### 5.5.3.7.3 Is Required

❌ No

##### 5.5.3.7.4 Is Primary Key

❌ No

##### 5.5.3.7.5 Size

255

##### 5.5.3.7.6 Is Unique

❌ No

##### 5.5.3.7.7 Constraints

- iCal RRULE format

##### 5.5.3.7.8 Precision

0

##### 5.5.3.7.9 Scale

0

##### 5.5.3.7.10 Is Foreign Key

❌ No

#### 5.5.3.8.0 createdByUserId

##### 5.5.3.8.1 Name

createdByUserId

##### 5.5.3.8.2 Type

🔹 String

##### 5.5.3.8.3 Is Required

✅ Yes

##### 5.5.3.8.4 Is Primary Key

❌ No

##### 5.5.3.8.5 Size

0

##### 5.5.3.8.6 Is Unique

❌ No

##### 5.5.3.8.7 Constraints

*No items available*

##### 5.5.3.8.8 Precision

0

##### 5.5.3.8.9 Scale

0

##### 5.5.3.8.10 Is Foreign Key

✅ Yes

#### 5.5.3.9.0 assignedUserIds

##### 5.5.3.9.1 Name

assignedUserIds

##### 5.5.3.9.2 Type

🔹 Array<String>

##### 5.5.3.9.3 Is Required

❌ No

##### 5.5.3.9.4 Is Primary Key

❌ No

##### 5.5.3.9.5 Size

0

##### 5.5.3.9.6 Is Unique

❌ No

##### 5.5.3.9.7 Constraints

*No items available*

##### 5.5.3.9.8 Precision

0

##### 5.5.3.9.9 Scale

0

##### 5.5.3.9.10 Is Foreign Key

❌ No

#### 5.5.3.10.0 assignedTeamIds

##### 5.5.3.10.1 Name

assignedTeamIds

##### 5.5.3.10.2 Type

🔹 Array<String>

##### 5.5.3.10.3 Is Required

❌ No

##### 5.5.3.10.4 Is Primary Key

❌ No

##### 5.5.3.10.5 Size

0

##### 5.5.3.10.6 Is Unique

❌ No

##### 5.5.3.10.7 Constraints

*No items available*

##### 5.5.3.10.8 Precision

0

##### 5.5.3.10.9 Scale

0

##### 5.5.3.10.10 Is Foreign Key

❌ No

#### 5.5.3.11.0 createdAt

##### 5.5.3.11.1 Name

createdAt

##### 5.5.3.11.2 Type

🔹 Timestamp

##### 5.5.3.11.3 Is Required

✅ Yes

##### 5.5.3.11.4 Is Primary Key

❌ No

##### 5.5.3.11.5 Size

0

##### 5.5.3.11.6 Is Unique

❌ No

##### 5.5.3.11.7 Constraints

*No items available*

##### 5.5.3.11.8 Precision

0

##### 5.5.3.11.9 Scale

0

##### 5.5.3.11.10 Is Foreign Key

❌ No

#### 5.5.3.12.0 updatedAt

##### 5.5.3.12.1 Name

updatedAt

##### 5.5.3.12.2 Type

🔹 Timestamp

##### 5.5.3.12.3 Is Required

✅ Yes

##### 5.5.3.12.4 Is Primary Key

❌ No

##### 5.5.3.12.5 Size

0

##### 5.5.3.12.6 Is Unique

❌ No

##### 5.5.3.12.7 Constraints

*No items available*

##### 5.5.3.12.8 Precision

0

##### 5.5.3.12.9 Scale

0

##### 5.5.3.12.10 Is Foreign Key

❌ No

### 5.5.4.0.0 Primary Keys

- eventId

### 5.5.5.0.0 Unique Constraints

*No items available*

### 5.5.6.0.0 Indexes

#### 5.5.6.1.0 IX_Event_StartTime

##### 5.5.6.1.1 Name

IX_Event_StartTime

##### 5.5.6.1.2 Columns

- startTime

##### 5.5.6.1.3 Type

🔹 Single-Field

#### 5.5.6.2.0 IX_Event_AssignedUsers

##### 5.5.6.2.1 Name

IX_Event_AssignedUsers

##### 5.5.6.2.2 Columns

- assignedUserIds

##### 5.5.6.2.3 Type

🔹 Array-Contains

#### 5.5.6.3.0 IX_Event_AssignedTeams

##### 5.5.6.3.1 Name

IX_Event_AssignedTeams

##### 5.5.6.3.2 Columns

- assignedTeamIds

##### 5.5.6.3.3 Type

🔹 Array-Contains

## 5.6.0.0.0 AuditLog

### 5.6.1.0.0 Name

AuditLog

### 5.6.2.0.0 Description

An immutable log of critical system actions. Stored in a sub-collection: /tenants/{tenantId}/auditLogs/{auditLogId}. Immutability is enforced by Firestore Security Rules. (REQ-1-028)

### 5.6.3.0.0 Attributes

#### 5.6.3.1.0 auditLogId

##### 5.6.3.1.1 Name

auditLogId

##### 5.6.3.1.2 Type

🔹 String

##### 5.6.3.1.3 Is Required

✅ Yes

##### 5.6.3.1.4 Is Primary Key

✅ Yes

##### 5.6.3.1.5 Size

0

##### 5.6.3.1.6 Is Unique

✅ Yes

##### 5.6.3.1.7 Constraints

- Document ID

##### 5.6.3.1.8 Precision

0

##### 5.6.3.1.9 Scale

0

##### 5.6.3.1.10 Is Foreign Key

❌ No

#### 5.6.3.2.0 actingUserId

##### 5.6.3.2.1 Name

actingUserId

##### 5.6.3.2.2 Type

🔹 String

##### 5.6.3.2.3 Is Required

✅ Yes

##### 5.6.3.2.4 Is Primary Key

❌ No

##### 5.6.3.2.5 Size

0

##### 5.6.3.2.6 Is Unique

❌ No

##### 5.6.3.2.7 Constraints

*No items available*

##### 5.6.3.2.8 Precision

0

##### 5.6.3.2.9 Scale

0

##### 5.6.3.2.10 Is Foreign Key

✅ Yes

#### 5.6.3.3.0 targetEntity

##### 5.6.3.3.1 Name

targetEntity

##### 5.6.3.3.2 Type

🔹 String

##### 5.6.3.3.3 Is Required

✅ Yes

##### 5.6.3.3.4 Is Primary Key

❌ No

##### 5.6.3.3.5 Size

100

##### 5.6.3.3.6 Is Unique

❌ No

##### 5.6.3.3.7 Constraints

*No items available*

##### 5.6.3.3.8 Precision

0

##### 5.6.3.3.9 Scale

0

##### 5.6.3.3.10 Is Foreign Key

❌ No

#### 5.6.3.4.0 targetEntityId

##### 5.6.3.4.1 Name

targetEntityId

##### 5.6.3.4.2 Type

🔹 String

##### 5.6.3.4.3 Is Required

✅ Yes

##### 5.6.3.4.4 Is Primary Key

❌ No

##### 5.6.3.4.5 Size

0

##### 5.6.3.4.6 Is Unique

❌ No

##### 5.6.3.4.7 Constraints

*No items available*

##### 5.6.3.4.8 Precision

0

##### 5.6.3.4.9 Scale

0

##### 5.6.3.4.10 Is Foreign Key

❌ No

#### 5.6.3.5.0 actionType

##### 5.6.3.5.1 Name

actionType

##### 5.6.3.5.2 Type

🔹 String

##### 5.6.3.5.3 Is Required

✅ Yes

##### 5.6.3.5.4 Is Primary Key

❌ No

##### 5.6.3.5.5 Size

100

##### 5.6.3.5.6 Is Unique

❌ No

##### 5.6.3.5.7 Constraints

*No items available*

##### 5.6.3.5.8 Precision

0

##### 5.6.3.5.9 Scale

0

##### 5.6.3.5.10 Is Foreign Key

❌ No

#### 5.6.3.6.0 details

##### 5.6.3.6.1 Name

details

##### 5.6.3.6.2 Type

🔹 Map

##### 5.6.3.6.3 Is Required

✅ Yes

##### 5.6.3.6.4 Is Primary Key

❌ No

##### 5.6.3.6.5 Size

0

##### 5.6.3.6.6 Is Unique

❌ No

##### 5.6.3.6.7 Constraints

- Contains old/new values, justification, etc.

##### 5.6.3.6.8 Precision

0

##### 5.6.3.6.9 Scale

0

##### 5.6.3.6.10 Is Foreign Key

❌ No

#### 5.6.3.7.0 timestamp

##### 5.6.3.7.1 Name

timestamp

##### 5.6.3.7.2 Type

🔹 Timestamp

##### 5.6.3.7.3 Is Required

✅ Yes

##### 5.6.3.7.4 Is Primary Key

❌ No

##### 5.6.3.7.5 Size

0

##### 5.6.3.7.6 Is Unique

❌ No

##### 5.6.3.7.7 Constraints

*No items available*

##### 5.6.3.7.8 Precision

0

##### 5.6.3.7.9 Scale

0

##### 5.6.3.7.10 Is Foreign Key

❌ No

### 5.6.4.0.0 Primary Keys

- auditLogId

### 5.6.5.0.0 Unique Constraints

*No items available*

### 5.6.6.0.0 Indexes

#### 5.6.6.1.0 IX_AuditLog_Timestamp

##### 5.6.6.1.1 Name

IX_AuditLog_Timestamp

##### 5.6.6.1.2 Columns

- timestamp

##### 5.6.6.1.3 Type

🔹 Single-Field

#### 5.6.6.2.0 IX_AuditLog_TargetEntity_Id_Timestamp

##### 5.6.6.2.1 Name

IX_AuditLog_TargetEntity_Id_Timestamp

##### 5.6.6.2.2 Columns

- targetEntity
- targetEntityId
- timestamp

##### 5.6.6.2.3 Type

🔹 Composite

## 5.7.0.0.0 SubscriptionPlan

### 5.7.1.0.0 Name

SubscriptionPlan

### 5.7.2.0.0 Description

Global collection defining available subscription tiers. Cached at application startup. (REQ-1-001)

### 5.7.3.0.0 Attributes

#### 5.7.3.1.0 subscriptionPlanId

##### 5.7.3.1.1 Name

subscriptionPlanId

##### 5.7.3.1.2 Type

🔹 String

##### 5.7.3.1.3 Is Required

✅ Yes

##### 5.7.3.1.4 Is Primary Key

✅ Yes

##### 5.7.3.1.5 Size

0

##### 5.7.3.1.6 Is Unique

✅ Yes

##### 5.7.3.1.7 Constraints

- Document ID

##### 5.7.3.1.8 Precision

0

##### 5.7.3.1.9 Scale

0

##### 5.7.3.1.10 Is Foreign Key

❌ No

#### 5.7.3.2.0 name

##### 5.7.3.2.1 Name

name

##### 5.7.3.2.2 Type

🔹 String

##### 5.7.3.2.3 Is Required

✅ Yes

##### 5.7.3.2.4 Is Primary Key

❌ No

##### 5.7.3.2.5 Size

100

##### 5.7.3.2.6 Is Unique

✅ Yes

##### 5.7.3.2.7 Constraints

*No items available*

##### 5.7.3.2.8 Precision

0

##### 5.7.3.2.9 Scale

0

##### 5.7.3.2.10 Is Foreign Key

❌ No

#### 5.7.3.3.0 description

##### 5.7.3.3.1 Name

description

##### 5.7.3.3.2 Type

🔹 String

##### 5.7.3.3.3 Is Required

❌ No

##### 5.7.3.3.4 Is Primary Key

❌ No

##### 5.7.3.3.5 Size

1,000

##### 5.7.3.3.6 Is Unique

❌ No

##### 5.7.3.3.7 Constraints

*No items available*

##### 5.7.3.3.8 Precision

0

##### 5.7.3.3.9 Scale

0

##### 5.7.3.3.10 Is Foreign Key

❌ No

#### 5.7.3.4.0 price

##### 5.7.3.4.1 Name

price

##### 5.7.3.4.2 Type

🔹 Number

##### 5.7.3.4.3 Is Required

✅ Yes

##### 5.7.3.4.4 Is Primary Key

❌ No

##### 5.7.3.4.5 Size

0

##### 5.7.3.4.6 Is Unique

❌ No

##### 5.7.3.4.7 Constraints

*No items available*

##### 5.7.3.4.8 Precision

10

##### 5.7.3.4.9 Scale

2

##### 5.7.3.4.10 Is Foreign Key

❌ No

#### 5.7.3.5.0 features

##### 5.7.3.5.1 Name

features

##### 5.7.3.5.2 Type

🔹 Map

##### 5.7.3.5.3 Is Required

❌ No

##### 5.7.3.5.4 Is Primary Key

❌ No

##### 5.7.3.5.5 Size

0

##### 5.7.3.5.6 Is Unique

❌ No

##### 5.7.3.5.7 Constraints

*No items available*

##### 5.7.3.5.8 Precision

0

##### 5.7.3.5.9 Scale

0

##### 5.7.3.5.10 Is Foreign Key

❌ No

### 5.7.4.0.0 Primary Keys

- subscriptionPlanId

### 5.7.5.0.0 Unique Constraints

*No items available*

### 5.7.6.0.0 Indexes

*No items available*

## 5.8.0.0.0 TenantConfiguration

### 5.8.1.0.0 Name

TenantConfiguration

### 5.8.2.0.0 Description

Singleton document storing tenant-specific settings. Path: /tenants/{tenantId}/config/settings. (REQ-1-061)

### 5.8.3.0.0 Attributes

#### 5.8.3.1.0 timezone

##### 5.8.3.1.1 Name

timezone

##### 5.8.3.1.2 Type

🔹 String

##### 5.8.3.1.3 Is Required

✅ Yes

##### 5.8.3.1.4 Is Primary Key

❌ No

##### 5.8.3.1.5 Size

100

##### 5.8.3.1.6 Is Unique

❌ No

##### 5.8.3.1.7 Constraints

*No items available*

##### 5.8.3.1.8 Precision

0

##### 5.8.3.1.9 Scale

0

##### 5.8.3.1.10 Is Foreign Key

❌ No

#### 5.8.3.2.0 autoCheckoutTime

##### 5.8.3.2.1 Name

autoCheckoutTime

##### 5.8.3.2.2 Type

🔹 String

##### 5.8.3.2.3 Is Required

❌ No

##### 5.8.3.2.4 Is Primary Key

❌ No

##### 5.8.3.2.5 Size

5

##### 5.8.3.2.6 Is Unique

❌ No

##### 5.8.3.2.7 Constraints

- Format HH:MM

##### 5.8.3.2.8 Precision

0

##### 5.8.3.2.9 Scale

0

##### 5.8.3.2.10 Is Foreign Key

❌ No

#### 5.8.3.3.0 approvalEscalationPeriodDays

##### 5.8.3.3.1 Name

approvalEscalationPeriodDays

##### 5.8.3.3.2 Type

🔹 Number

##### 5.8.3.3.3 Is Required

✅ Yes

##### 5.8.3.3.4 Is Primary Key

❌ No

##### 5.8.3.3.5 Size

0

##### 5.8.3.3.6 Is Unique

❌ No

##### 5.8.3.3.7 Constraints

*No items available*

##### 5.8.3.3.8 Precision

0

##### 5.8.3.3.9 Scale

0

##### 5.8.3.3.10 Is Foreign Key

❌ No

#### 5.8.3.4.0 defaultWorkingHours

##### 5.8.3.4.1 Name

defaultWorkingHours

##### 5.8.3.4.2 Type

🔹 Map

##### 5.8.3.4.3 Is Required

❌ No

##### 5.8.3.4.4 Is Primary Key

❌ No

##### 5.8.3.4.5 Size

0

##### 5.8.3.4.6 Is Unique

❌ No

##### 5.8.3.4.7 Constraints

*No items available*

##### 5.8.3.4.8 Precision

0

##### 5.8.3.4.9 Scale

0

##### 5.8.3.4.10 Is Foreign Key

❌ No

#### 5.8.3.5.0 passwordPolicy

##### 5.8.3.5.1 Name

passwordPolicy

##### 5.8.3.5.2 Type

🔹 Map

##### 5.8.3.5.3 Is Required

❌ No

##### 5.8.3.5.4 Is Primary Key

❌ No

##### 5.8.3.5.5 Size

0

##### 5.8.3.5.6 Is Unique

❌ No

##### 5.8.3.5.7 Constraints

*No items available*

##### 5.8.3.5.8 Precision

0

##### 5.8.3.5.9 Scale

0

##### 5.8.3.5.10 Is Foreign Key

❌ No

#### 5.8.3.6.0 dataRetentionPeriods

##### 5.8.3.6.1 Name

dataRetentionPeriods

##### 5.8.3.6.2 Type

🔹 Map

##### 5.8.3.6.3 Is Required

❌ No

##### 5.8.3.6.4 Is Primary Key

❌ No

##### 5.8.3.6.5 Size

0

##### 5.8.3.6.6 Is Unique

❌ No

##### 5.8.3.6.7 Constraints

*No items available*

##### 5.8.3.6.8 Precision

0

##### 5.8.3.6.9 Scale

0

##### 5.8.3.6.10 Is Foreign Key

❌ No

#### 5.8.3.7.0 updatedAt

##### 5.8.3.7.1 Name

updatedAt

##### 5.8.3.7.2 Type

🔹 Timestamp

##### 5.8.3.7.3 Is Required

✅ Yes

##### 5.8.3.7.4 Is Primary Key

❌ No

##### 5.8.3.7.5 Size

0

##### 5.8.3.7.6 Is Unique

❌ No

##### 5.8.3.7.7 Constraints

*No items available*

##### 5.8.3.7.8 Precision

0

##### 5.8.3.7.9 Scale

0

##### 5.8.3.7.10 Is Foreign Key

❌ No

### 5.8.4.0.0 Primary Keys

*No items available*

### 5.8.5.0.0 Unique Constraints

*No items available*

### 5.8.6.0.0 Indexes

*No items available*

## 5.9.0.0.0 GoogleSheetIntegration

### 5.9.1.0.0 Name

GoogleSheetIntegration

### 5.9.2.0.0 Description

Singleton document storing Google Sheets integration settings. Path: /tenants/{tenantId}/integrations/googleSheet. (REQ-1-008)

### 5.9.3.0.0 Attributes

#### 5.9.3.1.0 googleSheetId

##### 5.9.3.1.1 Name

googleSheetId

##### 5.9.3.1.2 Type

🔹 String

##### 5.9.3.1.3 Is Required

✅ Yes

##### 5.9.3.1.4 Is Primary Key

❌ No

##### 5.9.3.1.5 Size

255

##### 5.9.3.1.6 Is Unique

❌ No

##### 5.9.3.1.7 Constraints

*No items available*

##### 5.9.3.1.8 Precision

0

##### 5.9.3.1.9 Scale

0

##### 5.9.3.1.10 Is Foreign Key

❌ No

#### 5.9.3.2.0 encryptedRefreshToken

##### 5.9.3.2.1 Name

encryptedRefreshToken

##### 5.9.3.2.2 Type

🔹 String

##### 5.9.3.2.3 Is Required

✅ Yes

##### 5.9.3.2.4 Is Primary Key

❌ No

##### 5.9.3.2.5 Size

1,000

##### 5.9.3.2.6 Is Unique

❌ No

##### 5.9.3.2.7 Constraints

*No items available*

##### 5.9.3.2.8 Precision

0

##### 5.9.3.2.9 Scale

0

##### 5.9.3.2.10 Is Foreign Key

❌ No

#### 5.9.3.3.0 status

##### 5.9.3.3.1 Name

status

##### 5.9.3.3.2 Type

🔹 String

##### 5.9.3.3.3 Is Required

✅ Yes

##### 5.9.3.3.4 Is Primary Key

❌ No

##### 5.9.3.3.5 Size

50

##### 5.9.3.3.6 Is Unique

❌ No

##### 5.9.3.3.7 Constraints

- Allowed values: 'active', 'error', 'disabled'

##### 5.9.3.3.8 Precision

0

##### 5.9.3.3.9 Scale

0

##### 5.9.3.3.10 Is Foreign Key

❌ No

#### 5.9.3.4.0 lastSyncTimestamp

##### 5.9.3.4.1 Name

lastSyncTimestamp

##### 5.9.3.4.2 Type

🔹 Timestamp

##### 5.9.3.4.3 Is Required

❌ No

##### 5.9.3.4.4 Is Primary Key

❌ No

##### 5.9.3.4.5 Size

0

##### 5.9.3.4.6 Is Unique

❌ No

##### 5.9.3.4.7 Constraints

*No items available*

##### 5.9.3.4.8 Precision

0

##### 5.9.3.4.9 Scale

0

##### 5.9.3.4.10 Is Foreign Key

❌ No

#### 5.9.3.5.0 lastSyncError

##### 5.9.3.5.1 Name

lastSyncError

##### 5.9.3.5.2 Type

🔹 String

##### 5.9.3.5.3 Is Required

❌ No

##### 5.9.3.5.4 Is Primary Key

❌ No

##### 5.9.3.5.5 Size

2,000

##### 5.9.3.5.6 Is Unique

❌ No

##### 5.9.3.5.7 Constraints

*No items available*

##### 5.9.3.5.8 Precision

0

##### 5.9.3.5.9 Scale

0

##### 5.9.3.5.10 Is Foreign Key

❌ No

#### 5.9.3.6.0 updatedAt

##### 5.9.3.6.1 Name

updatedAt

##### 5.9.3.6.2 Type

🔹 Timestamp

##### 5.9.3.6.3 Is Required

✅ Yes

##### 5.9.3.6.4 Is Primary Key

❌ No

##### 5.9.3.6.5 Size

0

##### 5.9.3.6.6 Is Unique

❌ No

##### 5.9.3.6.7 Constraints

*No items available*

##### 5.9.3.6.8 Precision

0

##### 5.9.3.6.9 Scale

0

##### 5.9.3.6.10 Is Foreign Key

❌ No

### 5.9.4.0.0 Primary Keys

*No items available*

### 5.9.5.0.0 Unique Constraints

*No items available*

### 5.9.6.0.0 Indexes

*No items available*

## 5.10.0.0.0 DailyUserSummary

### 5.10.1.0.0 Name

DailyUserSummary

### 5.10.2.0.0 Description

Pre-aggregated daily summary data for reporting. Stored in sub-collection: /tenants/{tenantId}/dailySummaries/{YYYY-MM-DD_userId}. (REQ-REP-001)

### 5.10.3.0.0 Attributes

#### 5.10.3.1.0 summaryId

##### 5.10.3.1.1 Name

summaryId

##### 5.10.3.1.2 Type

🔹 String

##### 5.10.3.1.3 Is Required

✅ Yes

##### 5.10.3.1.4 Is Primary Key

✅ Yes

##### 5.10.3.1.5 Size

0

##### 5.10.3.1.6 Is Unique

✅ Yes

##### 5.10.3.1.7 Constraints

- Document ID, format: YYYY-MM-DD_userId

##### 5.10.3.1.8 Precision

0

##### 5.10.3.1.9 Scale

0

##### 5.10.3.1.10 Is Foreign Key

❌ No

#### 5.10.3.2.0 summaryDate

##### 5.10.3.2.1 Name

summaryDate

##### 5.10.3.2.2 Type

🔹 Timestamp

##### 5.10.3.2.3 Is Required

✅ Yes

##### 5.10.3.2.4 Is Primary Key

❌ No

##### 5.10.3.2.5 Size

0

##### 5.10.3.2.6 Is Unique

❌ No

##### 5.10.3.2.7 Constraints

- Timestamp set to midnight of the summary day

##### 5.10.3.2.8 Precision

0

##### 5.10.3.2.9 Scale

0

##### 5.10.3.2.10 Is Foreign Key

❌ No

#### 5.10.3.3.0 userId

##### 5.10.3.3.1 Name

userId

##### 5.10.3.3.2 Type

🔹 String

##### 5.10.3.3.3 Is Required

✅ Yes

##### 5.10.3.3.4 Is Primary Key

❌ No

##### 5.10.3.3.5 Size

0

##### 5.10.3.3.6 Is Unique

❌ No

##### 5.10.3.3.7 Constraints

*No items available*

##### 5.10.3.3.8 Precision

0

##### 5.10.3.3.9 Scale

0

##### 5.10.3.3.10 Is Foreign Key

✅ Yes

#### 5.10.3.4.0 totalHoursWorked

##### 5.10.3.4.1 Name

totalHoursWorked

##### 5.10.3.4.2 Type

🔹 Number

##### 5.10.3.4.3 Is Required

❌ No

##### 5.10.3.4.4 Is Primary Key

❌ No

##### 5.10.3.4.5 Size

0

##### 5.10.3.4.6 Is Unique

❌ No

##### 5.10.3.4.7 Constraints

*No items available*

##### 5.10.3.4.8 Precision

5

##### 5.10.3.4.9 Scale

2

##### 5.10.3.4.10 Is Foreign Key

❌ No

#### 5.10.3.5.0 firstCheckIn

##### 5.10.3.5.1 Name

firstCheckIn

##### 5.10.3.5.2 Type

🔹 Timestamp

##### 5.10.3.5.3 Is Required

❌ No

##### 5.10.3.5.4 Is Primary Key

❌ No

##### 5.10.3.5.5 Size

0

##### 5.10.3.5.6 Is Unique

❌ No

##### 5.10.3.5.7 Constraints

*No items available*

##### 5.10.3.5.8 Precision

0

##### 5.10.3.5.9 Scale

0

##### 5.10.3.5.10 Is Foreign Key

❌ No

#### 5.10.3.6.0 lastCheckOut

##### 5.10.3.6.1 Name

lastCheckOut

##### 5.10.3.6.2 Type

🔹 Timestamp

##### 5.10.3.6.3 Is Required

❌ No

##### 5.10.3.6.4 Is Primary Key

❌ No

##### 5.10.3.6.5 Size

0

##### 5.10.3.6.6 Is Unique

❌ No

##### 5.10.3.6.7 Constraints

*No items available*

##### 5.10.3.6.8 Precision

0

##### 5.10.3.6.9 Scale

0

##### 5.10.3.6.10 Is Foreign Key

❌ No

#### 5.10.3.7.0 isLateArrival

##### 5.10.3.7.1 Name

isLateArrival

##### 5.10.3.7.2 Type

🔹 Boolean

##### 5.10.3.7.3 Is Required

❌ No

##### 5.10.3.7.4 Is Primary Key

❌ No

##### 5.10.3.7.5 Size

0

##### 5.10.3.7.6 Is Unique

❌ No

##### 5.10.3.7.7 Constraints

*No items available*

##### 5.10.3.7.8 Precision

0

##### 5.10.3.7.9 Scale

0

##### 5.10.3.7.10 Is Foreign Key

❌ No

#### 5.10.3.8.0 isEarlyDeparture

##### 5.10.3.8.1 Name

isEarlyDeparture

##### 5.10.3.8.2 Type

🔹 Boolean

##### 5.10.3.8.3 Is Required

❌ No

##### 5.10.3.8.4 Is Primary Key

❌ No

##### 5.10.3.8.5 Size

0

##### 5.10.3.8.6 Is Unique

❌ No

##### 5.10.3.8.7 Constraints

*No items available*

##### 5.10.3.8.8 Precision

0

##### 5.10.3.8.9 Scale

0

##### 5.10.3.8.10 Is Foreign Key

❌ No

#### 5.10.3.9.0 exceptionsCount

##### 5.10.3.9.1 Name

exceptionsCount

##### 5.10.3.9.2 Type

🔹 Number

##### 5.10.3.9.3 Is Required

❌ No

##### 5.10.3.9.4 Is Primary Key

❌ No

##### 5.10.3.9.5 Size

0

##### 5.10.3.9.6 Is Unique

❌ No

##### 5.10.3.9.7 Constraints

*No items available*

##### 5.10.3.9.8 Precision

0

##### 5.10.3.9.9 Scale

0

##### 5.10.3.9.10 Is Foreign Key

❌ No

#### 5.10.3.10.0 updatedAt

##### 5.10.3.10.1 Name

updatedAt

##### 5.10.3.10.2 Type

🔹 Timestamp

##### 5.10.3.10.3 Is Required

✅ Yes

##### 5.10.3.10.4 Is Primary Key

❌ No

##### 5.10.3.10.5 Size

0

##### 5.10.3.10.6 Is Unique

❌ No

##### 5.10.3.10.7 Constraints

*No items available*

##### 5.10.3.10.8 Precision

0

##### 5.10.3.10.9 Scale

0

##### 5.10.3.10.10 Is Foreign Key

❌ No

### 5.10.4.0.0 Primary Keys

- summaryId

### 5.10.5.0.0 Unique Constraints

*No items available*

### 5.10.6.0.0 Indexes

- {'name': 'IX_DailySummary_User_Date', 'columns': ['userId', 'summaryDate'], 'type': 'Composite'}

