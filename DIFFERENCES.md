# Comparaison install.sh v1 vs v2

Ce document explique les différences entre l'ancienne version (`install-old.sh.bak`) et la nouvelle version (`install.sh`).

## 📊 Statistiques

| Métrique | v1 (old) | v2 (new) | Différence |
|----------|----------|----------|------------|
| Lignes de code | 372 | 550 | +178 (+48%) |
| Taille fichier | 18 KB | 22 KB | +4 KB (+22%) |
| Fonctions | 4 | 5 | +1 |
| Vérifications | 0 | 5 | +5 |

## 🔄 Changements principaux

### 1. Installation des extensions GNOME

**❌ v1 (NE FONCTIONNE PAS):**
```bash
gnome-extensions install "$extension" --force
```

**✅ v2 (FONCTIONNE):**
```bash
install_gnome_extension() {
    local extension_uuid="$1"
    local extension_id="$2"
    local info_url="https://extensions.gnome.org/extension-info/?pk=${extension_id}&shell_version=${GNOME_VERSION}"
    local download_url=$(curl -s "$info_url" | grep -o '"download_url":"[^"]*' | cut -d'"' -f4)
    wget -q "https://extensions.gnome.org${download_url}" -O "$extension_file"
    unzip -o -q "$extension_file" -d "$extension_dir"
    glib-compile-schemas "$extension_dir/schemas/" 2>/dev/null
}
```

### 2. Gestion des erreurs

**❌ v1:**
```bash
set -e  # Arrête tout à la première erreur
```

**✅ v2:**
```bash
# Pas de set -e
ERRORS=0
WARNINGS=0

check_error() {
    if [ $? -ne 0 ]; then
        print_error "$1"
        ((ERRORS++))
        return 1
    else
        print_success "$2"
        return 0
    fi
}
```

### 3. Vérifications au démarrage

**❌ v1:**
- Aucune vérification préalable
- Commence directement l'installation

**✅ v2:**
```bash
# Vérification de la connexion internet
ping -c 1 google.com &> /dev/null

# Vérification de la version de GNOME
GNOME_VERSION=$(gnome-shell --version | cut -d ' ' -f 3 | cut -d '.' -f 1)
```

### 4. Téléchargements

**❌ v1:**
```bash
wget -O comfortaa.zip "https://dl.dafont.com/dl/?f=comfortaa"
```

**✅ v2:**
```bash
wget --timeout=30 -O comfortaa.zip "https://dl.dafont.com/dl/?f=comfortaa" 2>/dev/null
```

### 5. Application des thèmes

**❌ v1:**
```bash
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
# Suppose que le nom est exactement celui-ci
```

**✅ v2:**
```bash
CURSOR_NAME="Bibata-Modern-Ice"
if [ -d "$HOME/.icons/$CURSOR_NAME" ]; then
    gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_NAME"
else
    # Recherche automatique d'alternatives
    FOUND_CURSOR=$(ls "$HOME/.icons/" | grep -i bibata | head -n 1)
    if [ -n "$FOUND_CURSOR" ]; then
        gsettings set org.gnome.desktop.interface cursor-theme "$FOUND_CURSOR"
    fi
fi
```

### 6. Rapport final

**❌ v1:**
```
╔════════════════════════════════════════════════════════════╗
║  ✓ Installation terminée avec succès !                     ║
╚════════════════════════════════════════════════════════════╝
```

**✅ v2:**
```
╔════════════════════════════════════════════════════════════╗
║  ✓ Installation terminée !                                 ║
║  2 erreur(s) et 5 avertissement(s) détecté(s)              ║
║  Certaines étapes ont échoué. Vérifiez les messages.      ║
╚════════════════════════════════════════════════════════════╝
```

## 🎯 Résumé des améliorations

| Fonctionnalité | v1 | v2 |
|----------------|----|----|
| Installation extensions GNOME | ❌ Cassé | ✅ Fonctionne |
| Gestion d'erreurs | ❌ set -e strict | ✅ Continue avec compteurs |
| Vérification GNOME version | ❌ Non | ✅ Oui |
| Vérification internet | ❌ Non | ✅ Oui |
| Timeouts téléchargements | ❌ Non | ✅ 30 secondes |
| Détection auto noms thèmes | ❌ Non | ✅ Oui (fallback) |
| Rapport d'erreurs | ❌ Basique | ✅ Détaillé avec stats |
| Compilation schémas | ❌ Non | ✅ glib-compile-schemas |
| Résilience globale | 🟡 Faible | 🟢 Élevée |

## 💡 Recommandation

**Utilisez `install.sh` (v2)** - L'ancienne version est conservée dans `install-old.sh.bak` uniquement pour référence.

La version 2 est **beaucoup plus fiable** et gère bien mieux les erreurs, ce qui est crucial pour un script d'installation automatisé sur différentes configurations Ubuntu.
