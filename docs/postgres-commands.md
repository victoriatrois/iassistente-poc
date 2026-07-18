# Useful commands (used )

## DDL (Data Definition Language)

### Create User Table

```sql
CREATE TABLE "user" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR NOT NULL,
  auth0_sub TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX idx_user_auth0_sub
ON "user"(auth0_sub)
WHERE auth0_sub IS NOT NULL;
```

### Create Note Table

```sql
CREATE TABLE note (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Create Index on Notes

```sql
CREATE INDEX idx_note_user_id ON note(user_id);
```

## DQL (Data Query Language)

- List all databases: `psql -l`
- List the database tables: `\dt`

## DML (Data Manipulation Language)

## DCL (Data Control Language)

### Grant Permissions to User

```sql
GRANT ALL PRIVILEGES ON SCHEMA public TO notes_user;
GRANT ALL PRIVILEGES ON DATABASE notes_db TO notes_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO notes_user;
```

### Fix Table Ownership (when migrations fail with `must be owner`)

```sql
ALTER TABLE "user" OWNER TO notes_user;
ALTER TABLE note OWNER TO notes_user;
```

## TCL (Transaction Control Language)

## Connection Commands

- Connect as current system user: `psql -d notes_db`
- Connect as specific user: `psql -U notes_user -d notes_db`
- Connect using environment variable: `psql "$DATABASE_URL"`
- Exit psql: `\q`
