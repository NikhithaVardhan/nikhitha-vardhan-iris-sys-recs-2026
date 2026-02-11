FROM alpine:latest

RUN apk add --no-cache tar bash

WORKDIR /app

COPY backup.sh .

RUN chmod +x backup.sh

CMD ["./backup.sh"]
