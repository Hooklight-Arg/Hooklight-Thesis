# SQL - Hooklight

## Índice interactivo

- [1. Propósito de esta carpeta](#1-propósito-de-esta-carpeta)
- [2. Estructura de carpetas](#2-estructura-de-carpetas)
  - [2.1 `schema/`](#21-schema)
  - [2.2 `queries/`](#22-queries)
  - [2.3 `views/`](#23-views)
  - [2.4 `demo/`](#24-demo)
- [3. Modelo de datos](#3-modelo-de-datos)
  - [3.1 `participants`](#31-participants)
  - [3.2 `campaigns`](#32-campaigns)
  - [3.3 `events`](#33-events)
  - [3.4 `mendoza_departments_geo`](#34-mendoza_departments_geo)
- [4. Relación entre tablas](#4-relación-entre-tablas)
- [5. Orden recomendado de ejecución](#5-orden-recomendado-de-ejecución)
- [6. Uso recomendado](#6-uso-recomendado)
- [7. Convenciones usadas](#7-convenciones-usadas)
- [8. Nota de diseño](#8-nota-de-diseño)
- [9. Posibles mejoras futuras](#9-posibles-mejoras-futuras)
- [10. Finalidad académica](#10-finalidad-académica)
- [11. Explicación de las queries](#11-explicación-de-las-queries)
  - [11.1 `001_total_events.sql`](#111-001_total_eventssql)
  - [11.2 `002_metrics_by_campaign.sql`](#112-002_metrics_by_campaignsql)
  - [11.3 `003_unique_clicks_by_campaign.sql`](#113-003_unique_clicks_by_campaignsql)
  - [11.4 `004_unique_opens_by_campaign.sql`](#114-004_unique_opens_by_campaignsql)
  - [11.5 `005_real_vulnerability_rate.sql`](#115-005_real_vulnerability_ratesql)
  - [11.6 `006_country_distribution.sql`](#116-006_country_distributionsql)
  - [11.7 `007_user_agent_distribution.sql`](#117-007_user_agent_distributionsql)
  - [11.8 `008_events_timeline.sql`](#118-008_events_timelinesql)
  - [11.9 `009_detailed_events_with_participants.sql`](#119-009_detailed_events_with_participantssql)
  - [11.10 `010_funnel_global.sql`](#1110-010_funnel_globalsql)
  - [11.11 `011_mendoza_department_distribution.sql`](#1111-011_mendoza_department_distributionsql)
  - [11.12 `012_seed_mendoza_departments_geo.sql`](#1112-012_seed_mendoza_departments_geosql)
- [12. Explicación de las views](#12-explicación-de-las-views)
  - [12.1 `001_create_campaign_metrics_view.sql`](#121-001_create_campaign_metrics_viewsql)
  - [12.2 `002_create_campaign_unique_metrics_view.sql`](#122-002_create_campaign_unique_metrics_viewsql)
  - [12.3 `003_create_country_distribution_view.sql`](#123-003_create_country_distribution_viewsql)
  - [12.4 `004_create_browser_distribution_view.sql`](#124-004_create_browser_distribution_viewsql)
  - [12.5 `005_create_mendoza_department_distribution_view.sql`](#125-005_create_mendoza_department_distribution_viewsql)
  - [12.6 `006_create_event_facts_view.sql`](#126-006_create_event_facts_viewsql)

---

## 1. Propósito de esta carpeta

Esta carpeta contiene los scripts SQL del proyecto Hooklight, organizados para mantener versionada la estructura de la base de datos, las consultas analíticas y las vistas reutilizables del sistema.

El objetivo es facilitar:

- la reproducibilidad del entorno
- la trazabilidad de cambios en la base de datos
- la reutilización de consultas analíticas
- la documentación técnica del proyecto

[↑ Volver al índice](#índice-interactivo)

---

## 2. Estructura de carpetas

### 2.1 `schema/`

Contiene scripts de creación y actualización de tablas.

Se utiliza para:
- crear tablas nuevas
- modificar tablas existentes
- agregar columnas o constraints
- crear índices de performance

### 2.2 `queries/`

Contiene consultas SQL orientadas al análisis y obtención de métricas.

Se utiliza para:
- medir el embudo `sent -> open -> click`
- calcular vulnerabilidad con usuarios únicos
- obtener distribuciones por país, navegador y departamento
- generar evidencia para el informe y dashboards

### 2.3 `views/`

Contiene vistas SQL reutilizables.

Se utiliza para:
- encapsular consultas frecuentes
- simplificar análisis posteriores
- evitar reescribir consultas complejas
- servir de base para dashboards o reportes

### 2.4 `demo/`

Contiene scripts auxiliares para demos controladas.

Se utiliza para:
- generar backup antes de una demo
- resetear tablas transaccionales (`events`, `campaigns`, `participants`)
- sembrar datos sintéticos consistentes para visualización en Grafana

[↑ Volver al índice](#índice-interactivo)

---

## 3. Modelo de datos

El sistema se basa en un modelo relacional compuesto por tres entidades principales y una tabla de referencia geográfica.

### 3.1 `participants`

Representa a los participantes alcanzados por las campañas simuladas.

Campos principales:
- `id`: identificador UUID del participante
- `name`: nombre
- `email`: correo electrónico
- `consent`: consentimiento de participación
- `province`: provincia declarada
- `department`: departamento declarado

### 3.2 `campaigns`

Representa cada campaña simulada.

Campos principales:
- `id`: identificador textual de campaña (ej. `camp01`)
- `name`: nombre legible
- `description`: descripción
- `is_active`: estado de la campaña
- `start_date`: inicio planificado
- `end_date`: fin planificado

### 3.3 `events`

Representa cada evento registrado por el sistema.

Campos principales:
- `id`: identificador interno autoincremental
- `user_id`: referencia al participante
- `campaign_id`: referencia a la campaña
- `event_type`: tipo de evento (`sent`, `open` o `click`)
- `event_time`: fecha y hora del evento
- `ip`: IP capturada por el webhook
- `user_agent`: cliente/navegador
- `country`: país detectado por Cloudflare

### 3.4 `mendoza_departments_geo`

Tabla de referencia para mapas por coordenadas.

Campos principales:
- `department`: nombre del departamento (clave primaria)
- `lat`: latitud del centroide
- `lon`: longitud del centroide

[↑ Volver al índice](#índice-interactivo)

---

## 4. Relación entre tablas

- Un participante puede generar múltiples eventos.
- Una campaña puede tener múltiples eventos.
- Cada evento pertenece, idealmente, a un participante y a una campaña.
- La tabla `mendoza_departments_geo` se relaciona lógicamente con `participants.department` para análisis geográficos.

Esto permite separar correctamente:

- quién recibió la campaña
- a qué campaña pertenece el evento
- qué tipo de interacción ocurrió
- dónde se concentra la actividad (a nivel de departamento)

[↑ Volver al índice](#índice-interactivo)

---

## 5. Orden recomendado de ejecución

### 1. Crear tablas base
Ejecutar en este orden:

1. `schema/001_create_participants.sql`
2. `schema/002_create_campaigns.sql`
3. `schema/003_create_events.sql`

### 2. Adaptar entornos existentes
Si la base ya existía con una versión anterior:

4. `schema/004_alter_events_add_tracking_metadata.sql`
5. `schema/005_allow_sent_event_type.sql`
6. `schema/006_alter_campaigns_add_schedule_fields.sql`
7. `schema/007_alter_participants_add_name_consent.sql`
8. `schema/008_alter_participants_add_location_fields.sql`

### 3. Preparar soporte geográfico

9. `schema/009_create_mendoza_departments_geo.sql`
10. `queries/012_seed_mendoza_departments_geo.sql`

### 4. Optimizar para dashboards

11. `schema/010_add_dashboard_performance_indexes.sql`

### 5. Crear vistas analíticas
Luego ejecutar los archivos de `views/`.

### 6. Ejecutar consultas analíticas
Finalmente, utilizar los archivos de `queries/` en pgAdmin o Query Tool.

[↑ Volver al índice](#índice-interactivo)

---

## 6. Uso recomendado

### En pgAdmin
1. Abrir la base de datos `phishing_awareness`
2. Abrir Query Tool
3. Copiar y ejecutar el contenido del archivo `.sql`

### Para dashboard / demo
1. Seguir el orden de ejecución recomendado
2. Si se necesita una demo limpia, usar `sql/demo/README.md`
3. Consultar primero las `views/` y luego profundizar con `queries/`

### En documentación técnica
Estas consultas pueden ser utilizadas para:
- justificar resultados
- obtener métricas del informe
- respaldar capturas
- construir tablas analíticas

[↑ Volver al índice](#índice-interactivo)

---

## 7. Convenciones usadas

### `IF NOT EXISTS`
Se usa para evitar errores al reejecutar scripts de creación de tablas e índices.

### `CREATE OR REPLACE VIEW`
Se usa para actualizar vistas sin necesidad de borrarlas manualmente.

### `ON CONFLICT ... DO UPDATE`
Se usa para mantener idempotente la carga de referencia geográfica.

### `LEFT JOIN`
Se usa en consultas analíticas para no perder eventos aunque falte una referencia asociada.

[↑ Volver al índice](#índice-interactivo)

---

## 8. Nota de diseño

En este prototipo no se utiliza una tabla `users` separada, ya que la entidad funcional equivalente es `participants`.

Por lo tanto:

- `participants` representa a los usuarios alcanzados por la campaña
- `events.user_id` referencia a `participants.id`
- el embudo principal se mide con tres eventos: `sent`, `open` y `click`

[↑ Volver al índice](#índice-interactivo)

---

## 9. Posibles mejoras futuras

- normalizar aún más datos de dispositivos o navegadores
- agregar tabla de ejecuciones de campaña
- agregar tabla de plantillas de correo
- crear materialized views para paneles de alta carga
- incorporar métricas temporales más avanzadas

[↑ Volver al índice](#índice-interactivo)

---

## 10. Finalidad académica

La organización de estos scripts en archivos versionados permite mejorar la trazabilidad técnica del proyecto y fortalecer la reproducibilidad del entorno, aspecto relevante en el contexto de una tesis de desarrollo de software orientada a ciberseguridad.

[↑ Volver al índice](#índice-interactivo)

---

## 11. Explicación de las queries

### 11.1 `001_total_events.sql`

**Qué es:** una consulta de agregación simple.  
**Qué hace:** cuenta cuántos eventos hay de cada tipo.  
**Para qué sirve:** permite obtener una visión general rápida del volumen total registrado en el embudo.  
**Cómo funciona:**
- `SELECT event_type, COUNT(*) AS total` pide el tipo de evento y su cantidad.
- `FROM events` consulta la tabla de eventos.
- `GROUP BY event_type` agrupa por `sent`, `open` y `click`.
- `ORDER BY event_type` ordena alfabéticamente.

[↑ Volver al índice](#índice-interactivo)

---

### 11.2 `002_metrics_by_campaign.sql`

**Qué es:** una consulta analítica por campaña.  
**Qué hace:** calcula enviados, aperturas, clics, open rate y click-to-open rate para cada campaña.  
**Para qué sirve:** permite comparar el rendimiento general de distintas campañas simuladas.  
**Cómo funciona:**
- `COUNT(*) FILTER (WHERE event_type = 'sent')` cuenta enviados.
- `COUNT(*) FILTER (WHERE event_type = 'open')` cuenta aperturas.
- `COUNT(*) FILTER (WHERE event_type = 'click')` cuenta clics.
- `ROUND(..., 2)` redondea porcentajes.
- `NULLIF(..., 0)` evita división por cero.

[↑ Volver al índice](#índice-interactivo)

---

### 11.3 `003_unique_clicks_by_campaign.sql`

**Qué es:** una consulta de usuarios únicos.  
**Qué hace:** cuenta cuántos participantes distintos hicieron click en cada campaña.  
**Para qué sirve:** evita contar múltiples clics del mismo usuario como si fueran usuarios distintos.  
**Cómo funciona:**
- `WHERE event_type = 'click'` filtra solo clics.
- `COUNT(DISTINCT user_id)` cuenta usuarios únicos.
- `GROUP BY campaign_id` separa el resultado por campaña.

[↑ Volver al índice](#índice-interactivo)

---

### 11.4 `004_unique_opens_by_campaign.sql`

**Qué es:** una consulta de aperturas únicas.  
**Qué hace:** cuenta cuántos usuarios distintos generaron aperturas en cada campaña.  
**Para qué sirve:** ayuda a reducir el sesgo causado por múltiples aperturas repetidas del mismo usuario.  
**Cómo funciona:**
- filtra por `event_type = 'open'`
- usa `COUNT(DISTINCT user_id)` para no duplicar usuarios
- agrupa por campaña

[↑ Volver al índice](#índice-interactivo)

---

### 11.5 `005_real_vulnerability_rate.sql`

**Qué es:** una consulta de embudo único por campaña.  
**Qué hace:** calcula enviados únicos, aperturas únicas, clics únicos, open rate único y tasa de vulnerabilidad.  
**Para qué sirve:** mide el comportamiento humano con menos sesgo por duplicación de eventos.  
**Cómo funciona:**
- usa `COUNT(DISTINCT CASE WHEN ... THEN user_id END)` por etapa del embudo.
- calcula `open_rate_unico_percent` como `opens_unicos / sent_unicos`.
- calcula `tasa_vulnerabilidad` como `clicks_unicos / opens_unicos`.

[↑ Volver al índice](#índice-interactivo)

---

### 11.6 `006_country_distribution.sql`

**Qué es:** una consulta de distribución geográfica.  
**Qué hace:** cuenta cuántos eventos se registraron por país.  
**Para qué sirve:** sirve como evidencia técnica de geolocalización básica mediante headers de Cloudflare.  
**Cómo funciona:**
- agrupa por `country`
- cuenta eventos por cada país
- ordena de mayor a menor frecuencia

[↑ Volver al índice](#índice-interactivo)

---

### 11.7 `007_user_agent_distribution.sql`

**Qué es:** una consulta de distribución técnica.  
**Qué hace:** muestra los agentes de usuario más frecuentes.  
**Para qué sirve:** permite identificar navegadores, clientes de correo o proxys que generaron eventos.  
**Cómo funciona:**
- agrupa por `user_agent`
- cuenta repeticiones
- ordena de mayor a menor
- limita a los más frecuentes

[↑ Volver al índice](#índice-interactivo)

---

### 11.8 `008_events_timeline.sql`

**Qué es:** una consulta temporal.  
**Qué hace:** muestra cuántos eventos hubo por fecha y por tipo.  
**Para qué sirve:** permite visualizar la evolución temporal de enviados, aperturas y clics.  
**Cómo funciona:**
- `DATE(event_time)` toma solo la fecha
- agrupa por fecha y tipo de evento
- cuenta eventos de cada grupo

[↑ Volver al índice](#índice-interactivo)

---

### 11.9 `009_detailed_events_with_participants.sql`

**Qué es:** una consulta de detalle enriquecido.  
**Qué hace:** une eventos con información del participante y de la campaña.  
**Para qué sirve:** sirve para auditoría, validación manual y evidencia detallada del funcionamiento del sistema.  
**Cómo funciona:**
- `FROM events e` toma eventos como tabla principal.
- `LEFT JOIN participants p ON e.user_id = p.id` agrega datos del participante.
- `LEFT JOIN campaigns c ON e.campaign_id = c.id` agrega datos de campaña.
- `ORDER BY e.event_time DESC, e.id DESC` muestra lo más reciente primero.

[↑ Volver al índice](#índice-interactivo)

---

### 11.10 `010_funnel_global.sql`

**Qué es:** una consulta de embudo global (usuarios únicos).  
**Qué hace:** consolida enviados, aperturas y clics únicos de todo el sistema con sus tasas principales.  
**Para qué sirve:** brinda un KPI ejecutivo rápido sin segmentar por campaña.  
**Cómo funciona:**
- calcula `sent_unicos`, `opens_unicos` y `clicks_unicos`.
- calcula `open_rate_unico_percent` y `click_to_open_unico_percent`.
- usa `NULLIF` para evitar divisiones por cero.

[↑ Volver al índice](#índice-interactivo)

---

### 11.11 `011_mendoza_department_distribution.sql`

**Qué es:** una consulta geográfica por departamento de Mendoza.  
**Qué hace:** cuenta eventos totales, eventos por tipo y participantes únicos por departamento.  
**Para qué sirve:** alimenta paneles territoriales y análisis localizados.  
**Cómo funciona:**
- une `events` con `participants`.
- filtra `p.province ILIKE 'Mendoza'`.
- normaliza departamentos vacíos a `N/A`.
- agrupa por departamento.

[↑ Volver al índice](#índice-interactivo)

---

### 11.12 `012_seed_mendoza_departments_geo.sql`

**Qué es:** un script de carga semilla (no analítico).  
**Qué hace:** inserta y actualiza coordenadas de los departamentos de Mendoza.  
**Para qué sirve:** habilita mapas en Grafana con `Location mode: Coordinates`.  
**Cómo funciona:**
- inserta pares `department + lat + lon`.
- aplica `ON CONFLICT (department) DO UPDATE` para mantenerlo idempotente.

[↑ Volver al índice](#índice-interactivo)

---

## 12. Explicación de las views

### 12.1 `001_create_campaign_metrics_view.sql`

**Qué es:** una vista con métricas básicas por campaña.  
**Qué hace:** encapsula enviados, aperturas, clics, open rate y click-to-open rate.  
**Para qué sirve:** permite consultar rápidamente métricas sin reescribir la query completa.  
**Cómo usarla:**
```sql
SELECT * FROM campaign_metrics;
```

[↑ Volver al índice](#índice-interactivo)

---

### 12.2 `002_create_campaign_unique_metrics_view.sql`

**Qué es:** una vista con métricas únicas por campaña.  
**Qué hace:** encapsula enviados únicos, aperturas únicas, clics únicos y tasas únicas.  
**Para qué sirve:** es ideal para reportes académicos y dashboards ejecutivos.  
**Cómo usarla:**
```sql
SELECT * FROM campaign_unique_metrics;
```

[↑ Volver al índice](#índice-interactivo)

---

### 12.3 `003_create_country_distribution_view.sql`

**Qué es:** una vista de distribución por país.  
**Qué hace:** resume eventos por país.  
**Para qué sirve:** permite consultar rápidamente la distribución geográfica sin repetir la query.  
**Cómo usarla:**
```sql
SELECT * FROM event_country_distribution;
```

[↑ Volver al índice](#índice-interactivo)

---

### 12.4 `004_create_browser_distribution_view.sql`

**Qué es:** una vista de distribución por agente de usuario.  
**Qué hace:** resume eventos por navegador o cliente.  
**Para qué sirve:** permite reutilizar fácilmente esta consulta en análisis posteriores.  
**Cómo usarla:**
```sql
SELECT * FROM event_user_agent_distribution;
```

[↑ Volver al índice](#índice-interactivo)

---

### 12.5 `005_create_mendoza_department_distribution_view.sql`

**Qué es:** una vista de distribución territorial en Mendoza.  
**Qué hace:** resume total de eventos, eventos por tipo y participantes únicos por departamento.  
**Para qué sirve:** simplifica el consumo de datos para paneles geográficos.  
**Cómo usarla:**
```sql
SELECT * FROM mendoza_department_distribution;
```

[↑ Volver al índice](#índice-interactivo)

---

### 12.6 `006_create_event_facts_view.sql`

**Qué es:** una vista canónica de hechos para dashboards.  
**Qué hace:** unifica eventos con atributos normalizados de campaña, participante, geografía y navegador.  
**Para qué sirve:** centraliza la lógica de parsing/filtros para reducir duplicación en paneles.  
**Cómo usarla:**
```sql
SELECT * FROM event_facts;
```

[↑ Volver al índice](#índice-interactivo)
