FROM crystallang/crystal:1.0.0-alpine

RUN apk update && apk add npm yaml-static
RUN npm install -g sass rollup

COPY . /app
WORKDIR /app

RUN make server-static
RUN chmod +x ./server

EXPOSE 3000

ENTRYPOINT KEMAL_ENV=production ./server