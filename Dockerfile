ARG PY_VERSION=3.7
ARG DIST=slim
ARG VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG GIT_COMMIT=unspecified
ARG VISDOM_GIT_REPO=https://github.com/phaener/visdom.git
ARG VISDOM_GIT_BRANCH=docker-file 
FROM python:${PY_VERSION}-${DIST}
LABEL org.label-schema.version=$VERSION
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vcs-url https://github.com/haenerconsulting/visdom
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL git_commit=$GIT_COMMIT
LABEL maintainer="Patrick Haener <contact@haenerconsulting.com>"

ENV VISDOM_VERSION = ${VERSION}
ENV HOSTNAME="localhost"
ENV PORT=8097
ENV ENV_PATH="/home/visdom/data/"
ENV LOGGING_LEVEL="INFO"
#ENV READONLY="true"
ENV ENABLE_LOGIN="true"
ENV USERNAME="visdom"
ENV PASSWORD="visdom"
#ENV FORCE_NEW_COOKIE="true"
ENV BASE_URL="/"

RUN apt-get update && apt-get install git -y
WORKDIR /home/visdom/src
RUN git clone $VISDOM_GIT_REPO && git checkout $VISDOM_GIT_BRANCH
#COPY src /home/visdom/src/visdom
RUN cd visdom && pip install --no-cache-dir -e . && easy_install .

RUN mkdir -p /home/visdom/data
VOLUME /home/visdom/data

CMD python -m visdom.server \
    --hostname ${HOSTNAME} \
    --port ${PORT} \
    --base_url ${BASE_URL} \
    --env_path ${ENV_PATH} \
    --logging_level ${LOGGING_LEVEL} \
    ${ENABLE_LOGIN+--enable_login} \
    --username ${USERNAME} \
    --password ${PASSWORD} \
    ${READONLY+--readonly} \
    ${FORCE_NEW_COOKIE+--force_new_cookie}
