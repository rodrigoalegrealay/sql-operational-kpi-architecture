-- ==============================================================================
-- PROYECTO: Arquitectura de Datos Operativos y KPIs Logísticos Avanzados
-- AUTOR: Rodrigo Alegre Alay
-- DESCRIPCIÓN: Consultas SQL avanzadas utilizando CTEs y Window Functions 
--              para calcular la continuidad operacional y el ciclo de vida de OC.
-- ENTORNO: Compatible con PostgreSQL, BigQuery, Oracle y SQL Server.
-- ==============================================================================

-- COMPONENTE 1: Trazabilidad del Ciclo de Vida de Órdenes de Compra (OC) y Tiempos de Espera (SLA)
-- Objetivo: Medir los días transcurridos entre que se aprueba una OC y llega el repuesto a Bodega.

WITH Historial_Logistico AS (
    SELECT 
        id_orden,
        item_componente,
        estado,
        fecha_evento,
        -- Traemos la fecha del estado anterior para calcular el delta de tiempo
        LAG(fecha_evento) OVER(PARTITION BY id_orden ORDER BY fecha_evento) AS fecha_estado_anterior
    FROM operacion_bodega.seguimiento_oc
)
SELECT 
    id_orden,
    item_componente,
    fecha_estado_anterior AS fecha_aprobacion,
    fecha_evento AS fecha_recepcion_bodega,
    -- Calculamos la diferencia de días reales entre estados
    (fecha_evento - fecha_estado_anterior) AS dias_lead_time,
    CASE 
        WHEN (fecha_evento - fecha_estado_anterior) <= 5 THEN 'Dentro de SLA (Óptimo)'
        WHEN (fecha_evento - fecha_estado_anterior) BETWEEN 6 AND 10 THEN 'Riesgo Moderado'
        ELSE 'Fuera de SLA (Crítico - Detiene Operación)'
    END AS estatus_cumplimiento
FROM Historial_Logistico
WHERE estado = 'Recibido en Bodega' AND fecha_estado_anterior IS NOT NULL
ORDER BY dias_lead_time DESC;


-- ------------------------------------------------------------------------------
-- COMPONENTE 2: Control de Rotación e Identificación del Último Estado de Repuestos Críticos
-- Objetivo: Evitar mermas y duplicidad de registros, aislando el estado más reciente de cada activo.

WITH Ultimo_Movimiento_Activo AS (
    SELECT 
        id_componente,
        codigo_parte,
        ubicacion_bodega,
        costo_unitario_clp,
        estado_reparable,
        fecha_actualizacion,
        -- Numeramos las filas por componente, dejando el movimiento más reciente con el N° 1
        ROW_NUMBER() OVER(PARTITION BY id_componente ORDER BY fecha_actualizacion DESC) AS indice_reciente
    FROM inventario_minero.componentes_criticos
)
SELECT 
    id_componente,
    codigo_parte,
    ubicacion_bodega,
    costo_unitario_clp,
    estado_reparable,
    fecha_actualizacion AS fecha_ultimo_inventario
FROM Ultimo_Movimiento_Activo
WHERE indice_reciente = 1 -- Filtramos solo el registro vigente en tiempo real
ORDER BY costo_unitario_clp DESC;


-- ------------------------------------------------------------------------------
-- NOTA DE OPTIMIZACIÓN EN PRODUCCIÓN (Para el Reclutador Senior):
-- Para asegurar la eficiencia de estas consultas en tablas que superen los 10 millones de filas:
-- 1. Se sugiere aplicar particionamiento por la columna 'fecha_evento' o 'fecha_actualizacion'.
-- 2. Creación de índices compuestos en: seguimiento_oc(id_orden, fecha_evento) 
--    y componentes_criticos(id_componente, fecha_actualizacion DESC).