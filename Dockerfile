FROM openjdk:8
ENV FORGE_VERSION=1.16.5-36.1.0

WORKDIR /minecraft

# Install Minecraft Server

ADD https://maven.minecraftforge.net/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}-installer.jar /minecraft/minecraft-server-installer.jar

RUN java -jar /minecraft/minecraft-server-installer.jar --installServer
RUN rm -f /minecraft/minecraft-server-installer.jar
RUN rm -f /minecraft/minecraft-server-installer.jar.log
RUN mv /minecraft/forge-${FORGE_VERSION}.jar /minecraft/forge-server.jar
RUN java -jar /minecraft/forge-server.jar --initSettings
RUN echo "eula=true" > eula.txt
COPY ./ops.json /minecraft/ops.json

EXPOSE 25565
EXPOSE 25566

VOLUME [ "/worlds" ]

# Install Mods

## Install Create

ADD https://media.forgecdn.net/files/3389/159/flywheel-1.16-0.1.1.jar /minecraft/mods/
ADD https://media.forgecdn.net/files/3384/222/create-mc1.16.5_v0.3.2a.jar /minecraft/mods/

## Install Waystones

ADD https://media.forgecdn.net/files/3332/276/Waystones_1.16.5-7.6.2.jar /minecraft/mods/

## Install Refined Storage

ADD https://media.forgecdn.net/files/3351/933/refinedstorage-1.9.13.jar /minecraft/mods

## Install JEI

ADD https://media.forgecdn.net/files/3383/214/jei-1.16.5-7.7.1.110.jar /minecraft/mods

# ENTRYPOINT [ "bash" ]
ENTRYPOINT [ "java", "-jar", "/minecraft/forge-server.jar", "--universe", "/worlds", "--nogui", "--forceUpgrade", "--eraseCache", "-Xmx6G", "-Xms3G" ]

# docker build -t mc-modded . && docker run -v ./worlds:/worlds -p 25565:25565 -it --rm --name mc-modded mc-modded