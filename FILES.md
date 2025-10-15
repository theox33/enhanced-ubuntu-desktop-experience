# Guide des fichiers du projet

## 📁 Structure du projet

```
enhanced-ubuntu-desktop-experience/
├── install.sh                 ⭐ Script principal d'installation (v2 - UTILISEZ CELUI-CI)
├── install-old.sh.bak        📦 Ancienne version (v1 - pour référence uniquement)
├── README.md                 📖 Documentation principale du projet
├── CHANGELOG.md              📝 Historique des versions et changements
├── CRITIQUE.md               🔍 Analyse détaillée des problèmes de la v1
├── DIFFERENCES.md            🔄 Comparaison entre v1 et v2
├── FILES.md                  📋 Ce fichier - guide des fichiers
├── .gitignore                🚫 Fichiers à ignorer par Git
└── chat.txt                  💬 Conversation de développement (ignoré par Git)
```

## 📄 Description des fichiers

### 🚀 Fichiers principaux

#### `install.sh` ⭐
**LE FICHIER À UTILISER !**
- Script d'installation automatisé version 2.0
- Installe toute la configuration GNOME personnalisée
- Gestion d'erreurs robuste et intelligente
- 550 lignes, 22 KB
- Exécutable : `./install.sh`

#### `README.md`
- Documentation principale du projet
- Instructions d'installation
- Liste des fonctionnalités
- Guide de dépannage
- Informations sur les ressources

### 📚 Documentation

#### `CRITIQUE.md`
- Analyse critique complète de la version 1
- Liste des 11 problèmes identifiés
- Gravité de chaque problème (Critique/Majeur/Moyen/Mineur)
- Explications techniques détaillées
- Utile pour comprendre pourquoi v2 existe

#### `CHANGELOG.md`
- Historique des versions
- v2.0 : Améliorations majeures, corrections de bugs
- v1.0 : Version initiale avec problèmes
- Liste des changements entre versions

#### `DIFFERENCES.md`
- Comparaison technique v1 vs v2
- Exemples de code côte à côte
- Tableau comparatif des fonctionnalités
- Statistiques (lignes de code, taille, etc.)

#### `FILES.md`
- Ce fichier
- Guide de navigation du projet
- Description de chaque fichier

### 🗄️ Fichiers de référence

#### `install-old.sh.bak`
- Ancienne version du script (v1.0)
- **NE PAS UTILISER** - conservé pour référence
- 372 lignes, 18 KB
- Problème critique : installation des extensions cassée

### ⚙️ Configuration

#### `.gitignore`
- Fichiers à exclure du contrôle de version
- Ignore les backups, téléchargements, fichiers temporaires
- Ignore `chat.txt` (conversation de développement)

## 🎯 Démarrage rapide

### Pour installer la configuration :
```bash
cd enhanced-ubuntu-desktop-experience
./install.sh
```

### Pour comprendre le projet :
1. Lisez `README.md` - Vue d'ensemble et instructions
2. Lisez `CRITIQUE.md` - Pourquoi cette version existe
3. (Optionnel) `DIFFERENCES.md` - Détails techniques

### Pour contribuer :
1. Lisez `CHANGELOG.md` - Comprendre l'évolution
2. Lisez `CRITIQUE.md` - Connaître les pièges à éviter
3. Modifiez `install.sh` (pas `install-old.sh.bak` !)

## 📊 Métriques

| Type | Nombre | Taille totale |
|------|--------|---------------|
| Scripts exécutables | 2 | 40 KB |
| Documentation | 5 | ~20 KB |
| Configuration | 1 | <1 KB |
| **Total** | **8** | **~60 KB** |

## ⚠️ Important

- **Utilisez uniquement `install.sh`** (sans suffixe)
- `install-old.sh.bak` est conservé pour référence technique
- Si vous voulez l'ancienne version, renommez-la, mais elle ne fonctionnera pas correctement
- Lisez `CRITIQUE.md` pour comprendre pourquoi

## 🔗 Liens utiles

- Repository : https://github.com/theox33/enhanced-ubuntu-desktop-experience
- Issues : https://github.com/theox33/enhanced-ubuntu-desktop-experience/issues
- Documentation GNOME : https://extensions.gnome.org/
