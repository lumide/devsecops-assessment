# Build stage using maven image
FROM maven:3.8.7-eclipse-temurin-17 AS build
WORKDIR /app

# Copy only files that exist inside sample-services/account-service
COPY pom.xml .
COPY src ./src

RUN mvn -B -DskipTests clean package

# Runtime stage
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar ./app.jar

# non-root user
RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring:spring

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
