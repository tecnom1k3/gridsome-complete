FROM node:20 AS builder

RUN npm install -g npm@latest

WORKDIR /opt

USER node

VOLUME [ "/opt" ]

CMD npx create-strapi@latest --no-run --js --use-yarn --no-install --no-git-init --no-example --skip-cloud --skip-db app 

FROM node:18-alpine3.18 AS develop
# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY ./output/app/package.json ./
RUN yarn global add node-gyp
RUN yarn config set network-timeout 600000 -g && yarn install
ENV PATH=/opt/node_modules/.bin:/opt/app/node_modules/.strapi:$PATH

WORKDIR /opt/app
COPY  ./output/app .
RUN chown -R node:node /opt/app
USER node
RUN ["yarn", "build"]
EXPOSE 1337
CMD ["yarn", "develop"]
