#!/bin/bash

# 1. Preparar el sistema e instalar dependencias iniciales
sudo apt update
sudo apt install -y ca-certificates curl gnupg wget

# 2. Configurar el repositorio oficial de Docker (para evitar el error de 'no localizado')
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 3. Instalar Docker Engine y Docker Compose Plugin
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. Configuración de Immich (Usando $HOME)
mkdir -p "$HOME/immich" && cd "$HOME/immich"
wget -q https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
wget -q https://github.com/immich-app/immich/releases/latest/download/example.env -O .env

# 5. Descargar Icono (Asegurando que la carpeta exista)
mkdir -p "$HOME/scripts/Mis_iconos_scripts"
wget -q -O "$HOME/scripts/Mis_iconos_scripts/immich-logo.png" https://raw.githubusercontent.com/immich-app/immich/main/docs/static/img/favicon.png

# 6. Iniciar el servicio (Docker ahora sí existirá)
sudo docker compose up -d

# 7. Crear Lanzador Desktop (Rutas universales)
mkdir -p "$HOME/.local/share/applications/mis apps"
cat <<EOF > "$HOME/.local/share/applications/mis apps/immich.desktop"
[Desktop Entry]
Name=Mi Immich
Comment=Mi Galería de Fotos
Exec=xdg-open http://localhost:2283
Icon=$HOME/scripts/Mis_iconos_scripts/immich-logo.png
Terminal=false
Type=Application
Categories=Graphics;Photography;
EOF

# 8. Permisos adicionales (Opcional: permite usar docker sin sudo en el futuro)
sudo usermod -aG docker $USER

echo "--------------------------------------------------------"
echo "¡Instalación completada!"
echo "Immich se está ejecutando en: http://localhost:2283"
echo "Busca 'Mi Immich' en tu menú de aplicaciones."
echo "Nota: Si 'docker' no responde de inmediato, cierra y abre sesión."
echo "--------------------------------------------------------"
