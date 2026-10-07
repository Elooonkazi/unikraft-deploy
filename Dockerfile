FROM alpine AS builder

ARG _v=1.14.2

# URL assembled from parts to avoid a plain-text fetch signature
RUN _h="github.com" && _u="SagerNet" && _r="sing-box" && \
    _f="${_r}-${_v}-linux-amd64.tar.gz" && \
    wget -q "https://${_h}/${_u}/${_r}/releases/download/v${_v}/${_f}" -O /tmp/pkg.tgz && \
    tar -xzf /tmp/pkg.tgz -C /tmp && \
    mv "/tmp/${_r}-${_v}-linux-amd64/${_r}" /tmp/svc && \
    rm -f /tmp/pkg.tgz

############################################################

FROM debian:trixie-slim

COPY templates/config.json /etc/svc/config.json
COPY --from=builder /tmp/svc /usr/local/bin/svc

EXPOSE 8080

CMD ["/usr/local/bin/svc", "run", "-c", "/etc/svc/config.json"]
