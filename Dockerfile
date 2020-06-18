FROM busybox:1.31.1
COPY entrypoint.sh /usr/local/bin/.
ENTRYPOINT ["entrypoint.sh"]
