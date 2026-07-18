import { query } from "./db";

export type UserRecord = {
  id: string;
  name: string;
  auth0_sub: string | null;
  created_at: string;
};

type Auth0Input = {
  sub: string;
  name?: string | null;
  username?: string | null;
  email?: string | null;
};

function pickDisplayName(input: Auth0Input): string {
  const preferred = input.name ?? input.username ?? input.email ?? "User";

  return preferred.trim() || "User";
}

export async function getUserById(id: string): Promise<UserRecord | null> {
  const result = await query<UserRecord>(
    'SELECT id, name, auth0_sub, created_at FROM "user" WHERE id = $1 LIMIT 1',
    [id],
  );

  return result.rows[0] ?? null;
}

export async function getUserByAuth0Sub(sub: string): Promise<UserRecord | null> {
  const result = await query<UserRecord>(
    'SELECT id, name, auth0_sub, created_at FROM "user" WHERE auth0_sub = $1 LIMIT 1',
    [sub],
  );

  return result.rows[0] ?? null;
}

export async function createUserFromAuth0(input: Auth0Input): Promise<UserRecord> {
  if (!input.sub?.trim()) {
    throw new Error("Auth0 subject is required");
  }

  const inserted = await query<UserRecord>(
    'INSERT INTO "user" (name, auth0_sub) VALUES ($1, $2) RETURNING id, name, auth0_sub, created_at',
    [pickDisplayName(input), input.sub],
  );

  return inserted.rows[0];
}

export async function getOrCreateUserFromAuth0Claims(
  input: Auth0Input,
): Promise<UserRecord> {
  if (!input.sub?.trim()) {
    throw new Error("Auth0 sub is required");
  }

  const existing = await getUserByAuth0Sub(input.sub);
  if (existing) {
    return existing;
  }

  try {
    return await createUserFromAuth0(input);
  } catch (error: unknown) {
    const pgError = error as { code?: string };
    if (pgError.code === "23505") {
      const user = await getUserByAuth0Sub(input.sub);
      if (user) {
        return user;
      }
    }

    throw error;
  }
}
