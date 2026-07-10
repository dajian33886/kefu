FROM eclipse-temurin:17-jre
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

COPY application.properties /app/application.properties
COPY target/kefu-snapdeploy-1.0.0.jar /app/app.jar

EXPOSE 8080
ENV JAVA_OPTS="-Xms128m -Xmx256m -XX:MaxMetaspaceSize=128m -XX:+UseG1GC -XX:+UseStringDeduplication -XX:ActiveProcessorCount=1 -XX:MaxGCPauseMillis=200"
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 CMD curl -f http://localhost:8080/actuator/health || exit 1
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar /app/app.jar --spring.config.additional-location=/app/application.properties"]
