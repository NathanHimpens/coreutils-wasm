// Test for @nathanhimpens/coreutils-wasm
const path = require('path');
const fs = require('fs');

console.log('Testing @nathanhimpens/coreutils-wasm\n');

// Test 1: WASM file exists
const wasmPath = path.join(__dirname, '..', 'wasm', 'coreutils.wasm');
console.log('Test 1: WASM file exists');
if (fs.existsSync(wasmPath)) {
  const stats = fs.statSync(wasmPath);
  console.log(`  ✓ WASM file found (${(stats.size / 1024 / 1024).toFixed(2)} MB)\n`);
} else {
  console.log('  ✗ WASM file not found!\n');
  process.exit(1);
}

// Test 2: WASM magic number
console.log('Test 2: WASM magic number');
const buffer = Buffer.alloc(4);
const fd = fs.openSync(wasmPath, 'r');
fs.readSync(fd, buffer, 0, 4, 0);
fs.closeSync(fd);

if (buffer[0] === 0x00 && buffer[1] === 0x61 && buffer[2] === 0x73 && buffer[3] === 0x6d) {
  console.log('  ✓ Valid WASM magic number (\\0asm)\n');
} else {
  console.log('  ✗ Invalid WASM magic number!\n');
  process.exit(1);
}

// Test 3: Module exports (simulated since we can't import ESM in CommonJS test)
console.log('Test 3: Expected exports check');
const srcPath = path.join(__dirname, '..', 'src', 'index.ts');
const srcContent = fs.readFileSync(srcPath, 'utf8');

const expectedExports = ['getWasmPath', 'getWasmBytes', 'getWasmUint8Array', 'commands'];
const missingExports = expectedExports.filter(exp => !srcContent.includes(`export function ${exp}`) && !srcContent.includes(`export const ${exp}`));

if (missingExports.length === 0) {
  console.log(`  ✓ All expected exports found: ${expectedExports.join(', ')}\n`);
} else {
  console.log(`  ✗ Missing exports: ${missingExports.join(', ')}\n`);
  process.exit(1);
}

// Test 4: Commands list
console.log('Test 4: Commands list');
const commandsMatch = srcContent.match(/export const commands = \[([\s\S]*?)\] as const/);
if (commandsMatch) {
  const commandsStr = commandsMatch[1];
  const hasLs = commandsStr.includes('"ls"');
  const hasCat = commandsStr.includes('"cat"');
  const hasHead = commandsStr.includes('"head"');
  const hasTail = commandsStr.includes('"tail"');
  const hasWc = commandsStr.includes('"wc"');
  
  if (hasLs && hasCat && hasHead && hasTail && hasWc) {
    console.log('  ✓ Required commands found: ls, cat, head, tail, wc\n');
  } else {
    console.log('  ✗ Some required commands missing!\n');
    process.exit(1);
  }
} else {
  console.log('  ✗ Commands list not found!\n');
  process.exit(1);
}

console.log('✓ All tests passed!');
