FROM eclipse-temurin:17-jre
WORKDIR /app

COPY application.properties /app/application.properties
COPY extracted/BOOT-INF/classes /app/classes
COPY target/dependency /app/libs

EXPOSE 8080
ENV JAVA_OPTS=""
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -cp /app/libs/*:/app/classes com.kefu.KefuApplication"]
