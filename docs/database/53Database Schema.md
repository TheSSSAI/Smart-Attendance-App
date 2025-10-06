# 1 Entities

## 1.1 Tenant

### 1.1.1 Name

Tenant

### 1.1.2 Description

Represents an organization, which is a logically isolated container for all its data. (REQ-1-002)

### 1.1.3 Attributes

#### 1.1.3.1 tenantId

##### 1.1.3.1.1 Name

tenantId

##### 1.1.3.1.2 Type

🔹 Guid

##### 1.1.3.1.3 Is Required

✅ Yes

##### 1.1.3.1.4 Is Primary Key

✅ Yes

##### 1.1.3.1.5 Is Unique

✅ Yes

##### 1.1.3.1.6 Index Type

UniqueIndex

##### 1.1.3.1.7 Size

0

##### 1.1.3.1.8 Constraints

*No items available*

##### 1.1.3.1.9 Default Value



##### 1.1.3.1.10 Is Foreign Key

❌ No

##### 1.1.3.1.11 Precision

0

##### 1.1.3.1.12 Scale

0

#### 1.1.3.2.0 name

##### 1.1.3.2.1 Name

name

##### 1.1.3.2.2 Type

🔹 VARCHAR

##### 1.1.3.2.3 Is Required

✅ Yes

##### 1.1.3.2.4 Is Primary Key

❌ No

##### 1.1.3.2.5 Is Unique

✅ Yes

##### 1.1.3.2.6 Index Type

UniqueIndex

##### 1.1.3.2.7 Size

255

##### 1.1.3.2.8 Constraints

*No items available*

##### 1.1.3.2.9 Default Value



##### 1.1.3.2.10 Is Foreign Key

❌ No

##### 1.1.3.2.11 Precision

0

##### 1.1.3.2.12 Scale

0

#### 1.1.3.3.0 status

##### 1.1.3.3.1 Name

status

##### 1.1.3.3.2 Type

🔹 VARCHAR

##### 1.1.3.3.3 Is Required

✅ Yes

##### 1.1.3.3.4 Is Primary Key

❌ No

##### 1.1.3.3.5 Is Unique

❌ No

##### 1.1.3.3.6 Index Type

Index

##### 1.1.3.3.7 Size

50

##### 1.1.3.3.8 Constraints

- ENUM('active', 'pending_deletion', 'deleted')

##### 1.1.3.3.9 Default Value

active

##### 1.1.3.3.10 Is Foreign Key

❌ No

##### 1.1.3.3.11 Precision

0

##### 1.1.3.3.12 Scale

0

#### 1.1.3.4.0 deletionRequestedAt

##### 1.1.3.4.1 Name

deletionRequestedAt

##### 1.1.3.4.2 Type

🔹 DateTime

##### 1.1.3.4.3 Is Required

❌ No

##### 1.1.3.4.4 Is Primary Key

❌ No

##### 1.1.3.4.5 Is Unique

❌ No

##### 1.1.3.4.6 Index Type

None

##### 1.1.3.4.7 Size

0

##### 1.1.3.4.8 Constraints

*No items available*

##### 1.1.3.4.9 Default Value



##### 1.1.3.4.10 Is Foreign Key

❌ No

##### 1.1.3.4.11 Precision

0

##### 1.1.3.4.12 Scale

0

#### 1.1.3.5.0 gcpRegion

##### 1.1.3.5.1 Name

gcpRegion

##### 1.1.3.5.2 Type

🔹 VARCHAR

##### 1.1.3.5.3 Is Required

✅ Yes

##### 1.1.3.5.4 Is Primary Key

❌ No

##### 1.1.3.5.5 Is Unique

❌ No

##### 1.1.3.5.6 Index Type

None

##### 1.1.3.5.7 Size

100

##### 1.1.3.5.8 Constraints

*No items available*

##### 1.1.3.5.9 Default Value



##### 1.1.3.5.10 Is Foreign Key

❌ No

##### 1.1.3.5.11 Precision

0

##### 1.1.3.5.12 Scale

0

#### 1.1.3.6.0 subscriptionPlanId

##### 1.1.3.6.1 Name

subscriptionPlanId

##### 1.1.3.6.2 Type

🔹 Guid

##### 1.1.3.6.3 Is Required

✅ Yes

##### 1.1.3.6.4 Is Primary Key

❌ No

##### 1.1.3.6.5 Is Unique

❌ No

##### 1.1.3.6.6 Index Type

Index

##### 1.1.3.6.7 Size

0

##### 1.1.3.6.8 Constraints

*No items available*

##### 1.1.3.6.9 Default Value



##### 1.1.3.6.10 Is Foreign Key

✅ Yes

##### 1.1.3.6.11 Precision

0

##### 1.1.3.6.12 Scale

0

#### 1.1.3.7.0 createdAt

##### 1.1.3.7.1 Name

createdAt

##### 1.1.3.7.2 Type

🔹 DateTime

##### 1.1.3.7.3 Is Required

✅ Yes

##### 1.1.3.7.4 Is Primary Key

❌ No

##### 1.1.3.7.5 Is Unique

❌ No

##### 1.1.3.7.6 Index Type

Index

##### 1.1.3.7.7 Size

0

##### 1.1.3.7.8 Constraints

*No items available*

##### 1.1.3.7.9 Default Value

CURRENT_TIMESTAMP

##### 1.1.3.7.10 Is Foreign Key

❌ No

##### 1.1.3.7.11 Precision

0

##### 1.1.3.7.12 Scale

0

#### 1.1.3.8.0 updatedAt

##### 1.1.3.8.1 Name

updatedAt

##### 1.1.3.8.2 Type

🔹 DateTime

##### 1.1.3.8.3 Is Required

✅ Yes

##### 1.1.3.8.4 Is Primary Key

❌ No

##### 1.1.3.8.5 Is Unique

❌ No

##### 1.1.3.8.6 Index Type

None

##### 1.1.3.8.7 Size

0

##### 1.1.3.8.8 Constraints

*No items available*

##### 1.1.3.8.9 Default Value

CURRENT_TIMESTAMP

##### 1.1.3.8.10 Is Foreign Key

❌ No

##### 1.1.3.8.11 Precision

0

##### 1.1.3.8.12 Scale

0

### 1.1.4.0.0 Primary Keys

- tenantId

### 1.1.5.0.0 Unique Constraints

- {'name': 'UC_Tenant_Name', 'columns': ['name']}

### 1.1.6.0.0 Indexes

#### 1.1.6.1.0 IX_Tenant_Status

##### 1.1.6.1.1 Name

IX_Tenant_Status

##### 1.1.6.1.2 Columns

- status

##### 1.1.6.1.3 Type

🔹 BTree

#### 1.1.6.2.0 IX_Tenant_SubscriptionPlanId

##### 1.1.6.2.1 Name

IX_Tenant_SubscriptionPlanId

##### 1.1.6.2.2 Columns

- subscriptionPlanId

##### 1.1.6.2.3 Type

🔹 BTree

## 1.2.0.0.0 User

### 1.2.1.0.0 Name

User

### 1.2.2.0.0 Description

Represents an individual user account within a tenant, including their role and hierarchical position. (REQ-1-003) User role, team memberships, and supervisor data should be cached upon login (e.g., in JWT claims or session cache) to reduce authorization overhead on subsequent requests.

### 1.2.3.0.0 Attributes

#### 1.2.3.1.0 userId

##### 1.2.3.1.1 Name

userId

##### 1.2.3.1.2 Type

🔹 Guid

##### 1.2.3.1.3 Is Required

✅ Yes

##### 1.2.3.1.4 Is Primary Key

✅ Yes

##### 1.2.3.1.5 Is Unique

✅ Yes

##### 1.2.3.1.6 Index Type

UniqueIndex

##### 1.2.3.1.7 Size

0

##### 1.2.3.1.8 Constraints

*No items available*

##### 1.2.3.1.9 Default Value



##### 1.2.3.1.10 Is Foreign Key

❌ No

##### 1.2.3.1.11 Precision

0

##### 1.2.3.1.12 Scale

0

#### 1.2.3.2.0 tenantId

##### 1.2.3.2.1 Name

tenantId

##### 1.2.3.2.2 Type

🔹 Guid

##### 1.2.3.2.3 Is Required

✅ Yes

##### 1.2.3.2.4 Is Primary Key

❌ No

##### 1.2.3.2.5 Is Unique

❌ No

##### 1.2.3.2.6 Index Type

Index

##### 1.2.3.2.7 Size

0

##### 1.2.3.2.8 Constraints

*No items available*

##### 1.2.3.2.9 Default Value



##### 1.2.3.2.10 Is Foreign Key

✅ Yes

##### 1.2.3.2.11 Precision

0

##### 1.2.3.2.12 Scale

0

#### 1.2.3.3.0 email

##### 1.2.3.3.1 Name

email

##### 1.2.3.3.2 Type

🔹 VARCHAR

##### 1.2.3.3.3 Is Required

✅ Yes

##### 1.2.3.3.4 Is Primary Key

❌ No

##### 1.2.3.3.5 Is Unique

❌ No

##### 1.2.3.3.6 Index Type

Index

##### 1.2.3.3.7 Size

255

##### 1.2.3.3.8 Constraints

- EMAIL_FORMAT

##### 1.2.3.3.9 Default Value



##### 1.2.3.3.10 Is Foreign Key

❌ No

##### 1.2.3.3.11 Precision

0

##### 1.2.3.3.12 Scale

0

#### 1.2.3.4.0 passwordHash

##### 1.2.3.4.1 Name

passwordHash

##### 1.2.3.4.2 Type

🔹 VARCHAR

##### 1.2.3.4.3 Is Required

❌ No

##### 1.2.3.4.4 Is Primary Key

❌ No

##### 1.2.3.4.5 Is Unique

❌ No

##### 1.2.3.4.6 Index Type

None

##### 1.2.3.4.7 Size

255

##### 1.2.3.4.8 Constraints

*No items available*

##### 1.2.3.4.9 Default Value



##### 1.2.3.4.10 Is Foreign Key

❌ No

##### 1.2.3.4.11 Precision

0

##### 1.2.3.4.12 Scale

0

#### 1.2.3.5.0 firstName

##### 1.2.3.5.1 Name

firstName

##### 1.2.3.5.2 Type

🔹 VARCHAR

##### 1.2.3.5.3 Is Required

✅ Yes

##### 1.2.3.5.4 Is Primary Key

❌ No

##### 1.2.3.5.5 Is Unique

❌ No

##### 1.2.3.5.6 Index Type

Index

##### 1.2.3.5.7 Size

100

##### 1.2.3.5.8 Constraints

*No items available*

##### 1.2.3.5.9 Default Value



##### 1.2.3.5.10 Is Foreign Key

❌ No

##### 1.2.3.5.11 Precision

0

##### 1.2.3.5.12 Scale

0

#### 1.2.3.6.0 lastName

##### 1.2.3.6.1 Name

lastName

##### 1.2.3.6.2 Type

🔹 VARCHAR

##### 1.2.3.6.3 Is Required

✅ Yes

##### 1.2.3.6.4 Is Primary Key

❌ No

##### 1.2.3.6.5 Is Unique

❌ No

##### 1.2.3.6.6 Index Type

Index

##### 1.2.3.6.7 Size

100

##### 1.2.3.6.8 Constraints

*No items available*

##### 1.2.3.6.9 Default Value



##### 1.2.3.6.10 Is Foreign Key

❌ No

##### 1.2.3.6.11 Precision

0

##### 1.2.3.6.12 Scale

0

#### 1.2.3.7.0 phoneNumber

##### 1.2.3.7.1 Name

phoneNumber

##### 1.2.3.7.2 Type

🔹 VARCHAR

##### 1.2.3.7.3 Is Required

❌ No

##### 1.2.3.7.4 Is Primary Key

❌ No

##### 1.2.3.7.5 Is Unique

❌ No

##### 1.2.3.7.6 Index Type

Index

##### 1.2.3.7.7 Size

20

##### 1.2.3.7.8 Constraints

*No items available*

##### 1.2.3.7.9 Default Value



##### 1.2.3.7.10 Is Foreign Key

❌ No

##### 1.2.3.7.11 Precision

0

##### 1.2.3.7.12 Scale

0

#### 1.2.3.8.0 role

##### 1.2.3.8.1 Name

role

##### 1.2.3.8.2 Type

🔹 VARCHAR

##### 1.2.3.8.3 Is Required

✅ Yes

##### 1.2.3.8.4 Is Primary Key

❌ No

##### 1.2.3.8.5 Is Unique

❌ No

##### 1.2.3.8.6 Index Type

Index

##### 1.2.3.8.7 Size

50

##### 1.2.3.8.8 Constraints

- ENUM('Admin', 'Supervisor', 'Subordinate')

##### 1.2.3.8.9 Default Value



##### 1.2.3.8.10 Is Foreign Key

❌ No

##### 1.2.3.8.11 Precision

0

##### 1.2.3.8.12 Scale

0

#### 1.2.3.9.0 status

##### 1.2.3.9.1 Name

status

##### 1.2.3.9.2 Type

🔹 VARCHAR

##### 1.2.3.9.3 Is Required

✅ Yes

##### 1.2.3.9.4 Is Primary Key

❌ No

##### 1.2.3.9.5 Is Unique

❌ No

##### 1.2.3.9.6 Index Type

Index

##### 1.2.3.9.7 Size

50

##### 1.2.3.9.8 Constraints

- ENUM('invited', 'active', 'deactivated')

##### 1.2.3.9.9 Default Value

invited

##### 1.2.3.9.10 Is Foreign Key

❌ No

##### 1.2.3.9.11 Precision

0

##### 1.2.3.9.12 Scale

0

#### 1.2.3.10.0 supervisorId

##### 1.2.3.10.1 Name

supervisorId

