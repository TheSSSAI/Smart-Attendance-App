# 1 Title

Alternative Design - Graph Database for Hierarchies

# 2 Name

app_hierarchy_graph_db

# 3 Db Type

- graph

# 4 Db Technology

Neo4j / JanusGraph

# 5 Entities

## 5.1 Node: User

### 5.1.1 Name

Node: User

### 5.1.2 Description

Represents a user as a node in the graph.

### 5.1.3 Attributes

#### 5.1.3.1 userId

##### 5.1.3.1.1 Name

userId

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

*No items available*

##### 5.1.3.1.8 Precision

0

##### 5.1.3.1.9 Scale

0

##### 5.1.3.1.10 Is Foreign Key

❌ No

#### 5.1.3.2.0 email

##### 5.1.3.2.1 Name

email

##### 5.1.3.2.2 Type

🔹 String

##### 5.1.3.2.3 Is Required

✅ Yes

##### 5.1.3.2.4 Is Primary Key

❌ No

##### 5.1.3.2.5 Size

0

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

#### 5.1.3.3.0 fullName

##### 5.1.3.3.1 Name

fullName

##### 5.1.3.3.2 Type

🔹 String

##### 5.1.3.3.3 Is Required

✅ Yes

##### 5.1.3.3.4 Is Primary Key

❌ No

##### 5.1.3.3.5 Size

0

##### 5.1.3.3.6 Is Unique

❌ No

##### 5.1.3.3.7 Constraints

*No items available*

##### 5.1.3.3.8 Precision

0

##### 5.1.3.3.9 Scale

0

##### 5.1.3.3.10 Is Foreign Key

❌ No

### 5.1.4.0.0 Primary Keys

- userId

### 5.1.5.0.0 Unique Constraints

*No items available*

### 5.1.6.0.0 Indexes

*No items available*

## 5.2.0.0.0 Node: Team

### 5.2.1.0.0 Name

Node: Team

### 5.2.2.0.0 Description

Represents a team as a node in the graph.

### 5.2.3.0.0 Attributes

#### 5.2.3.1.0 teamId

##### 5.2.3.1.1 Name

teamId

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

*No items available*

##### 5.2.3.1.8 Precision

0

##### 5.2.3.1.9 Scale

0

##### 5.2.3.1.10 Is Foreign Key

❌ No

#### 5.2.3.2.0 name

##### 5.2.3.2.1 Name

name

##### 5.2.3.2.2 Type

🔹 String

##### 5.2.3.2.3 Is Required

✅ Yes

##### 5.2.3.2.4 Is Primary Key

❌ No

##### 5.2.3.2.5 Size

0

##### 5.2.3.2.6 Is Unique

❌ No

##### 5.2.3.2.7 Constraints

*No items available*

##### 5.2.3.2.8 Precision

0

##### 5.2.3.2.9 Scale

0

##### 5.2.3.2.10 Is Foreign Key

❌ No

### 5.2.4.0.0 Primary Keys

- teamId

### 5.2.5.0.0 Unique Constraints

*No items available*

### 5.2.6.0.0 Indexes

*No items available*

## 5.3.0.0.0 Edge: REPORTS_TO

### 5.3.1.0.0 Name

Edge: REPORTS_TO

### 5.3.2.0.0 Description

A directed edge from a subordinate User to a supervisor User.

### 5.3.3.0.0 Attributes

- {'name': 'startDate', 'type': 'Date', 'isRequired': False, 'isPrimaryKey': False, 'size': 0, 'isUnique': False, 'constraints': ['Property on the edge'], 'precision': 0, 'scale': 0, 'isForeignKey': False}

### 5.3.4.0.0 Primary Keys

*No items available*

### 5.3.5.0.0 Unique Constraints

*No items available*

### 5.3.6.0.0 Indexes

*No items available*

## 5.4.0.0.0 Edge: MEMBER_OF

### 5.4.1.0.0 Name

Edge: MEMBER_OF

### 5.4.2.0.0 Description

A directed edge from a User to a Team.

### 5.4.3.0.0 Attributes

*No items available*

### 5.4.4.0.0 Primary Keys

*No items available*

### 5.4.5.0.0 Unique Constraints

*No items available*

### 5.4.6.0.0 Indexes

*No items available*

## 5.5.0.0.0 Edge: SUPERVISES

### 5.5.1.0.0 Name

Edge: SUPERVISES

### 5.5.2.0.0 Description

A directed edge from a User to a Team they supervise.

### 5.5.3.0.0 Attributes

*No items available*

### 5.5.4.0.0 Primary Keys

*No items available*

### 5.5.5.0.0 Unique Constraints

*No items available*

### 5.5.6.0.0 Indexes

*No items available*

