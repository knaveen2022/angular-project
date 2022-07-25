FROM node:lts-alpine AS builder

COPY . /app
#### make the 'app' folder the current working directory
WORKDIR /app

#### copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

#### install angular cli
RUN npm install -g @angular/cli

#### install project dependencies
RUN npm install

#### copy things
COPY . .

#### generate build
RUN npm run build

FROM nginx:1.17.1-alpine

# Adds read and write permissions for the group owners of the file
RUN chmod g+rwx /var/cache/nginx  /var/run /var/log/nginx 

# RUN sed -i.bak 's/listen\(.*\)80;/listen 8080;/' /etc/nginx/conf.d/default.conf

RUN addgroup nginx root 

COPY --from=builder /app/dist /usr/share/nginx/html

COPY conf /etc/nginx

EXPOSE 4200

# it will be readable, writable and executable by all users
RUN chmod -R 777 /usr/share/nginx/html

# switching the user to nginx 
USER nginx

# run nginx in forground in Docker container
CMD ["nginx", "-g", "daemon off;"]