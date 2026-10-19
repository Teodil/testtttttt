#Базовый образ на основе которого будет работать прилол.
#Образ для сборки зависимостей
FROM node:20-alpine AS deps 

#Расположение файлов внутри контейнера
WORKDIR /usr/src/app

#Копирование файлов package-lock.json package.json
COPY package*.json ./

#Установка зависимостей
RUN npm ci

#Образ для сборки приложения
FROM node:20-alpine AS builder

#Расположение файлов внутри контейнера
WORKDIR /usr/src/app

#из образа deps копируем папку node_modules в образ builder
COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY . .

RUN npm run build

#Этап 3 - образ для запуска
FROM node:20-alpine AS prod

#Расположение файлов внутри контейнера
WORKDIR /usr/src/app
#Установка переменной окружения
ENV NODE_ENV=production

COPY package*.json ./
#Установка prod зависимостей
RUN npm ci --omit=dev
#Очистка кэша библиотек node
RUN npm cache clean --force

#Копирование собрнных файлов для запуска проложения из этапа сборки
COPY --from=builder /usr/src/app/dist ./dist

#Проброс 3000 порта
EXPOSE 3000

USER node

CMD ["node", "dist/main"]
