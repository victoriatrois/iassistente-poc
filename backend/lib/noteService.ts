import { query } from "./db";

export type NoteRecord = {
  id: string;
  user_id: string;
  content: string;
  created_at: string;
  updated_at: string;
};

type NoteCountRow = {
  count: string;
};

export async function getNotesByUserId(
  userId: string,
  limit: number,
  offset: number,
): Promise<NoteRecord[]> {
  const result = await query<NoteRecord>(
    `SELECT
       id, user_id, content, created_at, updated_at
     FROM
       note
     WHERE
       user_id = $1
     ORDER BY
       created_at DESC, id DESC
     LIMIT $2
     OFFSET $3`,
    [userId, limit, offset],
  );

  return result.rows;
}

export async function getNotesCountByUserId(userId: string): Promise<number> {
  const result = await query<NoteCountRow>(
    `SELECT COUNT(*) AS
       count
     FROM
       note
     WHERE
       user_id = $1`,
    [userId],
  );

  return Number.parseInt(result.rows[0]?.count ?? "0", 10);
}
