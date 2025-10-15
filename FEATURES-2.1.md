# Nouvelles fonctionnalités - Version 2.1

## 🎯 Vue d'ensemble

La version 2.1 transforme le script d'installation en un outil professionnel avec :
- **5 modes d'exécution** différents
- **Système de logging** complet
- **Backup automatique** des paramètres
- **Options en ligne de commande** puissantes

---

## 📋 Options disponibles

### Mode d'exécution

```bash
# Mode interactif (défaut)
./install.sh
# → Demande confirmation pour chaque étape importante

# Mode automatique
./install.sh -y
# → Installation complète sans interruption

# Mode dry-run (simulation)
./install.sh -d
# → Simule l'installation sans rien modifier

# Mode verbeux
./install.sh -v
# → Affiche des informations de débogage détaillées
```

### Options système

```bash
# Sauter la mise à niveau système
./install.sh --skip-upgrade
# → Économise 5-15 minutes, installe uniquement les nouveaux paquets

# Fichier de log personnalisé
./install.sh --log /tmp/mon-install.log
# → Spécifie l'emplacement du fichier de log
```

### Combinaisons utiles

```bash
# Installation rapide et silencieuse
./install.sh -y --skip-upgrade

# Test avec détails complets
./install.sh -d -v

# Installation automatique avec log personnalisé
./install.sh -y --log /var/log/gnome-custom.log
```

---

## 🔍 Vérifications préalables

Le script vérifie automatiquement :

### 1. Espace disque
- **Minimum requis** : 500 MB
- **Action** : Affiche un avertissement si insuffisant
- **Bypass** : En mode interactif, demande confirmation

### 2. Connexion internet
- **Test** : Ping vers google.com (timeout 3s)
- **Action** : Arrêt du script si pas de connexion
- **Visible** : Message clair de l'état de la connexion

### 3. Version GNOME Shell
- **Détection** : Automatique via `gnome-shell --version`
- **Usage** : Pour télécharger les extensions compatibles
- **Affichage** : Version détectée affichée au démarrage

### 4. Permissions sudo
- **Vérification** : Au début du script
- **Keep-alive** : Sudo maintenu actif pendant toute l'installation
- **Nettoyage** : Processus automatiquement terminé à la fin

---

## 💾 Système de backup

### Création automatique

Le script crée automatiquement un backup avant toute modification :

```
~/.gnome-config-backup-YYYYMMDD-HHMMSS/
├── desktop-settings.dconf    # Paramètres du bureau
├── shell-settings.dconf      # Paramètres du shell GNOME
└── enabled-extensions.txt    # Liste des extensions actives
```

### Utilisation du backup

```bash
# Le chemin du dernier backup est enregistré
cat ~/.gnome-config-last-backup

# Restaurer manuellement
BACKUP_DIR=$(cat ~/.gnome-config-last-backup)
dconf load /org/gnome/desktop/ < "$BACKUP_DIR/desktop-settings.dconf"
dconf load /org/gnome/shell/ < "$BACKUP_DIR/shell-settings.dconf"

# Voir les extensions qui étaient activées avant
cat "$BACKUP_DIR/enabled-extensions.txt"
```

---

## 📊 Système de logging

### Fichiers de log automatiques

Chaque exécution crée un log horodaté :
```
~/gnome-install-20251015-143052.log
```

### Contenu du log

Le fichier contient :
- **Timestamps** pour chaque événement
- **Niveau** : INFO, SUCCESS, WARNING, ERROR, DEBUG
- **Messages** détaillés de chaque étape
- **Erreurs** et leur contexte complet

### Exemple de log

```
[2025-10-15 14:30:52] INFO: Vérification de la connexion internet...
[2025-10-15 14:30:53] SUCCESS: Connexion internet OK
[2025-10-15 14:30:53] INFO: Vérification de la version de GNOME Shell...
[2025-10-15 14:30:54] SUCCESS: GNOME Shell version 46 détecté
[2025-10-15 14:30:54] DEBUG: Version complète: GNOME Shell 46.0
[2025-10-15 14:31:02] ERROR: Échec du téléchargement de comfortaa.zip
[2025-10-15 14:31:15] SUCCESS: JetBrains Mono installé (18 fichiers de police)
```

### Personnalisation

```bash
# Log dans un emplacement spécifique
./install.sh --log /var/log/gnome-install.log

# Log dans un dossier temporaire
./install.sh --log /tmp/install-$(date +%s).log
```

---

## 🎨 Rapport final amélioré

