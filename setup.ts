import * as Bun from "bun";
import * as NodeOS from "node:os";
import * as NodePath from "node:path";
import * as NodeFS from "node:fs/promises";

const chatId = Bun.env.TELEGRAM_CHAT_ID;
const botToken = Bun.env.TELEGRAM_BOT_TOKEN;

if (!chatId) throw new Error("TELEGRAM_CHAT_ID is not set");
if (!botToken) throw new Error("TELEGRAM_BOT_TOKEN is not set");

const takopiPath = NodePath.join(NodeOS.homedir(), ".takopi", "takopi.toml");
let takopiToml = await NodeFS.readFile(takopiPath, "utf8");

takopiToml = takopiToml
  .replace("chat_id = 0", `chat_id = ${chatId}`)
  .replace('bot_token = ""', `bot_token = "${botToken}"`);

const success = await Bun.write(takopiPath, takopiToml);

if (!success) throw new Error("Failed to update takopi.toml");
console.info("Successfully updated takopi.toml");
