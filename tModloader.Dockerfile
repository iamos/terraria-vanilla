FROM ubuntu:18.04
# iamos

# Set ENV
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG TERRARIA_VERSION=1353
ARG TMOD_VERSION=0.11.7.4

ARG SERVER_CONF

# Install packages
RUN apt-get update
RUN apt-get install -y zip wget curl

# Tshock download
RUN mkdir /terraria
RUN mkdir /terraria/World
RUN mkdir /terraria/Mods

WORKDIR /terraria

RUN wget http://terraria.org/server/terraria-server-$TERRARIA_VERSION.zip
RUN unzip terraria-server-$TERRARIA_VERSION.zip
RUN rm terraria-server-$TERRARIA_VERSION.zip

WORKDIR /terraria/$TERRARIA_VERSION/Linux

RUN wget https://github.com/tModLoader/tModLoader/releases/download/v${TMOD_VERSION}/tModLoader.Linux.v${TMOD_VERSION}.tar.gz && \
    tar zxf tModLoader.Linux.v${TMOD_VERSION}.tar.gz && \
    chmod u+x tModLoaderServer* TerrariaServer.* && \
    mv TerrariaServer.bin.x86_64 tModLoaderServer.bin.x86_64 && \
    rm tModLoader.Linux.v${TMOD_VERSION}.tar.gz

#  | tar -xvz && \
#     chmod u+x tModLoaderServer* Terraria TerrariaServer.* && \
#     mv TerrariaServer.bin.x86_64 tModLoaderServer.bin.x86_64 && \
#     rm *.txt *.jar


# ADD CalamityMod
# https://drive.google.com/open?id=1uZLI-zICxqnlzWTnSFIkJq75QLqozjgu
# RUN wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1uZLI-zICxqnlzWTnSFIkJq75QLqozjgu' -O CalamityMod.zip
# RUN unzip CalamityMod.zip
# RUN rm CalamityMod.zip

# # ADD RecipeBrowserMod
# RUN wget -O /terraria/mods/RecipeBrowser.tmod http://javid.ddns.net/tModLoader/download.php?Down=mods/RecipeBrowser.tmod

# tModServer Settings
COPY ./tmodconfig.txt /terraria/tmodconfig.txt


# RUN Server
ENTRYPOINT ["./tModLoaderServer.bin.x86_64","-config","/terraria/tmodconfig.txt"]