##### 1.2.3.10.2 Type

🔹 Guid

##### 1.2.3.10.3 Is Required

❌ No

##### 1.2.3.10.4 Is Primary Key

❌ No

##### 1.2.3.10.5 Is Unique

❌ No

##### 1.2.3.10.6 Index Type

Index

##### 1.2.3.10.7 Size

0

##### 1.2.3.10.8 Constraints

- NO_CIRCULAR_REFERENCE

##### 1.2.3.10.9 Default Value



##### 1.2.3.10.10 Is Foreign Key

✅ Yes

##### 1.2.3.10.11 Precision

0

##### 1.2.3.10.12 Scale

0

#### 1.2.3.11.0 hierarchyPath

##### 1.2.3.11.1 Name

hierarchyPath

##### 1.2.3.11.2 Type

🔹 VARCHAR

##### 1.2.3.11.3 Is Required

❌ No

##### 1.2.3.11.4 Is Primary Key

❌ No

##### 1.2.3.11.5 Is Unique

❌ No

##### 1.2.3.11.6 Index Type

Index

##### 1.2.3.11.7 Size

1,000

##### 1.2.3.11.8 Constraints

- Must be updated transactionally with supervisorId

##### 1.2.3.11.9 Default Value



##### 1.2.3.11.10 Is Foreign Key

❌ No

##### 1.2.3.11.11 Precision

0

##### 1.2.3.11.12 Scale

0

#### 1.2.3.12.0 invitationToken

##### 1.2.3.12.1 Name

invitationToken

##### 1.2.3.12.2 Type

🔹 VARCHAR

##### 1.2.3.12.3 Is Required

❌ No

##### 1.2.3.12.4 Is Primary Key

❌ No

##### 1.2.3.12.5 Is Unique

✅ Yes

##### 1.2.3.12.6 Index Type

UniqueIndex

##### 1.2.3.12.7 Size

255

##### 1.2.3.12.8 Constraints

*No items available*

##### 1.2.3.12.9 Default Value



##### 1.2.3.12.10 Is Foreign Key

❌ No

##### 1.2.3.12.11 Precision

0

##### 1.2.3.12.12 Scale

0

#### 1.2.3.13.0 invitationExpiresAt

##### 1.2.3.13.1 Name

invitationExpiresAt

##### 1.2.3.13.2 Type

🔹 DateTime

##### 1.2.3.13.3 Is Required

❌ No

##### 1.2.3.13.4 Is Primary Key

❌ No

##### 1.2.3.13.5 Is Unique

❌ No

##### 1.2.3.13.6 Index Type

Index

##### 1.2.3.13.7 Size

0

##### 1.2.3.13.8 Constraints

*No items available*

##### 1.2.3.13.9 Default Value



##### 1.2.3.13.10 Is Foreign Key

❌ No

##### 1.2.3.13.11 Precision

0

##### 1.2.3.13.12 Scale

0

#### 1.2.3.14.0 deactivatedAt

##### 1.2.3.14.1 Name

deactivatedAt

##### 1.2.3.14.2 Type

🔹 DateTime

##### 1.2.3.14.3 Is Required

❌ No

##### 1.2.3.14.4 Is Primary Key

❌ No

##### 1.2.3.14.5 Is Unique

❌ No

##### 1.2.3.14.6 Index Type

Index

##### 1.2.3.14.7 Size

0

##### 1.2.3.14.8 Constraints

*No items available*

##### 1.2.3.14.9 Default Value



##### 1.2.3.14.10 Is Foreign Key

❌ No

##### 1.2.3.14.11 Precision

0

##### 1.2.3.14.12 Scale

0

#### 1.2.3.15.0 createdAt

##### 1.2.3.15.1 Name

createdAt

##### 1.2.3.15.2 Type

🔹 DateTime

##### 1.2.3.15.3 Is Required

✅ Yes

##### 1.2.3.15.4 Is Primary Key

❌ No

##### 1.2.3.15.5 Is Unique

❌ No

##### 1.2.3.15.6 Index Type

Index

##### 1.2.3.15.7 Size

0

##### 1.2.3.15.8 Constraints

*No items available*

##### 1.2.3.15.9 Default Value

CURRENT_TIMESTAMP

##### 1.2.3.15.10 Is Foreign Key

❌ No

##### 1.2.3.15.11 Precision

0

##### 1.2.3.15.12 Scale

0

#### 1.2.3.16.0 updatedAt

##### 1.2.3.16.1 Name

updatedAt

##### 1.2.3.16.2 Type

🔹 DateTime

##### 1.2.3.16.3 Is Required

✅ Yes

##### 1.2.3.16.4 Is Primary Key

❌ No

##### 1.2.3.16.5 Is Unique

❌ No

##### 1.2.3.16.6 Index Type

None

##### 1.2.3.16.7 Size

0

##### 1.2.3.16.8 Constraints

*No items available*

##### 1.2.3.16.9 Default Value

CURRENT_TIMESTAMP

##### 1.2.3.16.10 Is Foreign Key

❌ No

##### 1.2.3.16.11 Precision

0

##### 1.2.3.16.12 Scale

0

### 1.2.4.0.0 Primary Keys

- userId

### 1.2.5.0.0 Unique Constraints

#### 1.2.5.1.0 UC_User_Tenant_Email

##### 1.2.5.1.1 Name

UC_User_Tenant_Email

##### 1.2.5.1.2 Columns

- tenantId
- email

#### 1.2.5.2.0 UC_User_InvitationToken

##### 1.2.5.2.1 Name

UC_User_InvitationToken

##### 1.2.5.2.2 Columns

- invitationToken

### 1.2.6.0.0 Indexes

#### 1.2.6.1.0 IX_User_TenantId

##### 1.2.6.1.1 Name

IX_User_TenantId

##### 1.2.6.1.2 Columns

- tenantId

##### 1.2.6.1.3 Type

🔹 BTree

#### 1.2.6.2.0 IX_User_SupervisorId

##### 1.2.6.2.1 Name

IX_User_SupervisorId

##### 1.2.6.2.2 Columns

- supervisorId

##### 1.2.6.2.3 Type

🔹 BTree

#### 1.2.6.3.0 IX_User_Tenant_Status

##### 1.2.6.3.1 Name

IX_User_Tenant_Status

##### 1.2.6.3.2 Columns

- tenantId
- status

##### 1.2.6.3.3 Type

🔹 BTree

#### 1.2.6.4.0 IX_User_Status_DeactivatedAt_ForAnonymization

##### 1.2.6.4.1 Name

IX_User_Status_DeactivatedAt_ForAnonymization

##### 1.2.6.4.2 Columns

- status
- deactivatedAt

##### 1.2.6.4.3 Type

🔹 BTree

#### 1.2.6.5.0 IX_User_HierarchyPath

##### 1.2.6.5.1 Name

IX_User_HierarchyPath

##### 1.2.6.5.2 Columns

- hierarchyPath

##### 1.2.6.5.3 Type

🔹 BTree

## 1.3.0.0.0 Team

### 1.3.1.0.0 Name

Team

### 1.3.2.0.0 Description

A logical grouping of users within a tenant, typically managed by a Supervisor. (REQ-1-015)

### 1.3.3.0.0 Attributes

#### 1.3.3.1.0 teamId

##### 1.3.3.1.1 Name

teamId

##### 1.3.3.1.2 Type

🔹 Guid

##### 1.3.3.1.3 Is Required

✅ Yes

##### 1.3.3.1.4 Is Primary Key

✅ Yes

##### 1.3.3.1.5 Is Unique

✅ Yes

##### 1.3.3.1.6 Index Type

UniqueIndex

##### 1.3.3.1.7 Size

0

##### 1.3.3.1.8 Constraints

*No items available*

##### 1.3.3.1.9 Default Value



##### 1.3.3.1.10 Is Foreign Key

❌ No

##### 1.3.3.1.11 Precision

0

##### 1.3.3.1.12 Scale

0

#### 1.3.3.2.0 tenantId

##### 1.3.3.2.1 Name

tenantId

##### 1.3.3.2.2 Type

🔹 Guid

##### 1.3.3.2.3 Is Required

✅ Yes

##### 1.3.3.2.4 Is Primary Key

❌ No

##### 1.3.3.2.5 Is Unique

❌ No

##### 1.3.3.2.6 Index Type

Index

##### 1.3.3.2.7 Size

0

##### 1.3.3.2.8 Constraints

*No items available*

##### 1.3.3.2.9 Default Value



##### 1.3.3.2.10 Is Foreign Key

✅ Yes

##### 1.3.3.2.11 Precision

0

##### 1.3.3.2.12 Scale

0

#### 1.3.3.3.0 name

##### 1.3.3.3.1 Name

name

##### 1.3.3.3.2 Type

🔹 VARCHAR

##### 1.3.3.3.3 Is Required

✅ Yes

##### 1.3.3.3.4 Is Primary Key

❌ No

##### 1.3.3.3.5 Is Unique

❌ No

##### 1.3.3.3.6 Index Type

Index

##### 1.3.3.3.7 Size

255

##### 1.3.3.3.8 Constraints

*No items available*

##### 1.3.3.3.9 Default Value



##### 1.3.3.3.10 Is Foreign Key

❌ No

##### 1.3.3.3.11 Precision

0

##### 1.3.3.3.12 Scale

0

#### 1.3.3.4.0 supervisorId

##### 1.3.3.4.1 Name

supervisorId

##### 1.3.3.4.2 Type

🔹 Guid

##### 1.3.3.4.3 Is Required

✅ Yes

##### 1.3.3.4.4 Is Primary Key

❌ No

##### 1.3.3.4.5 Is Unique

❌ No

##### 1.3.3.4.6 Index Type

Index

##### 1.3.3.4.7 Size

0

##### 1.3.3.4.8 Constraints

*No items available*

##### 1.3.3.4.9 Default Value



##### 1.3.3.4.10 Is Foreign Key

✅ Yes

##### 1.3.3.4.11 Precision

0

##### 1.3.3.4.12 Scale

0

#### 1.3.3.5.0 createdAt

##### 1.3.3.5.1 Name

createdAt

##### 1.3.3.5.2 Type

🔹 DateTime

##### 1.3.3.5.3 Is Required

✅ Yes

##### 1.3.3.5.4 Is Primary Key

❌ No

##### 1.3.3.5.5 Is Unique

❌ No

##### 1.3.3.5.6 Index Type

Index

##### 1.3.3.5.7 Size

0

##### 1.3.3.5.8 Constraints

*No items available*

##### 1.3.3.5.9 Default Value

CURRENT_TIMESTAMP

##### 1.3.3.5.10 Is Foreign Key

❌ No

##### 1.3.3.5.11 Precision

0

##### 1.3.3.5.12 Scale

0

#### 1.3.3.6.0 updatedAt

##### 1.3.3.6.1 Name

updatedAt

##### 1.3.3.6.2 Type

🔹 DateTime

##### 1.3.3.6.3 Is Required

✅ Yes

##### 1.3.3.6.4 Is Primary Key

❌ No

##### 1.3.3.6.5 Is Unique

❌ No

##### 1.3.3.6.6 Index Type

None

##### 1.3.3.6.7 Size

0

##### 1.3.3.6.8 Constraints

*No items available*

##### 1.3.3.6.9 Default Value

CURRENT_TIMESTAMP

##### 1.3.3.6.10 Is Foreign Key

❌ No

##### 1.3.3.6.11 Precision

0

##### 1.3.3.6.12 Scale

0

### 1.3.4.0.0 Primary Keys

- teamId

### 1.3.5.0.0 Unique Constraints

- {'name': 'UC_Team_Tenant_Name', 'columns': ['tenantId', 'name']}

### 1.3.6.0.0 Indexes

#### 1.3.6.1.0 IX_Team_TenantId

##### 1.3.6.1.1 Name

IX_Team_TenantId

##### 1.3.6.1.2 Columns

- tenantId

##### 1.3.6.1.3 Type

🔹 BTree

#### 1.3.6.2.0 IX_Team_SupervisorId

##### 1.3.6.2.1 Name

IX_Team_SupervisorId

##### 1.3.6.2.2 Columns

- supervisorId

##### 1.3.6.2.3 Type

🔹 BTree

## 1.4.0.0.0 UserTeamMembership

### 1.4.1.0.0 Name

UserTeamMembership

### 1.4.2.0.0 Description

Join table to represent the many-to-many relationship between Users and Teams. (REQ-1-017)

### 1.4.3.0.0 Attributes

#### 1.4.3.1.0 userTeamMembershipId

##### 1.4.3.1.1 Name

userTeamMembershipId

##### 1.4.3.1.2 Type

🔹 Guid

##### 1.4.3.1.3 Is Required

✅ Yes

##### 1.4.3.1.4 Is Primary Key

✅ Yes

##### 1.4.3.1.5 Is Unique

✅ Yes

##### 1.4.3.1.6 Index Type

UniqueIndex

##### 1.4.3.1.7 Size

0

##### 1.4.3.1.8 Constraints

*No items available*

##### 1.4.3.1.9 Default Value



##### 1.4.3.1.10 Is Foreign Key

❌ No

##### 1.4.3.1.11 Precision

0

##### 1.4.3.1.12 Scale

0

#### 1.4.3.2.0 userId

##### 1.4.3.2.1 Name

userId

##### 1.4.3.2.2 Type

🔹 Guid

##### 1.4.3.2.3 Is Required

✅ Yes

##### 1.4.3.2.4 Is Primary Key

❌ No

##### 1.4.3.2.5 Is Unique

❌ No

##### 1.4.3.2.6 Index Type

Index

##### 1.4.3.2.7 Size

0

##### 1.4.3.2.8 Constraints

*No items available*

##### 1.4.3.2.9 Default Value



##### 1.4.3.2.10 Is Foreign Key

✅ Yes

