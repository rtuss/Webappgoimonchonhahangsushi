// backend/scripts/setup.js
import { spawn } from 'child_process';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

console.log('🚀 Starting database setup...\n');

// Run seedAdmin.js
const runSeedAdmin = () => {
  return new Promise((resolve, reject) => {
    const seedAdmin = spawn('node', [path.join(__dirname, 'seedAdmin.js')], {
      cwd: path.dirname(__dirname),
      stdio: 'inherit',
    });

    seedAdmin.on('close', (code) => {
      if (code !== 0) reject(new Error('seedAdmin failed'));
      else resolve();
    });
  });
};

// Run seedStaff.js
const runSeedStaff = () => {
  return new Promise((resolve, reject) => {
    const seedStaff = spawn('node', [path.join(__dirname, 'seedStaff.js')], {
      cwd: path.dirname(__dirname),
      stdio: 'inherit',
    });

    seedStaff.on('close', (code) => {
      if (code !== 0) reject(new Error('seedStaff failed'));
      else resolve();
    });
  });
};

async function setup() {
  try {
    console.log('📝 Creating admin user...\n');
    await runSeedAdmin();

    console.log('\n📝 Creating staff users...\n');
    await runSeedStaff();

    console.log('✅ Setup completed successfully!\n');
    process.exit(0);
  } catch (error) {
    console.error('❌ Setup failed:', error);
    process.exit(1);
  }
}

setup();
