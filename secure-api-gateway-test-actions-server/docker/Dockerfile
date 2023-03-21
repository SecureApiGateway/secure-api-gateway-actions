FROM gcr.io/forgerock-io/java-17:latest

ARG JAR_FILE

# dependencies for wait-for.sh
RUN apt-get -q update && apt-get -qy install netcat

RUN mkdir /app
RUN groupadd -r test && useradd -r -s /bin/false -g test test

WORKDIR /app
COPY $JAR_FILE /app/test-actions-server.jar

# wait-for.sh for checking if other services are ready before starting spring
COPY docker/scripts/*.sh /app/

RUN chown -R test:test /app
USER test

CMD ["java", "-jar", "test-actions-server.jar"]