##### 1.4.3.2.11 Precision

0

##### 1.4.3.2.12 Scale

0

#### 1.4.3.3.0 teamId

##### 1.4.3.3.1 Name

teamId

##### 1.4.3.3.2 Type

🔹 Guid

##### 1.4.3.3.3 Is Required

✅ Yes

##### 1.4.3.3.4 Is Primary Key

❌ No

##### 1.4.3.3.5 Is Unique

❌ No

##### 1.4.3.3.6 Index Type

Index

##### 1.4.3.3.7 Size

0

##### 1.4.3.3.8 Constraints

*No items available*

##### 1.4.3.3.9 Default Value



##### 1.4.3.3.10 Is Foreign Key

✅ Yes

##### 1.4.3.3.11 Precision

0

##### 1.4.3.3.12 Scale

0

### 1.4.4.0.0 Primary Keys

- userTeamMembershipId

### 1.4.5.0.0 Unique Constraints

- {'name': 'UC_UserTeamMembership_User_Team', 'columns': ['userId', 'teamId']}

### 1.4.6.0.0 Indexes

#### 1.4.6.1.0 IX_UserTeamMembership_UserId

##### 1.4.6.1.1 Name

IX_UserTeamMembership_UserId

##### 1.4.6.1.2 Columns

- userId

##### 1.4.6.1.3 Type

🔹 BTree

#### 1.4.6.2.0 IX_UserTeamMembership_TeamId

##### 1.4.6.2.1 Name

IX_UserTeamMembership_TeamId

##### 1.4.6.2.2 Columns

- teamId

##### 1.4.6.2.3 Type

🔹 BTree

## 1.5.0.0.0 AttendanceRecord

### 1.5.1.0.0 Name

AttendanceRecord

### 1.5.2.0.0 Description

Stores a single attendance entry, including check-in and check-out times and locations. (REQ-1-004)

### 1.5.3.0.0 Attributes

#### 1.5.3.1.0 attendanceRecordId

##### 1.5.3.1.1 Name

attendanceRecordId

##### 1.5.3.1.2 Type

🔹 Guid

##### 1.5.3.1.3 Is Required

✅ Yes

##### 1.5.3.1.4 Is Primary Key

✅ Yes

##### 1.5.3.1.5 Is Unique

✅ Yes

##### 1.5.3.1.6 Index Type

UniqueIndex

##### 1.5.3.1.7 Size

0

##### 1.5.3.1.8 Constraints

*No items available*

##### 1.5.3.1.9 Default Value



##### 1.5.3.1.10 Is Foreign Key

❌ No

##### 1.5.3.1.11 Precision

0

##### 1.5.3.1.12 Scale

0

#### 1.5.3.2.0 userId

##### 1.5.3.2.1 Name

userId

##### 1.5.3.2.2 Type

🔹 Guid

##### 1.5.3.2.3 Is Required

✅ Yes

##### 1.5.3.2.4 Is Primary Key

❌ No

##### 1.5.3.2.5 Is Unique

❌ No

##### 1.5.3.2.6 Index Type

Index

##### 1.5.3.2.7 Size

0

##### 1.5.3.2.8 Constraints

*No items available*

##### 1.5.3.2.9 Default Value



##### 1.5.3.2.10 Is Foreign Key

✅ Yes

##### 1.5.3.2.11 Precision

0

##### 1.5.3.2.12 Scale

0

#### 1.5.3.3.0 tenantId

##### 1.5.3.3.1 Name

tenantId

##### 1.5.3.3.2 Type

🔹 Guid

##### 1.5.3.3.3 Is Required

✅ Yes

##### 1.5.3.3.4 Is Primary Key

❌ No

##### 1.5.3.3.5 Is Unique

❌ No

##### 1.5.3.3.6 Index Type

Index

##### 1.5.3.3.7 Size

0

##### 1.5.3.3.8 Constraints

*No items available*

##### 1.5.3.3.9 Default Value



##### 1.5.3.3.10 Is Foreign Key

✅ Yes

##### 1.5.3.3.11 Precision

0

##### 1.5.3.3.12 Scale

0

#### 1.5.3.4.0 userFullName

##### 1.5.3.4.1 Name

userFullName

##### 1.5.3.4.2 Type

🔹 VARCHAR

##### 1.5.3.4.3 Is Required

❌ No

##### 1.5.3.4.4 Is Primary Key

❌ No

##### 1.5.3.4.5 Is Unique

❌ No

##### 1.5.3.4.6 Index Type

None

##### 1.5.3.4.7 Size

201

##### 1.5.3.4.8 Constraints

*No items available*

##### 1.5.3.4.9 Default Value



##### 1.5.3.4.10 Is Foreign Key

❌ No

##### 1.5.3.4.11 Precision

0

##### 1.5.3.4.12 Scale

0

#### 1.5.3.5.0 checkInTime

##### 1.5.3.5.1 Name

checkInTime

##### 1.5.3.5.2 Type

🔹 DateTime

##### 1.5.3.5.3 Is Required

✅ Yes

##### 1.5.3.5.4 Is Primary Key

❌ No

##### 1.5.3.5.5 Is Unique

❌ No

##### 1.5.3.5.6 Index Type

Index

##### 1.5.3.5.7 Size

0

##### 1.5.3.5.8 Constraints

*No items available*

##### 1.5.3.5.9 Default Value



##### 1.5.3.5.10 Is Foreign Key

❌ No

##### 1.5.3.5.11 Precision

0

##### 1.5.3.5.12 Scale

0

#### 1.5.3.6.0 checkInLatitude

##### 1.5.3.6.1 Name

checkInLatitude

##### 1.5.3.6.2 Type

🔹 DECIMAL

##### 1.5.3.6.3 Is Required

✅ Yes

##### 1.5.3.6.4 Is Primary Key

❌ No

##### 1.5.3.6.5 Is Unique

❌ No

##### 1.5.3.6.6 Index Type

None

##### 1.5.3.6.7 Size

0

##### 1.5.3.6.8 Constraints

*No items available*

##### 1.5.3.6.9 Default Value



##### 1.5.3.6.10 Is Foreign Key

❌ No

##### 1.5.3.6.11 Precision

9

##### 1.5.3.6.12 Scale

6

#### 1.5.3.7.0 checkInLongitude

##### 1.5.3.7.1 Name

checkInLongitude

##### 1.5.3.7.2 Type

🔹 DECIMAL

##### 1.5.3.7.3 Is Required

✅ Yes

##### 1.5.3.7.4 Is Primary Key

❌ No

##### 1.5.3.7.5 Is Unique

❌ No

##### 1.5.3.7.6 Index Type

None

##### 1.5.3.7.7 Size

0

##### 1.5.3.7.8 Constraints

*No items available*

##### 1.5.3.7.9 Default Value



##### 1.5.3.7.10 Is Foreign Key

❌ No

##### 1.5.3.7.11 Precision

9

##### 1.5.3.7.12 Scale

6

#### 1.5.3.8.0 checkOutTime

##### 1.5.3.8.1 Name

checkOutTime

##### 1.5.3.8.2 Type

🔹 DateTime

##### 1.5.3.8.3 Is Required

❌ No

##### 1.5.3.8.4 Is Primary Key

❌ No

##### 1.5.3.8.5 Is Unique

❌ No

##### 1.5.3.8.6 Index Type

Index

##### 1.5.3.8.7 Size

0

##### 1.5.3.8.8 Constraints

*No items available*

##### 1.5.3.8.9 Default Value



##### 1.5.3.8.10 Is Foreign Key

❌ No

##### 1.5.3.8.11 Precision

0

##### 1.5.3.8.12 Scale

0

#### 1.5.3.9.0 checkOutLatitude

##### 1.5.3.9.1 Name

checkOutLatitude

##### 1.5.3.9.2 Type

🔹 DECIMAL

##### 1.5.3.9.3 Is Required

❌ No

##### 1.5.3.9.4 Is Primary Key

❌ No

##### 1.5.3.9.5 Is Unique

❌ No

##### 1.5.3.9.6 Index Type

None

##### 1.5.3.9.7 Size

0

##### 1.5.3.9.8 Constraints

*No items available*

##### 1.5.3.9.9 Default Value



##### 1.5.3.9.10 Is Foreign Key

❌ No

##### 1.5.3.9.11 Precision

9

##### 1.5.3.9.12 Scale

6

#### 1.5.3.10.0 checkOutLongitude

##### 1.5.3.10.1 Name

checkOutLongitude

##### 1.5.3.10.2 Type

🔹 DECIMAL

##### 1.5.3.10.3 Is Required

❌ No

##### 1.5.3.10.4 Is Primary Key

❌ No

##### 1.5.3.10.5 Is Unique

❌ No

##### 1.5.3.10.6 Index Type

None

##### 1.5.3.10.7 Size

0

##### 1.5.3.10.8 Constraints

*No items available*

##### 1.5.3.10.9 Default Value



##### 1.5.3.10.10 Is Foreign Key

❌ No

##### 1.5.3.10.11 Precision

9

##### 1.5.3.10.12 Scale

6

#### 1.5.3.11.0 status

##### 1.5.3.11.1 Name

status

##### 1.5.3.11.2 Type

🔹 VARCHAR

##### 1.5.3.11.3 Is Required

✅ Yes

##### 1.5.3.11.4 Is Primary Key

❌ No

##### 1.5.3.11.5 Is Unique

❌ No

##### 1.5.3.11.6 Index Type

Index

##### 1.5.3.11.7 Size

50

##### 1.5.3.11.8 Constraints

- ENUM('pending', 'approved', 'rejected', 'correction_pending')

##### 1.5.3.11.9 Default Value

pending

##### 1.5.3.11.10 Is Foreign Key

❌ No

##### 1.5.3.11.11 Precision

0

##### 1.5.3.11.12 Scale

0

#### 1.5.3.12.0 supervisorId

##### 1.5.3.12.1 Name

supervisorId

##### 1.5.3.12.2 Type

🔹 Guid

##### 1.5.3.12.3 Is Required

✅ Yes

##### 1.5.3.12.4 Is Primary Key

❌ No

##### 1.5.3.12.5 Is Unique

❌ No

##### 1.5.3.12.6 Index Type

Index

##### 1.5.3.12.7 Size

0

##### 1.5.3.12.8 Constraints

*No items available*

##### 1.5.3.12.9 Default Value



##### 1.5.3.12.10 Is Foreign Key

✅ Yes

##### 1.5.3.12.11 Precision

0

##### 1.5.3.12.12 Scale

0

#### 1.5.3.13.0 rejectionReason

##### 1.5.3.13.1 Name

rejectionReason

##### 1.5.3.13.2 Type

🔹 TEXT

##### 1.5.3.13.3 Is Required

❌ No

##### 1.5.3.13.4 Is Primary Key

❌ No

##### 1.5.3.13.5 Is Unique

❌ No

##### 1.5.3.13.6 Index Type

None

##### 1.5.3.13.7 Size

0

##### 1.5.3.13.8 Constraints

*No items available*

##### 1.5.3.13.9 Default Value



##### 1.5.3.13.10 Is Foreign Key

❌ No

##### 1.5.3.13.11 Precision

0

##### 1.5.3.13.12 Scale

0

#### 1.5.3.14.0 flags

##### 1.5.3.14.1 Name

flags

##### 1.5.3.14.2 Type

🔹 JSON

##### 1.5.3.14.3 Is Required

❌ No

##### 1.5.3.14.4 Is Primary Key

❌ No

##### 1.5.3.14.5 Is Unique

❌ No

##### 1.5.3.14.6 Index Type

None

##### 1.5.3.14.7 Size

0

##### 1.5.3.14.8 Constraints

- Array of strings: 'clock_discrepancy', 'auto-checked-out', 'isOfflineEntry', 'manually-corrected'

##### 1.5.3.14.9 Default Value

[]

##### 1.5.3.14.10 Is Foreign Key

❌ No

##### 1.5.3.14.11 Precision

0

##### 1.5.3.14.12 Scale

0

#### 1.5.3.15.0 eventId

##### 1.5.3.15.1 Name

eventId

##### 1.5.3.15.2 Type

🔹 Guid

##### 1.5.3.15.3 Is Required

❌ No

##### 1.5.3.15.4 Is Primary Key

❌ No

##### 1.5.3.15.5 Is Unique

❌ No

##### 1.5.3.15.6 Index Type

Index

##### 1.5.3.15.7 Size

0

##### 1.5.3.15.8 Constraints

*No items available*

##### 1.5.3.15.9 Default Value



##### 1.5.3.15.10 Is Foreign Key

✅ Yes

##### 1.5.3.15.11 Precision

0

##### 1.5.3.15.12 Scale

0

#### 1.5.3.16.0 createdAt

##### 1.5.3.16.1 Name

createdAt

##### 1.5.3.16.2 Type

🔹 DateTime

##### 1.5.3.16.3 Is Required

✅ Yes

##### 1.5.3.16.4 Is Primary Key

❌ No

##### 1.5.3.16.5 Is Unique

❌ No

##### 1.5.3.16.6 Index Type

Index

##### 1.5.3.16.7 Size

0

##### 1.5.3.16.8 Constraints

*No items available*

##### 1.5.3.16.9 Default Value

CURRENT_TIMESTAMP

##### 1.5.3.16.10 Is Foreign Key

❌ No

##### 1.5.3.16.11 Precision

0

##### 1.5.3.16.12 Scale

0

#### 1.5.3.17.0 updatedAt

##### 1.5.3.17.1 Name

updatedAt

##### 1.5.3.17.2 Type

🔹 DateTime

##### 1.5.3.17.3 Is Required

✅ Yes

##### 1.5.3.17.4 Is Primary Key

❌ No

##### 1.5.3.17.5 Is Unique

❌ No

##### 1.5.3.17.6 Index Type

None

##### 1.5.3.17.7 Size

