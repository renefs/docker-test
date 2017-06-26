FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf.template /etc/nginx/conf.d/default.conf.template
COPY entrypoint.sh /etc/nginx/entrypoint.sh

EXPOSE 8080

RUN chgrp -R 0 /var/* /etc/nginx && chmod -R g+rwX /var/* /etc/nginx

CMD ["/etc/nginx/entrypoint.sh"]