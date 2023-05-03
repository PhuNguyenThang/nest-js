FROM node:18-alpine AS build

USER node

WORKDIR /usr/src/app

ENV NODE_ENV build

COPY --chown=node:node package*.json ./


#RUN npm ci --production --ignore-scripts
RUN npm ci --production --ignore-scripts

COPY --chown=node:node . .

RUN npm run build && npm prune --production

FROM node:18-alpine as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY --chown=node:node --from=build  /usr/src/app/node_modules ./node_modules/
COPY --chown=node:node --from=build  /usr/src/app/package*.json ./
COPY --chown=node:node --from=build /usr/src/app/dist ./dist/

CMD ["node", "dist/src/main"]