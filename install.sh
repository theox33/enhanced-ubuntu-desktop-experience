#!/bin/bash

#==============================================================================
# Script d'installation de la configuration GNOME personnalisée
# Pour Ubuntu Desktop avec GNOME
# Version améliorée avec gestion d'erreurs robuste
#==============================================================================

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Compteurs d'erreurs
ERRORS=0
WARNINGS=0

# Fonction pour afficher les messages
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
    ((ERRORS++))
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
    ((WARNINGS++))
}

# Fonction pour vérifier si une commande existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Fonction pour vérifier le code de sortie
check_error() {
    if [ $? -ne 0 ]; then
        print_error "$1"
        return 1
    else
        print_success "$2"
        return 0
    fi
}

# Vérification de la connexion internet
print_status "Vérification de la connexion internet..."
if ping -c 1 google.com &> /dev/null; then
    print_success "Connexion internet OK"
else
    print_error "Pas de connexion internet. Le script nécessite une connexion active."
    exit 1
fi

# Vérification de la version de GNOME
print_status "Vérification de la version de GNOME Shell..."
GNOME_VERSION=$(gnome-shell --version | cut -d ' ' -f 3 | cut -d '.' -f 1)
if [ -z "$GNOME_VERSION" ]; then
    print_error "GNOME Shell n'est pas installé ou non détecté"
    exit 1
else
    print_success "GNOME Shell version $GNOME_VERSION détecté"
fi

#==============================================================================
# ÉTAPE 1: Mise à jour du système
#==============================================================================
print_status "Mise à jour du système..."
sudo apt update
if check_error "Échec de la mise à jour des dépôts" "Dépôts mis à jour"; then
    sudo apt upgrade -y
    check_error "Échec de la mise à niveau des paquets" "Système mis à jour"
fi

#==============================================================================
# ÉTAPE 2: Installation des applications nécessaires
#==============================================================================
print_status "Installation des applications nécessaires..."

# Installation de flatpak
if ! command_exists flatpak; then
    print_status "Installation de Flatpak..."
    sudo apt install -y flatpak
    check_error "Échec de l'installation de Flatpak" "Flatpak installé"
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    print_success "Flatpak déjà installé"
fi

# Installation de GNOME Tweaks (Ajustements)
if ! command_exists gnome-tweaks; then
    print_status "Installation de GNOME Tweaks..."
    sudo apt install -y gnome-tweaks
    check_error "Échec de l'installation de GNOME Tweaks" "GNOME Tweaks installé"
else
    print_success "GNOME Tweaks déjà installé"
fi

# Installation du gestionnaire d'extensions GNOME
if ! command_exists gnome-extensions; then
    print_status "Installation du gestionnaire d'extensions GNOME..."
    sudo apt install -y gnome-shell-extensions gnome-shell-extension-manager
    check_error "Échec de l'installation du gestionnaire d'extensions" "Gestionnaire d'extensions installé"
else
    print_success "Gestionnaire d'extensions déjà installé"
fi

# Installation d'outils nécessaires
print_status "Installation des outils nécessaires..."
sudo apt install -y wget unzip tar dconf-cli gir1.2-gtop-2.0 lm-sensors curl
check_error "Échec de l'installation des outils" "Outils installés"

# Installation de glib-compile-schemas (nécessaire pour certaines extensions)
sudo apt install -y libglib2.0-dev-bin
check_error "Échec de l'installation de glib-compile-schemas" "glib-compile-schemas installé"

#==============================================================================
# ÉTAPE 3: Création des dossiers nécessaires
#==============================================================================
print_status "Création des dossiers pour les ressources..."
mkdir -p "$HOME/.icons"
mkdir -p "$HOME/.themes"
mkdir -p "$HOME/.local/share/fonts"
mkdir -p "$HOME/.local/share/gnome-shell/extensions"
mkdir -p "$HOME/Downloads/gnome-config-temp"
print_success "Dossiers créés"

