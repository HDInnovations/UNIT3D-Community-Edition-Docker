FROM caddy:2.2.1-builder AS builder
RUN xcaddy build --with github.com/caddy-dns/cloudflare

FROM caddy:2.2.1
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
VOLUME ["/app/public", "/app/public/files"]
