# Unoptimised build

FROM node:8.9-alpine
 
# prep the container
RUN apk add --update git nginx
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# copy our app into the container and install dependencies
COPY ./ ./
RUN yarn --pure-lockfile

# build production static files (.js .css)
RUN yarn run build
COPY /usr/src/app/build /usr/share/nginx/html

# apply our own config
RUN rm /etc/nginx/conf.d/default.conf
COPY /usr/src/app/nginx-server.conf /etc/nginx/conf.d/frontend-livefeed-server.conf

# get ready to serve files
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
