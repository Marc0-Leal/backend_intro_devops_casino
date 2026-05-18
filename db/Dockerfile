FROM postgres:16-alpine

LABEL maintainer="casino-devops"

COPY init.sql /docker-entrypoint-initdb.d/01-init.sql

EXPOSE 5432
