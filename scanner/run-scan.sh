#!/bin/sh
set -e

echo "[+] Démarrage du scan..."

REPORT_DIR="/scanner/reports"
mkdir -p "$REPORT_DIR"

echo "[+] Vérification de l'accès à Nginx..."
curl -s -o /dev/null -w "%{http_code}" http://nginx || echo "[!] Échec de la connexion à Nginx"

echo "[+] Scan Trivy (image nginx:1.10)..."
trivy image nginx:1.10 \
  --scanners vuln \
  --severity HIGH,CRITICAL \
  --format table \
  --no-progress \
  --timeout 10m \
  > "$REPORT_DIR/trivy-report.txt" 2>&1 || echo "[!] Erreur Trivy"


echo "[+] Contenu du rapport Trivy:"
cat "$REPORT_DIR/trivy-report.txt"

echo "[+] Scan Nikto (http://nginx)..."
perl /opt/nikto/program/nikto.pl -host http://nginx -output "$REPORT_DIR/nikto-report.txt" -Format txt -Display V > /dev/null 2>&1 || echo "[!] Erreur Nikto"

echo "[+] Contenu du rapport Nikto:"
cat "$REPORT_DIR/nikto-report.txt"

echo "[✓] Scan terminé !"
