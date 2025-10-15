# 🎨 Enhanced Ubuntu Desktop Experience

Configuration personnalisée GNOME pour Ubuntu Desktop avec thèmes, icônes, polices et extensions.

## 📋 Description

Ce projet fournit un script d'installation automatisé pour transformer une installation Ubuntu Desktop vanilla en un environnement GNOME personnalisé et élégant.

### ✨ Caractéristiques

- **Polices** :
  - Interface : Comfortaa
  - Documents : JetBrains Mono
  - Monospace : JetBrains Mono

- **Thèmes** :
  - GTK/Shell : Lavanda-Sea
  - Icônes : Uos-fulldistro-icons
  - Curseurs : Bibata-Modern-Ice

- **Extensions GNOME** :
  - Blur My Shell
  - Burn My Windows (effet Hexagone)
  - Clipboard Indicator
  - Compiz Alike Magic Lamp Effect
  - Compiz Windows Effect
  - Coverflow Alt-Tab
  - Dash to Dock
  - Desktop Cube
  - GSConnect
  - Media Controls
  - Search Light
  - User Themes

## 🚀 Installation

### Prérequis

- Ubuntu Desktop (22.04 ou supérieur recommandé)
- GNOME Shell (la version sera détectée automatiquement)
- Connexion Internet active
- ~500 MB d'espace disque disponible
- Accès sudo

### Installation rapide

```bash
# Cloner le dépôt
git clone https://github.com/theox33/enhanced-ubuntu-desktop-experience.git
cd enhanced-ubuntu-desktop-experience

# Rendre le script exécutable
chmod +x install.sh

# Exécuter le script
./install.sh
```

### Options avancées

Le script supporte plusieurs options pour personnaliser l'installation :

```bash
# Afficher l'aide
./install.sh --help

# Installation automatique sans confirmation
./install.sh -y

# Simuler l'installation (dry-run)
./install.sh -d

# Mode verbeux pour plus de détails
./install.sh -v

# Sauter la mise à niveau système
./install.sh --skip-upgrade

# Installation automatique avec log personnalisé
./install.sh -y --log /tmp/mon-installation.log

# Combinaison d'options
./install.sh -v -y --skip-upgrade
```

### Installation manuelle

Si vous préférez télécharger uniquement le script :

```bash
# Télécharger le script
wget https://raw.githubusercontent.com/theox33/enhanced-ubuntu-desktop-experience/main/install.sh

# Rendre le script exécutable
chmod +x install.sh

# Exécuter
./install.sh
```

## 📝 Que fait le script ?

Le script `install.sh` effectue une installation complète et robuste avec gestion d'erreurs avancée :

