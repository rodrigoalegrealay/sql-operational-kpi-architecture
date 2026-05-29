# sql-operational-kpi-architecture
Queries avanzadas en SQL (CTEs y Window Functions) para control de inventarios críticos, trazabilidad logística y cumplimiento de SLAs de continuidad operativa.

# Arquitectura de Consultas SQL: KPIs de Continuidad Operativa e Inventarios

## 📌 Propósito del Proyecto
Este repositorio expone una galería de scripts de **SQL Avanzado** diseñados para resolver problemas críticos de la cadena de suministro, control de gestión e ingeniería de procesos logísticos. El objetivo es procesar grandes volúmenes de datos operativos y transformarlos en métricas de cumplimiento de niveles de servicio (SLAs), optimizando la toma de decisiones y reduciendo costos por mermas o quiebres de stock.

## 🛠️ Conceptos Técnicos Demostrados
* **Expresiones de Tabla Comunes (CTEs):** Estructuración de código limpio, modular y legible, eliminando subconsultas anidadas ineficientes.
* **Window Functions (Funciones de Ventana):** Uso estratégico de `LAG()` para calcular tiempos de tránsito (*Lead Times*) y `ROW_NUMBER()` para la deduplicación de inventario en tiempo real.
* **Lógica Condicional Avanzada:** Segmentación dinámica de alertas operativas basadas en rangos de cumplimiento.
* **Estrategias de Optimización:** Diseño conceptual de indexación y particionamiento para entornos Big Data.

## 📈 Impacto en el Negocio
* **Monitoreo de Proveedores:** Identificación inmediata de órdenes de compra fuera de SLA que ponen en riesgo la continuidad operacional de la faena u obra.
* **Gobernanza de Inventarios:** Control exacto del ciclo de vida y la ubicación del stock de repuestos de alto valor, asegurando auditorías de existencias con 100% de confiabilidad.
