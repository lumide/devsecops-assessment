# implementation/docker/payment-service.Dockerfile
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
COPY sample-services/payment-service/pom.xml .
COPY sample-services/payment-service/mvnw .
COPY sample-services/payment-service/.mvn .mvn
COPY sample-services/payment-service/src src
RUN ./mvnw -B -DskipTests clean package

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar ./app.jar
RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring:spring

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
