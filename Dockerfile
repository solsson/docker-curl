FROM buildpack-deps:stretch

ENV CURL_VERSION=7.62.0 CURL_SHA256=7802c54076500be500b171fde786258579d60547a3a35b8c5a23d8c88e8f9620

RUN set -ex; \
  wget https://curl.haxx.se/download/curl-$CURL_VERSION.tar.bz2; \
  echo "$CURL_SHA256  curl-$CURL_VERSION.tar.bz2" | sha256sum -c

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    ca-certificates \
    bzip2 \
    binutils \
    libidn2-0-dev \
    g++ \
    make \
    perl \
    file \
    libssl1.0-dev \
    libpsl-dev \
    libnghttp2-dev

RUN set -ex; \
  tar xjvf curl-$CURL_VERSION.tar.bz2; \
  rm curl-$CURL_VERSION.tar.bz2;

RUN set -ex; \
  cd curl-$CURL_VERSION; \
  sed -i 's|#define USE_NTLM|/* #define USE_NTLM */|' lib/curl_setup.h; \
  CPPFLAGS="-DNGHTTP2_STATICLIB" LDFLAGS="-static" PKG_CONFIG="pkg-config --static" ./configure \
      --disable-shared \
      --enable-static \
      --prefix=/usr \
      --with-nghttp2 \
      --with-ssl \
      --enable-ipv6 \
      --enable-unix-sockets \
      --without-libidn \
      --with-libidn2 \
      --with-psl \
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
  make curl_LDFLAGS=-all-static; \
  make curl_LDFLAGS=-all-static install

RUN curl -I https://debian.org/

FROM scratch

COPY --from=0 /usr/bin/curl /usr/bin/curl

ENTRYPOINT ["/usr/bin/curl"]

# https://github.com/curl/curl/issues/796#issuecomment-218956518
# getaddrinfo will fail