0

##### 1.5.3.17.8 Constraints

*No items available*

##### 1.5.3.17.9 Default Value

CURRENT_TIMESTAMP

##### 1.5.3.17.10 Is Foreign Key

❌ No

##### 1.5.3.17.11 Precision

0

##### 1.5.3.17.12 Scale

0

### 1.5.4.0.0 Primary Keys

- attendanceRecordId

### 1.5.5.0.0 Unique Constraints

*No items available*

### 1.5.6.0.0 Indexes

#### 1.5.6.1.0 IX_AttendanceRecord_User_CheckInTime

##### 1.5.6.1.1 Name

IX_AttendanceRecord_User_CheckInTime

##### 1.5.6.1.2 Columns

- userId
- checkInTime

##### 1.5.6.1.3 Type

🔹 BTree

#### 1.5.6.2.0 IX_AttendanceRecord_Tenant_Status_Supervisor

##### 1.5.6.2.1 Name

IX_AttendanceRecord_Tenant_Status_Supervisor

##### 1.5.6.2.2 Columns

- tenantId
- status
- supervisorId

##### 1.5.6.2.3 Type

🔹 BTree

#### 1.5.6.3.0 IX_AttendanceRecord_EventId

##### 1.5.6.3.1 Name

IX_AttendanceRecord_EventId

##### 1.5.6.3.2 Columns

- eventId

##### 1.5.6.3.3 Type

🔹 BTree

#### 1.5.6.4.0 IX_Attendance_Tenant_Status_UpdatedAt_ForExport

##### 1.5.6.4.1 Name

IX_Attendance_Tenant_Status_UpdatedAt_ForExport

##### 1.5.6.4.2 Columns

- tenantId
- status
- updatedAt

##### 1.5.6.4.3 Type

🔹 BTree

#### 1.5.6.5.0 SP_AttendanceRecord_CheckInLocation

##### 1.5.6.5.1 Name

SP_AttendanceRecord_CheckInLocation

##### 1.5.6.5.2 Columns

- checkInLatitude
- checkInLongitude

##### 1.5.6.5.3 Type

🔹 Spatial

### 1.5.7.0.0 Partitioning

| Property | Value |
|----------|-------|
| Strategy | RANGE |
| Column | checkInTime |
| Interval | MONTHLY |

## 1.6.0.0.0 Event

### 1.6.1.0.0 Name

Event

### 1.6.2.0.0 Description

Represents a calendar event that can be assigned to users or teams. (REQ-1-007)

### 1.6.3.0.0 Attributes

#### 1.6.3.1.0 eventId

##### 1.6.3.1.1 Name

eventId

##### 1.6.3.1.2 Type

🔹 Guid

##### 1.6.3.1.3 Is Required

✅ Yes

##### 1.6.3.1.4 Is Primary Key

✅ Yes

##### 1.6.3.1.5 Is Unique

✅ Yes

##### 1.6.3.1.6 Index Type

UniqueIndex

##### 1.6.3.1.7 Size

0

##### 1.6.3.1.8 Constraints

*No items available*

##### 1.6.3.1.9 Default Value



##### 1.6.3.1.10 Is Foreign Key

❌ No

##### 1.6.3.1.11 Precision

0

##### 1.6.3.1.12 Scale

0

#### 1.6.3.2.0 tenantId

##### 1.6.3.2.1 Name

tenantId

##### 1.6.3.2.2 Type

🔹 Guid

##### 1.6.3.2.3 Is Required

✅ Yes

##### 1.6.3.2.4 Is Primary Key

❌ No

##### 1.6.3.2.5 Is Unique

❌ No

##### 1.6.3.2.6 Index Type

Index

##### 1.6.3.2.7 Size

0

##### 1.6.3.2.8 Constraints

*No items available*

##### 1.6.3.2.9 Default Value



##### 1.6.3.2.10 Is Foreign Key

✅ Yes

##### 1.6.3.2.11 Precision

0

##### 1.6.3.2.12 Scale

0

#### 1.6.3.3.0 title

##### 1.6.3.3.1 Name

title

##### 1.6.3.3.2 Type

🔹 VARCHAR

##### 1.6.3.3.3 Is Required

✅ Yes

##### 1.6.3.3.4 Is Primary Key

❌ No

##### 1.6.3.3.5 Is Unique

❌ No

##### 1.6.3.3.6 Index Type

None

##### 1.6.3.3.7 Size

255

##### 1.6.3.3.8 Constraints

*No items available*

##### 1.6.3.3.9 Default Value



##### 1.6.3.3.10 Is Foreign Key

❌ No

##### 1.6.3.3.11 Precision

0

##### 1.6.3.3.12 Scale

0

#### 1.6.3.4.0 description

##### 1.6.3.4.1 Name

description

##### 1.6.3.4.2 Type

🔹 TEXT

##### 1.6.3.4.3 Is Required

❌ No

##### 1.6.3.4.4 Is Primary Key

❌ No

##### 1.6.3.4.5 Is Unique

❌ No

##### 1.6.3.4.6 Index Type

None

##### 1.6.3.4.7 Size

0

##### 1.6.3.4.8 Constraints

*No items available*

##### 1.6.3.4.9 Default Value



##### 1.6.3.4.10 Is Foreign Key

❌ No

##### 1.6.3.4.11 Precision

0

##### 1.6.3.4.12 Scale

0

#### 1.6.3.5.0 startTime

##### 1.6.3.5.1 Name

startTime

##### 1.6.3.5.2 Type

🔹 DateTime

##### 1.6.3.5.3 Is Required

✅ Yes

##### 1.6.3.5.4 Is Primary Key

❌ No

##### 1.6.3.5.5 Is Unique

❌ No

##### 1.6.3.5.6 Index Type

Index

##### 1.6.3.5.7 Size

0

##### 1.6.3.5.8 Constraints

*No items available*

##### 1.6.3.5.9 Default Value



##### 1.6.3.5.10 Is Foreign Key

❌ No

##### 1.6.3.5.11 Precision

0

##### 1.6.3.5.12 Scale

0

#### 1.6.3.6.0 endTime

##### 1.6.3.6.1 Name

endTime

##### 1.6.3.6.2 Type

🔹 DateTime

##### 1.6.3.6.3 Is Required

✅ Yes

##### 1.6.3.6.4 Is Primary Key

❌ No

##### 1.6.3.6.5 Is Unique

❌ No

##### 1.6.3.6.6 Index Type

Index

##### 1.6.3.6.7 Size

0

##### 1.6.3.6.8 Constraints

*No items available*

##### 1.6.3.6.9 Default Value



##### 1.6.3.6.10 Is Foreign Key

❌ No

##### 1.6.3.6.11 Precision

0

##### 1.6.3.6.12 Scale

0

#### 1.6.3.7.0 isRecurring

##### 1.6.3.7.1 Name

isRecurring

##### 1.6.3.7.2 Type

🔹 BOOLEAN

##### 1.6.3.7.3 Is Required

✅ Yes

##### 1.6.3.7.4 Is Primary Key

❌ No

##### 1.6.3.7.5 Is Unique

❌ No

##### 1.6.3.7.6 Index Type

Index

##### 1.6.3.7.7 Size

0

##### 1.6.3.7.8 Constraints

*No items available*

##### 1.6.3.7.9 Default Value

false

##### 1.6.3.7.10 Is Foreign Key

❌ No

##### 1.6.3.7.11 Precision

0

##### 1.6.3.7.12 Scale

0

#### 1.6.3.8.0 recurrenceRule

##### 1.6.3.8.1 Name

recurrenceRule

##### 1.6.3.8.2 Type

🔹 VARCHAR

##### 1.6.3.8.3 Is Required

❌ No

##### 1.6.3.8.4 Is Primary Key

❌ No

##### 1.6.3.8.5 Is Unique

❌ No

##### 1.6.3.8.6 Index Type

None

##### 1.6.3.8.7 Size

255

##### 1.6.3.8.8 Constraints

- iCal RRULE format

##### 1.6.3.8.9 Default Value



##### 1.6.3.8.10 Is Foreign Key

❌ No

##### 1.6.3.8.11 Precision

0

##### 1.6.3.8.12 Scale

0

#### 1.6.3.9.0 createdByUserId

##### 1.6.3.9.1 Name

createdByUserId

##### 1.6.3.9.2 Type

🔹 Guid

##### 1.6.3.9.3 Is Required

✅ Yes

##### 1.6.3.9.4 Is Primary Key

❌ No

##### 1.6.3.9.5 Is Unique

❌ No

##### 1.6.3.9.6 Index Type

Index

##### 1.6.3.9.7 Size

0

##### 1.6.3.9.8 Constraints

*No items available*

##### 1.6.3.9.9 Default Value



##### 1.6.3.9.10 Is Foreign Key

✅ Yes

##### 1.6.3.9.11 Precision

0

##### 1.6.3.9.12 Scale

0

#### 1.6.3.10.0 createdAt

##### 1.6.3.10.1 Name

createdAt

##### 1.6.3.10.2 Type

🔹 DateTime

##### 1.6.3.10.3 Is Required

✅ Yes

##### 1.6.3.10.4 Is Primary Key

❌ No

##### 1.6.3.10.5 Is Unique

❌ No

##### 1.6.3.10.6 Index Type

Index

##### 1.6.3.10.7 Size

0

##### 1.6.3.10.8 Constraints

*No items available*

##### 1.6.3.10.9 Default Value

CURRENT_TIMESTAMP

##### 1.6.3.10.10 Is Foreign Key

❌ No

##### 1.6.3.10.11 Precision

0

##### 1.6.3.10.12 Scale

0

#### 1.6.3.11.0 updatedAt

##### 1.6.3.11.1 Name

updatedAt

##### 1.6.3.11.2 Type

🔹 DateTime

##### 1.6.3.11.3 Is Required

✅ Yes

##### 1.6.3.11.4 Is Primary Key

❌ No

##### 1.6.3.11.5 Is Unique

❌ No

##### 1.6.3.11.6 Index Type

None

##### 1.6.3.11.7 Size

0

##### 1.6.3.11.8 Constraints

*No items available*

##### 1.6.3.11.9 Default Value

CURRENT_TIMESTAMP

##### 1.6.3.11.10 Is Foreign Key

❌ No

##### 1.6.3.11.11 Precision

0

##### 1.6.3.11.12 Scale

0

### 1.6.4.0.0 Primary Keys

- eventId

### 1.6.5.0.0 Unique Constraints

*No items available*

### 1.6.6.0.0 Indexes

#### 1.6.6.1.0 IX_Event_Tenant_StartTime

##### 1.6.6.1.1 Name

IX_Event_Tenant_StartTime

##### 1.6.6.1.2 Columns

- tenantId
- startTime

##### 1.6.6.1.3 Type

🔹 BTree

#### 1.6.6.2.0 IX_Event_CreatedByUserId

##### 1.6.6.2.1 Name

IX_Event_CreatedByUserId

##### 1.6.6.2.2 Columns

- createdByUserId

##### 1.6.6.2.3 Type

🔹 BTree

## 1.7.0.0.0 EventAssignment

### 1.7.1.0.0 Name

EventAssignment

### 1.7.2.0.0 Description

Join table to represent the many-to-many relationship between Events and their assignees (Users or Teams). (REQ-1-007)

### 1.7.3.0.0 Attributes

#### 1.7.3.1.0 eventAssignmentId

##### 1.7.3.1.1 Name

eventAssignmentId

##### 1.7.3.1.2 Type

🔹 Guid

##### 1.7.3.1.3 Is Required

✅ Yes

##### 1.7.3.1.4 Is Primary Key

✅ Yes

##### 1.7.3.1.5 Is Unique

✅ Yes

##### 1.7.3.1.6 Index Type

UniqueIndex

##### 1.7.3.1.7 Size

0

##### 1.7.3.1.8 Constraints

*No items available*

##### 1.7.3.1.9 Default Value



##### 1.7.3.1.10 Is Foreign Key

❌ No

##### 1.7.3.1.11 Precision

0

##### 1.7.3.1.12 Scale

0

#### 1.7.3.2.0 eventId

##### 1.7.3.2.1 Name

eventId

##### 1.7.3.2.2 Type

🔹 Guid

##### 1.7.3.2.3 Is Required

✅ Yes

##### 1.7.3.2.4 Is Primary Key

❌ No

##### 1.7.3.2.5 Is Unique

❌ No

##### 1.7.3.2.6 Index Type

Index

##### 1.7.3.2.7 Size

0

##### 1.7.3.2.8 Constraints

*No items available*

##### 1.7.3.2.9 Default Value



##### 1.7.3.2.10 Is Foreign Key

✅ Yes

##### 1.7.3.2.11 Precision

0

##### 1.7.3.2.12 Scale

0

#### 1.7.3.3.0 assigneeId

##### 1.7.3.3.1 Name

assigneeId

##### 1.7.3.3.2 Type

🔹 Guid

##### 1.7.3.3.3 Is Required

✅ Yes

##### 1.7.3.3.4 Is Primary Key

❌ No

##### 1.7.3.3.5 Is Unique

❌ No

##### 1.7.3.3.6 Index Type

Index

##### 1.7.3.3.7 Size

0

##### 1.7.3.3.8 Constraints

*No items available*

##### 1.7.3.3.9 Default Value



##### 1.7.3.3.10 Is Foreign Key

❌ No

##### 1.7.3.3.11 Precision

0

##### 1.7.3.3.12 Scale

0

#### 1.7.3.4.0 assigneeType

##### 1.7.3.4.1 Name

assigneeType

##### 1.7.3.4.2 Type

🔹 VARCHAR

##### 1.7.3.4.3 Is Required

✅ Yes

##### 1.7.3.4.4 Is Primary Key

❌ No

##### 1.7.3.4.5 Is Unique

❌ No

