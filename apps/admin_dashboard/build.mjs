import { cpSync, existsSync, mkdirSync, rmSync } from 'node:fs';
import { resolve } from 'node:path';

const root = process.cwd();
const output = resolve(root, 'dist');
const files = ['index.html', 'styles.css', 'app.js'];

rmSync(output, { recursive: true, force: true });
mkdirSync(output, { recursive: true });

for (const file of files) {
  const source = resolve(root, file);
  if (!existsSync(source)) {
    throw new Error(`Missing required dashboard file: ${file}`);
  }
  cpSync(source, resolve(output, file));
}

console.log(`Biloo Delivery admin dashboard built to ${output}`);
