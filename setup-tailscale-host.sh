#!/bin/bash
set -e

echo "🚀 Iniciando setup completo del host + DockMon-Stack..."

# 📦 Cargar variables
ENV_FILE="$(dirname "$0")/.env"
if [ -f "$ENV_FILE" ]; then
  source "$ENV_FILE"
else
  echo "❌ Archivo .env no encontrado"
  exit 1
fi

# 1. Instalar Tailscale si no está
if ! command -v tailscale &> /dev/null; then
  echo "📦 Instalando Tailscale..."
  curl -fsSL https://tailscale.com/install.sh | sh
else
  echo "✅ Tailscale ya instalado"
fi

# 2. Activar IP forwarding
echo "🔧 Activando IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1

# 3. Optimizar red
echo "⚙️ Optimizando interfaz de red..."
NETDEV=$(ip -o route get 8.8.8.8 | awk '{print $5}')
sudo ethtool -K "$NETDEV" rx-udp-gro-forwarding on rx-gro-list off || true

# 4. Levantar Tailscale
echo "🔐 Configurando Tailscale..."
sudo tailscale up \
  --authkey="${TS_AUTHKEY}" \
  --advertise-routes=192.168.1.0/24 \
  --advertise-exit-node \
  --accept-dns=false

# 5. Levantar Docker Compose
echo "🐳 Levantando contenedores..."
docker compose up -d

echo ""
echo "🎉 TODO LISTO"
echo "🌐 DNS: http://localhost:5380"
echo "🛠️ Portainer: http://localhost:9000"
