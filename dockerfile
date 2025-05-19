## baixa e executa a imagem do node na versão Alpine (versão simplificada)
FROM node:alpine

## define o local onde o app ira ficar no disco do container 
## O caminho o Dev quem escolhe
WORKDIR /usr/app

## Copia tudo que começa com package e termin com .json para dentro de usr/app
COPY package*.json ./

## Executa npm install para adicionar todas as dependencias e criar a pasta node_modules
RUN npm install

## Copia tudo que esta no diretorio onde o arquivo Dockerfile esta
## Sera copiado dentro da pasta /usr/app do container
## Vamos ignorar a node_modules (.dockerignore)
COPY . .

## Container ficara ouvindo os acessos na porta 5000
EXPOSE 5000 

## Executa o comando para iniciar o script que esta no package.json
CMD npm start