### Exemple de sortie

```
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║  ✓ Installation terminée !                                 ║
║                                                            ║
║  ✨ Aucune erreur détectée - Installation parfaite !       ║
║                                                            ║
║  📊 Statistiques:                                          ║
║     Extensions installées: 12/12                           ║
║                                                            ║
║  📝 Fichier de log: gnome-install-20251015-143052.log     ║
║     Emplacement: ~/.../gnome-install-20251015-143052.log  ║
║                                                            ║
║  🔄 Pour appliquer les changements:                        ║
║                                                            ║
║  1. Déconnectez-vous                                       ║
║  2. Reconnectez-vous                                       ║
║                                                            ║
║  Ou: Alt+F2 → tapez 'r' → Entrée (X11 uniquement)         ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

💾 Backup disponible: /home/user/.gnome-config-backup-20251015-143050
   Pour restaurer: dconf load /org/gnome/desktop/ < ...
```

---

## 🚀 Cas d'usage typiques

### 1. Première installation (utilisateur prudent)

```bash
# 1. D'abord tester en simulation
./install.sh -d

# 2. Lire ce qui sera fait
./install.sh -d -v | less

# 3. Lancer l'installation réelle
./install.sh
# → Confirmations à chaque étape
```

### 2. Installation rapide (utilisateur expérimenté)

```bash
# Installation complète automatique
./install.sh -y --skip-upgrade
```

### 3. Déploiement automatisé

```bash
# Script pour déployer sur plusieurs machines
./install.sh -y --log /var/log/deployment-$(hostname).log
```

### 4. Débogage de problème

```bash
# Mode verbeux avec tous les détails
./install.sh -v 2>&1 | tee debug-output.txt
```

### 5. Installation partielle

```bash
# Installer sans mettre à jour le système
./install.sh --skip-upgrade

# Installer avec confirmation à chaque étape
./install.sh  # (mode interactif par défaut)
```

---

## 🛡️ Sécurité et fiabilité

### Protection contre les erreurs

1. **Dry-run** : Tester sans risque
2. **Backup** : Restauration possible
3. **Logging** : Traçabilité complète
4. **Continue on error** : Le script ne s'arrête pas brusquement

### Vérifications avant modification

- Espace disque suffisant
- Connexion internet active
- GNOME Shell installé
- Permissions sudo disponibles

### En cas de problème

1. **Consulter le log** : `cat ~/gnome-install-*.log`
2. **Restaurer le backup** : Voir section backup ci-dessus
3. **Relancer en mode verbeux** : `./install.sh -v`
4. **Désinstaller manuellement** : Via GNOME Tweaks et Gestionnaire d'extensions

---

## 📈 Améliorations par rapport à la v2.0

| Fonctionnalité | v2.0 | v2.1 |
|----------------|------|------|
| Options CLI | ❌ Aucune | ✅ 6 options |
| Mode interactif | ❌ Non | ✅ Oui (défaut) |
| Dry-run | ❌ Non | ✅ Oui (-d) |
| Logging | ❌ Basique | ✅ Complet avec timestamps |
| Backup auto | ❌ Non | ✅ Oui |
| Vérif. espace disque | ❌ Non | ✅ Oui (500 MB) |
| Aide intégrée | ❌ Non | ✅ Oui (--help) |
| Rapport final | 🟡 Simple | ✅ Détaillé avec stats |
| Mode verbeux | ❌ Non | ✅ Oui (-v) |
| Paquets skippés | ❌ Toujours upgrade | ✅ Option --skip-upgrade |

---

## 💡 Conseils d'utilisation

### Pour un usage personnel
```bash
./install.sh  # Mode interactif recommandé
```

### Pour tester sur une VM
```bash
# Tester sans risque
./install.sh -d

# Puis installer
./install.sh -y
```

### Pour un déploiement en entreprise
```bash
# Logging centralisé
./install.sh -y --skip-upgrade --log /nfs/logs/$(hostname)-install.log
```

### Pour contribuer au projet
```bash
# Mode verbeux pour diagnostiquer
./install.sh -d -v > test-output.txt 2>&1
```

---

## 🎓 Conclusion

La version 2.1 est un outil **professionnel et flexible** qui s'adapte à tous les cas d'usage :
- ✅ Débutants : Mode interactif avec confirmations
- ✅ Avancés : Options CLI puissantes
- ✅ Admins : Logging et déploiement automatisé
- ✅ Développeurs : Dry-run et mode verbeux
