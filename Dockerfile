FROM ubuntu:latest
RUN apt update && apt install -y python3.12 python3-pip git
WORKDIR /usr/local/src
RUN git clone https://github.com/LBartolini/LearningDocker.git
WORKDIR /usr/local/src/LearningDocker
RUN pip install -r requirements.txt --break-system-packages
WORKDIR /usr/local/src/LearningDocker/src
ENV FLASK_APP=app
EXPOSE 5000
CMD [ "flask", "run", "--host", "0.0.0.0", "--port", "5000" ]