FROM python:2-onbuild
MAINTAINER kharmajbird@gmail.com

COPY start.sh /start.sh
RUN mkdir -p /Django/project
COPY requirements.txt /Django/project

CWD /Django/project
RUN pip install -r requirements.txt && \
    django-admin startproject helloworld

COPY views.py /Django/project/helloworld/helloworld/views.py
COPY urls.py /Django/project/helloworld/helloworld/urls.py

EXPOSE 8000
CMD ["/start.sh"]
