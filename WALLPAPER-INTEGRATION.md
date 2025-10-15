# Intégration du fond d'écran personnalisé

## Vue d'ensemble

Le fond d'écran `fondecran.png` a été encodé en base64 et intégré directement dans le script `install.sh`. Cela signifie que le script est autonome et ne nécessite aucun fichier externe pour le fond d'écran.

## Détails techniques

### Encodage
- **Fichier source** : `fondecran.png` (PNG 1536x1024, 2.5 MB)
- **Format** : Encodé en base64 sans retour à la ligne (`-w 0`)
- **Taille encodée** : 3.4 MB (augmentation normale de ~33% pour base64)
- **Taille finale du script** : 3.3 MB (au lieu de ~50 KB)

### Emplacement dans le script
- **Lignes 1099-1150** : Fonction d'installation du fond d'écran
- **Ligne 1299** : Marqueur `__WALLPAPER_DATA__`
- **Ligne 1300** : Données base64 du fond d'écran (une seule ligne)

### Processus d'installation

1. **Création du dossier** : `~/.local/share/backgrounds/` (si inexistant)
2. **Extraction** : Les données après `__WALLPAPER_DATA__` sont extraites et décodées
3. **Sauvegarde PERMANENTE** : Le fichier PNG est sauvegardé vers `~/.local/share/backgrounds/enhanced-ubuntu-wallpaper.png`
4. **Permissions** : `chmod 644` pour garantir la lisibilité
5. **Application** : Configuration via gsettings pour les modes clair et sombre (si disponible)
6. **Option** : Mode zoom pour un affichage optimal
7. **Vérification** : Le script vérifie que gsettings a bien appliqué le fond d'écran

### Commande d'extraction

```bash
SCRIPT_PATH="$(readlink -f "$0")"
sed -n '/^__WALLPAPER_DATA__$/,${p}' "$SCRIPT_PATH" | tail -n +2 | base64 -d > "$WALLPAPER_FILE"
```

Cette commande :
- Utilise le chemin absolu du script (`readlink -f`)
- Extrait tout ce qui suit `__WALLPAPER_DATA__` dans le script
- Ignore la ligne du marqueur (`tail -n +2`)
- Décode le base64 vers un fichier PNG

### Configuration appliquée

```bash
gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_FILE"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_FILE" || true
gsettings set org.gnome.desktop.background picture-options 'zoom'
```

## ⚠️ IMPORTANT : Persistance du fichier

### Le fichier est PERMANENT et n'est JAMAIS supprimé automatiquement

✅ **Le fichier reste dans le système** :
- Après l'exécution du script
- Après un redémarrage
- Après une déconnexion/reconnexion
- Même si le script `install.sh` est supprimé

### Comportement lors de la restauration des défauts (Option 2)

Lorsque l'utilisateur choisit `--remove` ou l'option 2 du menu :

1. **Le fond d'écran par défaut est restauré** :
   ```bash
   gsettings reset org.gnome.desktop.background picture-uri
   ```

2. **Le fichier `enhanced-ubuntu-wallpaper.png` est CONSERVÉ par défaut**

3. **L'utilisateur est invité à choisir** :
   ```
   ⚠️  Souhaitez-vous également supprimer tous les fichiers installés ?
   Supprimer tous les fichiers installés ? [o/N]
   ```

   - **Si NON (défaut)** : Le fichier reste dans `~/.local/share/backgrounds/`
   - **Si OUI** : Le fichier est supprimé avec tous les autres fichiers personnalisés

## Avantages

✅ **Autonome** : Pas de dépendance externe  
✅ **Simple** : Un seul fichier à distribuer  
✅ **Fiable** : Pas de lien cassé ou de téléchargement  
✅ **Portable** : Fonctionne partout où bash est disponible  
✅ **Permanent** : Le fichier reste après l'exécution du script
✅ **Réutilisable** : Peut être restauré rapidement sans réexécuter le script

## Emplacements des fichiers

### Pendant l'installation
```
Script : install.sh (contient les données base64)
   ↓
Extraction et décodage
   ↓
Sauvegarde : ~/.local/share/backgrounds/enhanced-ubuntu-wallpaper.png (2.5 MB)
   ↓
Application : gsettings → GNOME affiche le fond d'écran
```

### Après l'installation
```
~/.local/share/backgrounds/enhanced-ubuntu-wallpaper.png
├─ Fichier PNG permanent (2.5 MB)
├─ Permissions : 644 (lisible par tous)
└─ Référencé par gsettings
```

## Test de validation

```bash
# Extraire et vérifier le fond d'écran
SCRIPT_PATH="$(readlink -f install.sh)"
sed -n '/^__WALLPAPER_DATA__$/,${p}' "$SCRIPT_PATH" | tail -n +2 | base64 -d > test.png
file test.png
# Devrait afficher : PNG image data, 1536 x 1024, 8-bit/color RGB

# Vérifier que le fichier installé existe
ls -lh ~/.local/share/backgrounds/enhanced-ubuntu-wallpaper.png

# Vérifier la configuration
gsettings get org.gnome.desktop.background picture-uri
# Devrait afficher : 'file:///home/USER/.local/share/backgrounds/enhanced-ubuntu-wallpaper.png'
```

## Dépannage

### Le fichier fait 0 octets
**Problème** : Le chemin du script n'est pas résolu correctement.  
**Solution** : Le script utilise maintenant `readlink -f "$0"` pour obtenir le chemin absolu.

### Le fond d'écran n'est pas appliqué
**Vérification** :
```bash
gsettings get org.gnome.desktop.background picture-uri
```
**Solution** : Réexécuter la partie application :
```bash
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.local/share/backgrounds/enhanced-ubuntu-wallpaper.png"
```

### Le fichier a disparu
**Cause** : L'utilisateur a choisi de supprimer tous les fichiers lors de la restauration des défauts.  
**Solution** : Réexécuter `./install.sh --install` pour recréer le fichier.

