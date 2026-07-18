import { afterAll, describe, expect, it } from "vitest";
import { query } from "../lib/db";
import { createUserFromAuth0 } from "../lib/userService";
import { getNotesByUserId, getNotesCountByUserId } from "../lib/noteService";

const createdSubs: string[] = [];

async function insertNote(
  userId: string,
  content: string,
  createdAt: string,
): Promise<void> {
  await query(
    `INSERT INTO note (user_id, content, created_at, updated_at)
     VALUES ($1, $2, $3, $3)`,
    [userId, content, createdAt],
  );
}

afterAll(async () => {
  if (createdSubs.length > 0) {
    await query('DELETE FROM "user" WHERE auth0_sub = ANY($1)', [createdSubs]);
  }
});

describe("noteService", () => {
  it("returns paginated notes in descending creation order", async () => {
    const sub = `auth0|notes-${Date.now()}`;
    createdSubs.push(sub);

    const user = await createUserFromAuth0({
      sub,
      name: "Notes Test",
    });

    await insertNote(user.id, "first", "2026-07-17T10:00:00.000Z");
    await insertNote(user.id, "second", "2026-07-17T11:00:00.000Z");
    await insertNote(user.id, "third", "2026-07-17T12:00:00.000Z");

    const notes = await getNotesByUserId(user.id, 2, 1);

    expect(notes).toHaveLength(2);
    expect(notes.map((note) => note.content)).toEqual(["second", "first"]);
  });

  it("counts only the current user's notes", async () => {
    const firstSub = `auth0|count-a-${Date.now()}`;
    const secondSub = `auth0|count-b-${Date.now()}`;
    createdSubs.push(firstSub, secondSub);

    const firstUser = await createUserFromAuth0({
      sub: firstSub,
      name: "Count A",
    });
    const secondUser = await createUserFromAuth0({
      sub: secondSub,
      name: "Count B",
    });

    await insertNote(firstUser.id, "a1", "2026-07-18T10:00:00.000Z");
    await insertNote(firstUser.id, "a2", "2026-07-18T11:00:00.000Z");
    await insertNote(secondUser.id, "b1", "2026-07-18T12:00:00.000Z");

    await expect(getNotesCountByUserId(firstUser.id)).resolves.toBe(2);
    await expect(getNotesCountByUserId(secondUser.id)).resolves.toBe(1);
  });
});
