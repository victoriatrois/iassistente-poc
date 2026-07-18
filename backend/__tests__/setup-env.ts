import fs from "node:fs";
import path from "node:path";
import dotenv from "dotenv";

function loadEnvFile(filePath: string) {
  if (fs.existsSync(filePath)) {
    dotenv.config({ path: filePath });
  }
}

loadEnvFile(path.resolve(__dirname, "../.env.local"));
loadEnvFile(path.resolve(__dirname, "../../.env.local"));
