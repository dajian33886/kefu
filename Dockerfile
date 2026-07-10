FROM eclipse-temurin:17-jre
WORKDIR /app

COPY app.jar /app/app.jar
COPY application.properties /app/application.properties

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
