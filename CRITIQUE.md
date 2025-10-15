# Analyse critique du script install.sh

## ❌ Problèmes critiques identifiés

### 1. **Installation des extensions GNOME - NE FONCTIONNE PAS**
**Ligne problématique :**
```bash
gnome-extensions install "$extension" --force
```

**Problème :** 
- `gnome-extensions install` nécessite un chemin vers un fichier `.zip` local
- Passer simplement le nom de l'extension (ex: `blur-my-shell@aunetx`) ne fonctionnera pas
- Cette commande va échouer pour toutes les extensions

**Impact :** 🔴 CRITIQUE - Aucune extension ne sera installée

**Solution :** Télécharger les extensions depuis extensions.gnome.org avec leur ID et la version de GNOME Shell

---

### 2. **`set -e` trop strict**
**Ligne problématique :**
```bash
set -e  # Arrêter le script en cas d'erreur
```

**Problème :**
- Le script s'arrête à la moindre erreur, même non-critique
- Si un téléchargement échoue, tout le script s'arrête
- Les commandes avec `||` ou `2>/dev/null` désactivent temporairement `set -e`

**Impact :** 🟠 MAJEUR - Le script peut s'arrêter prématurément

**Solution :** Utiliser une gestion d'erreurs manuelle avec des compteurs d'erreurs/warnings

---

### 3. **Outil `gnome-shell-extension-installer` obsolète**
**Lignes problématiques :**
```bash
wget -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
```

**Problème :**
- Le projet n'est plus maintenu depuis 2020
- Ne fonctionne plus avec les versions récentes de GNOME (42+)
- L'API d'extensions.gnome.org a changé

**Impact :** 🟠 MAJEUR - L'outil téléchargé ne fonctionnera probablement pas

**Solution :** Implémenter une fonction personnalisée pour télécharger depuis extensions.gnome.org

---

### 4. **Pas de vérification de version GNOME**
**Problème :**
- Les extensions sont spécifiques à une version de GNOME Shell
- Une extension pour GNOME 42 ne fonctionnera pas sur GNOME 46
- Le script ne vérifie pas la compatibilité

**Impact :** 🟠 MAJEUR - Extensions incompatibles

**Solution :** Détecter la version de GNOME et télécharger la version appropriée

---

### 5. **Gestion d'erreurs de téléchargement insuffisante**
**Lignes problématiques :**
```bash
if wget -O comfortaa.zip "https://dl.dafont.com/dl/?f=comfortaa"; then
    print_success "Comfortaa téléchargé"
else
    print_error "Échec du téléchargement de Comfortaa"
fi
```

**Problème :**
- L'erreur est affichée mais le script continue
- Plus tard, `unzip comfortaa.zip` échouera avec `set -e`, arrêtant tout
- Pas de vérification de la taille du fichier (peut être vide)

**Impact :** 🟡 MOYEN - Le script peut planter plus tard

**Solution :** Vérifier l'existence et la taille des fichiers avant extraction

---

### 6. **Nom du thème Lavanda potentiellement incorrect**
**Lignes problématiques :**
```bash
./install.sh -c dark -t blue --tweaks nord
# ...
gsettings set org.gnome.desktop.interface gtk-theme 'Lavanda-Sea'
```

**Problème :**
- Le thème installé pourrait s'appeler différemment (Lavanda-Dark-Sea, Lavanda-Blue, etc.)
- Les options du script d'installation peuvent avoir changé
- Pas de vérification que le thème existe après installation

**Impact :** 🟡 MOYEN - Le thème peut ne pas s'appliquer

**Solution :** Vérifier les noms de thèmes disponibles après installation

---

### 7. **Structure d'archive Comfortaa incertaine**
**Lignes problématiques :**
```bash
find comfortaa -name "*.ttf" -o -name "*.otf" | xargs -I {} cp {} "$HOME/.local/share/fonts/"
```

**Problème :**
- DaFont peut retourner différentes structures d'archive
- Le fichier peut ne pas être un zip valide
- Les polices peuvent être dans des sous-dossiers avec des noms variables

**Impact :** 🟡 MOYEN - Les polices peuvent ne pas être installées

**Solution :** Vérifier la structure après extraction et utiliser `find` avec `-type f`

---

### 8. **Nom du curseur après extraction incertain**
**Problème :**
- Le fichier tar.xz peut créer un dossier avec un nom différent
- Peut être "Bibata-Modern-Ice" ou "Bibata-Modern-Ice-Right"
- Le script suppose un nom spécifique

**Impact :** 🟡 MOYEN - Le curseur peut ne pas s'appliquer

**Solution :** Vérifier le nom du dossier créé après extraction

---

### 9. **Configuration Burn My Windows excessive**
**Problème :**
- 40+ lignes de `dconf write` pour désactiver tous les effets
- Certains effets peuvent ne pas exister selon la version
- Les clés dconf peuvent avoir changé

**Impact :** 🟢 MINEUR - Warnings possibles mais non bloquant

**Solution :** Utiliser `/dev/null` pour rediriger les erreurs ou vérifier les clés existantes

---

### 10. **Pas de vérification de connexion internet**
**Problème :**
- Le script nécessite une connexion internet active
- Aucune vérification initiale
- Les téléchargements échoueront silencieusement

**Impact :** 🟡 MOYEN - Expérience utilisateur dégradée

**Solution :** Vérifier la connectivité au début du script

---

### 11. **Permissions sudo non vérifiées**
**Problème :**
- Le script nécessite sudo
- Pas de vérification initiale
- L'utilisateur découvre le besoin au milieu du script

**Impact :** 🟢 MINEUR - Expérience utilisateur dégradée

**Solution :** Demander le mot de passe sudo au début ou vérifier les permissions

---

## 📊 Résumé

| Gravité | Nombre | Description |
|---------|--------|-------------|
| 🔴 CRITIQUE | 1 | Installation des extensions non fonctionnelle |
| 🟠 MAJEUR | 3 | Problèmes qui empêcheront certaines fonctionnalités |
| 🟡 MOYEN | 5 | Problèmes qui peuvent causer des échecs partiels |
| 🟢 MINEUR | 2 | Problèmes cosmétiques ou d'UX |

## ✅ Améliorations dans install-improved.sh

1. ✅ **Installation correcte des extensions** via l'API extensions.gnome.org
2. ✅ **Gestion d'erreurs robuste** avec compteurs et continuation
3. ✅ **Vérification de version GNOME** pour compatibilité
4. ✅ **Vérification de connexion internet** au démarrage
5. ✅ **Vérification des fichiers** avant extraction
6. ✅ **Vérification des noms de thèmes** après installation
7. ✅ **Rapport final** avec nombre d'erreurs et warnings
8. ✅ **Timeouts sur wget** pour éviter les blocages
9. ✅ **Compilation des schémas** pour les extensions
10. ✅ **Fallback automatique** pour les noms de thèmes/curseurs

## 🎯 Recommandation

**Utilisez `install-improved.sh`** au lieu de `install.sh` pour une installation beaucoup plus fiable et robuste.

Le script original a de bonnes intentions mais plusieurs problèmes techniques majeurs qui empêcheront son fonctionnement correct, notamment l'installation complète des extensions GNOME qui est le cœur de la configuration.
