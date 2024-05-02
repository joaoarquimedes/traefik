ARG ARCH=${ARCH}
FROM --platform=${ARCH} nginx:stable-alpine
LABEL maintainer="Joao Arquimedes"

RUN apk update
RUN apk upgrade

# Certificate
RUN apk add openssl
RUN mkdir /etc/nginx/ssl
COPY --chown=root.root --chmod=664 ./conf/openssl.cnf /etc/nginx/ssl/openssl.cnf
RUN openssl req -x509 -newkey rsa:2048 -config /etc/nginx/ssl/openssl.cnf -keyout /etc/nginx/ssl/cert.key -out /etc/nginx/ssl/cert.pem -days 7300 -nodes
RUN openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
RUN rm -rf /etc/nginx/ssl/openssl.cnf
RUN chmod 770 /etc/nginx/ssl

# Nginx
COPY --chown=root.root --chmod=664 ./conf/nginx.conf /etc/nginx/nginx.conf

WORKDIR /var/www/html/
EXPOSE 80 443

STOPSIGNAL SIGQUIT
CMD ["nginx", "-g", "daemon off;"]
