#!/usr/bin/env node

/**
 * Setup automático de Whitelabel multi-plataforma
 * Adiciona entradas ao arquivo hosts automaticamente
 * Funciona em Windows, Linux e macOS
 */

const { exec } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const readline = require('readline');

// Detectar sistema operacional
const platform = os.platform();
const isWindows = platform === 'win32';
const isLinux = platform === 'linux';
const isMac = platform === 'darwin';

// Caminho do arquivo hosts por SO
const hostsPath = isWindows
  ? 'C:\\Windows\\System32\\drivers\\etc\\hosts'
  : '/etc/hosts';

console.log('\n🚀 Setup Whitelabel - Configuração Automática\n');
console.log(`Sistema Operacional: ${platform}`);
console.log(`Arquivo hosts: ${hostsPath}\n`);

// Lojas padrão para configurar
const stores = [
  { name: 'devnology', description: 'Loja Devnology (Verde)' },
  { name: 'in8', description: 'Loja IN8 (Roxo)' }
];

/**
 * Verifica se uma entrada já existe no hosts
 */
function checkEntry(storeName) {
  try {
    const hostsContent = fs.readFileSync(hostsPath, 'utf8');
    const entry = `127.0.0.1 ${storeName}.localhost`;
    return hostsContent.includes(entry);
  } catch (error) {
    console.error('❌ Erro ao ler arquivo hosts:', error.message);
    return false;
  }
}

/**
 * Adiciona entrada ao hosts (requer permissões de admin)
 */
function addToHosts(storeName, callback) {
  const entry = `127.0.0.1 ${storeName}.localhost`;

  // Verificar se já existe
  if (checkEntry(storeName)) {
    console.log(`✅ ${storeName}.localhost já configurado!`);
    callback(true);
    return;
  }

  console.log(`📝 Adicionando: ${entry}`);

  let cmd;
  if (isWindows) {
    // Windows: precisa executar como Administrador
    cmd = `echo. >> "${hostsPath}" && echo ${entry} >> "${hostsPath}"`;
  } else {
    // Linux/macOS: usa sudo
    cmd = `echo "${entry}" | sudo tee -a ${hostsPath}`;
  }

  exec(cmd, (error, stdout, stderr) => {
    if (error) {
      console.error(`❌ Erro ao adicionar ${storeName}:`, error.message);
      if (isWindows) {
        console.log('\n⚠️  Execute este script como Administrador (clique direito → Executar como administrador)');
      } else {
        console.log('\n⚠️  Você precisa ter permissões sudo');
      }
      callback(false);
    } else {
      console.log(`✅ ${storeName}.localhost configurado com sucesso!`);
      callback(true);
    }
  });
}

/**
 * Configura todas as lojas
 */
async function setupStores() {
  console.log('🔧 Configurando lojas padrão...\n');

  for (const store of stores) {
    await new Promise((resolve) => {
      addToHosts(store.name, (success) => {
        if (success) {
          console.log(`   → http://${store.name}.localhost:8000`);
        }
        resolve();
      });
    });
  }

  console.log('\n✨ Configuração concluída!\n');
  console.log('📖 Como usar:');
  console.log('   1. Inicie a API: cd api && npm start');
  console.log('   2. Inicie o Frontend: cd ecommercefrontend && flutter run -d chrome --web-port 8000');
  console.log('   3. Acesse:');
  console.log('      → http://devnology.localhost:8000 (Verde)');
  console.log('      → http://in8.localhost:8000 (Roxo)');
  console.log('\n💡 Para adicionar novas lojas, edite este script e rode novamente.\n');
}

/**
 * Mostra instruções caso não tenha permissões
 */
function showManualInstructions() {
  console.log('\n📋 INSTRUÇÕES MANUAIS\n');
  console.log('Como este script não tem permissões, você pode:');
  console.log('\n1️⃣  Opção A - Editar hosts manualmente:\n');

  if (isWindows) {
    console.log('   a) Abra o Bloco de Notas como Administrador');
    console.log(`   b) Abra o arquivo: ${hostsPath}`);
  } else {
    console.log(`   a) Execute: sudo nano ${hostsPath}`);
  }

  console.log('   c) Adicione no final:');
  stores.forEach(store => {
    console.log(`      127.0.0.1 ${store.name}.localhost`);
  });
  console.log('   d) Salve e feche');

  console.log('\n2️⃣  Opção B - Usar query parameters (SEM editar hosts):\n');
  console.log('   → http://localhost:8000?store=devnology');
  console.log('   → http://localhost:8000?store=in8');
  console.log('   ✅ Funciona imediatamente, sem configuração!\n');
}

// Executar setup
setupStores().catch((error) => {
  console.error('❌ Erro durante o setup:', error);
  showManualInstructions();
});
