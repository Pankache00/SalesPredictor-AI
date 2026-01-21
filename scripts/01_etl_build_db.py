import sqlite3
from pathlib import Path
import pandas as pd

# =========================
# RUTAS DEL PROYECTO
# =========================
PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "data"
DB_DIR = PROJECT_ROOT / "database"

SQL_CREATE_TABLES = DB_DIR / "create_table.sql"
DB_PATH = DB_DIR / "dodo_supermercado.db"
SCHEMA_OUT = DB_DIR / "schema.sql"

# CSV
CSV_SUPERMERCADO = DATA_DIR / "Supermercado.csv"
CSV_VENTAS = DATA_DIR / "Ventas.csv"
CSV_INVENTARIO = DATA_DIR / "Inventario.csv"


def export_schema(conn, out_path):
    rows = conn.execute(
        """
        SELECT type, name, sql
        FROM sqlite_master
        WHERE sql IS NOT NULL
          AND name NOT LIKE 'sqlite_%'
        ORDER BY type, name;
    """
    ).fetchall()

    lines = []
    lines.append("PRAGMA foreign_keys = ON;")
    lines.append("")

    for obj_type, name, sql in rows:
        if not sql.endswith(";"):
            sql += ";"
        lines.append(f"-- {obj_type.upper()}: {name}")
        lines.append(sql)
        lines.append("")

    out_path.write_text("\n".join(lines), encoding="utf-8")


def main():
    # Leer CSV
    df_super = pd.read_csv(CSV_SUPERMERCADO)
    df_ventas = pd.read_csv(CSV_VENTAS)
    df_inv = pd.read_csv(CSV_INVENTARIO)

    # Conectar DB
    conn = sqlite3.connect(DB_PATH)
    try:
        conn.execute("PRAGMA foreign_keys = ON;")

        # Crear tablas
        sql = SQL_CREATE_TABLES.read_text(encoding="utf-8")
        conn.executescript(sql)

        # Cargar staging
        df_super.to_sql("stg_supermercado", conn, if_exists="append", index=False)
        df_ventas.to_sql("stg_ventas", conn, if_exists="append", index=False)
        df_inv.to_sql("stg_inventario", conn, if_exists="append", index=False)

        # Poblar tablas finales
        conn.execute("DELETE FROM dim_tienda;")
        conn.execute(
            """
            INSERT INTO dim_tienda
            SELECT DISTINCT Id_Tienda, Nombre_Supermercado, Ciudad, Region
            FROM stg_supermercado;
        """
        )

        conn.execute("DELETE FROM fact_ventas;")
        conn.execute(
            """
            INSERT INTO fact_ventas
            SELECT Id_Venta, Fecha, Id_Tienda, Categoria, Cantidad_Vendida, Monto_Total
            FROM stg_ventas;
        """
        )

        conn.execute("DELETE FROM fact_inventario;")
        conn.execute(
            """
            INSERT INTO fact_inventario
            SELECT Id_Inventario, Fecha, Id_Tienda, Categoria,
                   Promocion, Descuento_pct, Lead_Time_Dias,
                   Stock_Minimo, Stock_Objetivo, Precio,
                   Cantidad_Vendida, Stock_Disponible,
                   Pedido_Pendiente, Rotura_Stock
            FROM stg_inventario;
        """
        )

        conn.commit()

        # Exportar schema.sql
        export_schema(conn, SCHEMA_OUT)

        print("✅ Base creada correctamente")
        print("✅ schema.sql generado")

    finally:
        conn.close()


if __name__ == "__main__":
    main()
