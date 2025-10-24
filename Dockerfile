FROM public.ecr.aws/docker/library/node:22-slim

# Upgrade do npm
RUN npm install -g npm@11 --loglevel=error

# Instalar curl para health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Copiar e instalar dependências do backend (raiz)
COPY package*.json ./
RUN npm install --loglevel=error

# Copiar e instalar dependências do frontend (client)
COPY client/package*.json ./client/
RUN cd client && npm install --legacy-peer-deps --loglevel=error

# Copiar todos os arquivos do projeto
COPY . .

# Build do frontend com Vite
RUN cd client && VITE_API_URL=http://williamdominguesbarbosa.com.br    npm run build

# Limpeza das dependências de desenvolvimento do client
RUN cd client && npm prune --production && rm -rf node_modules/.cache

EXPOSE 8080

CMD ["npm", "start"]
