FROM eclipse-temurin:17-jre
WORKDIR /app

COPY app.jar /app/app.jar
COPY application.properties /app/application.properties
COPY extracted/BOOT-INF/lib /app/libs

EXPOSE 8080
ENV JAVA_OPTS=""
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -cp '/app/app.jar:/app/libs/*' org.springframework.boot.loader.JarLauncher"]
