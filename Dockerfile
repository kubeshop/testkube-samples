FROM node:lts

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

COPY index.mjs .
COPY app.test.mjs .

EXPOSE 8080
CMD ["node", "index.mjs"]
