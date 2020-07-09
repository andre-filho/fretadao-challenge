FROM node:10.14

EXPOSE 8080

WORKDIR /client

COPY . /client

RUN yarn add @vue/cli @vue/cli-init --global
RUN yarn install

RUN chmod +x /client/docker-test-script.sh

CMD yarn run dev
