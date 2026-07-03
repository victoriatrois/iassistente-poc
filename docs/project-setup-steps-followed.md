# Initial setup

## Frontend setup

1. cd ..
2. mkdir frontend
3. npx react-native init frontend --template react-native-template-typescript
4. npx @react-native-community/cli init frontend
5. cd frontend
6. npm install react-native-voice axios

## Backend setup

1. mkdir backend && cd backend
2. npx create-next-app@latest . --typescript --eslint
3. npm install pg dotenv
4. npm install --save-dev @types/node
5. cp .env.local .env.local 2>/dev/null || echo "NEXT_PUBLIC_API_URL=http://localhost:3000
   DATABASE_URL=postgresql://user:password@localhost:5432/notes_db" > .env.local

## Database setup

1. run the backend locally: `npm run build`
2. install `brew install postgresql@15`
3. start the service: `brew services start postgresql@15`
4. Create the database: `createdb notes_db`
5. Create a user`createuser -P notes_user`
6. Connect to the database as system user: `psql -d notes_db`
7. `GRANT ALL PRIVILEGES ON SCHEMA public TO notes_user;`
8. `GRANT ALL PRIVILEGES ON DATABASE notes_db TO notes_user;`
9. `ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO notes_user;`
10. Quit `\q`
11. log in as notes_user again: `psql -U notes_user -d notes_db`
12. Create the tables:

```sql
CREATE TABLE "user" (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE note (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_note_user_id ON note(user_id);
```
