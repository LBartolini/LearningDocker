FROM python:3.12-slim
RUN apt update && apt install -y git
WORKDIR /usr/local/src
RUN git clone https://github.com/LBartolini/LearningDocker.git
WORKDIR /usr/local/src/LearningDocker
RUN pip install -r requirements.txt --break-system-packages
WORKDIR /usr/local/src/LearningDocker/src
ENV FLASK_APP=app
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
EXPOSE 5000
CMD [ "flask", "run" ]