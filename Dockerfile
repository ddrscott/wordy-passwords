FROM alpine:latest as builder

RUN apk update && apk add make curl grep
WORKDIR /app
COPY . .

RUN make build/book_ids && make && rm build/*.txt

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/dist/words /app/dist/words
COPY wordy .
CMD ["./wordy"]
