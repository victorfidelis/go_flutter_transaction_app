FROM golang:1.24.2-bookworm

WORKDIR /app

COPY . .

RUN go mod download
RUN go build -o /app/main ./cmd/app

EXPOSE 8080

CMD ["./main"]