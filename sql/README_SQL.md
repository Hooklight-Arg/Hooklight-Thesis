# SQL - Hooklight

## Índice interactivo

- [1. Propósito de esta carpeta](#1-propósito-de-esta-carpeta)
- [2. Estructura de carpetas](#2-estructura-de-carpetas)
  - [2.1 `schema/`](#21-schema)
  - [2.2 `queries/`](#22-queries)
  - [2.3 `views/`](#23-views)
- [3. Modelo de datos](#3-modelo-de-datos)
  - [3.1 `participants`](#31-participants)
  - [3.2 `campaigns`](#32-campaigns)
  - [3.3 `events`](#33-events)
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
- [12. Explicación de las views](#12-explicación-de-las-views)
  - [12.1 `001_create_campaign_metrics_view.sql`](#121-001_create_campaign_metrics_viewsql)
  - [12.2 `002_create_campaign_unique_metrics_view.sql`](#122-002_create_campaign_unique_metrics_viewsql)
  - [12.3 `003_create_country_distribution_view.sql`](#123-003_create_country_distribution_viewsql)
  - [12.4 `004_create_browser_distribution_view.sql`](#124-004_create_browser_distribution_viewsql)

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
- cargar datos iniciales mínimos

### 2.2 `queries/`

Contiene consultas SQL orientadas al análisis y obtención de métricas.

Se utiliza para:
- contar eventos
- calcular aperturas y clics
- medir vulnerabilidad
- obtener distribuciones por país o navegador
- generar evidencia para el informe

### 2.3 `views/`

Contiene vistas SQL reutilizables.

Se utiliza para:
- encapsular consultas frecuentes
- simplificar análisis posteriores
- evitar reescribir consultas complejas
- servir de base para dashboards o reportes

[↑ Volver al índice](#índice-interactivo)

---

## 3. Modelo de datos

El sistema se basa en un modelo relacional compuesto por tres entidades principales:

### 3.1 `participants`

Representa a los participantes alcanzados por las campañas simuladas.

Campos principales:
- `id`: identificador UUID del participante
- `name`: nombre
- `email`: correo electrónico
- `consent`: consentimiento de participación

### 3.2 `campaigns`

Representa cada campaña simulada.

Campos principales:
- `id`: identificador textual de campaña (ej. `camp01`)
- `name`: nombre legible
- `description`: descripción
- `is_active`: estado de la campaña

### 3.3 `events`

Representa cada evento registrado por el sistema.

Campos principales:
- `id`: identificador interno autoincremental
- `user_id`: referencia al participante
- `campaign_id`: referencia a la campaña
- `event_type`: tipo de evento (`open` o `click`)
- `event_time`: fecha y hora del evento
- `ip`: IP capturada por el webhook
- `user_agent`: cliente/navegador
- `country`: país detectado por Cloudflare

[↑ Volver al índice](#índice-interactivo)

---

## 4. Relación entre tablas

- Un participante puede generar múltiples eventos.
- Una campaña puede tener múltiples eventos.
- Cada evento pertenece, idealmente, a un participante y a una campaña.

Esto permite separar correctamente:

- quién recibió la campaña
- a qué campaña pertenece el evento
- qué tipo de interacción ocurrió

[↑ Volver al índice](#índice-interactivo)

---

## 5. Orden recomendado de ejecución

### 1. Crear tablas principales
Ejecutar en este orden:

1. `schema/001_create_participants.sql`
2. `schema/002_create_campaigns.sql`
3. `schema/003_create_events.sql`

### 2. Adaptar tablas existentes
Si la tabla `events` ya existía con una estructura anterior, ejecutar:

4. `schema/004_alter_events_add_tracking_metadata.sql`

### 3. Cargar campaña inicial
Opcional:

5. `schema/005_seed_campaigns.sql`

### 4. Crear vistas analíticas
Luego ejecutar los archivos de `views/`.

### 5. Ejecutar consultas analíticas
Finalmente, utilizar los archivos de `queries/` en pgAdmin o Query Tool.

[↑ Volver al índice](#índice-interactivo)

---

## 6. Uso recomendado

### En pgAdmin
1. Abrir la base de datos `phishing_awareness`
2. Abrir Query Tool
3. Copiar y ejecutar el contenido del archivo `.sql`

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
Se usa para evitar errores al reejecutar scripts de creación.

### `CREATE OR REPLACE VIEW`
Se usa para actualizar vistas sin necesidad de borrarlas manualmente.

### `ON CONFLICT DO NOTHING`
Se usa para evitar errores en cargas repetidas de datos semilla.

### `LEFT JOIN`
Se usa en consultas analíticas para no perder eventos aunque falte una referencia asociada.

[↑ Volver al índice](#índice-interactivo)

---

## 8. Nota de diseño

En este prototipo no se utiliza una tabla `users` separada, ya que la entidad funcional equivalente es `participants`.

Por lo tanto:

- `participants` representa a los usuarios alcanzados por la campaña
- `events.user_id` referencia a `participants.id`

[↑ Volver al índice](#índice-interactivo)

---

## 9. Posibles mejoras futuras

- normalizar aún más datos de dispositivos o navegadores
- agregar tabla de ejecuciones de campaña
- agregar tabla de plantillas de correo
- crear vistas orientadas a dashboards
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
**Para qué sirve:** permite obtener una visión general rápida del volumen total de aperturas y clics registrados.  
**Cómo funciona:**
- `SELECT event_type, COUNT(*) AS total` pide el tipo de evento y su cantidad.
- `FROM events` consulta la tabla de eventos.
- `GROUP BY event_type` agrupa por `open` y `click`.
- `ORDER BY event_type` ordena alfabéticamente.

**Ejemplo de resultado:**

| event_type | total |
|---|---:|
| click | 5 |
| open | 21 |

[↑ Volver al índice](#índice-interactivo)

---

### 11.2 `002_metrics_by_campaign.sql`

**Qué es:** una consulta analítica por campaña.  
**Qué hace:** calcula aperturas, clics y porcentaje de clics sobre aperturas para cada campaña.  
**Para qué sirve:** permite comparar el rendimiento general de distintas campañas simuladas.  
**Cómo funciona:**
- `campaign_id` agrupa resultados por campaña.
- `COUNT(*) FILTER (WHERE event_type = 'open')` cuenta solo aperturas.
- `COUNT(*) FILTER (WHERE event_type = 'click')` cuenta solo clics.
- `ROUND(..., 2)` redondea el porcentaje a dos decimales.
- `NULLIF(..., 0)` evita división por cero.

**Ejemplo de resultado:**

| campaign_id | opens | clicks | click_rate_percent |
|---|---:|---:|---:|
| camp01 | 20 | 4 | 20.00 |
| camp02 | 15 | 6 | 40.00 |

**Aclaración:** esta métrica puede estar sesgada si los `open` están inflados por la precarga automática de imágenes.

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

**Ejemplo de resultado:**

| campaign_id | usuarios_que_hicieron_click |
|---|---:|
| camp01 | 3 |

Si una misma persona hizo dos clics, cuenta una sola vez.

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

**Ejemplo de resultado:**

| campaign_id | usuarios_que_abrieron |
|---|---:|
| camp01 | 8 |

Si una persona abrió el mismo correo varias veces, cuenta una sola vez.

[↑ Volver al índice](#índice-interactivo)

---

### 11.5 `005_real_vulnerability_rate.sql`

**Qué es:** la métrica más sólida del conjunto.  
**Qué hace:** calcula la tasa de vulnerabilidad real por campaña usando usuarios únicos.  
**Para qué sirve:** estima cuántos usuarios que abrieron el correo terminaron haciendo click, evitando el sesgo de eventos duplicados.  
**Cómo funciona:**
- `COUNT(DISTINCT CASE WHEN event_type = 'open' THEN user_id END)` cuenta aperturas únicas.
- `COUNT(DISTINCT CASE WHEN event_type = 'click' THEN user_id END)` cuenta clics únicos.
- divide clics únicos sobre aperturas únicas.
- redondea el porcentaje final.

**Ejemplo de resultado:**

| campaign_id | opens_unicos | clicks_unicos | tasa_vulnerabilidad |
|---|---:|---:|---:|
| camp01 | 20 | 5 | 25.00 |

**Interpretación:** si la tasa de vulnerabilidad es 25%, significa que 1 de cada 4 usuarios que abrió el correo hizo click.

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

**Ejemplo de resultado:**

| country | total |
|---|---:|
| AR | 18 |
| CL | 2 |

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
- limita a los 10 más frecuentes

**Ejemplo de resultado:**

| user_agent | total |
|---|---:|
| Mozilla/5.0 ... Chrome/145... | 7 |
| GmailImageProxy | 4 |

**Utilidad analítica:** ayuda a justificar por qué algunos `open` pueden estar inflados.

[↑ Volver al índice](#índice-interactivo)

---

### 11.8 `008_events_timeline.sql`

**Qué es:** una consulta temporal.  
**Qué hace:** muestra cuántos eventos hubo por fecha y por tipo.  
**Para qué sirve:** permite visualizar la evolución temporal de aperturas y clics.  
**Cómo funciona:**
- `DATE(event_time)` toma solo la fecha
- agrupa por fecha y tipo de evento
- cuenta eventos de cada grupo

**Ejemplo de resultado:**

| fecha | event_type | total |
|---|---|---:|
| 2026-04-08 | open | 14 |
| 2026-04-08 | click | 3 |

**Uso típico:** generar gráficos de línea o barras por día.

[↑ Volver al índice](#índice-interactivo)

---

### 11.9 `009_detailed_events_with_participants.sql`

**Qué es:** una consulta de detalle enriquecido.  
**Qué hace:** une eventos con información del participante y de la campaña.  
**Para qué sirve:** sirve para auditoría, validación manual y evidencia detallada del funcionamiento del sistema.  
**Cómo funciona:**
- `FROM events e` toma eventos como tabla principal.
- `LEFT JOIN participants p ON e.user_id = p.id` agrega nombre y email.
- `LEFT JOIN campaigns c ON e.campaign_id = c.id` agrega nombre de campaña.
- `ORDER BY e.event_time DESC, e.id DESC` muestra lo más reciente primero.

**Ejemplo de resultado:**

| id | event_time | event_type | user_id | name | email | campaign_id | campaign_name | ip | country |
|---|---|---|---|---|---|---|---|---|---|
| 12 | 2026-04-08 10:42 | click | uuid... | Martina | marti@email.com | camp01 | Campaña inicial | 190... | AR |

[↑ Volver al índice](#índice-interactivo)

---

## 12. Explicación de las views

### 12.1 `001_create_campaign_metrics_view.sql`

**Qué es:** una vista con métricas básicas por campaña.  
**Qué hace:** guarda como vista la lógica de aperturas, clics y click rate.  
**Para qué sirve:** permite consultar rápidamente métricas sin reescribir la query completa.  
**Cómo usarla:**
```sql
SELECT * FROM campaign_metrics;
```

[↑ Volver al índice](#índice-interactivo)

---

### 12.2 `002_create_campaign_unique_metrics_view.sql`

**Qué es:** una vista con métricas únicas por campaña.  
**Qué hace:** encapsula aperturas únicas, clics únicos y tasa de vulnerabilidad real.  
**Para qué sirve:** es ideal para reportes académicos y dashboards futuros.  
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
