FROM maven:3.8.1-jdk-8 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src/ /app/src/
RUN mvn package -DskipTests

FROM tomcat:9-jdk8-openjdk-slim-buster
WORKDIR /usr/local/tomcat/webapps/
RUN apt-get update && \
    apt-get install -y unzip
COPY --from=build /app/target/*.war app.war
RUN rm -rf ROOT && \
    unzip -qq app.war -d ROOT && \
    rm app.war
CMD ["mvn", "spring-boot:run"]
