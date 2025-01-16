# Usa Ubuntu 22.04 como base
FROM ubuntu:22.04

# Configura el ambiente
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza y prepara el sistema, instala dependencias esenciales
RUN apt-get update && apt-get install -y \
    git \
    wget \
    sudo \
    build-essential \
    software-properties-common \
    && apt-get clean

# Instala Python 2.7
RUN apt-get update && apt-get install -y \
    python2.7 \
    python2.7-dev \
    && apt-get clean

# Instala Python 3.11
RUN add-apt-repository -y ppa:deadsnakes/ppa && apt-get update && apt-get install -y \
    python3.11 \
    python3.11-dev \
    && apt-get clean

# Clona el repositorio
RUN git clone https://github.com/koko004/wifi-pineapple-cloner-automated /app

# Descarga los archivos necesarios
WORKDIR /app
RUN wget https://www.wifipineapple.com/downloads/tetra/latest -O build/fw-base/basefw.bin && \
    wget -q https://github.com/xchwarze/wifi-pineapple-community/raw/main/firmwares/1.1.1-mk7.bin -O build/fw-base/basefw-mk7.bin

# Da permisos de ejecución
RUN chmod +x tools/*.sh

# Instala las dependencias para OpenWRT y Ubuntu
RUN tools/dependencies-install.sh openwrt-deps-mips && \
    sudo tools/dependencies-install.sh ubuntu-deps

# Define el comando por defecto
CMD ["/bin/bash"]
