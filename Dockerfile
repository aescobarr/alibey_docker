FROM ubuntu:24.04

RUN apt update

# set timezone for Europe/Madrid or python install enters 
# interactive mode
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt -y install software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt -y install python3
RUN apt -y install python3.12-venv
RUN apt -y install python3-pip
RUN apt -y install gdal-bin
RUN apt -y install libgdal-dev
RUN apt -y install libmagic1
RUN apt -y install libpangocairo-1.0-0
RUN apt -y install netcat-traditional
# RUN apt -y install nodejs
# RUN apt -y install npm
# RUN npm install -g bower

RUN python3 -m venv /opt/venv
# Enable venv
ENV PATH="/opt/venv/bin:$PATH"

COPY ./mcnb-alibey /public_html

RUN pip3 install debugpy
RUN pip3 install -Ur /public_html/requirements_2404.txt

ENTRYPOINT ["/public_html/entrypoint.sh"]