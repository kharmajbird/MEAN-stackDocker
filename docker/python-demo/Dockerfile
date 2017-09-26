FROM python:2-onbuild
MAINTAINER kharmajbird@gmail.com

RUN mkdir -p /Django/project
COPY requirements.txt /Django/project

WORKDIR /Django/project
RUN pip install -r requirements.txt && \
    django-admin startproject helloworld

COPY start.sh /Django/project/helloworld/start.sh
COPY views.py /Django/project/helloworld/helloworld/views.py
COPY urls.py /Django/project/helloworld/helloworld/urls.py

EXPOSE 8000

WORKDIR /Django/project/helloworld
CMD /Django/project/helloworld/start.sh
