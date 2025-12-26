FROM node:22-slim

RUN npm install -g npm@11 --loglevel=error
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# deps backend (raiz)
COPY package*.json ./
RUN npm ci --loglevel=error || npm install --loglevel=error

# deps frontend
COPY client/package*.json ./client/
RUN cd client && npm ci --legacy-peer-deps --loglevel=error || npm install --legacy-peer-deps --loglevel=error

# código
COPY . .

# build frontend
ARG VITE_API_URL=http://localhost:3001
#RUN cd client && VITE_API_URL=bia-pipeline-formcaobeanstalkwill.us-east-1.elasticbeanstalk.comnpm run build
RUN cd client && VITE_API_URL=$VITE_API_URL npm run build

# porta do app (ajuste conforme seu server)
ENV PORT=8080
EXPOSE 8080

CMD ["npm","start"]





#FROM public.ecr.aws/docker/library/node:22-slim
#RUN npm install -g npm@11 --loglevel=error

# Instalando curl
#RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

#WORKDIR /usr/src/app

# Copiar package.json raiz primeiro
#COPY package*.json ./
#RUN npm install --loglevel=error

# Copiar package.json do client e instalar dependências (incluindo devDependencies para build)
#COPY client/package*.json ./client/
#RUN cd client && npm install --legacy-peer-deps --loglevel=error

# Copiar todos os arquivos
#COPY . .

# Build do front-end com Vite
#RUN cd client && VITE_API_URL=http://localhost:3001 npm run build
#RUN cd client && VITE_API_URL=bia-pipeline-formcaobeanstalkwill.us-east-1.elasticbeanstalk.comnpm run build

# Limpeza das dependências de desenvolvimento do client para reduzir tamanho
#RUN cd client && npm prune --production && rm -rf node_modules/.cache

#EXPOSE 8080

#CMD [ "npm", "start" ]


