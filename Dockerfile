### STAGE 1: Build ###
FROM node:lts-alpine AS build

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

#### generate build --prod
RUN npm run build

### STAGE 2: Run ###
FROM nginxinc/nginx-unprivileged

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /code

COPY --from=build /app/dist/angular-project .

EXPOSE 8080:8080
CMD ["nginx", "-g", "daemon off;"]