##### 1.7.3.4.6 Index Type

Index

##### 1.7.3.4.7 Size

50

##### 1.7.3.4.8 Constraints

- ENUM('USER', 'TEAM')

##### 1.7.3.4.9 Default Value



##### 1.7.3.4.10 Is Foreign Key

❌ No

##### 1.7.3.4.11 Precision

0

##### 1.7.3.4.12 Scale

0

### 1.7.4.0.0 Primary Keys

- eventAssignmentId

### 1.7.5.0.0 Unique Constraints

- {'name': 'UC_EventAssignment_Event_Assignee', 'columns': ['eventId', 'assigneeId', 'assigneeType']}

### 1.7.6.0.0 Indexes

#### 1.7.6.1.0 IX_EventAssignment_EventId

##### 1.7.6.1.1 Name

IX_EventAssignment_EventId

##### 1.7.6.1.2 Columns

- eventId

##### 1.7.6.1.3 Type

🔹 BTree

#### 1.7.6.2.0 IX_EventAssignment_Assignee

##### 1.7.6.2.1 Name

IX_EventAssignment_Assignee

##### 1.7.6.2.2 Columns

- assigneeId
- assigneeType

##### 1.7.6.2.3 Type

🔹 BTree

## 1.8.0.0.0 AuditLog

### 1.8.1.0.0 Name

AuditLog

### 1.8.2.0.0 Description

An immutable log of critical system actions for auditing and tracking changes. (REQ-1-006, REQ-1-028)

### 1.8.3.0.0 Attributes

#### 1.8.3.1.0 auditLogId

##### 1.8.3.1.1 Name

auditLogId

##### 1.8.3.1.2 Type

🔹 Guid

##### 1.8.3.1.3 Is Required

✅ Yes

##### 1.8.3.1.4 Is Primary Key

✅ Yes

##### 1.8.3.1.5 Is Unique

✅ Yes

##### 1.8.3.1.6 Index Type

UniqueIndex

##### 1.8.3.1.7 Size

0

##### 1.8.3.1.8 Constraints

*No items available*

##### 1.8.3.1.9 Default Value



##### 1.8.3.1.10 Is Foreign Key

❌ No

##### 1.8.3.1.11 Precision

0

##### 1.8.3.1.12 Scale

0

#### 1.8.3.2.0 tenantId

##### 1.8.3.2.1 Name

tenantId

##### 1.8.3.2.2 Type

🔹 Guid

##### 1.8.3.2.3 Is Required

✅ Yes

##### 1.8.3.2.4 Is Primary Key

❌ No

##### 1.8.3.2.5 Is Unique

❌ No

##### 1.8.3.2.6 Index Type

Index

##### 1.8.3.2.7 Size

0

##### 1.8.3.2.8 Constraints

*No items available*

##### 1.8.3.2.9 Default Value



##### 1.8.3.2.10 Is Foreign Key

✅ Yes

##### 1.8.3.2.11 Precision

0

##### 1.8.3.2.12 Scale

0

#### 1.8.3.3.0 actingUserId

##### 1.8.3.3.1 Name

actingUserId

##### 1.8.3.3.2 Type

🔹 Guid

##### 1.8.3.3.3 Is Required

✅ Yes

##### 1.8.3.3.4 Is Primary Key

❌ No

##### 1.8.3.3.5 Is Unique

❌ No

##### 1.8.3.3.6 Index Type

Index

##### 1.8.3.3.7 Size

0

##### 1.8.3.3.8 Constraints

*No items available*

##### 1.8.3.3.9 Default Value



##### 1.8.3.3.10 Is Foreign Key

✅ Yes

##### 1.8.3.3.11 Precision

0

##### 1.8.3.3.12 Scale

0

#### 1.8.3.4.0 targetEntity

##### 1.8.3.4.1 Name

targetEntity

##### 1.8.3.4.2 Type

🔹 VARCHAR

##### 1.8.3.4.3 Is Required

✅ Yes

##### 1.8.3.4.4 Is Primary Key

❌ No

##### 1.8.3.4.5 Is Unique

❌ No

##### 1.8.3.4.6 Index Type

Index

##### 1.8.3.4.7 Size

100

##### 1.8.3.4.8 Constraints

*No items available*

##### 1.8.3.4.9 Default Value



##### 1.8.3.4.10 Is Foreign Key

❌ No

##### 1.8.3.4.11 Precision

0

##### 1.8.3.4.12 Scale

0

#### 1.8.3.5.0 targetEntityId

##### 1.8.3.5.1 Name

targetEntityId

##### 1.8.3.5.2 Type

🔹 Guid

##### 1.8.3.5.3 Is Required

✅ Yes

##### 1.8.3.5.4 Is Primary Key

❌ No

##### 1.8.3.5.5 Is Unique

❌ No

##### 1.8.3.5.6 Index Type

Index

##### 1.8.3.5.7 Size

0

##### 1.8.3.5.8 Constraints

*No items available*

##### 1.8.3.5.9 Default Value



##### 1.8.3.5.10 Is Foreign Key

❌ No

##### 1.8.3.5.11 Precision

0

##### 1.8.3.5.12 Scale

0

#### 1.8.3.6.0 actionType

##### 1.8.3.6.1 Name

actionType

##### 1.8.3.6.2 Type

🔹 VARCHAR

##### 1.8.3.6.3 Is Required

✅ Yes

##### 1.8.3.6.4 Is Primary Key

❌ No

##### 1.8.3.6.5 Is Unique

❌ No

##### 1.8.3.6.6 Index Type

Index

##### 1.8.3.6.7 Size

100

##### 1.8.3.6.8 Constraints

- ENUM('DIRECT_EDIT', 'CORRECTION_APPROVED', 'CORRECTION_REJECTED', 'APPROVAL_ESCALATION', 'USER_DEACTIVATED')

##### 1.8.3.6.9 Default Value



##### 1.8.3.6.10 Is Foreign Key

❌ No

##### 1.8.3.6.11 Precision

0

##### 1.8.3.6.12 Scale

0

#### 1.8.3.7.0 details

##### 1.8.3.7.1 Name

details

##### 1.8.3.7.2 Type

🔹 JSON

##### 1.8.3.7.3 Is Required

✅ Yes

##### 1.8.3.7.4 Is Primary Key

❌ No

##### 1.8.3.7.5 Is Unique

❌ No

##### 1.8.3.7.6 Index Type

None

##### 1.8.3.7.7 Size

0

##### 1.8.3.7.8 Constraints

- Contains old/new values, justification, etc.

##### 1.8.3.7.9 Default Value

{}

##### 1.8.3.7.10 Is Foreign Key

❌ No

##### 1.8.3.7.11 Precision

0

##### 1.8.3.7.12 Scale

0

#### 1.8.3.8.0 timestamp

##### 1.8.3.8.1 Name

timestamp

##### 1.8.3.8.2 Type

🔹 DateTime

##### 1.8.3.8.3 Is Required

✅ Yes

##### 1.8.3.8.4 Is Primary Key

❌ No

##### 1.8.3.8.5 Is Unique

❌ No

##### 1.8.3.8.6 Index Type

Index

##### 1.8.3.8.7 Size

0

##### 1.8.3.8.8 Constraints

*No items available*

##### 1.8.3.8.9 Default Value

CURRENT_TIMESTAMP

##### 1.8.3.8.10 Is Foreign Key

❌ No

##### 1.8.3.8.11 Precision

0

##### 1.8.3.8.12 Scale

0

### 1.8.4.0.0 Primary Keys

- auditLogId

### 1.8.5.0.0 Unique Constraints

*No items available*

### 1.8.6.0.0 Indexes

#### 1.8.6.1.0 IX_AuditLog_Tenant_Timestamp

##### 1.8.6.1.1 Name

IX_AuditLog_Tenant_Timestamp

##### 1.8.6.1.2 Columns

- tenantId
- timestamp

##### 1.8.6.1.3 Type

🔹 BTree

#### 1.8.6.2.0 IX_AuditLog_TargetEntity

##### 1.8.6.2.1 Name

IX_AuditLog_TargetEntity

##### 1.8.6.2.2 Columns

- targetEntity
- targetEntityId

##### 1.8.6.2.3 Type

🔹 BTree

#### 1.8.6.3.0 IX_AuditLog_ActingUserId

##### 1.8.6.3.1 Name

IX_AuditLog_ActingUserId

##### 1.8.6.3.2 Columns

- actingUserId

##### 1.8.6.3.3 Type

🔹 BTree

### 1.8.7.0.0 Partitioning

| Property | Value |
|----------|-------|
| Strategy | RANGE |
| Column | timestamp |
| Interval | MONTHLY |

## 1.9.0.0.0 SubscriptionPlan

### 1.9.1.0.0 Name

SubscriptionPlan

### 1.9.2.0.0 Description

Defines the available subscription tiers and their features. (REQ-1-001) This table is small and static, intended to be cached in application memory at startup to eliminate database lookups for feature checks.

### 1.9.3.0.0 Attributes

#### 1.9.3.1.0 subscriptionPlanId

##### 1.9.3.1.1 Name

subscriptionPlanId

##### 1.9.3.1.2 Type

🔹 Guid

##### 1.9.3.1.3 Is Required

✅ Yes

##### 1.9.3.1.4 Is Primary Key

✅ Yes

##### 1.9.3.1.5 Is Unique

✅ Yes

##### 1.9.3.1.6 Index Type

UniqueIndex

##### 1.9.3.1.7 Size

0

##### 1.9.3.1.8 Constraints

*No items available*

##### 1.9.3.1.9 Default Value



##### 1.9.3.1.10 Is Foreign Key

❌ No

##### 1.9.3.1.11 Precision

0

##### 1.9.3.1.12 Scale

0

#### 1.9.3.2.0 name

##### 1.9.3.2.1 Name

name

##### 1.9.3.2.2 Type

🔹 VARCHAR

##### 1.9.3.2.3 Is Required

✅ Yes

##### 1.9.3.2.4 Is Primary Key

❌ No

##### 1.9.3.2.5 Is Unique

✅ Yes

##### 1.9.3.2.6 Index Type

UniqueIndex

##### 1.9.3.2.7 Size

100

##### 1.9.3.2.8 Constraints

*No items available*

##### 1.9.3.2.9 Default Value



##### 1.9.3.2.10 Is Foreign Key

❌ No

##### 1.9.3.2.11 Precision

0

##### 1.9.3.2.12 Scale

0

#### 1.9.3.3.0 description

##### 1.9.3.3.1 Name

description

##### 1.9.3.3.2 Type

🔹 TEXT

##### 1.9.3.3.3 Is Required

❌ No

##### 1.9.3.3.4 Is Primary Key

❌ No

##### 1.9.3.3.5 Is Unique

❌ No

##### 1.9.3.3.6 Index Type

None

##### 1.9.3.3.7 Size

0

##### 1.9.3.3.8 Constraints

*No items available*

##### 1.9.3.3.9 Default Value



##### 1.9.3.3.10 Is Foreign Key

❌ No

##### 1.9.3.3.11 Precision

0

##### 1.9.3.3.12 Scale

0

#### 1.9.3.4.0 price

##### 1.9.3.4.1 Name

price

##### 1.9.3.4.2 Type

🔹 DECIMAL

##### 1.9.3.4.3 Is Required

✅ Yes

##### 1.9.3.4.4 Is Primary Key

❌ No

##### 1.9.3.4.5 Is Unique

❌ No

##### 1.9.3.4.6 Index Type

None

##### 1.9.3.4.7 Size

0

##### 1.9.3.4.8 Constraints

- NON_NEGATIVE

##### 1.9.3.4.9 Default Value

0.00

##### 1.9.3.4.10 Is Foreign Key

❌ No

##### 1.9.3.4.11 Precision

10

##### 1.9.3.4.12 Scale

2

#### 1.9.3.5.0 features

##### 1.9.3.5.1 Name

features

##### 1.9.3.5.2 Type

🔹 JSON

##### 1.9.3.5.3 Is Required

❌ No

##### 1.9.3.5.4 Is Primary Key

❌ No

##### 1.9.3.5.5 Is Unique

❌ No

##### 1.9.3.5.6 Index Type

None

##### 1.9.3.5.7 Size

0

##### 1.9.3.5.8 Constraints

*No items available*

##### 1.9.3.5.9 Default Value

{}

##### 1.9.3.5.10 Is Foreign Key

❌ No

##### 1.9.3.5.11 Precision

0

##### 1.9.3.5.12 Scale

0

### 1.9.4.0.0 Primary Keys

- subscriptionPlanId

### 1.9.5.0.0 Unique Constraints

- {'name': 'UC_SubscriptionPlan_Name', 'columns': ['name']}

### 1.9.6.0.0 Indexes

*No items available*

## 1.10.0.0.0 TenantConfiguration

### 1.10.1.0.0 Name

TenantConfiguration

### 1.10.2.0.0 Description

Stores tenant-specific settings and configurable business rules. (REQ-1-061) This configuration is read frequently and updated rarely, making it a prime candidate for a write-through cache (e.g., Redis).

### 1.10.3.0.0 Attributes

#### 1.10.3.1.0 tenantId

##### 1.10.3.1.1 Name

tenantId

##### 1.10.3.1.2 Type

🔹 Guid

##### 1.10.3.1.3 Is Required

✅ Yes

##### 1.10.3.1.4 Is Primary Key

✅ Yes

##### 1.10.3.1.5 Is Unique

✅ Yes

##### 1.10.3.1.6 Index Type

UniqueIndex

##### 1.10.3.1.7 Size

0

##### 1.10.3.1.8 Constraints

*No items available*

##### 1.10.3.1.9 Default Value



##### 1.10.3.1.10 Is Foreign Key

✅ Yes

##### 1.10.3.1.11 Precision

0

##### 1.10.3.1.12 Scale

0