1. ✅ Vérifie la connexion internet et la version de GNOME Shell
2. ✅ Met à jour le système
3. ✅ Installe les applications nécessaires (Flatpak, GNOME Tweaks, Gestionnaire d'extensions)
4. ✅ Télécharge toutes les ressources (polices, thèmes, icônes, curseurs)
5. ✅ Installe et configure les polices avec vérification
6. ✅ Installe les thèmes, icônes et curseurs avec détection automatique des noms
7. ✅ **Installe les extensions GNOME** via l'API officielle extensions.gnome.org
8. ✅ Désactive les extensions Ubuntu par défaut (ubuntu-dock, tiling-assistant)
9. ✅ Configure Burn My Windows avec l'effet Hexagone
10. ✅ Applique tous les paramètres d'apparence
11. ✅ Nettoie les fichiers temporaires
12. ✅ **Affiche un rapport détaillé** avec le nombre d'erreurs et d'avertissements

### 🔧 Fonctionnalités avancées du script

**Version 2.1** avec améliorations majeures :

- **Modes d'exécution flexibles**
  - Mode interactif (défaut) : Confirmations à chaque étape
  - Mode automatique (`-y`) : Installation sans intervention
  - Mode dry-run (`-d`) : Simulation sans modification du système

- **Système de logging complet**
  - Fichier de log automatique horodaté
  - Tous les événements enregistrés avec timestamps
  - Log personnalisable avec `--log`

- **Vérifications avancées**
  - Espace disque disponible (minimum 500 MB)
  - Connexion internet avec timeout
  - Version de GNOME Shell détectée
  - Permissions sudo vérifiées au démarrage

- **Backup et restauration**
  - Sauvegarde automatique des paramètres actuels
  - Possibilité de restaurer en cas de problème
  - Backup des paramètres dconf et liste des extensions

- **Gestion d'erreurs robuste**
  - Le script continue même en cas d'erreur non-critique
  - Compteurs d'erreurs et d'avertissements
  - Rapport final détaillé avec statistiques

- **Détection automatique**
  - Versions de GNOME compatibles
  - Noms de thèmes et variantes
  - Fichiers téléchargés valides
  - Paquets déjà installés

- **Options pratiques**
  - `--skip-upgrade` : Gagner du temps en sautant apt upgrade
  - `-v` : Mode verbeux pour le débogage
  - `--help` : Aide complète avec exemples

- **Rapport final amélioré**
  - Statistiques précises (extensions installées, erreurs, warnings)
  - Indication du fichier de log créé
  - Information sur le backup disponible

## ⚠️ Après l'installation

Pour appliquer complètement tous les changements, vous devez **redémarrer votre session GNOME** :

### Option 1 : Déconnexion/Reconnexion
1. Déconnectez-vous de votre session
2. Reconnectez-vous

### Option 2 : Redémarrage de GNOME Shell (X11 seulement)
1. Appuyez sur `Alt+F2`
2. Tapez `r`
3. Appuyez sur `Entrée`

### Option 3 : Redémarrage complet
```bash
sudo reboot
```

## 🔧 Configuration manuelle des extensions

Certaines extensions peuvent nécessiter une configuration manuelle via le Gestionnaire d'extensions. Le script fait de son mieux pour tout installer automatiquement, mais si une extension n'est pas activée :

1. Ouvrez le **Gestionnaire d'extensions**
2. Recherchez l'extension manquante
3. Installez-la et activez-la

## 📦 Ressources téléchargées

Le script télécharge les ressources depuis les sources officielles :

- **Comfortaa** : DaFont
- **JetBrains Mono** : JetBrains
- **Bibata-Modern-Ice** : GitHub (ful1e5)
- **Uos-fulldistro-icons** : GitHub (zayronxio)
- **Lavanda GTK Theme** : GitHub (vinceliuice)

## 🐛 Dépannage

### Tester avant d'installer

Vous pouvez simuler l'installation pour voir ce qui sera fait :

```bash
./install.sh -d  # Mode dry-run (simulation)
./install.sh -v  # Mode verbeux pour plus de détails
```

### Consulter les logs

Chaque installation crée un fichier de log :

```bash
# Le fichier est automatiquement créé dans ~/
ls -lt ~/ | grep gnome-install

# Consulter le log
cat ~/gnome-install-YYYYMMDD-HHMMSS.log
```

### Restaurer un backup

Si vous avez des problèmes après l'installation :

```bash
# Trouver le backup
ls -lt ~/.gnome-config-backup-*

# Restaurer les paramètres
dconf load /org/gnome/desktop/ < ~/.gnome-config-backup-*/desktop-settings.dconf
dconf load /org/gnome/shell/ < ~/.gnome-config-backup-*/shell-settings.dconf
```

### Le script affiche des avertissements

C'est normal ! Le script utilise une gestion d'erreurs robuste qui permet de continuer même si certaines étapes échouent. À la fin, vous verrez un rapport avec :
- Le nombre d'**erreurs** (en rouge)
- Le nombre d'**avertissements** (en jaune)

Tant que l'installation se termine, la plupart des fonctionnalités devraient fonctionner.

### Les extensions ne s'installent pas automatiquement

Le script tente d'installer les extensions automatiquement, mais cela peut échouer. Dans ce cas :
- Ouvrez le Gestionnaire d'extensions GNOME
- Installez manuellement les extensions listées ci-dessus

### Les thèmes n'apparaissent pas

- Vérifiez que les dossiers `~/.themes` et `~/.icons` existent
- Redémarrez votre session GNOME
- Ouvrez GNOME Tweaks et sélectionnez manuellement les thèmes

### Les polices ne sont pas appliquées

```bash
# Reconstruire le cache des polices
fc-cache -f -v

# Vérifier que les polices sont installées
fc-list | grep -i comfortaa
fc-list | grep -i jetbrains
```

## 📸 Aperçu

Après l'installation, vous aurez :
- Une interface élégante avec le thème Lavanda-Sea
- Des polices modernes et lisibles
- Des effets visuels fluides et agréables
- Un dock personnalisé avec Dash to Dock
- Des animations de fenêtres avec l'effet Hexagone

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs
- Proposer des améliorations
- Ajouter de nouvelles fonctionnalités

## 📄 Licence

Ce projet est distribué sous licence MIT. Les ressources tierces (polices, thèmes, icônes) conservent leurs licences respectives.

## 🙏 Remerciements

Merci aux créateurs des ressources utilisées :
- [Bibata Cursor](https://github.com/ful1e5/Bibata_Cursor)
- [Uos-fulldistro-icons](https://github.com/zayronxio/Uos-fulldistro-icons)
- [Lavanda GTK Theme](https://github.com/vinceliuice/Lavanda-gtk-theme)
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
- Tous les développeurs des extensions GNOME

---

**Note** : Ce script est testé sur Ubuntu Desktop avec GNOME. Il peut fonctionner sur d'autres distributions basées sur GNOME, mais cela n'est pas garanti.