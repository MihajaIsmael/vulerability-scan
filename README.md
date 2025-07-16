
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

## Fonctionnement technique
Trivy scanne l’image nginx:1.10 à la recherche de vulnérabilités connues (CVE).

Nikto effectue un scan HTTP de base sur l’URL http://nginx, accessible via le réseau Docker.

Les deux outils produisent un rapport texte redirigé dans le volume partagé avec l’hôte.

Le script run-scan.sh automatise tout ce processus.

## Personnalisation possible
Le serveur cible peut être remplacé par un conteneur Apache, ou une autre version de Nginx.

Le script peut être adapté pour exporter les rapports au format HTML, JSON, ou les envoyer par email.

Des outils complémentaires comme Nmap, OpenVAS ou Wapiti peuvent être ajoutés.
