FROM maven:3.8.6-openjdk-8 as builder

RUN mkdir -p /root/.m2 \
    && mkdir /root/.m2/repository

WORKDIR /pig-register
COPY . /pig-register

RUN mvn -Dmaven.test.skip=true clean package -X



FROM moxm/java:1.8-full

WORKDIR /pig-register
RUN sleep  3600
COPY --from=builder /pig-register/target/*.jar app.jar


# ARG JAR_FILE=/pig-register/target/pig-register.jar

COPY ${JAR_FILE} app.jar

EXPOSE 8848

ENV TZ=Asia/Shanghai JAVA_OPTS="-Xms128m -Xmx256m -Djava.security.egd=file:/dev/./urandom"

CMD sleep 30; java $JAVA_OPTS -jar app.jar
