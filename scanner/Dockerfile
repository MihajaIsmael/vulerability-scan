FROM alpine:3.19

# Dépendances système
RUN apk add --no-cache bash git curl wget tar perl nmap

# Installation de Trivy (binaire officiel)
ENV TRIVY_VERSION=0.50.0

RUN wget https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz && \
    tar -xzf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz && \
    mv trivy /usr/local/bin/trivy && \
    chmod +x /usr/local/bin/trivy && \
    rm trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz

# Cloner Nikto
RUN git clone https://github.com/sullo/nikto.git /opt/nikto

# Copier le script de scan
COPY run-scan.sh /run-scan.sh
RUN chmod +x /run-scan.sh

WORKDIR /scanner
ENTRYPOINT ["/run-scan.sh"]
