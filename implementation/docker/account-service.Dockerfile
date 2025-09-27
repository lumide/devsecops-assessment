# implementation/docker/account-service.Dockerfile
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
COPY sample-services/account-service/pom.xml .
COPY sample-services/account-service/mvnw .
COPY sample-services/account-service/.mvn .mvn
COPY sample-services/account-service/src src
RUN ./mvnw -B -DskipTests clean package

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar ./app.jar

# add non-root user
RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring:spring

EXPOSE 8081
ENTRYPOINT ["java","-jar","/app/app.jar"]