#### 1.10.3.2.0 timezone

##### 1.10.3.2.1 Name

timezone

##### 1.10.3.2.2 Type

🔹 VARCHAR

##### 1.10.3.2.3 Is Required

✅ Yes

##### 1.10.3.2.4 Is Primary Key

❌ No

##### 1.10.3.2.5 Is Unique

❌ No

##### 1.10.3.2.6 Index Type

None

##### 1.10.3.2.7 Size

100

##### 1.10.3.2.8 Constraints

*No items available*

##### 1.10.3.2.9 Default Value

UTC

##### 1.10.3.2.10 Is Foreign Key

❌ No

##### 1.10.3.2.11 Precision

0

##### 1.10.3.2.12 Scale

0

#### 1.10.3.3.0 autoCheckoutTime

##### 1.10.3.3.1 Name

autoCheckoutTime

##### 1.10.3.3.2 Type

🔹 TIME

##### 1.10.3.3.3 Is Required

❌ No

##### 1.10.3.3.4 Is Primary Key

❌ No

##### 1.10.3.3.5 Is Unique

❌ No

##### 1.10.3.3.6 Index Type

None

##### 1.10.3.3.7 Size

0

##### 1.10.3.3.8 Constraints

*No items available*

##### 1.10.3.3.9 Default Value



##### 1.10.3.3.10 Is Foreign Key

❌ No

##### 1.10.3.3.11 Precision

0

##### 1.10.3.3.12 Scale

0

#### 1.10.3.4.0 approvalEscalationPeriodDays

##### 1.10.3.4.1 Name

approvalEscalationPeriodDays

##### 1.10.3.4.2 Type

🔹 INT

##### 1.10.3.4.3 Is Required

✅ Yes

##### 1.10.3.4.4 Is Primary Key

❌ No

##### 1.10.3.4.5 Is Unique

❌ No

##### 1.10.3.4.6 Index Type

None

##### 1.10.3.4.7 Size

0

##### 1.10.3.4.8 Constraints

- POSITIVE_VALUE

##### 1.10.3.4.9 Default Value

3

##### 1.10.3.4.10 Is Foreign Key

❌ No

##### 1.10.3.4.11 Precision

0

##### 1.10.3.4.12 Scale

0

#### 1.10.3.5.0 defaultWorkingHours

##### 1.10.3.5.1 Name

defaultWorkingHours

##### 1.10.3.5.2 Type

🔹 JSON

##### 1.10.3.5.3 Is Required

❌ No

##### 1.10.3.5.4 Is Primary Key

❌ No

##### 1.10.3.5.5 Is Unique

❌ No

##### 1.10.3.5.6 Index Type

None

##### 1.10.3.5.7 Size

0

##### 1.10.3.5.8 Constraints

- {"start":"09:00", "end":"17:00"}

##### 1.10.3.5.9 Default Value

{}

##### 1.10.3.5.10 Is Foreign Key

❌ No

##### 1.10.3.5.11 Precision

0

##### 1.10.3.5.12 Scale

0

#### 1.10.3.6.0 passwordPolicy

##### 1.10.3.6.1 Name

passwordPolicy

##### 1.10.3.6.2 Type

🔹 JSON

##### 1.10.3.6.3 Is Required

❌ No

##### 1.10.3.6.4 Is Primary Key

❌ No

##### 1.10.3.6.5 Is Unique

❌ No

##### 1.10.3.6.6 Index Type

None

##### 1.10.3.6.7 Size

0

##### 1.10.3.6.8 Constraints

*No items available*

##### 1.10.3.6.9 Default Value

{}

##### 1.10.3.6.10 Is Foreign Key

❌ No

##### 1.10.3.6.11 Precision

0

##### 1.10.3.6.12 Scale

0

#### 1.10.3.7.0 dataRetentionPeriods

##### 1.10.3.7.1 Name

dataRetentionPeriods

##### 1.10.3.7.2 Type

🔹 JSON

##### 1.10.3.7.3 Is Required

❌ No

##### 1.10.3.7.4 Is Primary Key

❌ No

##### 1.10.3.7.5 Is Unique

❌ No

##### 1.10.3.7.6 Index Type

None

##### 1.10.3.7.7 Size

0

##### 1.10.3.7.8 Constraints

- {"attendance": 365, "auditLog": 2555}

##### 1.10.3.7.9 Default Value

{}

##### 1.10.3.7.10 Is Foreign Key

❌ No

##### 1.10.3.7.11 Precision

0

##### 1.10.3.7.12 Scale

0

#### 1.10.3.8.0 updatedAt

##### 1.10.3.8.1 Name

updatedAt

##### 1.10.3.8.2 Type

🔹 DateTime

##### 1.10.3.8.3 Is Required

✅ Yes

##### 1.10.3.8.4 Is Primary Key

❌ No

##### 1.10.3.8.5 Is Unique

❌ No

##### 1.10.3.8.6 Index Type

None

##### 1.10.3.8.7 Size

0

##### 1.10.3.8.8 Constraints

*No items available*

##### 1.10.3.8.9 Default Value

CURRENT_TIMESTAMP

##### 1.10.3.8.10 Is Foreign Key

❌ No

##### 1.10.3.8.11 Precision

0

##### 1.10.3.8.12 Scale

0

### 1.10.4.0.0 Primary Keys

- tenantId

### 1.10.5.0.0 Unique Constraints

*No items available*

### 1.10.6.0.0 Indexes

*No items available*

## 1.11.0.0.0 GoogleSheetIntegration

### 1.11.1.0.0 Name

GoogleSheetIntegration

### 1.11.2.0.0 Description

Stores configuration and credentials for exporting data to Google Sheets. (REQ-1-008)

### 1.11.3.0.0 Attributes

#### 1.11.3.1.0 googleSheetIntegrationId

##### 1.11.3.1.1 Name

googleSheetIntegrationId

##### 1.11.3.1.2 Type

🔹 Guid

##### 1.11.3.1.3 Is Required

✅ Yes

##### 1.11.3.1.4 Is Primary Key

✅ Yes

##### 1.11.3.1.5 Is Unique

✅ Yes

##### 1.11.3.1.6 Index Type

UniqueIndex

##### 1.11.3.1.7 Size

0

##### 1.11.3.1.8 Constraints

*No items available*

##### 1.11.3.1.9 Default Value



##### 1.11.3.1.10 Is Foreign Key

❌ No

##### 1.11.3.1.11 Precision

0

##### 1.11.3.1.12 Scale

0

#### 1.11.3.2.0 tenantId

##### 1.11.3.2.1 Name

tenantId

##### 1.11.3.2.2 Type

🔹 Guid

##### 1.11.3.2.3 Is Required

✅ Yes

##### 1.11.3.2.4 Is Primary Key

❌ No

##### 1.11.3.2.5 Is Unique

✅ Yes

##### 1.11.3.2.6 Index Type

UniqueIndex

##### 1.11.3.2.7 Size

0

##### 1.11.3.2.8 Constraints

*No items available*

##### 1.11.3.2.9 Default Value



##### 1.11.3.2.10 Is Foreign Key

✅ Yes

##### 1.11.3.2.11 Precision

0

##### 1.11.3.2.12 Scale

0

#### 1.11.3.3.0 googleSheetId

##### 1.11.3.3.1 Name

googleSheetId

##### 1.11.3.3.2 Type

🔹 VARCHAR

##### 1.11.3.3.3 Is Required

✅ Yes

##### 1.11.3.3.4 Is Primary Key

❌ No

##### 1.11.3.3.5 Is Unique

❌ No

##### 1.11.3.3.6 Index Type

None

##### 1.11.3.3.7 Size

255

##### 1.11.3.3.8 Constraints

*No items available*

##### 1.11.3.3.9 Default Value



##### 1.11.3.3.10 Is Foreign Key

❌ No

##### 1.11.3.3.11 Precision

0

##### 1.11.3.3.12 Scale

0

#### 1.11.3.4.0 encryptedRefreshToken

##### 1.11.3.4.1 Name

encryptedRefreshToken

##### 1.11.3.4.2 Type

🔹 TEXT

##### 1.11.3.4.3 Is Required

✅ Yes

##### 1.11.3.4.4 Is Primary Key

❌ No

##### 1.11.3.4.5 Is Unique

❌ No

##### 1.11.3.4.6 Index Type

None

##### 1.11.3.4.7 Size

0

##### 1.11.3.4.8 Constraints

*No items available*

##### 1.11.3.4.9 Default Value



##### 1.11.3.4.10 Is Foreign Key

❌ No

##### 1.11.3.4.11 Precision

0

##### 1.11.3.4.12 Scale

0

#### 1.11.3.5.0 status

##### 1.11.3.5.1 Name

status

##### 1.11.3.5.2 Type

🔹 VARCHAR

##### 1.11.3.5.3 Is Required

✅ Yes

##### 1.11.3.5.4 Is Primary Key

❌ No

##### 1.11.3.5.5 Is Unique

❌ No

##### 1.11.3.5.6 Index Type

Index

##### 1.11.3.5.7 Size

50

##### 1.11.3.5.8 Constraints

- ENUM('active', 'error', 'disabled')

##### 1.11.3.5.9 Default Value

active

##### 1.11.3.5.10 Is Foreign Key

❌ No

##### 1.11.3.5.11 Precision

0

##### 1.11.3.5.12 Scale

0

#### 1.11.3.6.0 lastSyncTimestamp

##### 1.11.3.6.1 Name

lastSyncTimestamp

##### 1.11.3.6.2 Type

🔹 DateTime

##### 1.11.3.6.3 Is Required

❌ No

##### 1.11.3.6.4 Is Primary Key

❌ No

##### 1.11.3.6.5 Is Unique

❌ No

##### 1.11.3.6.6 Index Type

Index

##### 1.11.3.6.7 Size

0

##### 1.11.3.6.8 Constraints

*No items available*

##### 1.11.3.6.9 Default Value



##### 1.11.3.6.10 Is Foreign Key

❌ No

##### 1.11.3.6.11 Precision

0

##### 1.11.3.6.12 Scale

0

#### 1.11.3.7.0 lastSyncError

##### 1.11.3.7.1 Name

lastSyncError

##### 1.11.3.7.2 Type

🔹 TEXT

##### 1.11.3.7.3 Is Required

❌ No

##### 1.11.3.7.4 Is Primary Key

❌ No

##### 1.11.3.7.5 Is Unique

❌ No

##### 1.11.3.7.6 Index Type

None

##### 1.11.3.7.7 Size

0

##### 1.11.3.7.8 Constraints

*No items available*

##### 1.11.3.7.9 Default Value



##### 1.11.3.7.10 Is Foreign Key

❌ No

##### 1.11.3.7.11 Precision

0

##### 1.11.3.7.12 Scale

0

#### 1.11.3.8.0 createdAt

##### 1.11.3.8.1 Name

createdAt

##### 1.11.3.8.2 Type

🔹 DateTime

##### 1.11.3.8.3 Is Required

✅ Yes

##### 1.11.3.8.4 Is Primary Key

❌ No

##### 1.11.3.8.5 Is Unique

❌ No

##### 1.11.3.8.6 Index Type

Index

##### 1.11.3.8.7 Size

0

##### 1.11.3.8.8 Constraints

*No items available*

##### 1.11.3.8.9 Default Value

CURRENT_TIMESTAMP

##### 1.11.3.8.10 Is Foreign Key

❌ No

##### 1.11.3.8.11 Precision

0

##### 1.11.3.8.12 Scale

0

#### 1.11.3.9.0 updatedAt

##### 1.11.3.9.1 Name

updatedAt

##### 1.11.3.9.2 Type

🔹 DateTime

##### 1.11.3.9.3 Is Required

✅ Yes

##### 1.11.3.9.4 Is Primary Key

❌ No

##### 1.11.3.9.5 Is Unique

❌ No

##### 1.11.3.9.6 Index Type

None

##### 1.11.3.9.7 Size

0

##### 1.11.3.9.8 Constraints

*No items available*

##### 1.11.3.9.9 Default Value

CURRENT_TIMESTAMP

##### 1.11.3.9.10 Is Foreign Key

❌ No

##### 1.11.3.9.11 Precision

0

##### 1.11.3.9.12 Scale

0

### 1.11.4.0.0 Primary Keys

- googleSheetIntegrationId

### 1.11.5.0.0 Unique Constraints

- {'name': 'UC_GoogleSheetIntegration_TenantId', 'columns': ['tenantId']}

### 1.11.6.0.0 Indexes

- {'name': 'IX_GoogleSheetIntegration_Status', 'columns': ['status'], 'type': 'BTree'}

## 1.12.0.0.0 DailyUserSummary

### 1.12.1.0.0 Name

DailyUserSummary

### 1.12.2.0.0 Description

Pre-aggregated daily summary data for a user to speed up reporting. Populated by a scheduled batch job.

### 1.12.3.0.0 Attributes

#### 1.12.3.1.0 summaryDate

##### 1.12.3.1.1 Name

summaryDate

##### 1.12.3.1.2 Type

🔹 Date

##### 1.12.3.1.3 Is Required

✅ Yes

##### 1.12.3.1.4 Is Primary Key

✅ Yes

##### 1.12.3.1.5 Is Unique

❌ No

##### 1.12.3.1.6 Index Type

None

##### 1.12.3.1.7 Size

0

##### 1.12.3.1.8 Constraints

*No items available*

##### 1.12.3.1.9 Default Value



##### 1.12.3.1.10 Is Foreign Key

❌ No

##### 1.12.3.1.11 Precision

0

##### 1.12.3.1.12 Scale

0

#### 1.12.3.2.0 userId

##### 1.12.3.2.1 Name

userId

##### 1.12.3.2.2 Type

🔹 Guid

##### 1.12.3.2.3 Is Required

✅ Yes

##### 1.12.3.2.4 Is Primary Key

