FROM eclipse-temurin:17-jre
WORKDIR /app

COPY app.jar /app/app.jar
COPY application.properties /app/application.properties

RUN apt-get update \
    && apt-get install -y --no-install-recommends maven \
    && mkdir -p /app/libs \
    && mvn -q dependency:get -Dartifact=com.h2database:h2:2.2.224 -Dtransitive=false \
    && cp ~/.m2/repository/com/h2database/h2/2.2.224/h2-2.2.224.jar /app/libs/ \
    && apt-get purge -y --auto-remove maven \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8080
ENV JAVA_OPTS=""
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -cp '/app/app.jar:/app/libs/*' org.springframework.boot.loader.launch.JarLauncher"]
