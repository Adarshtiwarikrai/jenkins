# FROM node:20.10.0

# RUN  mkdir -p /home/my-app

# COPY my-app /home/my-app

# WORKDIR /home/my-app

# RUN npm install 

# CMD ["npm","run","dev"]


FROM node:20.10.0 as build

WORKDIR /app

COPY my-app .

RUN npm install

RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
CMD ["nginx","-g","daemon off;"]