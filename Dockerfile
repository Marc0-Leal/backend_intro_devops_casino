# ---------- Etapa 1: build (instala dependencias) ----------
FROM node:20-slim AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev

# ---------- Etapa 2: runtime ----------
FROM node:20-slim

RUN useradd --create-home --shell /bin/bash appuser

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./
COPY ./src ./src

RUN chown -R appuser:appuser /app
USER appuser

ENV NODE_ENV=production

EXPOSE 3000

CMD ["node", "src/server.js"]