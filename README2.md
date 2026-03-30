# 🧠 Docker DNS Stack (Technitium + Portainer + Bot)

Infraestructura ligera y potente para gestión de contenedores, DNS centralizado y monitoreo, lista para entornos de laboratorio, home lab o producción ligera.

---

## 🚀 Características

* 🌐 Servidor DNS local con Technitium
* 🛠️ Administración visual con Portainer
* 🤖 Bot de Telegram para monitoreo de contenedores
* 🔒 Buenas prácticas de seguridad (no-new-privileges)
* 📦 Persistencia de datos
* 🔗 Integración con VPN (Tailscale-ready)

---

## 🧱 Servicios incluidos

| Servicio       | Descripción                       |
| -------------- | --------------------------------- |
| Portainer      | Panel web para administrar Docker |
| Technitium DNS | Servidor DNS local avanzado       |
| Controller Bot | Bot de Telegram para monitoreo    |

---

## 📦 Requisitos

* Docker
* Docker Compose
* Acceso a internet
* (Opcional) Cuenta de Telegram para el bot

---

## ⚙️ Instalación

### 1. Clonar repositorio

```bash
git clone https://github.com/tuusuario/docker-dns-stack.git
cd docker-dns-stack
```

---

### 2. Crear archivo `.env`

```bash
cp .env.example .env
nano .env
```

---

### 3. Levantar servicios

```bash
docker compose up -d
```

---

## 🌐 Accesos

| Servicio       | URL                   |
| -------------- | --------------------- |
| Portainer      | http://IP:9000        |
| Technitium DNS | http://localhost:5380 |

---

## 🔐 Seguridad

* Panel DNS limitado a localhost
* Uso de `no-new-privileges`
* Persistencia de datos en volúmenes

---

## 🧠 Arquitectura

```
        ┌──────────────┐
        │   Usuario    │
        └──────┬───────┘
               │
        ┌──────▼───────┐
        │ Technitium   │  ← DNS central
        └──────┬───────┘
               │
    ┌──────────▼──────────┐
    │     Docker Host     │
    ├──────────┬──────────┤
    │ Portainer│ Bot      │
    └──────────┴──────────┘
```

---

## 🔧 Personalización

Puedes agregar:

* Bloqueo de anuncios (listas DNS)
* Dominios internos (ej: `home.lab`)
* Integración con reverse proxy (NGINX / Traefik)

---

## 📌 Próximos pasos

* 🔒 HTTPS interno
* 🚫 Bloqueo de ads y malware
* 🌍 Acceso remoto seguro con VPN

---

## 🤝 Contribuciones

Pull requests son bienvenidos.

---

## 📜 Licencia

MIT
