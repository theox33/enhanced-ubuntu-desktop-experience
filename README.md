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

## 🚀 Installation rapide

```bash
git clone https://github.com/theox33/enhanced-ubuntu-desktop-experience.git
cd enhanced-ubuntu-desktop-experience
chmod +x install.sh
./install.sh
```

Un menu interactif s'affichera avec 5 options :
1. **Installer** - Configuration complète
2. **Restaurer défauts** - Revenir à Ubuntu vanilla
3. **Backup** - Sauvegarder les paramètres actuels
4. **Restore** - Restaurer un backup
5. **Quitter**

### Prérequis

- Ubuntu Desktop 22.04+ avec GNOME Shell
- Connexion Internet active
- ~500 MB d'espace disque
- Accès sudo

### Options utiles

```bash
./install.sh --help          # Aide complète
./install.sh --install       # Installation directe
./install.sh -y --install    # Installation automatique
./install.sh --remove        # Restaurer Ubuntu par défaut
./install.sh --backup        # Créer un backup
./install.sh -d              # Simuler (dry-run)
```

## 📝 Que fait le script ?

1. ✅ Vérifie les prérequis (connexion internet, espace disque, GNOME Shell)
2. ✅ Met à jour le système et installe les dépendances
3. ✅ Télécharge polices, thèmes, icônes et curseurs
4. ✅ Installe et configure tout automatiquement
5. ✅ **Installe et active 12 extensions GNOME**
6. ✅ Configure Burn My Windows avec l'effet Hexagone
7. ✅ Applique tous les paramètres d'apparence
8. ✅ Génère un rapport détaillé avec statistiques

### Fonctionnalités principales (v2.2.0)

- ✨ **Menu interactif** - Interface simple pour installer/restaurer/sauvegarder
- 🔄 **Activation auto des extensions** - Les extensions fonctionnent immédiatement
- 💾 **Backup/Restore** - Sauvegarde complète de vos paramètres
- 🔙 **Restauration défauts** - Retour à Ubuntu vanilla en un clic
- 📊 **Logging complet** - Fichiers de log détaillés avec timestamps
- 🛡️ **Gestion d'erreurs** - Continue même en cas d'erreurs non-critiques
- 🎯 **Modes flexibles** - Interactif, automatique ou simulation

## ⚠️ Après l'installation

**Les extensions sont activées automatiquement**, mais pour tout appliquer :

**X11** : `Alt+F2` → tapez `r` → `Entrée` (redémarrage rapide)  
**Wayland** : Déconnectez-vous et reconnectez-vous

## 🐛 Problèmes courants

### Extensions non activées
```bash
gnome-extensions list --enabled  # Vérifier les extensions actives
./install.sh --install           # Réinstaller
```

### Thème non appliqué
```bash
# Ouvrir GNOME Tweaks et appliquer manuellement
gnome-tweaks
```

### Restaurer Ubuntu par défaut
```bash
./install.sh --remove
```

### Consulter les logs
```bash
cat ~/gnome-install-*.log
```

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


### Extensions non installées

Ouvrez le **Gestionnaire d'extensions** et installez-les manuellement si nécessaire.

### Polices non appliquées

```bash
fc-cache -f -v  # Reconstruire le cache
fc-list | grep -i comfortaa  # Vérifier
```

## 🤝 Contribution

Les contributions sont bienvenues ! Signalez des bugs ou proposez des améliorations via GitHub Issues.

## 🙏 Crédits

- [Bibata Cursor](https://github.com/ful1e5/Bibata_Cursor)
- [Uos Icons](https://github.com/zayronxio/Uos-fulldistro-icons)
- [Lavanda Theme](https://github.com/vinceliuice/Lavanda-gtk-theme)
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
- Développeurs des extensions GNOME

## 📄 Licence

MIT License

---

**Version 2.2.0** | Testé sur Ubuntu 22.04+ avec GNOME Shell
