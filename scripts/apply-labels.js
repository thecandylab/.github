#!/usr/bin/env node

const https = require('https');
const fs = require('fs');
const path = require('path');

// Colores para la consola
const colors = {
	reset: '\x1b[0m',
	bright: '\x1b[1m',
	green: '\x1b[32m',
	yellow: '\x1b[33m',
	red: '\x1b[31m',
	blue: '\x1b[34m',
	cyan: '\x1b[36m'
};

// Verificar argumentos
if (process.argv.length < 5) {
	console.log(`
${colors.yellow}Uso:${colors.reset}
  node apply-labels.js <OWNER> <REPO> <TOKEN>

${colors.yellow}Argumentos:${colors.reset}
  OWNER  - Nombre de la organización o usuario
  REPO   - Nombre del repositorio
  TOKEN  - Token de GitHub con permisos de escritura

${colors.yellow}Ejemplo:${colors.reset}
  node apply-labels.js mi-org mi-repo ghp_xxxxxxxxxxxx
  `);
	process.exit(1);
}

const [, , OWNER, REPO, TOKEN] = process.argv;

// Cargar etiquetas desde el archivo JSON
const labelsPath = path.join(__dirname, 'labels.json');
const labels = JSON.parse(fs.readFileSync(labelsPath, 'utf8'));

// Función para hacer peticiones a la API de GitHub
function githubRequest(method, path, data = null) {
	return new Promise((resolve, reject) => {
		const options = {
			hostname: 'api.github.com',
			path: path,
			method: method,
			headers: {
				'Authorization': `token ${TOKEN}`,
				'Accept': 'application/vnd.github.v3+json',
				'User-Agent': 'Label-Manager',
				'Content-Type': 'application/json'
			}
		};

		const req = https.request(options, (res) => {
			let body = '';
			res.on('data', chunk => body += chunk);
			res.on('end', () => {
				if (res.statusCode >= 200 && res.statusCode < 300) {
					try {
						resolve(body ? JSON.parse(body) : null);
					} catch (e) {
						resolve(body);
					}
				} else {
					reject({
						status: res.statusCode,
						message: body
					});
				}
			});
		});

		req.on('error', reject);

		if (data) {
			req.write(JSON.stringify(data));
		}

		req.end();
	});
}

// Obtener etiquetas existentes
async function getExistingLabels() {
	try {
		console.log(`\n${colors.cyan}📋 Obteniendo etiquetas existentes...${colors.reset}`);
		const labels = [];
		let page = 1;
		let hasMore = true;

		while (hasMore) {
			const response = await githubRequest('GET', `/repos/${OWNER}/${REPO}/labels?page=${page}&per_page=100`);
			labels.push(...response);
			hasMore = response.length === 100;
			page++;
		}

		console.log(`${colors.green}✓${colors.reset} Encontradas ${labels.length} etiquetas existentes`);
		return labels;
	} catch (error) {
		console.error(`${colors.red}✗ Error al obtener etiquetas:${colors.reset}`, error.message);
		throw error;
	}
}

// Crear o actualizar una etiqueta
async function createOrUpdateLabel(label, existingLabels) {
	const existing = existingLabels.find(l => l.name.toLowerCase() === label.name.toLowerCase());

	try {
		if (existing) {
			// Verificar si necesita actualización
			if (existing.color !== label.color || existing.description !== label.description) {
				await githubRequest('PATCH', `/repos/${OWNER}/${REPO}/labels/${encodeURIComponent(existing.name)}`, {
					color: label.color,
					description: label.description
				});
				console.log(`${colors.yellow}↻${colors.reset} Actualizada: ${colors.bright}${label.name}${colors.reset}`);
			} else {
				console.log(`${colors.blue}═${colors.reset} Sin cambios: ${label.name}`);
			}
		} else {
			// Crear nueva etiqueta
			await githubRequest('POST', `/repos/${OWNER}/${REPO}/labels`, {
				name: label.name,
				color: label.color,
				description: label.description
			});
			console.log(`${colors.green}✓${colors.reset} Creada: ${colors.bright}${label.name}${colors.reset}`);
		}
	} catch (error) {
		console.error(`${colors.red}✗${colors.reset} Error con ${label.name}:`, error.message);
	}
}

// Función principal
async function main() {
	console.log(`
${colors.bright}🏷️  Aplicador de Etiquetas de GitHub${colors.reset}
${colors.cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}
📦 Repositorio: ${colors.bright}${OWNER}/${REPO}${colors.reset}
🏷️  Etiquetas a procesar: ${colors.bright}${labels.length}${colors.reset}
  `);

	try {
		// Verificar acceso al repositorio
		console.log(`${colors.cyan}🔐 Verificando acceso...${colors.reset}`);
		await githubRequest('GET', `/repos/${OWNER}/${REPO}`);
		console.log(`${colors.green}✓${colors.reset} Acceso confirmado\n`);

		// Obtener etiquetas existentes
		const existingLabels = await getExistingLabels();

		// Aplicar etiquetas
		console.log(`\n${colors.cyan}🚀 Aplicando etiquetas...${colors.reset}`);
		console.log(`${colors.cyan}${'─'.repeat(40)}${colors.reset}`);

		for (const label of labels) {
			await createOrUpdateLabel(label, existingLabels);
		}

		console.log(`\n${colors.green}${colors.bright}✅ ¡Proceso completado!${colors.reset}`);
		console.log(`
${colors.cyan}📊 Resumen:${colors.reset}
• Total de etiquetas procesadas: ${labels.length}
• Repositorio: ${OWNER}/${REPO}

${colors.yellow}💡 Próximos pasos:${colors.reset}
1. Visita https://github.com/${OWNER}/${REPO}/labels
2. Verifica que las etiquetas se hayan aplicado correctamente
3. Comienza a usar las plantillas de issues
    `);

	} catch (error) {
		console.error(`\n${colors.red}${colors.bright}❌ Error fatal:${colors.reset}`, error);
		process.exit(1);
	}
}

// Ejecutar
main();
