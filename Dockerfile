FROM golang:1.27.0-alpine AS build

WORKDIR /cmd
COPY go.mod go.sum ./
COPY . .
RUN CGO_ENABLED=0 go build -o /bearly-secure ./cmd/server
RUN CGO_ENABLED=0 go build -o /bearly-attacker-lab ./cmd/attackerlab
FROM alpine:3.22

RUN apk add --no-cache ca-certificates && addgroup -S bearly && adduser -S -G bearly bearly
WORKDIR /app
COPY --from=build /bearly-secure ./bearly-secure
COPY --from=build /bearly-attacker-lab ./bearly-attacker-lab
COPY /attacker-lab ./attacker-lab
COPY /web ./web
COPY /data/uploads/mystery-shack-tax-exemption.pdf ./data/uploads/mystery-shack-tax-exemption.pdf
RUN chown bearly:bearly ./data
USER bearly
CMD [ "./bearly-secure" ]
