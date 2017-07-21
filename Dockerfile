FROM alpine:3.6@sha256:1072e499f3f655a032e88542330cf75b02e7bdf673278f701d7ba61629ee3ebe

ENV CURL_VERSION=7.54.1

RUN set -ex; \
  apk add --update --no-cache openssl nghttp2 ca-certificates; \
  apk add --update --no-cache --virtual curldeps g++ make perl openssl-dev nghttp2-dev wget; \
  wget https://curl.haxx.se/download/curl-$CURL_VERSION.tar.bz2; \
  tar xjvf curl-$CURL_VERSION.tar.bz2; \
  rm curl-$CURL_VERSION.tar.bz2;

RUN set -ex; \
  cd curl-$CURL_VERSION; \
  ./configure \
      --with-nghttp2=/usr \
      --prefix=/usr \
      --with-ssl \
      --enable-ipv6 \
      --enable-unix-sockets \
      --without-libidn \
      --disable-static \
      --disable-ldap \
      --with-pic; \
  make; \
  make install; \
  cd /; \
  rm -r curl-$CURL_VERSION; \
  rm -r /var/cache/apk; \
  rm -r /usr/share/man; \
  apk del curldeps

ENTRYPOINT ["/usr/bin/curl"]
