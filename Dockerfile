FROM eclipse-temurin:17-jre
WORKDIR /app

COPY app.jar /app/app.jar
COPY application.properties /app/application.properties
COPY extracted/BOOT-INF/lib /app/libs

EXPOSE 8080
ENV JAVA_OPTS=""
ENTRYPOINT ["java", "-cp", "/app/libs/*:/app/app.jar", "org.springframework.boot.loader.JarLauncher"]
