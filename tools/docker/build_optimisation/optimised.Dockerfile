## BUILD CONTAINER
# build environment - contains all dev dependencies (~500MB)
FROM node:8.9-alpine as builder
RUN apk add --update git

# create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# install app dependencies first (cache as docker layer)
COPY package.json yarn.lock ./
RUN yarn --pure-lockfile

# build production app
COPY ./ ./
RUN yarn run build


## PROD CONTAINER - absolutely minimal
# serve static files with nginx
FROM nginx:1.13-alpine

# create a non root user - for security of serving on prod
ENV APP_USER="cr-frontend-livefeed" \
  APP_UID=10000 \
  APP_HOME="/opt/www/"
RUN adduser -h "${APP_HOME}" -s /sbin/nologin -u "${APP_UID}" -D "${APP_USER}"

# change permissions for necessary nginx files
RUN touch /var/run/nginx.pid && \
  chown "${APP_USER}:${APP_USER}" /var/run/nginx.pid && \
  chown -R "${APP_USER}:${APP_USER}" /var/cache/nginx /var/log/nginx

# copy app content - only our built and minimised files
COPY --from=builder /usr/src/app/build "${APP_HOME}"
# apply our own config
RUN rm /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/src/app/nginx-server.conf /etc/nginx/conf.d/frontend-livefeed-server.conf

# make sure we run with non-root user on a non-root port
USER "${APP_USER}"
EXPOSE 3300
CMD ["nginx", "-g", "daemon off;"]
