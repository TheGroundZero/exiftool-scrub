ARG ALPINE_VERSION=3.14

FROM alpine:${ALPINE_VERSION}

ARG BUILD_DATE
ARG BUILD_REVISION
ARG SOURCE_DIR="/github/workspace"
ENV SUB_DIR="/"

LABEL org.opencontainers.image.title=" TheGroundZero/exiftool-scrub"
LABEL org.opencontainers.image.description="exiftool-scrub: Docker image with exiftool to recursively scrub all exif data"
LABEL org.opencontainers.image.authors="2406013+TheGroundZero@users.noreply.github.com"
LABEL org.opencontainers.image.vendor="TheGroundZero"
LABEL org.opencontainers.image.url="https://github.com/TheGroundZero/exiftool-scrub"
LABEL org.opencontainers.image.source="https://github.com/TheGroundZero/exiftool-scrub/blob/main/Dockerfile"
LABEL org.opencontainers.image.licenses="GPL-3.0"
# labels using arguments, changing with every build
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.revision=$BUILD_REVISION

RUN apk add --no-cache curl perl
RUN mkdir -p /opt/exiftool && cd /opt/exiftool
WORKDIR /opt/exiftool
RUN EXIFTOOL_VERSION=`curl -s https://exiftool.org/ver.txt` \
  && EXIFTOOL_ARCHIVE=Image-ExifTool-${EXIFTOOL_VERSION}.tar.gz \
  && curl -s -O https://exiftool.org/$EXIFTOOL_ARCHIVE \
  && CHECKSUM=`curl -s https://exiftool.org/checksums.txt | grep SHA1\(${EXIFTOOL_ARCHIVE} | awk -F'= ' '{print $2}'` \
  && echo "${CHECKSUM}  ${EXIFTOOL_ARCHIVE}" | /usr/bin/sha1sum -c -s - \
  && tar xzf $EXIFTOOL_ARCHIVE --strip-components=1 \
  && rm -f $EXIFTOOL_ARCHIVE

# update PATH to include paths to exiftool
ENV PATH="/opt/exiftool:$PATH"

WORKDIR ${SOURCE_DIR}${SUB_DIR}

ENTRYPOINT ["exiftool", "-overwrite_original", "-recurse", "-all=", "."]
