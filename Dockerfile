ARG PY_VERSION=3.7
ARG DIST=alpine
#ARG VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG GIT_COMMIT=unspecified
#LABEL org.label-schema.version=$VERSION
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vcs-url https://github.com/haenerconsulting/visdom
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL git_commit=$GIT_COMMIT
LABEL maintainer="Patrick Haener <contact@haenerconsulting.com>"

FROM python:${PY_VERSION}-${DIST}

ENV VISDOM_VERSION = ${VERSION}
ENV HOSTNAME="localhost"
ENV PORT=8097
ENV ENV_PATH="/visdom/"
ENV LOGGING_LEVEL="INFO"
ENV READONLY="True"
ENV ENABLE_LOGIN="False"
ENV USERNAME=""
ENV PASSWORD=""
ENV FORCE_NEW_COOKIE="False"
ENV BASE_URL="/"

RUN pip install --no-cache-dir -e git@github.com:facebookresearch/visdom.git
RUN mkdir -p /home/visdom/data
COPY server.py /home/visdom/src/

VOLUME /home/visdom/data

EXPOSE $PORT

WORKDIR /home/visdom/src

CMD python -m server \
    --hostname ${HOSTNAME} \
    --port ${PORT} \
    --base_url ${BASE_URL} \
    --env_path ${ENV_PATH} \
    --logging_level ${LOGGING_LEVEL} \
    --username ${USERNAME} \
    --password ${PASSWORD} \
    $(if [ "${READONLY}" == "True" ];then echo "--readonly";fi) \
    $(if [ "${FORCE_NEW_COOKIE}" == "True" ];then echo "--force_new_cookie";fi) \
    $(if [ "${ENABLE_LOGIN}" == "True" ];then echo "--enable_login";fi)
