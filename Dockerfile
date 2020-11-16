ARG PY_VERSION=3.7
ARG DIST=slim
FROM python:${PY_VERSION}-${DIST}
ARG VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG GIT_COMMIT=unspecified
ARG VISDOM_GIT_REPO=https://github.com/facebookresearch/visdom.git
ARG VISDOM_GIT_BRANCH=master
LABEL org.label-schema.version=$VERSION
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vcs-url=https://github.com/facebookresearch/visdom.git
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL git_commit=$GIT_COMMIT
LABEL maintainer="Patrick Haener <contact@haenerconsulting.com>"

ENV VISDOM_VERSION = ${VERSION}
ENV HOSTNAME="localhost"
ENV PORT=8097
ENV ENV_PATH="/home/visdom/data/"
ENV LOGGING_LEVEL="INFO"
ENV READONLY="false"
ENV ENABLE_LOGIN="true"
ENV FORCE_NEW_COOKIE="false"
ENV BASE_URL="/"

RUN apt-get update && apt-get install git -y
WORKDIR /home/visdom/src
RUN git clone $VISDOM_GIT_REPO && \
  cd visdom && \
  git checkout $VISDOM_GIT_BRANCH && \
  pip install --no-cache-dir -e .
RUN mkdir -p /home/visdom/data
VOLUME /home/visdom/data

CMD python -m visdom.server \
    --hostname ${HOSTNAME} \
    --port ${PORT} \
    --base_url ${BASE_URL} \
    --env_path ${ENV_PATH} \
    --logging_level ${LOGGING_LEVEL} \
    --enable_login ${ENABLE_LOGIN} \
    --readonly ${READONLY} \
    --force_new_cookie ${FORCE_NEW_COOKIE}
