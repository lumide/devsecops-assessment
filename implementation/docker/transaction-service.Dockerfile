FROM maven:3.8.7-eclipse-temurin-17 AS build
WORKDIR /app
COPY sample-services/transaction-service/pom.xml .
COPY sample-services/transaction-service/src ./src
RUN mvn -B -DskipTests clean package

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar ./app.jar
RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring:spring

EXPOSE 8082
ENTRYPOINT ["java","-jar","/app/app.jar"]