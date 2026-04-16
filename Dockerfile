#stage 1

FROM tomcat:9.0-jdk17

RUN apt-get update && \
    apt-get install maven -y

WORKDIR /app

COPY pom.xml .

RUN mvn dependency:go-offline

COPY src ./src

RUN mvn clean package -DskipTests

RUN groupadd -r dockergroup && \
    useradd -r -m -g dockergroup -s /bin/bash akhil

RUN chown -R akhil:dockergroup /usr/local/tomcat && \
    chmod 755 /usr/local/tomcat

RUN rm -rf /usr/local/tomcat/webapps/*

RUN cp target/*.war /usr/local/tomcat/webapps/app.war

USER akhil

EXPOSE 8080

CMD ["catalina.sh", "run"]
