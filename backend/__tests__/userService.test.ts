import { afterAll, describe, expect, it } from "vitest";
import { query } from "../lib/db";
import {
  createUserFromAuth0,
  getOrCreateUserFromAuth0Claims,
  getUserByAuth0Sub,
  getUserById,
} from "../lib/userService";

const createdSubs: string[] = [];

afterAll(async () => {
  if (createdSubs.length > 0) {
    await query('DELETE FROM "user" WHERE auth0_sub = ANY($1)', [createdSubs]);
  }
});

describe("userService", () => {
  it("creates and fetches user by auth0_sub and id", async () => {
    const sub = "auth0|test-" + Date.now();
    createdSubs.push(sub);

    const created = await createUserFromAuth0({
      sub,
      name: "Victoria's Test",
    });

    const bySub = await getUserByAuth0Sub(sub);
    const byId = await getUserById(created.id);

    expect(bySub?.id).toBe(created.id);
    expect(byId?.id).toBe(created.id);
  });

  it("returns existing user on second getOrCreate", async () => {
    const sub = "auth0|existing-" + Date.now();
    createdSubs.push(sub);

    const first = await getOrCreateUserFromAuth0Claims({
    sub,
    name: "First Name",
    });

    const second = await getOrCreateUserFromAuth0Claims({
    sub,
    name: "Second Name",
    });

    expect(second.id).toBe(first.id);
  });

  it("throws when sub is missing", async () => {
    await expect(
      getOrCreateUserFromAuth0Claims({
      sub: "",
      name: "No Sub",
      }),
    ).rejects.toThrow("Auth0 sub is required");
  });
});
