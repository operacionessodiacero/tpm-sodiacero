# Plan de implementación TPM — Sodiacero

> **La app de tarjetas TPM e inventario se movió al link único https://operacionessodiacero.github.io/sistema-gestion/** (repositorio `sistema-gestion`). Este link redirige allá y conserva los links de instalación. Este repositorio queda para el plan TPM (issues, milestones y tablero).

> **10 pilares, una sola meta: cero pérdidas** — cero fallas, cero defectos, cero accidentes.

**Duración:** 24 meses de implementación + consolidación hasta el mes 30.
**Punto de partida:** sin indicadores, sin inventario de equipos ni repuestos, sin cultura de mantenimiento.
**Lógica:** primero medir y ordenar → luego mantener → luego mejorar. Todo inicia en un **área piloto** y después se replica.

## Cómo usar este repositorio

| Elemento | Para qué sirve |
|---|---|
| **Issues** | Un issue por paso del plan (`[F1.3] ...`). Dentro: tareas, entregable y checklist de cierre. |
| **Milestones** | Una por fase (F0 a F5) con fecha límite. Muestran el % de avance de cada fase. |
| **Etiquetas** | Una por pilar (`P1 5S`, `P2 Mantenimiento Autonomo`, …). Filtran el avance por pilar. |
| **Project "TPM Sodiacero"** | Tablero con campos Estado, Fase, Pilar, Inicio y Fin. Vistas sugeridas: *Tablero* (por Estado) y *Roadmap* (por Inicio/Fin). |

**Rutina de seguimiento**
1. Cada responsable marca las tareas del issue y adjunta evidencia (fotos, formatos) como comentario.
2. En el **Comité TPM semanal** se revisa el tablero: qué avanzó, qué está atrasado, qué está bloqueado.
3. Un issue se cierra cuando el entregable está aprobado por el comité.
4. Mensualmente se revisa con gerencia el avance por milestone y los indicadores.

`plan-tpm.json` es la fuente del plan, `plan-tpm.csv` es la misma información para Google Sheets o Excel, y `crear-repo-github.ps1` regenera la estructura (no duplica lo existente).

## Línea de tiempo

| Fase | M1-3 | M4-6 | M7-9 | M10-12 | M13-15 | M16-18 | M19-21 | M22-24 | M25-30 |
|---|---|---|---|---|---|---|---|---|---|
| **F0** Arranque y compromiso | ■■ | | | | | | | | |
| **F1** Diagnóstico y línea base | ■■■ | ■■ | | | | | | | |
| **F2** Cimientos (5S, formación, seguridad) | ■ | ■■■ | ■■■ | | | | | | |
| **F3** Pilotos (MA, MP, Mejora Enfocada) | | | ■■■ | ■■■ | ■■■ | | | | |
| **F4** Expansión a toda la planta | | | | ■■ | ■■■ | ■■■ | ■■■ | ■■■ | |
| **F5** Consolidación | | | | | | ■ | ■■ | ■■■ | ■■■ |

## Los 10 pilares

| # | Pilar | Rol en el plan |
|---|---|---|
| 1 | 5S | Base de la cultura: orden y disciplina visibles |
| 2 | Mantenimiento Autónomo | Los operarios cuidan su equipo (pasos 1 a 7) |
| 3 | Mantenimiento Planificado | Inventario, criticidad, preventivo, OT, repuestos, predictivo |
| 4 | Mantenimiento de Calidad | Condiciones del equipo para cero defectos |
| 5 | Mejora Enfocada | Kaizen sobre las 6 grandes pérdidas |
| 6 | Educación y Entrenamiento | Sensibilización, matriz de habilidades, LUP, formación técnica |
| 7 | Seguridad y Medio Ambiente | LOTO, condiciones inseguras, reporte de incidentes |
| 8 | TPM en Oficinas | Compras, almacén y planeación al servicio de la planta |
| 9 | Gestión Temprana de Equipos | Comprar equipos fáciles de operar y mantener |
| 10 | Meta e Indicadores | Medir: paradas → disponibilidad, MTTR, MTBF → OEE |

## Indicadores (se introducen de forma gradual)

1. **Mes 2:** número de paradas y tiempo de parada
2. **Mes 5:** disponibilidad, MTTR, MTBF, accidentes e incidentes (línea base)
3. **Mes 6-8:** puntaje 5S, tarjetas TPM abiertas/cerradas, horas de capacitación
4. **Mes 9:** OEE del piloto y cumplimiento del plan preventivo
5. **Mes 15-18:** % mantenimiento planificado vs. correctivo, costo de mantenimiento, OEE de planta

## Metas de referencia (se ajustan con la línea base del mes 5)

| Hito | Meta |
|---|---|
| Mes 6 | 100 % equipos inventariados y con criticidad; 100 % del personal sensibilizado |
| Mes 12 | Piloto con 5S ≥ 70 %, paradas no planificadas −30 % vs. base, cero accidentes en el piloto |
| Mes 24 | OEE del piloto +15 puntos vs. base, ≥ 60 % del mantenimiento planificado, toda la planta en 5S |

## Rutinas de gestión

- **Diaria (10 min):** reunión frente al tablero del área piloto
- **Semanal:** Comité TPM revisa este tablero
- **Mensual:** revisión con gerencia de indicadores y bloqueos
- **Trimestral:** ajuste del plan y reconocimientos

## Riesgos principales

- **"Eso no es mi trabajo":** resultados rápidos y visibles (5S) y gerencia presente en planta.
- **Querer medir todo de una vez:** dos indicadores en papel valen más que un sistema perfecto que nadie llena.
- **Coordinador sobrecargado:** mínimo 50 % de su tiempo dedicado a TPM.
- **Expandir antes de consolidar:** no salir del piloto hasta que el piloto funcione.
