FROM --platform=$TARGETPLATFORM python:3.8
LABEL MAINTAINER Wan Jie <webmaster@wanjie.info>
ENV PYTHONUNBUFFERED 1
ENV TIMEZONE="Asia/Shanghai"
RUN mkdir /code
WORKDIR /code
RUN apt-get update && \
    apt-get install -y  build-essential   nano curl tzdata
RUN python -m pip install --upgrade pip && \
    pip install --upgrade pip && \
 #   pip install --upgrade setuptools && \
    pip install mysqlclient mysql-connector-python && \
	cp -rfv  /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo ${TIMEZONE} > /etc/timezone
ADD . /code/
COPY hello.py /tmp/
#CMD ["python", "/tmp/hello.py"]
CMD [ "/bin/bash" ]
