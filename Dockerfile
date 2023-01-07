FROM node:16.10-alpine
ARG NODE_ENV=prod

RUN mkdir /usr/app
WORKDIR /usr/app
RUN apk add nodejs npm

RUN npm install npm@8.11.0
RUN rm -rf /usr/local/lib/node_modules/npm
RUN mv /usr/app/node_modules/npm /usr/local/lib/node_modules/npm

COPY package*.json ./

RUN npm cache clean --force

RUN if [ "${NODE_ENV}" = "prod" ];  \
    then npm ci --only=production && echo "npm prod"; \
    else npm i && echo "npm dev";  \
    fi

COPY ./ /usr/app

RUN npm run build

CMD [ "node", "dist/main.js" ]
