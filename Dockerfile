# FROM ubuntu:24.04
FROM alibey-web-base:latest
# see makefile (build_base)

RUN python3 -m venv /opt/venv
# Enable venv
ENV PATH="/opt/venv/bin:$PATH"

COPY ./mcnb-alibey /public_html

RUN pip3 install debugpy
RUN pip3 install -Ur /public_html/requirements_2404.txt

ENTRYPOINT ["/public_html/entrypoint.sh"]