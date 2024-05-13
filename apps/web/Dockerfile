# # # # # # # # # # # # # # # #
# BUILD
# # # # # # # # # # # # # # # #
FROM node:20.5-bullseye-slim AS buildContainer
ENV NODE_OPTIONS="--max-old-space-size=8192"
RUN corepack enable

WORKDIR /service
COPY package.json package-lock.json ./
RUN npm install --ci

COPY . .

RUN npm run build

# # # # # # # # # # # # # # # #
# RUNTIME
# # # # # # # # # # # # # # # #
FROM nginxinc/nginx-unprivileged:1.25.3-alpine
ARG MODE

USER root
COPY --from=buildContainer /service/nginx.conf /etc/nginx/nginx.conf
COPY --from=buildContainer /service/dist /usr/share/nginx/dashboard

RUN chown -R 1001:0 /etc/nginx && chmod -R g+rwX /etc/nginx \
 && chown -R 1001:0 /usr/share/nginx && chmod -R g+rwX /usr/share/nginx

USER 1001
EXPOSE 3001
