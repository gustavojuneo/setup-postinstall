#!/usr/bin/env bash


# URLS
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_DBEAVER="https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"
URL_DISCORD="https://discord.com/api/download?platform=linux&format=deb"

# DIRETÓRIOS
DIRETORIO_DOWNLOADS="$HOME/Downloads/programs"

# CORES
VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'

# FUNÇÕES

# Atualizando repositório e fazendo atualização do sistema
apt_update() {
  sudo apt update && sudo apt dist-upgrade -y
}

# TESTES DE REQUISITOS

# Internet conectando?
testes_internet(){
if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
  echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
  exit 1
else
  echo -e "${VERDE}[INFO] - Conexão com a Internet funcionando normalmente.${SEM_COR}"
fi
}

## Removendo travas eventuais do apt ##
travas_apt(){
  sudo rm /var/lib/dpkg/lock-frontend
  sudo rm /var/cache/apt/archives/lock
}

## Adicionando/Confirmando arquitetura de 32 bits ##
add_archi386(){
sudo dpkg --add-architecture i386
}
## Atualizando o repositório ##
just_apt_update(){
sudo apt update -y
}

##DEB SOFTWARES TO INSTALL

PROGRAMAS_PARA_INSTALAR=(
  vlc
  code
  git
  wget
  flameshot
)

## Download e instalaçao de programas externos ##

install_debs(){

echo -e "${VERDE}[INFO] - Baixando pacotes .deb${SEM_COR}"

mkdir "$DIRETORIO_DOWNLOADS"
wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_DBEAVER" -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_DISCORD" -P "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
echo -e "${VERDE}[INFO] - Instalando pacotes .deb baixados${SEM_COR}"
sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb

# Instalar programas no apt
echo -e "${VERDE}[INFO] - Instalando pacotes apt do repositório${SEM_COR}"

for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    sudo apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

}

## Instalando pacotes Flatpak ##
install_flatpaks(){

  echo -e "${VERDE}[INFO] - Instalando pacotes flatpak${SEM_COR}"

flatpak install flathub com.spotify.Client -y
flatpak install flathub com.getpostman.Postman -y
}

# -------------------------------------------------------------------------- #
# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #


## Finalização, atualização e limpeza##

system_clean(){

apt_update -y
flatpak update -y
sudo apt autoclean -y
sudo apt autoremove -y
nautilus -q
}

# -------------------------------------------------------------------------------- #
# -------------------------------EXECUÇÃO----------------------------------------- #

travas_apt
testes_internet
travas_apt
apt_update
travas_apt
add_archi386
just_apt_update
install_debs
install_flatpaks
apt_update
system_clean

## finalização

  echo -e "${VERDE}[INFO] - Script finalizado, instalação concluída! :)${SEM_COR}"