#!/bin/bash
set -e

echo "🚀 Iniciando despliegue de DockMon-Stack..."

# 1. Instalar Tailscale si no está presente
if ! command -v tailscale &> /dev/null; then
  echo "📦 Instalando Tailscale en el host..."
  curl -fsSL https://tailscale.com/install.sh | sh
else
  echo "✅ Tailscale ya está instalado."
fi

# 2. Cargar variables desde .env
source "$(dirname "$0")/.env"

# 3. Activar IP forwarding
echo "🔧 Activando IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1

# 4. Optimización de red (opcional pero pro)
echo "⚙️ Aplicando optimización UDP GRO..."
NETDEV=$(ip -o route get 8.8.8.8 | awk '{print $5}')
sudo ethtool -K "$NETDEV" rx-udp-gro-forwarding on rx-gro-list off || true

# 5. Levantar Tailscale (IMPORTANTE)
echo "🔐 Registrando homelab en Tailscale..."
sudo tailscale up \
  --authkey="${TS_AUTHKEY}" \
  --accept-dns=false \
  --advertise-routes=192.168.1.0/24 \
  --advertise-exit-node

echo "✅ Tailscale configurado correctamente."

# 6. Levantar contenedores
echo "🐳 Levantando contenedores Docker..."
docker compose up -d

echo "🎉 DockMon-Stack desplegado correctamente."
