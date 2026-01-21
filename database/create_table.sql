PRAGMA foreign_keys = ON;

-- =========================
-- 1) STAGING (RAW) - espejo CSV
-- =========================

DROP TABLE IF EXISTS stg_supermercado;
CREATE TABLE stg_supermercado (
  Id_Tienda INTEGER,
  Nombre_Supermercado TEXT,
  Ciudad TEXT,
  Region TEXT
);

DROP TABLE IF EXISTS stg_ventas;
CREATE TABLE stg_ventas (
  Id_Venta INTEGER,
  Fecha TEXT,
  Nombre_Supermercado TEXT,
  Ciudad TEXT,
  Categoria TEXT,
  Cantidad_Vendida REAL,
  Monto_Total REAL,
  Id_Tienda INTEGER
);

DROP TABLE IF EXISTS stg_inventario;
CREATE TABLE stg_inventario (
  Id_Inventario INTEGER,
  Fecha TEXT,
  Id_Tienda INTEGER,
  Nombre_Supermercado TEXT,
  Ciudad TEXT,
  Categoria TEXT,
  Promocion INTEGER,
  Descuento_pct REAL,
  Lead_Time_Dias INTEGER,
  Stock_Minimo REAL,
  Stock_Objetivo REAL,
  Precio REAL,
  Cantidad_Vendida REAL,
  Stock_Disponible REAL,
  Pedido_Pendiente REAL,
  Rotura_Stock INTEGER
);

-- =========================
-- 2) CURADA - modelo para análisis
-- =========================

DROP TABLE IF EXISTS dim_tienda;
CREATE TABLE dim_tienda (
  Id_Tienda INTEGER PRIMARY KEY,
  Nombre_Supermercado TEXT NOT NULL,
  Ciudad TEXT NOT NULL,
  Region TEXT NOT NULL
);

DROP TABLE IF EXISTS fact_ventas;
CREATE TABLE fact_ventas (
  Id_Venta INTEGER PRIMARY KEY,
  Fecha TEXT NOT NULL,
  Id_Tienda INTEGER NOT NULL,
  Categoria TEXT NOT NULL,
  Cantidad_Vendida REAL NOT NULL,
  Monto_Total REAL NOT NULL,
  FOREIGN KEY (Id_Tienda) REFERENCES dim_tienda(Id_Tienda)
);

DROP TABLE IF EXISTS fact_inventario;
CREATE TABLE fact_inventario (
  Id_Inventario INTEGER PRIMARY KEY,
  Fecha TEXT NOT NULL,
  Id_Tienda INTEGER NOT NULL,
  Categoria TEXT NOT NULL,
  Promocion INTEGER,
  Descuento_pct REAL,
  Lead_Time_Dias INTEGER,
  Stock_Minimo REAL,
  Stock_Objetivo REAL,
  Precio REAL,
  Cantidad_Vendida REAL,
  Stock_Disponible REAL,
  Pedido_Pendiente REAL,
  Rotura_Stock INTEGER,
  FOREIGN KEY (Id_Tienda) REFERENCES dim_tienda(Id_Tienda)
);

-- Índices para optimización de consultas
CREATE INDEX IF NOT EXISTS idx_fact_ventas_fecha ON fact_ventas(Fecha);
CREATE INDEX IF NOT EXISTS idx_fact_ventas_tienda ON fact_ventas(Id_Tienda);
CREATE INDEX IF NOT EXISTS idx_fact_inv_fecha ON fact_inventario(Fecha);
CREATE INDEX IF NOT EXISTS idx_fact_inv_tienda ON fact_inventario(Id_Tienda);