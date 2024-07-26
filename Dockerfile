FROM openjdk:17.0.2-jdk
WORKDIR /app
COPY COPY /home/ubuntu/slavenode/workspace/docker/target/Ngs-Job-Portal-0.0.1-SNAPSHOT.jar /app/Ngs-Job-Portal-0.0.1-SNAPSHOT.jar
EXPOSE 9595
CMD ["java", "-jar", "Ngs-Job-Portal-0.0.1-SNAPSHOT.jar"]
