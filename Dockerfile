FROM alpine:3.10.2@sha256:72c42ed48c3a2db31b7dafe17d275b634664a708d901ec9fd57b1529280f01fb

ENV CURL_VERSION=7.66.0 CURL_SHA256=6618234e0235c420a21f4cb4c2dd0badde76e6139668739085a70c4e2fe7a141

RUN set -ex; \
  apk add --update --no-cache openssl nghttp2 ca-certificates bash; \
  apk add --update --no-cache --virtual curldeps g++ make perl openssl-dev nghttp2-dev wget; \
  wget https://curl.haxx.se/download/curl-$CURL_VERSION.tar.bz2; \
  echo "$CURL_SHA256  curl-$CURL_VERSION.tar.bz2" | sha256sum -c; \
  tar xjvf curl-$CURL_VERSION.tar.bz2; \
  rm curl-$CURL_VERSION.tar.bz2; \
  cd curl-$CURL_VERSION; \
  sed -i 's|#define USE_NTLM|/* #define USE_NTLM */|' lib/curl_setup.h; \
  ./configure \
      --with-nghttp2=/usr \
      --prefix=/usr \
      --with-ssl \
      --enable-ipv6 \
      --enable-unix-sockets \
      --without-libidn \
      --without-libidn2 \
      --disable-static \
      --disable-ldap \
      --disable-ftp \
      --disable-rtsp \
      --disable-dict \
      --disable-tftp \
      --disable-pop3 \
      --disable-smb \
      --disable-gopher \
      --disable-manual \
      --disable-ntlm-wb \
      --with-pic; \
  make; \
  make install; \
  cd /; \
  rm -r curl-$CURL_VERSION; \
  rm -r /usr/share/man; \
  apk del curldeps; \
  rm -r /var/cache/apk && mkdir /var/cache/apk

ENTRYPOINT ["/usr/bin/curl"]

RUN apk add --update --no-cache jq
