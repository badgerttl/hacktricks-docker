# Stage 1: build mdbook and mdbook-tabs on Alpine (musl binaries)
FROM rust:alpine AS builder
RUN apk add --no-cache musl-dev openssl-dev pkgconfig
RUN cargo install mdbook mdbook-tabs \
    && strip /usr/local/cargo/bin/mdbook /usr/local/cargo/bin/mdbook-tabs

# Stage 2: minimal runtime (~50–80MB instead of ~1GB)
FROM alpine:3.19
RUN apk add --no-cache python3 ca-certificates
COPY --from=builder /usr/local/cargo/bin/mdbook /usr/local/bin/
COPY --from=builder /usr/local/cargo/bin/mdbook-tabs /usr/local/bin/

WORKDIR /app
CMD ["bash", "-c", "rm -rf /app/book && MDBOOK_PREPROCESSOR__HACKTRICKS__ENV=dev mdbook serve --hostname 0.0.0.0 --port 3337"]