✅ Yes

##### 1.12.3.2.5 Is Unique

❌ No

##### 1.12.3.2.6 Index Type

None

##### 1.12.3.2.7 Size

0

##### 1.12.3.2.8 Constraints

*No items available*

##### 1.12.3.2.9 Default Value



##### 1.12.3.2.10 Is Foreign Key

✅ Yes

##### 1.12.3.2.11 Precision

0

##### 1.12.3.2.12 Scale

0

#### 1.12.3.3.0 tenantId

##### 1.12.3.3.1 Name

tenantId

##### 1.12.3.3.2 Type

🔹 Guid

##### 1.12.3.3.3 Is Required

✅ Yes

##### 1.12.3.3.4 Is Primary Key

❌ No

##### 1.12.3.3.5 Is Unique

❌ No

##### 1.12.3.3.6 Index Type

Index

##### 1.12.3.3.7 Size

0

##### 1.12.3.3.8 Constraints

*No items available*

##### 1.12.3.3.9 Default Value



##### 1.12.3.3.10 Is Foreign Key

✅ Yes

##### 1.12.3.3.11 Precision

0

##### 1.12.3.3.12 Scale

0

#### 1.12.3.4.0 totalHoursWorked

##### 1.12.3.4.1 Name

totalHoursWorked

##### 1.12.3.4.2 Type

🔹 DECIMAL

##### 1.12.3.4.3 Is Required

❌ No

##### 1.12.3.4.4 Is Primary Key

❌ No

##### 1.12.3.4.5 Is Unique

❌ No

##### 1.12.3.4.6 Index Type

None

##### 1.12.3.4.7 Size

0

##### 1.12.3.4.8 Constraints

*No items available*

##### 1.12.3.4.9 Default Value

0.00

##### 1.12.3.4.10 Is Foreign Key

❌ No

##### 1.12.3.4.11 Precision

5

##### 1.12.3.4.12 Scale

2

#### 1.12.3.5.0 firstCheckIn

##### 1.12.3.5.1 Name

firstCheckIn

##### 1.12.3.5.2 Type

🔹 DateTime

##### 1.12.3.5.3 Is Required

❌ No

##### 1.12.3.5.4 Is Primary Key

❌ No

##### 1.12.3.5.5 Is Unique

❌ No

##### 1.12.3.5.6 Index Type

None

##### 1.12.3.5.7 Size

0

##### 1.12.3.5.8 Constraints

*No items available*

##### 1.12.3.5.9 Default Value



##### 1.12.3.5.10 Is Foreign Key

❌ No

##### 1.12.3.5.11 Precision

0

##### 1.12.3.5.12 Scale

0

#### 1.12.3.6.0 lastCheckOut

##### 1.12.3.6.1 Name

lastCheckOut

##### 1.12.3.6.2 Type

🔹 DateTime

##### 1.12.3.6.3 Is Required

❌ No

##### 1.12.3.6.4 Is Primary Key

❌ No

##### 1.12.3.6.5 Is Unique

❌ No

##### 1.12.3.6.6 Index Type

None

##### 1.12.3.6.7 Size

0

##### 1.12.3.6.8 Constraints

*No items available*

##### 1.12.3.6.9 Default Value



##### 1.12.3.6.10 Is Foreign Key

❌ No

##### 1.12.3.6.11 Precision

0

##### 1.12.3.6.12 Scale

0

#### 1.12.3.7.0 isLateArrival

##### 1.12.3.7.1 Name

isLateArrival

##### 1.12.3.7.2 Type

🔹 BOOLEAN

##### 1.12.3.7.3 Is Required

❌ No

##### 1.12.3.7.4 Is Primary Key

❌ No

##### 1.12.3.7.5 Is Unique

❌ No

##### 1.12.3.7.6 Index Type

None

##### 1.12.3.7.7 Size

0

##### 1.12.3.7.8 Constraints

*No items available*

##### 1.12.3.7.9 Default Value

false

##### 1.12.3.7.10 Is Foreign Key

❌ No

##### 1.12.3.7.11 Precision

0

##### 1.12.3.7.12 Scale

0

#### 1.12.3.8.0 isEarlyDeparture

##### 1.12.3.8.1 Name

isEarlyDeparture

##### 1.12.3.8.2 Type

🔹 BOOLEAN

##### 1.12.3.8.3 Is Required

❌ No

##### 1.12.3.8.4 Is Primary Key

❌ No

##### 1.12.3.8.5 Is Unique

❌ No

##### 1.12.3.8.6 Index Type

None

##### 1.12.3.8.7 Size

0

##### 1.12.3.8.8 Constraints

*No items available*

##### 1.12.3.8.9 Default Value

false

##### 1.12.3.8.10 Is Foreign Key

❌ No

##### 1.12.3.8.11 Precision

0

##### 1.12.3.8.12 Scale

0

#### 1.12.3.9.0 exceptionsCount

##### 1.12.3.9.1 Name

exceptionsCount

##### 1.12.3.9.2 Type

🔹 INT

##### 1.12.3.9.3 Is Required

❌ No

##### 1.12.3.9.4 Is Primary Key

❌ No

##### 1.12.3.9.5 Is Unique

❌ No

##### 1.12.3.9.6 Index Type

None

##### 1.12.3.9.7 Size

0

##### 1.12.3.9.8 Constraints

*No items available*

##### 1.12.3.9.9 Default Value

0

##### 1.12.3.9.10 Is Foreign Key

❌ No

##### 1.12.3.9.11 Precision

0

##### 1.12.3.9.12 Scale

0

#### 1.12.3.10.0 updatedAt

##### 1.12.3.10.1 Name

updatedAt

##### 1.12.3.10.2 Type

🔹 DateTime

##### 1.12.3.10.3 Is Required

✅ Yes

##### 1.12.3.10.4 Is Primary Key

❌ No

##### 1.12.3.10.5 Is Unique

❌ No

##### 1.12.3.10.6 Index Type

None

##### 1.12.3.10.7 Size

0

##### 1.12.3.10.8 Constraints

*No items available*

##### 1.12.3.10.9 Default Value

CURRENT_TIMESTAMP

##### 1.12.3.10.10 Is Foreign Key

❌ No

##### 1.12.3.10.11 Precision

0

##### 1.12.3.10.12 Scale

0

### 1.12.4.0.0 Primary Keys

- summaryDate
- userId

### 1.12.5.0.0 Unique Constraints

*No items available*

### 1.12.6.0.0 Indexes

- {'name': 'IX_DailySummary_Tenant_Date', 'columns': ['tenantId', 'summaryDate'], 'type': 'BTree'}

# 2.0.0.0.0 Relations

## 2.1.0.0.0 TenantOwnsUsers

### 2.1.1.0.0 Name

TenantOwnsUsers

### 2.1.2.0.0 Id

REL_TENANT_USER_001

### 2.1.3.0.0 Source Entity

Tenant

### 2.1.4.0.0 Target Entity

User

### 2.1.5.0.0 Type

🔹 OneToMany

### 2.1.6.0.0 Source Multiplicity

1

### 2.1.7.0.0 Target Multiplicity

0..*

### 2.1.8.0.0 Cascade Delete

✅ Yes

### 2.1.9.0.0 Is Identifying

❌ No

### 2.1.10.0.0 On Delete

Cascade

### 2.1.11.0.0 On Update

Cascade

### 2.1.12.0.0 Join Table

#### 2.1.12.1.0 Name

User

#### 2.1.12.2.0 Columns

- {'name': 'tenantId', 'type': 'Guid', 'references': 'Tenant.tenantId'}

## 2.2.0.0.0 TenantOwnsTeams

### 2.2.1.0.0 Name

TenantOwnsTeams

### 2.2.2.0.0 Id

REL_TENANT_TEAM_001

### 2.2.3.0.0 Source Entity

Tenant

### 2.2.4.0.0 Target Entity

Team

### 2.2.5.0.0 Type

🔹 OneToMany

### 2.2.6.0.0 Source Multiplicity

1

### 2.2.7.0.0 Target Multiplicity

0..*

### 2.2.8.0.0 Cascade Delete

✅ Yes

### 2.2.9.0.0 Is Identifying

❌ No

### 2.2.10.0.0 On Delete

Cascade

### 2.2.11.0.0 On Update

Cascade

### 2.2.12.0.0 Join Table

#### 2.2.12.1.0 Name

Team

#### 2.2.12.2.0 Columns

- {'name': 'tenantId', 'type': 'Guid', 'references': 'Tenant.tenantId'}

## 2.3.0.0.0 TenantOwnsAttendanceRecords

### 2.3.1.0.0 Name

TenantOwnsAttendanceRecords

### 2.3.2.0.0 Id

REL_TENANT_ATTENDANCERECORD_001

### 2.3.3.0.0 Source Entity

Tenant

### 2.3.4.0.0 Target Entity

AttendanceRecord

### 2.3.5.0.0 Type

🔹 OneToMany

### 2.3.6.0.0 Source Multiplicity

1

### 2.3.7.0.0 Target Multiplicity

0..*

### 2.3.8.0.0 Cascade Delete

✅ Yes

### 2.3.9.0.0 Is Identifying

❌ No

### 2.3.10.0.0 On Delete

Cascade

### 2.3.11.0.0 On Update

Cascade

### 2.3.12.0.0 Join Table

#### 2.3.12.1.0 Name

AttendanceRecord

#### 2.3.12.2.0 Columns

- {'name': 'tenantId', 'type': 'Guid', 'references': 'Tenant.tenantId'}

## 2.4.0.0.0 TenantOwnsEvents

### 2.4.1.0.0 Name

TenantOwnsEvents

### 2.4.2.0.0 Id

REL_TENANT_EVENT_001

### 2.4.3.0.0 Source Entity

Tenant

### 2.4.4.0.0 Target Entity

Event

### 2.4.5.0.0 Type

🔹 OneToMany

### 2.4.6.0.0 Source Multiplicity

1

### 2.4.7.0.0 Target Multiplicity

0..*

### 2.4.8.0.0 Cascade Delete

✅ Yes

### 2.4.9.0.0 Is Identifying

❌ No

### 2.4.10.0.0 On Delete

Cascade

### 2.4.11.0.0 On Update

Cascade

### 2.4.12.0.0 Join Table

#### 2.4.12.1.0 Name

Event

#### 2.4.12.2.0 Columns

- {'name': 'tenantId', 'type': 'Guid', 'references': 'Tenant.tenantId'}

## 2.5.0.0.0 TenantOwnsAuditLogs

### 2.5.1.0.0 Name

TenantOwnsAuditLogs

### 2.5.2.0.0 Id

REL_TENANT_AUDITLOG_001

### 2.5.3.0.0 Source Entity

Tenant

### 2.5.4.0.0 Target Entity

AuditLog

### 2.5.5.0.0 Type

🔹 OneToMany

### 2.5.6.0.0 Source Multiplicity

1

### 2.5.7.0.0 Target Multiplicity

0..*

### 2.5.8.0.0 Cascade Delete

✅ Yes

### 2.5.9.0.0 Is Identifying

❌ No

### 2.5.10.0.0 On Delete

Cascade

### 2.5.11.0.0 On Update

Cascade

### 2.5.12.0.0 Join Table

#### 2.5.12.1.0 Name

AuditLog

#### 2.5.12.2.0 Columns

- {'name': 'tenantId', 'type': 'Guid', 'references': 'Tenant.tenantId'}

## 2.6.0.0.0 SubscriptionPlanForTenants

### 2.6.1.0.0 Name

SubscriptionPlanForTenants

### 2.6.2.0.0 Id

REL_SUBSCRIPTIONPLAN_TENANT_001

### 2.6.3.0.0 Source Entity

SubscriptionPlan

### 2.6.4.0.0 Target Entity

Tenant

### 2.6.5.0.0 Type

🔹 OneToMany

### 2.6.6.0.0 Source Multiplicity

1

### 2.6.7.0.0 Target Multiplicity

0..*

### 2.6.8.0.0 Cascade Delete

❌ No

### 2.6.9.0.0 Is Identifying

❌ No

### 2.6.10.0.0 On Delete

Restrict

### 2.6.11.0.0 On Update

Cascade

### 2.6.12.0.0 Join Table

#### 2.6.12.1.0 Name

Tenant

#### 2.6.12.2.0 Columns

- {'name': 'subscriptionPlanId', 'type': 'Guid', 'references': 'SubscriptionPlan.subscriptionPlanId'}

## 2.7.0.0.0 TenantHasConfiguration

### 2.7.1.0.0 Name

TenantHasConfiguration

### 2.7.2.0.0 Id

REL_TENANT_TENANTCONFIGURATION_001

### 2.7.3.0.0 Source Entity

Tenant

### 2.7.4.0.0 Target Entity

TenantConfiguration

### 2.7.5.0.0 Type

🔹 OneToOne

### 2.7.6.0.0 Source Multiplicity

1

### 2.7.7.0.0 Target Multiplicity

1

### 2.7.8.0.0 Cascade Delete

✅ Yes

### 2.7.9.0.0 Is Identifying

✅ Yes

### 2.7.10.0.0 On Delete

Cascade

### 2.7.11.0.0 On Update

Cascade

### 2.7.12.0.0 Join Table

#### 2.7.12.1.0 Name

TenantConfiguration

#### 2.7.12.2.0 Columns

- {'name': 'tenantId', 'type': 'Guid', 'references': 'Tenant.tenantId'}

## 2.8.0.0.0 TenantHasGoogleSheetIntegration

### 2.8.1.0.0 Name

TenantHasGoogleSheetIntegration

### 2.8.2.0.0 Id

REL_TENANT_GOOGLESHEETINTEGRATION_001

### 2.8.3.0.0 Source Entity

Tenant

### 2.8.4.0.0 Target Entity

GoogleSheetIntegration

