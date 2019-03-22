FROM telegraf:latest

USER root

RUN apt-get update && apt-get install -y stress