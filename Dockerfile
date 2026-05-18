# =============================================================
# ETAPA 1: builder
# =============================================================
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN if [ -f package-lock.json ]; then \
      npm ci --omit=dev; \
    else \
      npm install --omit=dev; \
    fi

COPY src ./src

# =============================================================
# ETAPA 2: runtime
# =============================================================
FROM node:20-alpine AS runtime

LABEL maintainer="casino-devops"

WORKDIR /app

COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/src          ./src
COPY --chown=node:node package.json ./

RUN chown -R node:node /app

USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD node -e "require('http').get('http://127.0.0.1:3000/health',r=>{process.exit(r.statusCode===200?0:1)}).on('error',()=>process.exit(1));"

CMD ["node", "src/server.js"]
