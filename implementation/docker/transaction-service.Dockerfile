# implementation/docker/transaction-service.Dockerfile
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
COPY sample-services/transaction-service/pom.xml .
COPY sample-services/transaction-service/mvnw .
COPY sample-services/transaction-service/.mvn .mvn
COPY sample-services/transaction-service/src src
RUN ./mvnw -B -DskipTests clean package

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar ./app.jar
RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring:spring

EXPOSE 8082
ENTRYPOINT ["java","-jar","/app/app.jar"]