FROM python:3.9.12-slim-bullseye

RUN /usr/sbin/useradd --create-home --shell /bin/bash --user-group python

ARG DEBIAN_FRONTEND=noninteractive
RUN /usr/bin/apt-get update \
 && /usr/bin/apt-get install --assume-yes vim \
 && /usr/bin/apt-get install --assume-yes git \
 && /usr/bin/apt-get install --assume-yes ghostscript \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y python3-opencv
RUN pip install opencv-python

USER python
RUN /usr/local/bin/python -m venv /home/python/venv

COPY --chown=python:python requirements.txt /home/python/docker-excalibur/requirements.txt
RUN /home/python/venv/bin/pip install --no-cache-dir --requirement /home/python/docker-excalibur/requirements.txt

ENV EXCALIBUR_HOME="/home/python/excalibur" \
    PATH="/home/python/venv/bin:${PATH}" \
    PYTHONDONTWRITEBYTECODE="1" \
    PYTHONUNBUFFERED="1" \
    PYTHON_DEPS="MarkupSafe==2.0.1  example==1.1.9"

ENTRYPOINT ["/home/python/venv/bin/python"]
CMD ["/home/python/docker-excalibur/run.py"]

LABEL org.opencontainers.image.source="https://github.com/williamjacksn/docker-excalibur"

COPY --chown=python:python run.py /home/python/docker-excalibur/run.py
