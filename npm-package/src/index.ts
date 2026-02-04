import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

// For CommonJS compatibility
let __dirnameComputed: string;
try {
  const url = import.meta.url;
  __dirnameComputed = dirname(fileURLToPath(url));
} catch {
  __dirnameComputed = __dirname;
}

// Path to the WASM binary
const WASM_PATH = join(__dirnameComputed, "..", "wasm", "coreutils.wasm");

/**
 * Get the absolute path to the coreutils WASM binary
 * @returns Absolute path to coreutils.wasm
 */
export function getWasmPath(): string {
  return WASM_PATH;
}

/**
 * Get the raw WASM binary as a Buffer
 * @returns Buffer containing the WASM binary
 */
export function getWasmBytes(): Buffer {
  return readFileSync(WASM_PATH);
}

/**
 * Get the WASM binary as a Uint8Array (for WebAssembly.compile)
 * @returns Uint8Array containing the WASM binary
 */
export function getWasmUint8Array(): Uint8Array {
  return new Uint8Array(readFileSync(WASM_PATH));
}

// All available coreutils commands in this binary
export const commands = [
  "arch", "base32", "base64", "baseenc", "basename", "cat", "chcon", "chgrp",
  "chmod", "chown", "chroot", "cksum", "comm", "cp", "csplit", "cut", "date",
  "dd", "df", "dircolors", "dirname", "du", "echo", "env", "expand", "expr",
  "factor", "false", "fmt", "fold", "groups", "hashsum", "head", "hostid",
  "hostname", "id", "install", "join", "kill", "link", "ln", "logname", "ls",
  "mkdir", "mkfifo", "mknod", "mktemp", "more", "mv", "nice", "nl", "nohup",
  "nproc", "numfmt", "od", "paste", "pathchk", "pinky", "pr", "printenv",
  "printf", "ptx", "pwd", "readlink", "realpath", "relpath", "rm", "rmdir",
  "runcon", "seq", "shred", "shuf", "sleep", "sort", "split", "stat", "stdbuf",
  "sum", "sync", "tac", "tail", "tee", "test", "timeout", "touch", "tr", "true",
  "truncate", "tsort", "tty", "uname", "unexpand", "uniq", "unlink", "uptime",
  "users", "wc", "who", "whoami", "yes"
] as const;

export type Command = (typeof commands)[number];

export default {
  getWasmPath,
  getWasmBytes,
  getWasmUint8Array,
  commands,
};
