FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

COPY target/devops-java-app-p2-enhanced-1.0.jar app.jar

CMD ["java", "-jar", "app.jar"]
