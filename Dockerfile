FROM node:18-alpine3.18
# Installing libvips-dev for sharp Compatibility
RUN sed -i "s@https://dl-cdn.alpinelinux.org/@https://mirrors.huaweicloud.com/@g" /etc/apk/repositories \
    && apk update \
    && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY package.json ./
RUN npm config set registry https://mirrors.huaweicloud.com/repository/npm/ \
    && npm cache clean -f \
    && npm install -g node-gyp cnpm
RUN cnpm install
ENV PATH=/opt/node_modules/.bin:$PATH

WORKDIR /opt/strapi
COPY . .
RUN chown -R node:node /opt/strapi
USER node
RUN ["npm", "run", "build"]
EXPOSE 1337
CMD ["npm", "run", "develop"]
