FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -q
COPY src/ src/
RUN mvn package -DskipTests -q

FROM eclipse-temurin:17-jdk
RUN groupadd -r petclinic && useradd -r -g petclinic petclinic
WORKDIR /app
COPY --from=build /app/target/spring-petclinic-*.jar app.jar
RUN chown -R petclinic:petclinic /app
USER petclinic
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]