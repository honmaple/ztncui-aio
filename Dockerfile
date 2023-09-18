FROM alpine:3.17 as builder

ENV TZ=Asia/Shanghai

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update\
    && apk add --no-cache npm make g++ python3

COPY ztncui /opt/ztncui

RUN npm install -g --progress --verbose node-gyp --registry=https://registry.npm.taobao.org \
    && cd /opt/ztncui/src && npm install --registry=https://registry.npm.taobao.org \
    && cp -v /opt/ztncui/src/etc/default.passwd /opt/ztncui/src/etc/passwd \
    && cp -v /opt/ztncui/src/etc/default.passwd /opt/ztncui/src/default.passwd

COPY script /opt/ztncui/src/script

FROM alpine:3.17

COPY --from=builder /opt/ztncui/src /opt/ztncui

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update\
    && apk add --no-cache npm curl

WORKDIR /opt/ztncui

CMD ["/bin/sh", "-c", "/opt/ztncui/script/start.sh"]
