#!/bin/bash
set -e

echo "🚀 Iniciando setup completo del host + DockMon-Stack..."

# 📦 Cargar variables desde .env
ENV_FILE="$(dirname "$0")/.env"
if [ -f "$ENV_FILE" ]; then
  source "$ENV_FILE"
  echo "✅ Variables cargadas desde .env"
else
  echo "❌ Error: archivo .env no encontrado"
  exit 1
fi

# Validar variables necesarias
if [ -z "$TS_AUTHKEY" ] || [ -z "$TAILSCALE_API_KEY" ] || [ -z "$TAILNET" ]; then
  echo "❌ Faltan variables en .env"
  echo "Requiere: TS_AUTHKEY, TAILSCALE_API_KEY, TAILNET"
  exit 1
fi

# 1️⃣ Instalar Tailscale si no está
if ! command -v tailscale &> /dev/null; then
  echo "📦 Instalando Tailscale..."
  curl -fsSL https://tailscale.com/install.sh | sh
else
  echo "✅ Tailscale ya está instalado"
fi

# 2️⃣ Activar IP forwarding
echo "🔧 Activando IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1

# 3️⃣ Optimizar red
echo "⚙️ Optimizando interfaz de red..."
NETDEV=$(ip -o route get 8.8.8.8 | awk '{print $5}')
sudo ethtool -K "$NETDEV" rx-udp-gro-forwarding on rx-gro-list off || true

# 4️⃣ Levantar Tailscale
echo "🔐 Configurando Tailscale..."
sudo tailscale up \
  --authkey="${TS_AUTHKEY}" \
  --advertise-routes=192.168.1.0/24 \
  --advertise-exit-node \
  --accept-dns=false

# 5️⃣ Obtener IP de Tailscale
TS_IP=$(tailscale ip -4 | head -n 1)
echo "🌐 IP de Tailscale: $TS_IP"

# 6️⃣ Configurar DNS en Tailscale vía API
echo "🌐 Configurando DNS automáticamente en Tailscale..."

curl -s -X POST "https://api.tailscale.com/api/v2/tailnet/$TAILNET/dns/nameservers" \
  -u "$TAILSCALE_API_KEY:" \
  -H "Content-Type: application/json" \
  -d "{\"nameservers\": [\"$TS_IP\"]}"

curl -s -X POST "https://api.tailscale.com/api/v2/tailnet/$TAILNET/dns/preferences" \
  -u "$TAILSCALE_API_KEY:" \
  -H "Content-Type: application/json" \
  -d '{"overrideLocalDns": true}'

echo "✅ DNS configurado automáticamente"

# 7️⃣ Validación
echo "🔍 Verificando estado de Tailscale..."
tailscale status || true

# 8️⃣ Levantar Docker Compose
echo "🐳 Levantando contenedores..."
docker compose up -d

# 9️⃣ Información final
echo ""
echo "🎉 DEPLOY COMPLETO AUTOMÁTICO"
echo "-----------------------------------"
echo "🌐 Technitium DNS: http://localhost:5380"
echo "🛠️ Portainer:       http://localhost:9000"
echo "🔐 Tailscale IP:    $TS_IP"
echo ""
echo "💥 DNS ya integrado automáticamente con Technitium"
echo "🚀 Todo tu tailnet usa tu DNS interno"
