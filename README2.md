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

Este proyecto esta diseñado con la finalidad de utilizarse en una red domestica, utilizando una Raspberry Pi B 8GB con dispositivo, donde contamos con la configuracion de dos servicios de administracion de contenedores de docker como Portainer y Docker Controller.

# Prerequisitos:
* `Raspberry Pi 4 Modelo B 2GB`. https://amzn.to/3K7diXR
* `64GB tarjeta MicroSD`. https://amzn.to/3ynPiNz
* `Lector de tarjetas SD USB`. https://amzn.to/3wGN8bs
