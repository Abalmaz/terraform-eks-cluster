FROM httpd:2.4

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl jq
COPY ./templates/ /usr/local/apache2/htdocs/
ADD bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh
CMD ["/bootstrap.sh"]