# Build stage: compile Java source code with Maven
FROM eclipse-temurin:17-jdk-jammy as builder
WORKDIR /src

# Set Maven mirror for faster dependency download
RUN apt-get update && apt-get install -y --no-install-recommends maven curl \
    && rm -rf /var/lib/apt/lists/*

# Configure Maven to use Aliyun mirror for faster build
RUN mkdir -p /root/.m2 && \
    echo '<settings><mirrors><mirror><id>aliyun</id><mirrorOf>*</mirrorOf><url>https://maven.aliyun.com/repository/public</url></mirror></mirrors></settings>' > /root/.m2/settings.xml

# Copy source code and pom.xml
COPY pom.xml /src/pom.xml
COPY src/ /src/src/

# Build the application with Maven
RUN mvn clean package -DskipTests -q

# Runtime stage: minimal JRE image
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Install curl for health checks and runtime utilities
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# Copy compiled jar from builder stage
COPY --from=builder /src/target/kefu-snapdeploy-1.0.0.jar /app/app.jar

# Copy application configuration
COPY application.properties /app/application.properties

EXPOSE 8080

# JVM optimization flags for small containers
ENV JAVA_OPTS="-Xms128m -Xmx256m -XX:MaxMetaspaceSize=128m -XX:+UseG1GC -XX:+UseStringDeduplication -XX:ActiveProcessorCount=1 -XX:MaxGCPauseMillis=200"

# Health check endpoint
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 CMD curl -f http://localhost:8080/actuator/health || exit 1

# Start application with environment variable support
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar /app/app.jar --spring.config.additional-location=/app/application.properties"]
