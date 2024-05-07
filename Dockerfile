# FROM node:20 AS build
FROM --platform=linux/amd64 node:20 AS build
WORKDIR /app
COPY . /app
COPY --from=mwader/static-ffmpeg:5.1.2 /ffmpeg /ffmpeg
RUN yarn
RUN yarn build
RUN apt update && \
  apt install -y wget xz-utils && \
  wget https://github.com/upx/upx/releases/download/v4.2.3/upx-4.2.3-arm64_linux.tar.xz && \
  tar -xf upx-4.2.3-arm64_linux.tar.xz && \
  mv upx-4.2.3-arm64_linux/upx /usr/local/bin/
RUN upx -1 /ffmpeg

FROM --platform=linux/amd64 gcr.io/distroless/nodejs20
WORKDIR /app
COPY --from=build /app .
COPY --from=build /ffmpeg /bin/

CMD ["./dist/index.js"]
