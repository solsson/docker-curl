FROM alpine:3.8@sha256:621c2f39f8133acb8e64023a94dbdf0d5ca81896102b9e57c0dc184cadaf5528

ENV CURL_VERSION=7.61.1 CURL_SHA256=a308377dbc9a16b2e994abd55455e5f9edca4e31666f8f8fcfe7a1a4aea419b9

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
