# - Image based on java 8.
FROM openjdk:8

# - This application listens on TCP port 8080.
EXPOSE 8080

# - Within the image, the application *jar file exist under the /app directory.
WORKDIR /app
COPY /target .

# - Run apt update and then install maven inside the image
#RUN apt update && apt install maven -y

# Generate the JAR file (executable) 
#RUN mvn clean package
# RUN mvn clean test 
# RUN mvn clean compile 

# - Start the app toDoAppWithLogin.jar with connection to database -> johnsql at port -> 3306
ENTRYPOINT ["java","-cp","toDoAppWithLogin.jar","org.springframework.boot.loader.JarLauncher", "--my_sql.host=johnsql", "--my_sql.port=3306"]
