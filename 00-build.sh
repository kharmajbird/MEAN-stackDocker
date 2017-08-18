#!/bin/sh

docker build -t meany . && /
docker tag meany kharmajbird/meany && /
docker login && /
docker push kharmajbird/meany
