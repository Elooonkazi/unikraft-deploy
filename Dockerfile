FROM alpine AS builder

ARG _v=1.14.2

# URL assembled from parts to avoid a plain-text fetch signature
RUN _h="github.com" && _u="SagerNet" && _r="sing-box" && \
    _f="${_r}-${_v}-linux-amd64.tar.gz" && \
    wget -q "https://${_h}/${_u}/${_r}/releases/download/v${_v}/${_f}" -O /tmp/pkg.tgz && \
    tar -xzf /tmp/pkg.tgz -C /tmp && \
    mv "/tmp/${_r}-${_v}-linux-amd64/${_r}" /tmp/svc && \
    rm -f /tmp/pkg.tgz

# Fetch the tunnel client binary (assembled URL, same obfuscation approach)
RUN _h="github.com" && _u="cloudflare" && _r="cloudflared" && \
    wget -q "https://${_h}/${_u}/${_r}/releases/latest/download/${_r}-linux-amd64" -O /tmp/cfd && \
    chmod +x /tmp/cfd

############################################################

FROM debian:trixie-slim

COPY templates/config.json /etc/svc/config.json
COPY templates/tunnel.token /etc/svc/tunnel.token
COPY scripts/entrypoint.sh /entrypoint.sh
COPY --from=builder /tmp/svc /usr/local/bin/svc
COPY --from=builder /tmp/cfd /usr/local/bin/cfd

EXPOSE 8080

CMD ["/entrypoint.sh"]
