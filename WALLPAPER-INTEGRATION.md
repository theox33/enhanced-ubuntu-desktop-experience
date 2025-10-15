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
- **Lignes 1021-1050** : Fonction d'installation du fond d'écran
- **Ligne 1221** : Marqueur `__WALLPAPER_DATA__`
- **Ligne 1222** : Données base64 du fond d'écran (une seule ligne)

### Processus d'installation

1. **Création du dossier** : `~/.local/share/backgrounds/`
2. **Extraction** : Les données après `__WALLPAPER_DATA__` sont extraites et décodées
3. **Sauvegarde** : Le fichier PNG est sauvegardé vers `~/.local/share/backgrounds/enhanced-ubuntu-wallpaper.png`
4. **Application** : Configuration via gsettings pour les modes clair et sombre
5. **Option** : Mode zoom pour un affichage optimal

### Commande d'extraction

```bash
sed -n '/^__WALLPAPER_DATA__$/,${p}' "$0" | tail -n +2 | base64 -d > "$WALLPAPER_FILE"
```

Cette commande :
- Extrait tout ce qui suit `__WALLPAPER_DATA__` dans le script
- Ignore la ligne du marqueur (`tail -n +2`)
- Décode le base64 vers un fichier PNG

### Configuration appliquée

```bash
gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_FILE"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_FILE"
gsettings set org.gnome.desktop.background picture-options 'zoom'
```

## Avantages

✅ **Autonome** : Pas de dépendance externe  
✅ **Simple** : Un seul fichier à distribuer  
✅ **Fiable** : Pas de lien cassé ou de téléchargement  
✅ **Portable** : Fonctionne partout où bash est disponible  

## Notes

- Le fichier `fondecran.png` original peut être conservé pour référence, mais n'est plus nécessaire au script
- L'encodage base64 augmente la taille de ~33%, ce qui est normal
- Le décodage est quasi-instantané même pour un fichier de 3.4 MB

## Test de validation

```bash
# Extraire et vérifier le fond d'écran
sed -n '/^__WALLPAPER_DATA__$/,${p}' install.sh | tail -n +2 | base64 -d > test.png
file test.png
# Devrait afficher : PNG image data, 1536 x 1024, 8-bit/color RGB
```
