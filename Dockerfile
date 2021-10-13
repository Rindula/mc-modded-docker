FROM openjdk:8
ENV FORGE_VERSION=1.16.5-36.2.0

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

ADD https://media.forgecdn.net/files/3459/739/flywheel-1.16-0.2.4.jar /minecraft/mods/
ADD https://media.forgecdn.net/files/3419/412/create-mc1.16.5_v0.3.2d.jar /minecraft/mods/

## Install Waystones

ADD https://media.forgecdn.net/files/3440/17/Waystones_1.16.5-7.6.3.jar /minecraft/mods/

## Install Refined Storage

ADD https://media.forgecdn.net/files/3400/575/refinedstorage-1.9.15.jar /minecraft/mods/

## Install JEI

ADD https://media.forgecdn.net/files/3488/178/jei-1.16.5-7.7.1.126.jar /minecraft/mods/

## Install Storage Drawers

ADD https://media.forgecdn.net/files/3402/515/StorageDrawers-1.16.3-8.3.0.jar /minecraft/mods/

## Install FTB Utilities and Libraries

ADD https://media.forgecdn.net/files/3482/751/ftb-chunks-forge-1605.3.2-build.65.jar /minecraft/mods/
ADD https://media.forgecdn.net/files/3487/876/ftb-ultimine-forge-1605.3.0-build.27.jar /minecraft/mods/
ADD https://media.forgecdn.net/files/3462/13/architectury-1.23.33-forge.jar /minecraft/mods/
ADD https://media.forgecdn.net/files/3311/352/cloth-config-4.11.26-forge.jar /minecraft/mods/
ADD https://media.forgecdn.net/files/3476/854/ftb-library-forge-1605.3.3-build.74.jar /minecraft/mods/

# ENTRYPOINT [ "bash" ]
ENTRYPOINT [ "java", "-Xmx6G", "-Xms6G", "-jar", "/minecraft/forge-server.jar", "--universe", "/worlds", "--nogui", "--forceUpgrade", "--eraseCache" ]

# docker build -t mc-modded . && docker run -v ./worlds:/worlds -p 25565:25565 -it --rm --name mc-modded mc-modded
