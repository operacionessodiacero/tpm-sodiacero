# TPM Sodiacero

App web (computador y celular) para registrar **tarjetas rojas** (Mantenimiento planificado) y **tarjetas azules** (Mantenimiento autónomo) de TPM, y para el **levantamiento del inventario de equipos**.

- Numeración automática e independiente: tarjetas rojas TR-00001, azules TA-00001, avisos AV-000001 (uno por cada tarjeta).
- Fecha y hora automáticas, área y hangar seleccionables, foto del equipo.
- Al guardar se genera la imagen de la ficha diligenciada y se sube a la carpeta de Google Drive de su color.
- Inventario con código de activo automático por área (SDA-TAL-0001, SDA-L230-0001, ...).
- Los datos quedan en la hoja de Google Sheets (pestañas Tarjetas, Inventario y Contadores).

El backend es un proyecto de Google Apps Script vinculado a la hoja de inventario (Extensiones > Apps Script > TPM Sodiacero). La clave de acceso solo está en ese proyecto; cada dispositivo la recibe una vez con el link de instalación o en Ajustes.

Para cambiar áreas, hangares o listas: editar config.js.