cd "$HOME/Downloads/gnome-config-temp"

#==============================================================================
# ÉTAPE 4: Téléchargement des ressources
#==============================================================================
print_status "Téléchargement des ressources..."

# Comfortaa
print_status "Téléchargement des polices Comfortaa..."
if wget --timeout=30 -O comfortaa.zip "https://dl.dafont.com/dl/?f=comfortaa" 2>/dev/null; then
    print_success "Comfortaa téléchargé"
else
    print_error "Échec du téléchargement de Comfortaa"
fi

# JetBrains Mono
print_status "Téléchargement de JetBrains Mono..."
if wget --timeout=30 -O JetBrainsMono.zip "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip" 2>/dev/null; then
    print_success "JetBrains Mono téléchargé"
else
    print_error "Échec du téléchargement de JetBrains Mono"
fi

# Bibata Cursor
print_status "Téléchargement du curseur Bibata-Modern-Ice..."
if wget --timeout=30 -O Bibata-Modern-Ice.tar.xz "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice-Right.tar.xz" 2>/dev/null; then
    print_success "Bibata-Modern-Ice téléchargé"
else
    print_error "Échec du téléchargement de Bibata-Modern-Ice"
fi

# Icônes Uos
print_status "Téléchargement des icônes Uos-fulldistro..."
if wget --timeout=30 -O Uos-fulldistro-icons.zip "https://github.com/zayronxio/Uos-fulldistro-icons/archive/refs/heads/master.zip" 2>/dev/null; then
    print_success "Uos-fulldistro-icons téléchargé"
else
    print_error "Échec du téléchargement de Uos-fulldistro-icons"
fi

# Thème Lavanda
print_status "Téléchargement du thème Lavanda..."
if wget --timeout=30 -O Lavanda-gtk-theme.tar.gz "https://github.com/vinceliuice/Lavanda-gtk-theme/archive/refs/tags/2024-04-28.tar.gz" 2>/dev/null; then
    print_success "Lavanda-gtk-theme téléchargé"
else
    print_error "Échec du téléchargement de Lavanda-gtk-theme"
fi

#==============================================================================
# ÉTAPE 5: Extraction et installation des polices
#==============================================================================
print_status "Installation des polices..."

# Comfortaa
if [ -f comfortaa.zip ]; then
    print_status "Extraction de Comfortaa..."
    unzip -o -q comfortaa.zip -d comfortaa 2>/dev/null
    if [ $? -eq 0 ]; then
        # Copie de tous les fichiers de police trouvés
        find comfortaa -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$HOME/.local/share/fonts/" \; 2>/dev/null
        if [ $? -eq 0 ]; then
            print_success "Comfortaa installé"
        else
            print_error "Impossible de copier les polices Comfortaa"
        fi
    else
        print_error "Impossible d'extraire Comfortaa"
    fi
else
    print_warning "Fichier Comfortaa non trouvé - sauté"
fi

# JetBrains Mono
if [ -f JetBrainsMono.zip ]; then
    print_status "Extraction de JetBrains Mono..."
    unzip -o -q JetBrainsMono.zip -d JetBrainsMono 2>/dev/null
    if [ $? -eq 0 ]; then
        find JetBrainsMono -type f -name "*.ttf" -exec cp {} "$HOME/.local/share/fonts/" \; 2>/dev/null
        if [ $? -eq 0 ]; then
            print_success "JetBrains Mono installé"
        else
            print_error "Impossible de copier les polices JetBrains Mono"
        fi
    else
        print_error "Impossible d'extraire JetBrains Mono"
    fi
else
    print_warning "Fichier JetBrains Mono non trouvé - sauté"
fi

# Mise à jour du cache des polices
print_status "Mise à jour du cache des polices..."
fc-cache -f -v > /dev/null 2>&1
check_error "Échec de la mise à jour du cache des polices" "Cache des polices mis à jour"

