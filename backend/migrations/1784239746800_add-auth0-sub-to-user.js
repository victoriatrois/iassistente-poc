import { MigrationBuilder } from "node-pg-migrate";

export const up = (pgm) => {
  pgm.sql(`ALTER TABLE "user" ADD COLUMN IF NOT EXISTS auth0_sub TEXT;`);
  pgm.sql(`
    CREATE UNIQUE INDEX IF NOT EXISTS idx_user_auth0_sub
    ON "user"(auth0_sub)
    WHERE auth0_sub IS NOT NULL;
  `);
};

export const down = false;
