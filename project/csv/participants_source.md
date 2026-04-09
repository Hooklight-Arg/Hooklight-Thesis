# Participants Dataset Source

## Descripción

El archivo `participants.csv` es generado a partir de una hoja de cálculo en Google Sheets, utilizada como fuente dinámica de participantes para las campañas de phishing simuladas.

## Fuente de datos

Google Sheets:
https://docs.google.com/spreadsheets/d/19wAEFFFoNADMuCgV8_am2Dr7Gcchw7A0lb9xzJEiWEo/edit?usp=sharing

## Exportación CSV directa

https://docs.google.com/spreadsheets/d/19wAEFFFoNADMuCgV8_am2Dr7Gcchw7A0lb9xzJEiWEo/export?format=csv

## Uso en el sistema

Este archivo es consumido por el workflow de n8n:

- Lectura de participantes
- Validación de consentimiento
- Generación de correos personalizados

## Estructura esperada

| Campo     | Tipo    | Descripción |
|----------|--------|------------|
| name     | string | Nombre del participante |
| email    | string | Correo electrónico |
| consent  | boolean | Consentimiento informado |

## Nota técnica

El sistema puede consumir directamente el Google Sheet mediante el nodo de Google Sheets en n8n o mediante exportación CSV.