#==============================================================================
# ÉTAPE 6: Installation des curseurs
#==============================================================================
print_status "Installation des curseurs Bibata-Modern-Ice..."
if [ -f Bibata-Modern-Ice.tar.xz ]; then
    tar -xf Bibata-Modern-Ice.tar.xz -C "$HOME/.icons/" 2>/dev/null
    check_error "Échec de l'extraction des curseurs" "Curseurs Bibata-Modern-Ice installés"
else
    print_warning "Fichier Bibata-Modern-Ice non trouvé - sauté"
fi

#==============================================================================
# ÉTAPE 7: Installation des icônes
#==============================================================================
print_status "Installation des icônes Uos-fulldistro..."
if [ -f Uos-fulldistro-icons.zip ]; then
    unzip -o -q Uos-fulldistro-icons.zip 2>/dev/null
    if [ -d "Uos-fulldistro-icons-master" ]; then
        cp -r Uos-fulldistro-icons-master "$HOME/.icons/Uos-fulldistro-icons"
        check_error "Échec de la copie des icônes" "Icônes Uos-fulldistro installées"
    else
        print_error "Dossier Uos-fulldistro-icons-master non trouvé après extraction"
    fi
else
    print_warning "Fichier Uos-fulldistro-icons non trouvé - sauté"
fi

