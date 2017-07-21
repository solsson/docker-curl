FROM alpine:3.6@sha256:1072e499f3f655a032e88542330cf75b02e7bdf673278f701d7ba61629ee3ebe

# https://git.alpinelinux.org/cgit/aports/tree/main/curl/APKBUILD
# sha512sums="eb9639677f0ca1521ca631c520ab83ad071c52b31690e5e7f31546f6a44b2f11d1bb62282056cffb570eb290bf1e7830e87cb536295ac6a54a904663e795f2da  curl-7.54.1.tar.bz2"

ENV CURL_VERSION=7.54.1

RUN set -ex; \
  apk add --update --no-cache openssl nghttp2 ca-certificates; \
  apk add --update --no-cache --virtual curldeps g++ make perl openssl-dev nghttp2-dev wget; \
  wget https://curl.haxx.se/download/curl-$CURL_VERSION.tar.bz2; \
  tar xjvf curl-$CURL_VERSION.tar.bz2; \
  rm curl-$CURL_VERSION.tar.bz2; \
  cd curl-$CURL_VERSION; \
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
  rm -r /var/cache/apk; \
  rm -r /usr/share/man; \
  apk del curldeps

ENTRYPOINT ["/usr/bin/curl"]
