### STAGE 1: Build ###
FROM node:lts-alpine AS builder

#### make the 'app' folder the current working directory
WORKDIR /app

#### copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

#### install project dependencies
RUN npm install

#### copy things
COPY . .

#### generate build --prod
RUN npm run build

FROM nginxinc/nginx-unprivileged

USER root

COPY --from=builder /app/dist/* /usr/share/nginx/html

COPY nginx.conf /etc/nginx

RUN chown -R 1001 /usr/share/nginx/html

USER 1001

EXPOSE 8080 

CMD ["nginx", "-g", "daemon off;"]