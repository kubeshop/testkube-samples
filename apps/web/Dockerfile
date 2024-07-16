FROM node:lts as build

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./
COPY apps/web/package.json ./apps/web/package.json

RUN npm ci

COPY . .


WORKDIR /app/apps/web

RUN npm run build

CMD ["npx", "vite", "preview"]
