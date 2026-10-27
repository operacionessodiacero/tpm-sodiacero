// Configuración general de la app TPM Sodiacero.
window.APP_CONFIG = {
  // URL de la aplicación web de Google Apps Script (termina en /exec).
  // Si se deja vacía, la app funciona en "modo demostración" guardando solo en este navegador.
  // También se puede escribir desde la pestaña Ajustes de la app.
  API_URL: 'https://script.google.com/macros/s/AKfycbwm_BG8tj_86nqyYAX3Nd0MHaBiH6T2RxZw0uf1SXhfDzg1bGrS9gGX27XaB8N6wMpK/exec',

  EMPRESA: 'SODIACERO',

  // "codigo" se usa para generar el código de los activos: SDA-<codigo>-0001
  AREAS: [
    { nombre: 'TALLER', codigo: 'TAL' },
    {
      nombre: 'PATIO Y ALISTAMIENTO', codigo: 'PAT',
      ubicaciones: ['HANGAR 1', 'HANGAR 2', 'HANGAR 3', 'HANGAR 4', 'HANGAR 5', 'HANGAR 6',
        'HANGAR CARGUE DE MATERIA PRIMA AL HORNO']
    },
    { nombre: 'PLANTA - TREFI/DOBL/ELECTR', codigo: 'TDE' },
    { nombre: 'PLANTA - TREN DE LAMINACIÓN 230', codigo: 'L230' },
    { nombre: 'PLANTA - TREN DE LAMINACIÓN 380', codigo: 'L380' },
    { nombre: 'ENTORCHADO', codigo: 'ENT' },
    { nombre: 'ALMACÉN TALLER', codigo: 'ALM' }
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
