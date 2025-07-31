
Ce projet permet d'automatiser l'analyse de vulnérabilités d'un serveur web (comme Apache ou Nginx) à l'aide de conteneurs Docker. Il s'appuie sur deux outils spécialisés en sécurité :

- **Trivy** : pour scanner les images Docker à la recherche de vulnérabilités (CVE).
- **Nikto** : pour détecter les failles classiques liées au protocole HTTP.

L'ensemble du processus est automatisé via un script `run-scan.sh` exécuté dans un conteneur dédié.

## Objectifs pédagogiques

- Mettre en place un environnement de test isolé avec Docker.
- Utiliser des outils de scan de vulnérabilités en ligne de commande.
- Automatiser l’exécution des analyses et la génération de rapports.
- Organiser un projet technique publiable sur GitHub.

## Contenu du projet

- Un conteneur **Nginx** servant de cible à scanner (port exposé en 8180).
- Un conteneur **scanner**, équipé de Trivy et Nikto.
- Un dossier `reports/` dans lequel les rapports sont générés.
- Un fichier `docker-compose.yml` pour orchestrer le tout.
- Un script shell `run-scan.sh` lancé automatiquement au démarrage du scanner.

## Prérequis

- Docker et Docker Compose installés sur votre machine.
- Une connexion Internet pour télécharger les images et bases de vulnérabilités.

## Lancer le projet

1. Cloner le projet :

   ```bash
   git clone https://github.com/MihajaIsmael/vulerability-scan.git
   cd vulnerability-scan
   ```

2. Construire les conteneurs :

   ```bash
   docker-compose build
   ```
3. Lancer le scan :

   ```bash
   docker-compose up
   ```

4. Les résultats sont générés dans le dossier reports/ :

trivy-report.txt : résultat de l’analyse de l’image Docker Nginx.

nikto-report.txt : résultat du scan HTTP (port 80).

## ⚙️ Fonctionnement technique

Le projet repose sur une architecture Docker multi-conteneurs avec deux services principaux :

- **Nginx** : un conteneur web basé sur l'image `nginx:1.10`, exposé en interne via le réseau Docker sous le nom `nginx`.
- **Scanner** : un conteneur personnalisé qui exécute un script de scan automatisé via le fichier `run-scan.sh`.

Le script de scan exécute les étapes suivantes :

1. ✅ **Vérifie l’accessibilité HTTP de Nginx** via une requête `curl`.
2. 🛡️ **Exécute un scan Trivy** sur l’image `nginx:1.10` pour détecter les vulnérabilités connues (CVE), limité aux niveaux **HIGH** et **CRITICAL** :
   - Trivy est lancé avec les options `--scanners vuln` pour ignorer les secrets, `--timeout 10m` pour éviter les blocages, et `--format table` pour un rapport lisible.
   - Les résultats sont sauvegardés dans `reports/trivy-report.txt`.
3. 🔍 **Lance un scan Nikto** sur l’URL `http://nginx`, via le réseau Docker :
   - Nikto identifie les failles basiques liées au serveur web (mauvaises configurations, fichiers dangereux, headers obsolètes...).
   - Le résultat est enregistré dans `reports/nikto-report.txt`.
4. 📁 **Les rapports sont stockés dans un dossier partagé avec l’hôte**, grâce à un volume Docker (`./reports`), ce qui permet de consulter les résultats depuis le système local.

---

## 🔧 Personnalisation possible

Le projet est facilement extensible :

- 🖥️ **Changer la cible du scan** :
  - Tu peux remplacer `nginx:1.10` par n'importe quelle image Docker (ex. `httpd:2.4` pour Apache).
  - Modifie aussi l’URL cible dans `run-scan.sh` (`http://nginx`) pour pointer vers le nouveau conteneur.

- 📤 **Exporter les rapports dans différents formats** :
  - Trivy supporte aussi les formats `json`, `sarif`, `template` via `--format`.
  - Nikto peut produire des rapports en `html`, `csv`, `xml`.

- 📬 **Automatiser la diffusion des rapports** :
  - Ajoute un envoi par email via `mail`, `msmtp`, ou un webhook Slack/Mattermost.
  - Les rapports peuvent aussi être intégrés dans une CI/CD (GitLab, GitHub Actions...).

- 🧰 **Ajouter d'autres outils de scan** :
  - Intègre facilement des outils complémentaires dans le Dockerfile ou dans `run-scan.sh`, comme :
    - [`Nmap`](https://nmap.org/) (scan réseau),
    - [`Wapiti`](https://wapiti.sourceforge.io/) (pentest web),
    - [`OpenVAS`](https://www.greenbone.net/) (scan de vulnérabilité complet),
    - [`ZAP`](https://www.zaproxy.org/) ou [`Arachni`](https://www.arachni-scanner.com/) pour des audits plus poussés.
