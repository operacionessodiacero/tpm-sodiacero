// Configuración general de la app TPM Sodiacero.
window.APP_CONFIG = {
  // URL de la aplicación web de Google Apps Script (termina en /exec).
  // Si se deja vacía, la app funciona en "modo demostración" guardando solo en este navegador.
  // También se puede escribir desde la pestaña Ajustes de la app.
  API_URL: 'https://script.google.com/macros/s/AKfycbwm_BG8tj_86nqyYAX3Nd0MHaBiH6T2RxZw0uf1SXhfDzg1bGrS9gGX27XaB8N6wMpK/exec',

  EMPRESA: 'SODIACERO',

  // "codigo" se usa para generar el código de los activos: SDA-<codigo>-0001
  AREAS: [
    { nombre: 'Taller', codigo: 'TAL' },
    {
      nombre: 'Patio de alistamiento de materia prima', codigo: 'PAT',
      ubicaciones: ['Hangar 1', 'Hangar 2', 'Hangar 3', 'Hangar 4', 'Hangar 5']
    },
    { nombre: 'Despachos', codigo: 'DES' },
    { nombre: 'Almacén de materia prima para proceso (horno)', codigo: 'AMP' },
    { nombre: 'Almacenamiento y preparación de materiales', codigo: 'APM' },
    { nombre: 'Mallas', codigo: 'MAL' },
    { nombre: 'Tren de laminación 230', codigo: 'L230' },
    { nombre: 'Tren de laminación 380', codigo: 'L380' },
    { nombre: 'Entorchado', codigo: 'ENT' },
    { nombre: 'Almacén de repuestos y maquinaria', codigo: 'ALM' }
  ],

  CLASIFICACIONES: ['Limpieza', 'Mantenimiento autónomo', 'Requiere intervención de mantenimiento'],

  ANORMALIDADES: [
    'Fallos menores', 'Condiciones básicas', 'Lugar difícil acceso',
    'Fuentes de contaminación', 'Defecto de calidad', 'Organización y orden'
  ],

  TIPOS_EQUIPO: ['Motor', 'Bomba', 'Reductor', 'Compresor', 'Puente grúa', 'Montacargas',
    'Máquina herramienta', 'Tablero eléctrico', 'Instrumento', 'Vehículo', 'Herramienta', 'Otro'],

  ESTADOS_EQUIPO: ['Operativo', 'En mantenimiento', 'Fuera de servicio', 'Dado de baja']
};
