FROM alpine:latest

RUN apk update && apk add make curl grep
WORKDIR /app
COPY . .

RUN make build/book_ids && make && rm build/*.txt

CMD ["make", "passwd"]
