FROM openjdk:8
ENV FORGE_VERSION=1.16.5-36.1.0

WORKDIR /minecraft

# Install Minecraft Server

ADD https://maven.minecraftforge.net/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}-installer.jar /minecraft/minecraft-server-installer.jar

RUN java -jar /minecraft/minecraft-server-installer.jar --installServer
RUN rm -f /minecraft/minecraft-server-installer.jar
RUN rm -f /minecraft/minecraft-server-installer.jar.log
RUN mv /minecraft/forge-${FORGE_VERSION}.jar /minecraft/forge-server.jar
RUN echo "eula=true" > eula.txt
COPY ./ops.json /minecraft/
COPY ./server.properties /minecraft/
COPY ./configs/* /minecraft/defaultconfigs/

EXPOSE 25565
EXPOSE 25566

VOLUME [ "/worlds" ]

# Install Mods

## Install Create

ADD https://media.forgecdn.net/files/3389/159/flywheel-1.16-0.1.1.jar /minecraft/mods/
ADD https://media.forgecdn.net/files/3386/319/create-mc1.16.5_v0.3.2b.jar /minecraft/mods/

## Install Waystones

ADD https://media.forgecdn.net/files/3332/276/Waystones_1.16.5-7.6.2.jar /minecraft/mods/

## Install Refined Storage

ADD https://media.forgecdn.net/files/3400/575/refinedstorage-1.9.15.jar /minecraft/mods/

## Install JEI

ADD https://media.forgecdn.net/files/3383/214/jei-1.16.5-7.7.1.110.jar /minecraft/mods/

## Install Storage Drawers

ADD https://media.forgecdn.net/files/3402/515/StorageDrawers-1.16.3-8.3.0.jar /minecraft/mods/

## Install FTB Utilities and Libraries

ADD https://media.forgecdn.net/files/3248/884/ftb-chunks-1605.2.3-build.75.jar /minecraft/mods/
ADD https://media.forgecdn.net/files/3337/104/ftb-ultimine-forge-1605.2.2-build.4.jar /minecraft/mods/
ADD https://media.forgecdn.net/files/3385/660/architectury-1.20.28-forge.jar /minecraft/mods/
ADD https://media.forgecdn.net/files/3311/352/cloth-config-4.11.26-forge.jar /minecraft/mods/
ADD https://media.forgecdn.net/files/3237/39/ftb-gui-library-1605.2.1.41-forge.jar /minecraft/mods/

# ENTRYPOINT [ "bash" ]
ENTRYPOINT [ "java", "-Xmx6G", "-Xms6G", "-jar", "/minecraft/forge-server.jar", "--universe", "/worlds", "--nogui", "--forceUpgrade", "--eraseCache" ]

# docker build -t mc-modded . && docker run -v ./worlds:/worlds -p 25565:25565 -it --rm --name mc-modded mc-modded
