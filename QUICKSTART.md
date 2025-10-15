# 🚀 Démarrage Rapide

## Installation en 3 étapes

### 1️⃣ Télécharger

```bash
git clone https://github.com/theox33/enhanced-ubuntu-desktop-experience.git
cd enhanced-ubuntu-desktop-experience
```

### 2️⃣ Rendre exécutable

```bash
chmod +x install.sh
```

### 3️⃣ Installer

```bash
./install.sh
```

---

## 🎯 Modes d'utilisation

### Mode recommandé (interactif)
```bash
./install.sh
```
✅ **Parfait pour** : Première installation, utilisateurs prudents  
📝 **Ce qui se passe** : Le script demande confirmation avant chaque action importante

### Mode automatique (sans confirmation)
```bash
./install.sh -y
```
✅ **Parfait pour** : Utilisateurs expérimentés, déploiement automatisé  
📝 **Ce qui se passe** : Installation complète sans interruption

### Mode test (simulation)
```bash
./install.sh -d
```
✅ **Parfait pour** : Voir ce qui sera installé sans rien modifier  
📝 **Ce qui se passe** : Simule toutes les étapes sans modifier le système

### Mode rapide (sans mise à niveau système)
```bash
./install.sh --skip-upgrade
```
✅ **Parfait pour** : Gagner du temps (économise 5-15 minutes)  
📝 **Ce qui se passe** : Installe les nouveaux paquets mais ne met pas à niveau le système

---

## 📊 Ce qui sera installé

### Polices
- **Comfortaa** - Police d'interface élégante
- **JetBrains Mono** - Police monospace pour le code

### Thèmes
- **Lavanda-Sea** - Thème GTK/Shell moderne et coloré
- **Uos-fulldistro-icons** - Pack d'icônes complet
- **Bibata-Modern-Ice** - Curseurs modernes

### Extensions GNOME (12 au total)
1. Blur My Shell - Effets de flou
2. Burn My Windows - Animations de fenêtres (Hexagone)
3. Clipboard Indicator - Gestionnaire de presse-papiers
4. Compiz Magic Lamp - Effet lampe magique
5. Compiz Windows Effect - Effets de fenêtres
6. Coverflow Alt-Tab - Sélecteur d'applications 3D
7. Dash to Dock - Dock personnalisable
8. Desktop Cube - Bureau en cube 3D
9. GSConnect - Intégration Android
10. Media Controls - Contrôles multimédias
11. Search Light - Recherche améliorée
12. User Themes - Support des thèmes personnalisés

---

## 🛟 Aide et dépannage

### Voir toutes les options
```bash
./install.sh --help
```

### Tester avant d'installer
```bash
./install.sh -d        # Simulation
./install.sh -d -v     # Simulation avec détails
```

### En cas de problème

1. **Consulter le log**
   ```bash
   ls -lt ~/ | grep gnome-install
   cat ~/gnome-install-YYYYMMDD-HHMMSS.log
   ```

2. **Restaurer le backup**
   ```bash
   # Trouver le backup
   ls -lt ~/.gnome-config-backup-*
   
   # Restaurer
   BACKUP=~/.gnome-config-backup-YYYYMMDD-HHMMSS
   dconf load /org/gnome/desktop/ < $BACKUP/desktop-settings.dconf
   dconf load /org/gnome/shell/ < $BACKUP/shell-settings.dconf
   ```

3. **Relancer en mode verbeux**
   ```bash
   ./install.sh -v
   ```

---

## 💡 Exemples d'utilisation

### Pour découvrir
```bash
# 1. D'abord voir l'aide
./install.sh --help

# 2. Simuler pour voir ce qui se passera
./install.sh -d

# 3. Installer avec confirmations
./install.sh
```

### Pour un utilisateur pressé
```bash
# Installation rapide sans questions
./install.sh -y --skip-upgrade
```

### Pour un administrateur
```bash
# Installation avec log personnalisé
./install.sh -y --log /var/log/gnome-custom-$(hostname).log
```

### Pour déboguer
```bash
# Mode verbeux avec tous les détails
./install.sh -v > debug.log 2>&1
```

---

## ⏱️ Temps d'installation

| Mode | Durée estimée |
|------|---------------|
| Avec `apt upgrade` | 15-30 minutes |
| Sans `apt upgrade` (`--skip-upgrade`) | 5-10 minutes |
| Dry-run (`-d`) | < 1 minute |

*La durée dépend de votre connexion internet et de la vitesse de votre machine*

---

## ✅ Après l'installation

### Redémarrer la session GNOME

**Option 1** : Déconnexion/Reconnexion (recommandé)
1. Déconnectez-vous
2. Reconnectez-vous

**Option 2** : Redémarrage de GNOME Shell (X11 seulement)
1. `Alt + F2`
2. Tapez `r`
3. Appuyez sur `Entrée`

**Option 3** : Redémarrage complet
```bash
sudo reboot
```

### Vérifier que tout fonctionne

1. Ouvrir **GNOME Tweaks**
   - Vérifier les polices appliquées
   - Vérifier les thèmes activés

2. Ouvrir **Gestionnaire d'extensions**
   - Vérifier que les 12 extensions sont installées
   - Activer/désactiver selon vos préférences

3. Tester l'effet Hexagone
   - Fermer une fenêtre
   - Vous devriez voir l'animation hexagonale

---

## 🆘 Questions fréquentes

### Le script nécessite-t-il une connexion internet ?
**Oui**, environ 100 MB de ressources seront téléchargées.

### Puis-je l'utiliser sur d'autres distributions ?
Le script est optimisé pour **Ubuntu Desktop avec GNOME**. Il peut fonctionner sur d'autres distributions Debian/Ubuntu, mais ce n'est pas garanti.

### Que faire si une extension ne fonctionne pas ?
1. Vérifier dans le Gestionnaire d'extensions
2. Redémarrer la session GNOME
3. Installer manuellement depuis extensions.gnome.org

### Comment désinstaller ?
1. Restaurer le backup (voir section "En cas de problème")
2. Désinstaller les extensions via le Gestionnaire d'extensions
3. Supprimer les thèmes/polices manuellement :
   ```bash
   rm -rf ~/.themes/Lavanda*
   rm -rf ~/.icons/Uos-fulldistro-icons ~/.icons/Bibata*
   rm -rf ~/.local/share/fonts/Comfortaa* ~/.local/share/fonts/JetBrains*
   ```

---

## 📚 Documentation complète

- **README.md** - Documentation principale
- **FEATURES-2.1.md** - Guide détaillé des fonctionnalités v2.1
- **CHANGELOG.md** - Historique des versions
- **CRITIQUE.md** - Analyse des problèmes de la v1.0
- **DIFFERENCES.md** - Comparaison v1 vs v2
- **FILES.md** - Guide des fichiers du projet

---

## 🤝 Contribuer

Les contributions sont les bienvenues !

1. Fork le projet
2. Créez une branche (`git checkout -b feature/amelioration`)
3. Committez vos changements (`git commit -am 'Ajout de fonctionnalité'`)
4. Push vers la branche (`git push origin feature/amelioration`)
5. Ouvrez une Pull Request

---

## 📄 Licence

MIT License - Libre d'utilisation, modification et distribution.

---

**Bon customisation de votre Ubuntu GNOME ! 🎨✨**
