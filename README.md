# 📊 SalesPredictor-AI 📊

Proyecto de análisis de datos orientado a la predicción de ventas y apoyo a la gestión
de inventario en un contexto retail ficticio.

---

## Contexto del desafío y enfoque analítico

El proyecto *SalesPredictor-AI* surge a partir de un desafío de analítica para la gestión
comercial en una empresa de retail, cuyo objetivo es anticipar la demanda de productos
para evitar situaciones de sobrestock o quiebres de inventario.

La propuesta inicial consideraba el uso de modelos tradicionales de series de tiempo
como ARIMA, así como enfoques más avanzados como LSTM, utilizando datos históricos de ventas
y patrones estacionales.

Sin embargo, durante el desarrollo del proyecto se identificó que el modelo ARIMA resultaba
demasiado restrictivo y generaba proyecciones excesivamente planas, al no considerar factores
externos relevantes para la toma de decisiones comerciales.

Frente a este escenario, y en base a requerimientos simulados del mandante (empresa),
se decidió evolucionar el enfoque hacia un modelo SARIMAX, incorporando variables exógenas
que permiten capturar una mayor variabilidad en la demanda, tales como:

- Promociones y descuentos
- Ofertas en fines de semana
- Cambios en el comportamiento de compra por eventos comerciales

Este enfoque permitió obtener proyecciones más realistas y alineadas con un contexto
real de negocio.

> Nota: El escenario de negocio y las variables exógenas utilizadas corresponden a un
> contexto ficticio, diseñado con fines analíticos y de demostración de capacidades.

---

## Flujo del proyecto

1. Datos de entrada (CSV) en `data/`
2. Proceso ETL crea y carga una base SQLite local (no versionada)
3. Se exporta el esquema a `database/schema.sql` para documentar la estructura de la base
4. Análisis exploratorio y modelado predictivo en notebooks dentro de `scripts/`

---

## Estructura del repositorio

- `data/`: archivos CSV originales (fuente cruda)
- `database/`: scripts SQL (`create_table.sql` y `schema.sql`)
- `scripts/`: notebooks de ETL, consultas exploratorias y modelado SARIMAX
- `outputs/`: gráficos y resultados del análisis
- `requirements.txt`: dependencias del proyecto

---

## Tecnologías utilizadas

- Python
- Pandas
- NumPy
- Statsmodels (SARIMAX)
- SQLite
- Jupyter Notebook
- Git / GitHub

---

## Cómo ejecutar el ETL

```bash
py scripts/01_etl_build_db.py