#==============================================================================
# ÉTAPE 8: Installation du thème Lavanda
#==============================================================================
print_status "Installation du thème Lavanda..."
if [ -f Lavanda-gtk-theme.tar.gz ]; then
    tar -xzf Lavanda-gtk-theme.tar.gz 2>/dev/null
    if [ -d "Lavanda-gtk-theme-2024-04-28" ]; then
        cd Lavanda-gtk-theme-2024-04-28
        # Installation avec gestion d'erreurs
        if [ -x "./install.sh" ]; then
            ./install.sh -c dark -t blue --tweaks nord 2>/dev/null || {
                print_warning "Installation automatique du thème échouée, tentative manuelle..."
                # Copie manuelle si le script échoue
                if [ -d "themes" ]; then
                    cp -r themes/* "$HOME/.themes/" 2>/dev/null
                fi
            }
            print_success "Thème Lavanda installé"
        else
            print_error "Script d'installation du thème Lavanda non trouvé ou non exécutable"
        fi
        cd ..
    else
        print_error "Dossier Lavanda-gtk-theme non trouvé après extraction"
    fi
else
    print_warning "Fichier Lavanda-gtk-theme non trouvé - sauté"
fi

#==============================================================================
# ÉTAPE 9: Installation des extensions GNOME
#==============================================================================
print_status "Installation des extensions GNOME..."

# Liste des extensions avec leurs IDs sur extensions.gnome.org
declare -A EXTENSIONS
EXTENSIONS=(
    ["blur-my-shell@aunetx"]="3193"
    ["burn-my-windows@schneegans.github.com"]="4679"
    ["clipboard-indicator@tudmotu.com"]="779"
    ["compiz-alike-magic-lamp-effect@hermes83.github.com"]="3740"
    ["compiz-windows-effect@hermes83.github.com"]="3210"
    ["CoverflowAltTab@palatis.blogspot.com"]="97"
    ["dash-to-dock@micxgx.gmail.com"]="307"
    ["desktop-cube@schneegans.github.com"]="4648"
    ["gsconnect@andyholmes.github.io"]="1319"
    ["mediacontrols@cliffniff.github.com"]="4470"
    ["search-light@ferrarodomenico.com"]="5489"
    ["user-theme@gnome-shell-extensions.gcampax.github.com"]="19"
)

# Fonction pour installer une extension depuis extensions.gnome.org
install_gnome_extension() {
    local extension_uuid="$1"
    local extension_id="$2"
    
    print_status "Installation de l'extension: $extension_uuid"
    
    # URL de l'extension
    local info_url="https://extensions.gnome.org/extension-info/?pk=${extension_id}&shell_version=${GNOME_VERSION}"
    
    # Récupération des informations de l'extension
    local download_url=$(curl -s "$info_url" | grep -o '"download_url":"[^"]*' | cut -d'"' -f4)
    
    if [ -z "$download_url" ]; then
        print_warning "Impossible de trouver l'URL de téléchargement pour $extension_uuid"
        return 1
    fi
    
    # Téléchargement de l'extension
    local extension_file="${extension_uuid}.zip"
    wget -q "https://extensions.gnome.org${download_url}" -O "$extension_file"
    
    if [ ! -f "$extension_file" ]; then
        print_warning "Échec du téléchargement de $extension_uuid"
        return 1
    fi
    
    # Installation de l'extension
    local extension_dir="$HOME/.local/share/gnome-shell/extensions/${extension_uuid}"
    mkdir -p "$extension_dir"
    unzip -o -q "$extension_file" -d "$extension_dir"
    
    if [ $? -eq 0 ]; then
        # Compilation des schémas si nécessaire
        if [ -d "$extension_dir/schemas" ]; then
            glib-compile-schemas "$extension_dir/schemas/" 2>/dev/null
        fi
        print_success "$extension_uuid installé"
        rm -f "$extension_file"
        return 0
    else
        print_warning "Échec de l'extraction de $extension_uuid"
        rm -f "$extension_file"
        return 1
    fi
}

# Installation de chaque extension
for extension_uuid in "${!EXTENSIONS[@]}"; do
    extension_id="${EXTENSIONS[$extension_uuid]}"
    install_gnome_extension "$extension_uuid" "$extension_id"
done

# Désactivation des extensions par défaut
print_status "Désactivation des extensions par défaut..."
gnome-extensions disable ubuntu-dock@ubuntu.com 2>/dev/null && print_success "ubuntu-dock désactivé" || print_warning "ubuntu-dock non trouvé"
gnome-extensions disable tiling-assistant@ubuntu.com 2>/dev/null && print_success "tiling-assistant désactivé" || print_warning "tiling-assistant non trouvé"

# Activation des nouvelles extensions
print_status "Activation des nouvelles extensions..."
for extension_uuid in "${!EXTENSIONS[@]}"; do
    gnome-extensions enable "$extension_uuid" 2>/dev/null && print_success "$extension_uuid activé" || print_warning "Impossible d'activer $extension_uuid"
done

#==============================================================================
# ÉTAPE 10: Configuration de Burn My Windows
#==============================================================================
print_status "Configuration de Burn My Windows (effet Hexagone)..."

# Désactivation de tous les effets
dconf write /org/gnome/shell/extensions/burn-my-windows/apparition-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/broken-glass-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/energize-a-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/energize-b-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/fire-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/glide-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/glitch-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/incinerate-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/matrix-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/paint-brush-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/pixelate-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/pixel-wheel-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/pixel-wipe-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/portal-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/snap-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/t-rex-attack-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/tv-effect-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/tv-glitch-close-effect false 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/wisps-close-effect false 2>/dev/null

# Activation de l'effet Hexagone
dconf write /org/gnome/shell/extensions/burn-my-windows/hexagon-close-effect true 2>/dev/null
dconf write /org/gnome/shell/extensions/burn-my-windows/hexagon-animation-time 500 2>/dev/null

check_error "Échec de la configuration de Burn My Windows" "Burn My Windows configuré avec l'effet Hexagone"

#==============================================================================
# ÉTAPE 11: Application des thèmes via GNOME Tweaks
#==============================================================================
print_status "Application des paramètres d'apparence..."

# Polices
gsettings set org.gnome.desktop.interface font-name 'Comfortaa 11' 2>/dev/null
gsettings set org.gnome.desktop.interface document-font-name 'JetBrains Mono 11' 2>/dev/null
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10' 2>/dev/null
check_error "Échec de l'application des polices" "Polices appliquées"

# Thème d'icônes
gsettings set org.gnome.desktop.interface icon-theme 'Uos-fulldistro-icons' 2>/dev/null
check_error "Échec de l'application du thème d'icônes" "Thème d'icônes appliqué"

# Thème de curseurs (vérifier le nom exact)
CURSOR_NAME="Bibata-Modern-Ice"
if [ -d "$HOME/.icons/$CURSOR_NAME" ]; then
    gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_NAME" 2>/dev/null
    check_error "Échec de l'application du thème de curseurs" "Thème de curseurs appliqué"
else
    print_warning "Le dossier du curseur $CURSOR_NAME n'existe pas, vérification des alternatives..."
    # Chercher un nom similaire
    FOUND_CURSOR=$(ls "$HOME/.icons/" | grep -i bibata | head -n 1)
    if [ -n "$FOUND_CURSOR" ]; then
        gsettings set org.gnome.desktop.interface cursor-theme "$FOUND_CURSOR" 2>/dev/null
        print_success "Thème de curseurs appliqué: $FOUND_CURSOR"
    else
        print_error "Aucun curseur Bibata trouvé"
    fi
fi

# Thème GTK
THEME_NAME="Lavanda-Sea"
if [ -d "$HOME/.themes/$THEME_NAME" ] || [ -d "/usr/share/themes/$THEME_NAME" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME" 2>/dev/null
    check_error "Échec de l'application du thème GTK" "Thème GTK appliqué"
else
    print_warning "Thème $THEME_NAME non trouvé, recherche d'alternatives..."
    FOUND_THEME=$(ls "$HOME/.themes/" 2>/dev/null | grep -i lavanda | head -n 1)
    if [ -n "$FOUND_THEME" ]; then
        gsettings set org.gnome.desktop.interface gtk-theme "$FOUND_THEME" 2>/dev/null
        print_success "Thème GTK appliqué: $FOUND_THEME"
        THEME_NAME="$FOUND_THEME"
    else
        print_error "Aucun thème Lavanda trouvé"
    fi
fi

# Thème Shell (nécessite l'extension user-theme)
gsettings set org.gnome.shell.extensions.user-theme name "$THEME_NAME" 2>/dev/null
check_error "Échec de l'application du thème Shell" "Thème Shell appliqué"

#==============================================================================
# ÉTAPE 12: Nettoyage
#==============================================================================
print_status "Nettoyage des fichiers temporaires..."
cd "$HOME"
rm -rf "$HOME/Downloads/gnome-config-temp"
check_error "Échec du nettoyage" "Nettoyage terminé"

#==============================================================================
# RAPPORT FINAL
#==============================================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║  ✓ Installation terminée !                                 ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}║  Aucune erreur détectée                                    ║${NC}"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}║  $WARNINGS avertissement(s) détecté(s)                          ║${NC}"
else
    echo -e "${RED}║  $ERRORS erreur(s) et $WARNINGS avertissement(s) détecté(s)            ║${NC}"
fi
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║  Veuillez redémarrer votre session GNOME :                 ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║  1. Déconnectez-vous                                       ║${NC}"
echo -e "${GREEN}║  2. Reconnectez-vous                                       ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║  Ou utilisez : Alt+F2 → tapez 'r' → Entrée                ║${NC}"
echo -e "${GREEN}║  (pour redémarrer GNOME Shell en session X11)             ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

if [ $ERRORS -gt 0 ]; then
    print_warning "Certaines étapes ont échoué. Vérifiez les messages ci-dessus."
    print_warning "Vous pouvez installer manuellement les éléments manquants via:"
    print_warning "  - GNOME Tweaks pour les thèmes"
    print_warning "  - Gestionnaire d'extensions pour les extensions"
fi

echo ""
exit 0
