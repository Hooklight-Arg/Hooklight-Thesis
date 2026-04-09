# Sobre el Proyecto

El proyecto consiste en poder tener un sistema automatico , que tenga la capacidad de crear simulaciones de **pishing** de forma **automatica** . El sistema se divide en dos partes , infrastructura en Docker y servicios externos , los cuales interactuan entre si para automatizar y el envio de mails mediante smpt

---
### 🐋 Docker Infrastructura

```mermaid
flowchart LR
subgraph Docker["Entorno Local - Docker"]

n8n["n8n
Workflows / Webhooks"]

postgres["PostgreSQL"]

pgadmin["PGAdmin
Visualización"]

cloudflare["Cloudflare
Expone localhost:5678"]

n8n --> postgres
n8n --> pgadmin
pgadmin 
cloudflare --> pgadmin

end
```
---

#### 📘 [ver explicación detallada de arquitectura ](/Docs/arquitectura.md)


--- 
La arquitectura del sistema utiliza n8n como motor de automatización de workflows, PostgreSQL para el almacenamiento de datos, servicios SMTP para el envío de correos y herramientas de exposición segura de servicios como Cloudflare Tunnel.

---
### 🌐 Servicios Externos 
```mermaid
flowchart LR

subgraph Externos["Servicios Externos"]

sheets["Google Sheets
Lista de Participantes"]

mailgun["Mailgun
Servicio SMTP"]

usuario["Usuario Final"]

dominio["hooklight.dev.ar / trycloudflare
URL pública"]

sheets --> mailgun
mailgun --> usuario
usuario --> dominio

end
```

---
El proyecto propone el desarrollo de un sistema **automatizado** para la simulación de campañas de **phishing** con fines educativos y de concientización en **ciberseguridad**.

La plataforma permite recrear de forma controlada ataques de ingeniería social con el objetivo de medir el comportamiento de los usuarios frente a correos fraudulentos y mejorar la cultura de seguridad dentro de una organización o entorno académico.

El sistema automatiza todo el ciclo de una campaña de phishing simulada mediante el uso de herramientas de **orquestación** y **monitoreo**. Primero se carga una lista de participantes, luego se envían correos electrónicos simulados que incluyen mecanismos de seguimiento como píxeles de apertura y enlaces de seguimiento. Cuando un usuario interactúa con el correo, el sistema registra eventos como la apertura del mensaje o el clic en el enlace.

#### 📘 [ver explicación detallada de los flujos ](/Docs/flujo.md)
---
### ♒ Flujo De Automatización


```mermaid
flowchart LR

User[Usuario Final]

Sheets[Google Sheets\nLista de participantes]

n8n[n8n Workflows]

Mailgun[SMTP / Mailgun]

Cloudflare[Cloudflare Tunnel]

WebhookOpen[/Webhook\n/open pixel/]

WebhookClick[/Webhook\n/phishing-click/]

DB[(PostgreSQL\nTabla Events)]

Training[Pagina de Micro-Capacitación]

User -->|recibe correo| Mailgun
Sheets --> n8n
n8n --> Mailgun

Mailgun -->|correo phishing| User

User -->|abre correo| WebhookOpen
User -->|click en enlace| WebhookClick

WebhookOpen --> n8n
WebhookClick --> n8n

n8n --> DB

WebhookClick --> Training

Cloudflare --> WebhookOpen
Cloudflare --> WebhookClick

style Sheets fill: #9cff8f , color:black
style DB fill: #1a36d1 , color:white
style Mailgun fill: #d34646 , color:white

```

---

El proyecto se basa en principios de ciberseguridad defensiva y ética, incluyendo consentimiento informado de los participantes, minimización de datos personales y anonimización de la información recolectada.

De esta forma, Hooklight permite evaluar de forma práctica la vulnerabilidad humana frente a ataques de phishing y contribuir a mejorar la concientización en seguridad informática mediante entrenamiento basado en experiencias reales.

---
---
#### Temas Relacionados.
+ ###  [Ver Diagrama de Flujo](/Docs/flujo.md)
+ ###  [Ver Diagrama de Arquitectura](/Docs/arquitectura.md)
+ ###  [Investigacion sobre pishing](/Docs/Investigacion.md)
+ ###  [Regresar](/README.md)
