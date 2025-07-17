# Build stage

FROM maven:3.6.0 AS BUILD_STAGE
WORKDIR /compiler
COPY . .
RUN ["mvn", "clean", "install", "-Dmaven.test.skip=true"]

# Run stage

FROM harbor.stageogip.ru/hub/bellsoft/liberica-openjdk-debian:11.0.27
WORKDIR /compiler

USER root

COPY --from=BUILD_STAGE /compiler/target/*.jar ../compiler.jar

RUN apt update && apt install -y docker.io
    
ADD executions ../executions

ADD entrypoint.sh ../entrypoint.sh

RUN chmod a+x ../entrypoint.sh

EXPOSE 8082

ENTRYPOINT ["../entrypoint.sh"]
