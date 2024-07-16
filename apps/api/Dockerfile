FROM node:lts

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./ 
COPY apps/api/package.json ./apps/api/package.json

RUN npm ci

COPY . .

WORKDIR /app/apps/api

CMD ["npm", "run", "start"]
