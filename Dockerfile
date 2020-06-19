FROM busybox:1.31.1
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
