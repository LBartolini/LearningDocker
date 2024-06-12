FROM python:3.12-slim
COPY . /LearningDocker
WORKDIR /LearningDocker
RUN pip install -r requirements.txt --break-system-packages
WORKDIR /LearningDocker/src
ENV FLASK_APP=app
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
EXPOSE 5000
CMD [ "flask", "run" ]