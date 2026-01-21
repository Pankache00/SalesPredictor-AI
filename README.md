# SalesPredictor-AI 📊

Proyecto de análisis de datos orientado a predicción de ventas y apoyo a inventario en un contexto retail ficticio.

## Flujo del proyecto

1. Datos de entrada (CSV) en `data/`
2. ETL crea y carga una base SQLite (local, no versionada)
3. Se exporta el esquema a `database/schema.sql` para documentar la estructura
4. Análisis y modelado en notebooks dentro de `scripts/`

## Estructura

- `data/`: CSV originales (fuente cruda)
- `database/`: `create_table.sql` y `schema.sql` (estructura de la BD)
- `scripts/`: notebooks de ETL, consultas y SARIMAX
- `outputs/`: gráficos/resultados

## Cómo ejecutar el ETL

```bash
py scripts/01_etl_build_db.py
```
