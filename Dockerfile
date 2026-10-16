#Базовый образ на основе которого будет работать прилол.
FROM node:20

#Расположение файлов внутри контейнера
WORKDIR /usr/src/app

#Копирование файлов package-lock.json package.json
COPY package*.json ./

#Установка зависимостей
RUN npm ci

COPY . .

RUN npm run build

#Проброс 3000 порта
EXPOSE 3000

CMD ["node", "dist/main"]
