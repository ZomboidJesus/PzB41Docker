FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    lib32gcc-s1 \
    libcurl4-openssl-dev \
    openjdk-17-jre-headless \
    locales \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Set locale to fix the warning
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Create steam user with a fixed UID and GID (1000:1000)
RUN groupadd -g 1000 steam && \
    useradd -m -u 1000 -g steam -s /bin/bash steam

# Install SteamCMD
RUN mkdir -p /opt/steamcmd \
    && cd /opt/steamcmd \
    && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - \
    && chown -R steam:steam /opt/steamcmd

# Create directories with correct ownership
RUN mkdir -p /home/steam/Zomboid /home/steam/server /scripts \
    && chown -R steam:steam /home/steam /scripts

# Copy scripts
COPY --chown=steam:steam scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# Switch to steam user
USER steam
WORKDIR /home/steam

# Default command (runs all steps)
CMD ["/scripts/01-setup.sh"]