### 2.8.5.0.0 Type

🔹 OneToOne

### 2.8.6.0.0 Source Multiplicity

1

### 2.8.7.0.0 Target Multiplicity

0..1

### 2.8.8.0.0 Cascade Delete

✅ Yes

### 2.8.9.0.0 Is Identifying

❌ No

### 2.8.10.0.0 On Delete

Cascade

### 2.8.11.0.0 On Update

Cascade

### 2.8.12.0.0 Join Table

#### 2.8.12.1.0 Name

GoogleSheetIntegration

#### 2.8.12.2.0 Columns

- {'name': 'tenantId', 'type': 'Guid', 'references': 'Tenant.tenantId'}

## 2.9.0.0.0 UserHierarchy

### 2.9.1.0.0 Name

UserHierarchy

### 2.9.2.0.0 Id

REL_USER_USER_SUPERVISOR_001

### 2.9.3.0.0 Source Entity

User

### 2.9.4.0.0 Target Entity

User

### 2.9.5.0.0 Type

🔹 OneToMany

### 2.9.6.0.0 Source Multiplicity

0..1

### 2.9.7.0.0 Target Multiplicity

0..*

### 2.9.8.0.0 Cascade Delete

❌ No

### 2.9.9.0.0 Is Identifying

❌ No

### 2.9.10.0.0 On Delete

SetNull

### 2.9.11.0.0 On Update

Cascade

### 2.9.12.0.0 Join Table

#### 2.9.12.1.0 Name

User

#### 2.9.12.2.0 Columns

- {'name': 'supervisorId', 'type': 'Guid', 'references': 'User.userId'}

## 2.10.0.0.0 UserHasAttendanceRecords

### 2.10.1.0.0 Name

UserHasAttendanceRecords

### 2.10.2.0.0 Id

REL_USER_ATTENDANCERECORD_001

### 2.10.3.0.0 Source Entity

User

### 2.10.4.0.0 Target Entity

AttendanceRecord

### 2.10.5.0.0 Type

🔹 OneToMany

### 2.10.6.0.0 Source Multiplicity

1

### 2.10.7.0.0 Target Multiplicity

0..*

### 2.10.8.0.0 Cascade Delete

✅ Yes

### 2.10.9.0.0 Is Identifying

❌ No

### 2.10.10.0.0 On Delete

Cascade

### 2.10.11.0.0 On Update

Cascade

### 2.10.12.0.0 Join Table

#### 2.10.12.1.0 Name

AttendanceRecord

#### 2.10.12.2.0 Columns

- {'name': 'userId', 'type': 'Guid', 'references': 'User.userId'}

## 2.11.0.0.0 SupervisorReviewsAttendanceRecords

### 2.11.1.0.0 Name

SupervisorReviewsAttendanceRecords

### 2.11.2.0.0 Id

REL_USER_ATTENDANCERECORD_SUPERVISOR_001

### 2.11.3.0.0 Source Entity

User

### 2.11.4.0.0 Target Entity

AttendanceRecord

### 2.11.5.0.0 Type

🔹 OneToMany

### 2.11.6.0.0 Source Multiplicity

1

### 2.11.7.0.0 Target Multiplicity

0..*

### 2.11.8.0.0 Cascade Delete

❌ No

### 2.11.9.0.0 Is Identifying

❌ No

### 2.11.10.0.0 On Delete

SetNull

### 2.11.11.0.0 On Update

Cascade

### 2.11.12.0.0 Join Table

#### 2.11.12.1.0 Name

AttendanceRecord

#### 2.11.12.2.0 Columns

- {'name': 'supervisorId', 'type': 'Guid', 'references': 'User.userId'}

## 2.12.0.0.0 UserSupervisesTeams

### 2.12.1.0.0 Name

UserSupervisesTeams

### 2.12.2.0.0 Id

REL_USER_TEAM_SUPERVISOR_001

### 2.12.3.0.0 Source Entity

User

### 2.12.4.0.0 Target Entity

Team

### 2.12.5.0.0 Type

🔹 OneToMany

### 2.12.6.0.0 Source Multiplicity

1

### 2.12.7.0.0 Target Multiplicity

0..*

### 2.12.8.0.0 Cascade Delete

❌ No

### 2.12.9.0.0 Is Identifying

❌ No

### 2.12.10.0.0 On Delete

Restrict

### 2.12.11.0.0 On Update

Cascade

### 2.12.12.0.0 Join Table

#### 2.12.12.1.0 Name

Team

#### 2.12.12.2.0 Columns

- {'name': 'supervisorId', 'type': 'Guid', 'references': 'User.userId'}

## 2.13.0.0.0 UserTeamMembership

### 2.13.1.0.0 Name

UserTeamMembership

### 2.13.2.0.0 Id

REL_USER_TEAM_MEMBERSHIP_001

### 2.13.3.0.0 Source Entity

User

### 2.13.4.0.0 Target Entity

Team

### 2.13.5.0.0 Type

🔹 ManyToMany

### 2.13.6.0.0 Source Multiplicity

0..*

### 2.13.7.0.0 Target Multiplicity

0..*

### 2.13.8.0.0 Cascade Delete

✅ Yes

### 2.13.9.0.0 Is Identifying

❌ No

### 2.13.10.0.0 On Delete

Cascade

### 2.13.11.0.0 On Update

Cascade

### 2.13.12.0.0 Join Table

#### 2.13.12.1.0 Name

UserTeamMembership

#### 2.13.12.2.0 Columns

##### 2.13.12.2.1 userId

###### 2.13.12.2.1.1 Name

userId

###### 2.13.12.2.1.2 Type

🔹 Guid

###### 2.13.12.2.1.3 References

User.userId

##### 2.13.12.2.2.0 teamId

###### 2.13.12.2.2.1 Name

teamId

###### 2.13.12.2.2.2 Type

🔹 Guid

###### 2.13.12.2.2.3 References

Team.teamId

## 2.14.0.0.0.0 UserCreatesEvents

### 2.14.1.0.0.0 Name

UserCreatesEvents

### 2.14.2.0.0.0 Id

REL_USER_EVENT_CREATOR_001

### 2.14.3.0.0.0 Source Entity

User

### 2.14.4.0.0.0 Target Entity

Event

### 2.14.5.0.0.0 Type

🔹 OneToMany

### 2.14.6.0.0.0 Source Multiplicity

1

### 2.14.7.0.0.0 Target Multiplicity

0..*

### 2.14.8.0.0.0 Cascade Delete

❌ No

### 2.14.9.0.0.0 Is Identifying

❌ No

### 2.14.10.0.0.0 On Delete

SetNull

### 2.14.11.0.0.0 On Update

Cascade

### 2.14.12.0.0.0 Join Table

#### 2.14.12.1.0.0 Name

Event

#### 2.14.12.2.0.0 Columns

- {'name': 'createdByUserId', 'type': 'Guid', 'references': 'User.userId'}

## 2.15.0.0.0.0 UserPerformsAuditActions

### 2.15.1.0.0.0 Name

UserPerformsAuditActions

### 2.15.2.0.0.0 Id

REL_USER_AUDITLOG_ACTOR_001

### 2.15.3.0.0.0 Source Entity

User

### 2.15.4.0.0.0 Target Entity

AuditLog

### 2.15.5.0.0.0 Type

🔹 OneToMany

### 2.15.6.0.0.0 Source Multiplicity

1

### 2.15.7.0.0.0 Target Multiplicity

0..*

### 2.15.8.0.0.0 Cascade Delete

❌ No

### 2.15.9.0.0.0 Is Identifying

❌ No

### 2.15.10.0.0.0 On Delete

Restrict

### 2.15.11.0.0.0 On Update

NoAction

### 2.15.12.0.0.0 Join Table

#### 2.15.12.1.0.0 Name

AuditLog

#### 2.15.12.2.0.0 Columns

- {'name': 'actingUserId', 'type': 'Guid', 'references': 'User.userId'}

## 2.16.0.0.0.0 EventLinkedToAttendanceRecords

### 2.16.1.0.0.0 Name

EventLinkedToAttendanceRecords

### 2.16.2.0.0.0 Id

REL_EVENT_ATTENDANCERECORD_001

### 2.16.3.0.0.0 Source Entity

Event

### 2.16.4.0.0.0 Target Entity

AttendanceRecord

### 2.16.5.0.0.0 Type

🔹 OneToMany

### 2.16.6.0.0.0 Source Multiplicity

1

### 2.16.7.0.0.0 Target Multiplicity

0..*

### 2.16.8.0.0.0 Cascade Delete

❌ No

### 2.16.9.0.0.0 Is Identifying

❌ No

### 2.16.10.0.0.0 On Delete

SetNull

### 2.16.11.0.0.0 On Update

Cascade

### 2.16.12.0.0.0 Join Table

#### 2.16.12.1.0.0 Name

AttendanceRecord

#### 2.16.12.2.0.0 Columns

- {'name': 'eventId', 'type': 'Guid', 'references': 'Event.eventId'}

## 2.17.0.0.0.0 EventUserAssignment

### 2.17.1.0.0.0 Name

EventUserAssignment

### 2.17.2.0.0.0 Id

REL_EVENT_USER_ASSIGNMENT_001

### 2.17.3.0.0.0 Source Entity

Event

### 2.17.4.0.0.0 Target Entity

User

### 2.17.5.0.0.0 Type

🔹 ManyToMany

### 2.17.6.0.0.0 Source Multiplicity

0..*

### 2.17.7.0.0.0 Target Multiplicity

0..*

### 2.17.8.0.0.0 Cascade Delete

✅ Yes

### 2.17.9.0.0.0 Is Identifying

❌ No

### 2.17.10.0.0.0 On Delete

Cascade

### 2.17.11.0.0.0 On Update

Cascade

### 2.17.12.0.0.0 Join Table

#### 2.17.12.1.0.0 Name

EventAssignment

#### 2.17.12.2.0.0 Columns

##### 2.17.12.2.1.0 eventId

###### 2.17.12.2.1.1 Name

eventId

###### 2.17.12.2.1.2 Type

🔹 Guid

###### 2.17.12.2.1.3 References

Event.eventId

##### 2.17.12.2.2.0 assigneeId

###### 2.17.12.2.2.1 Name

assigneeId

###### 2.17.12.2.2.2 Type

🔹 Guid

###### 2.17.12.2.2.3 References

User.userId

## 2.18.0.0.0.0 EventTeamAssignment

### 2.18.1.0.0.0 Name

EventTeamAssignment

### 2.18.2.0.0.0 Id

REL_EVENT_TEAM_ASSIGNMENT_001

### 2.18.3.0.0.0 Source Entity

Event

### 2.18.4.0.0.0 Target Entity

Team

### 2.18.5.0.0.0 Type

🔹 ManyToMany

### 2.18.6.0.0.0 Source Multiplicity

0..*

### 2.18.7.0.0.0 Target Multiplicity

0..*

### 2.18.8.0.0.0 Cascade Delete

✅ Yes

### 2.18.9.0.0.0 Is Identifying

❌ No

### 2.18.10.0.0.0 On Delete

Cascade

### 2.18.11.0.0.0 On Update

Cascade

### 2.18.12.0.0.0 Join Table

#### 2.18.12.1.0.0 Name

EventAssignment

#### 2.18.12.2.0.0 Columns

##### 2.18.12.2.1.0 eventId

###### 2.18.12.2.1.1 Name

eventId

###### 2.18.12.2.1.2 Type

🔹 Guid

###### 2.18.12.2.1.3 References

Event.eventId

##### 2.18.12.2.2.0 assigneeId

###### 2.18.12.2.2.1 Name

assigneeId

###### 2.18.12.2.2.2 Type

🔹 Guid

###### 2.18.12.2.2.3 References

Team.teamId

## 2.19.0.0.0.0 TenantOwnsDailySummaries

### 2.19.1.0.0.0 Name

TenantOwnsDailySummaries

### 2.19.2.0.0.0 Id

REL_TENANT_DAILYSUMMARY_001

### 2.19.3.0.0.0 Source Entity

Tenant

### 2.19.4.0.0.0 Target Entity

DailyUserSummary

### 2.19.5.0.0.0 Type

🔹 OneToMany

### 2.19.6.0.0.0 Source Multiplicity

1

### 2.19.7.0.0.0 Target Multiplicity

0..*

### 2.19.8.0.0.0 Cascade Delete

✅ Yes

### 2.19.9.0.0.0 Is Identifying

❌ No

### 2.19.10.0.0.0 On Delete

Cascade

### 2.19.11.0.0.0 On Update

Cascade

### 2.19.12.0.0.0 Join Table

#### 2.19.12.1.0.0 Name

DailyUserSummary

#### 2.19.12.2.0.0 Columns

- {'name': 'tenantId', 'type': 'Guid', 'references': 'Tenant.tenantId'}

## 2.20.0.0.0.0 UserHasDailySummaries

### 2.20.1.0.0.0 Name

UserHasDailySummaries

### 2.20.2.0.0.0 Id

REL_USER_DAILYSUMMARY_001

### 2.20.3.0.0.0 Source Entity

User

### 2.20.4.0.0.0 Target Entity

DailyUserSummary

### 2.20.5.0.0.0 Type

🔹 OneToMany

### 2.20.6.0.0.0 Source Multiplicity

1

### 2.20.7.0.0.0 Target Multiplicity

0..*

### 2.20.8.0.0.0 Cascade Delete

✅ Yes

### 2.20.9.0.0.0 Is Identifying

❌ No

### 2.20.10.0.0.0 On Delete

Cascade

### 2.20.11.0.0.0 On Update

Cascade

### 2.20.12.0.0.0 Join Table

#### 2.20.12.1.0.0 Name

DailyUserSummary

#### 2.20.12.2.0.0 Columns

- {'name': 'userId', 'type': 'Guid', 'references': 'User.userId'}

