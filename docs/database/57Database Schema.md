# 1 Title

Alternative Design - Key-Value Cache for Configuration

# 2 Name

app_config_cache_kv

# 3 Db Type

- keyvalue
- inmemory

# 4 Db Technology

Redis / Google Cloud Memorystore

# 5 Entities

- {'name': 'TenantConfigurationCache', 'description': 'Stores serialized tenant configuration objects for fast retrieval.', 'attributes': [{'name': 'key', 'type': 'String', 'isRequired': True, 'isPrimaryKey': True, 'size': 0, 'isUnique': True, 'constraints': ["Format: 'config:tenant:{tenantId}'"], 'precision': 0, 'scale': 0, 'isForeignKey': False}, {'name': 'value', 'type': 'String', 'isRequired': True, 'isPrimaryKey': False, 'size': 0, 'isUnique': False, 'constraints': ['JSON string of the TenantConfiguration object'], 'precision': 0, 'scale': 0, 'isForeignKey': False}], 'primaryKeys': ['key'], 'uniqueConstraints': [], 'indexes': []}

