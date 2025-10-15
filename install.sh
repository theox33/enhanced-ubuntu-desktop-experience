#!/bin/bash

#==============================================================================
# Script d'installation de la configuration GNOME personnalisée
# Pour Ubuntu Desktop avec GNOME
# Version 2.2.0 - Menu interactif, activation extensions, backup/restore
#==============================================================================

VERSION="2.2.0"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Compteurs d'erreurs
ERRORS=0
WARNINGS=0

# Options du script
DRY_RUN=false
VERBOSE=false
INTERACTIVE=true
SKIP_UPGRADE=false
LOG_FILE="$HOME/gnome-install-$(date +%Y%m%d-%H%M%S).log"
ACTION="" # install, remove, backup, restore

# Fonction pour afficher l'aide
show_help() {
    cat << EOF
╔════════════════════════════════════════════════════════════════════════╗
║  Enhanced Ubuntu Desktop Experience - Installeur v${VERSION}           ║
╚════════════════════════════════════════════════════════════════════════╝

Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help              Afficher cette aide
    -v, --verbose           Mode verbeux (afficher plus de détails)
    -y, --non-interactive   Mode non-interactif (pas de questions)
    -d, --dry-run           Simuler l'installation sans rien modifier
    --skip-upgrade          Sauter la mise à niveau du système (apt upgrade)
    --log FILE              Chemin personnalisé pour le fichier de log
                            (défaut: ~/gnome-install-YYYYMMDD-HHMMSS.log)
    --install               Installer directement (sans menu)
    --remove                Restaurer les thèmes par défaut
    --backup                Créer uniquement un backup
    --restore               Restaurer depuis un backup

EXEMPLES:
    $0                      Menu interactif
    $0 --install            Installation directe
    $0 --remove             Désinstaller et restaurer défauts Ubuntu
    $0 --backup             Créer un backup seulement
    $0 -y --install         Installation automatique
    $0 -d                   Simuler l'installation
    $0 -v --skip-upgrade    Mode verbeux sans mise à niveau système
    $0 -y --log /tmp/install.log  Installation auto avec log personnalisé

DESCRIPTION:
    Ce script installe une configuration GNOME personnalisée avec:
    - Polices: Comfortaa, JetBrains Mono
    - Thème: Lavanda-Sea
    - Icônes: Uos-fulldistro-icons
    - Curseurs: Bibata-Modern-Ice
    - 12 extensions GNOME

Le script crée automatiquement un fichier de log dans votre dossier personnel.

EOF
    exit 0
}

# Parse des arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -y|--non-interactive)
            INTERACTIVE=false
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
            INTERACTIVE=false
            shift
            ;;
        --skip-upgrade)
            SKIP_UPGRADE=true
            shift
            ;;
        --log)
            LOG_FILE="$2"
            shift 2
            ;;
        --install)
            ACTION="install"
            shift
            ;;
        --remove)
            ACTION="remove"
            shift
            ;;
        --backup)
            ACTION="backup"
            shift
            ;;
        --restore)
            ACTION="restore"
            shift
            ;;
        *)
            echo "Option inconnue: $1"
            echo "Utilisez --help pour voir les options disponibles"
            exit 1
            ;;
    esac
done

# Fonction de logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Fonctions d'affichage améliorées
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
    log "INFO: $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
    log "SUCCESS: $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
    log "ERROR: $1"
    ((ERRORS++))
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
    log "WARNING: $1"
    ((WARNINGS++))
}

print_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${CYAN}[DEBUG]${NC} $1"
        log "DEBUG: $1"
    fi
}

print_dry_run() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${MAGENTA}[DRY-RUN]${NC} $1"
        log "DRY-RUN: $1"
    fi
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

# Fonction pour demander confirmation
ask_confirmation() {
    if [ "$INTERACTIVE" = false ]; then
        return 0
    fi
    
    local question="$1"
    local default="${2:-y}"
    
    if [ "$default" = "y" ]; then
        read -p "$question [O/n] " -n 1 -r
    else
        read -p "$question [o/N] " -n 1 -r
    fi
    echo
    
    if [[ $REPLY =~ ^[OoYy]$ ]] || [[ -z $REPLY && $default = "y" ]]; then
        return 0
    else
        return 1
    fi
}

# Fonction pour vérifier l'espace disque
check_disk_space() {
    local required_mb=500
    local available_mb=$(df -m "$HOME" | awk 'NR==2 {print $4}')
    
    print_verbose "Espace disque disponible: ${available_mb} MB (requis: ${required_mb} MB)"
    
    if [ "$available_mb" -lt "$required_mb" ]; then
        print_error "Espace disque insuffisant! Requis: ${required_mb} MB, Disponible: ${available_mb} MB"
        return 1
    else
        print_success "Espace disque suffisant (${available_mb} MB disponibles)"
        return 0
    fi
}

# Fonction pour créer un point de restauration (backup des paramètres)
create_backup() {
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Création d'un backup des paramètres actuels"
        return 0
    fi
    
    local backup_dir="$HOME/.gnome-config-backup-$(date +%Y%m%d-%H%M%S)"
    print_status "Création d'un backup des paramètres actuels dans $backup_dir"
    
    mkdir -p "$backup_dir"
    
    # Backup des paramètres gsettings
    dconf dump /org/gnome/desktop/ > "$backup_dir/desktop-settings.dconf" 2>/dev/null
    dconf dump /org/gnome/shell/ > "$backup_dir/shell-settings.dconf" 2>/dev/null
    
    # Liste des extensions actuellement activées
    gnome-extensions list --enabled > "$backup_dir/enabled-extensions.txt" 2>/dev/null
    
    print_success "Backup créé: $backup_dir"
    log "Backup créé dans: $backup_dir"
    
    echo "$backup_dir" > "$HOME/.gnome-config-last-backup"
}

# Fonction pour restaurer depuis un backup
restore_backup() {
    local backup_dir="$1"
    
    if [ -z "$backup_dir" ] && [ -f "$HOME/.gnome-config-last-backup" ]; then
        backup_dir=$(cat "$HOME/.gnome-config-last-backup")
    fi
    
    if [ -z "$backup_dir" ] || [ ! -d "$backup_dir" ]; then
        print_error "Aucun backup trouvé"
        return 1
    fi
    
    print_status "Restauration depuis: $backup_dir"
    
    if [ -f "$backup_dir/desktop-settings.dconf" ]; then
        dconf load /org/gnome/desktop/ < "$backup_dir/desktop-settings.dconf"
    fi
    
    if [ -f "$backup_dir/shell-settings.dconf" ]; then
        dconf load /org/gnome/shell/ < "$backup_dir/shell-settings.dconf"
    fi
    
    if [ -f "$backup_dir/enabled-extensions.txt" ]; then
        # Désactiver toutes les extensions actuelles
        gnome-extensions list --enabled | while read ext; do
            gnome-extensions disable "$ext" 2>/dev/null
        done
        
        # Réactiver les extensions du backup
        while read ext; do
            gnome-extensions enable "$ext" 2>/dev/null
        done < "$backup_dir/enabled-extensions.txt"
    fi
    
    print_success "Restauration terminée"
}

# Fonction pour restaurer les paramètres par défaut Ubuntu
restore_defaults() {
    print_status "Restauration des paramètres par défaut Ubuntu..."
    
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Restauration des paramètres par défaut"
        return 0
    fi
    
    # Désactiver toutes les extensions personnalisées
    print_status "Désactivation des extensions personnalisées..."
    declare -A EXTENSIONS=(
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
    
    for extension_uuid in "${!EXTENSIONS[@]}"; do
        gnome-extensions disable "$extension_uuid" 2>/dev/null
        print_verbose "$extension_uuid désactivé"
    done
    
    # Réactiver les extensions Ubuntu par défaut
    print_status "Réactivation des extensions Ubuntu par défaut..."
    gnome-extensions enable ubuntu-dock@ubuntu.com 2>/dev/null && print_verbose "ubuntu-dock activé"
    gnome-extensions enable tiling-assistant@ubuntu.com 2>/dev/null && print_verbose "tiling-assistant activé"
    gnome-extensions enable ubuntu-appindicators@ubuntu.com 2>/dev/null && print_verbose "ubuntu-appindicators activé"
    
    # Restaurer les thèmes par défaut
    print_status "Restauration des thèmes par défaut..."
    gsettings reset org.gnome.desktop.interface gtk-theme 2>/dev/null
    gsettings reset org.gnome.desktop.interface icon-theme 2>/dev/null
    gsettings reset org.gnome.desktop.interface cursor-theme 2>/dev/null
    gsettings reset org.gnome.desktop.interface font-name 2>/dev/null
    gsettings reset org.gnome.desktop.interface document-font-name 2>/dev/null
    gsettings reset org.gnome.desktop.interface monospace-font-name 2>/dev/null
    gsettings reset org.gnome.shell.extensions.user-theme name 2>/dev/null
    
    print_success "Paramètres par défaut Ubuntu restaurés"
    print_status "Les fichiers personnalisés (thèmes, icônes, polices) restent installés dans ~/.themes, ~/.icons et ~/.local/share/fonts"
    print_status "Pour les supprimer complètement, exécutez: rm -rf ~/.themes/Lavanda* ~/.icons/Uos* ~/.icons/Bibata*"
}

# Fonction pour afficher le menu principal
show_menu() {
    echo -e "${CYAN}"
    cat << "EOF"
╔════════════════════════════════════════════════════════════════════════╗
║                          MENU PRINCIPAL                                ║
╚════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${GREEN}1)${NC} Installer la configuration GNOME personnalisée"
    echo -e "${YELLOW}2)${NC} Restaurer les paramètres par défaut Ubuntu"
    echo -e "${BLUE}3)${NC} Créer un backup des paramètres actuels"
    echo -e "${MAGENTA}4)${NC} Restaurer depuis un backup précédent"
    echo -e "${RED}5)${NC} Quitter"
    echo ""
    
    read -p "Choisissez une option [1-5]: " choice
    
    case $choice in
        1)
            ACTION="install"
            ;;
        2)
            ACTION="remove"
            ;;
        3)
            ACTION="backup"
            ;;
        4)
            ACTION="restore"
            ;;
        5)
            echo "Au revoir!"
            exit 0
            ;;
        *)
            echo -e "${RED}Option invalide!${NC}"
            exit 1
            ;;
    esac
}

#==============================================================================
# DÉBUT DU SCRIPT
#==============================================================================

# Banner
echo -e "${CYAN}"
cat << "EOF"
╔════════════════════════════════════════════════════════════════════════╗
║                                                                        ║
║     ███████╗███╗   ██╗██╗  ██╗ █████╗ ███╗   ██╗ ██████╗███████╗       ║
║     ██╔════╝████╗  ██║██║  ██║██╔══██╗████╗  ██║██╔════╝██╔════╝       ║
║     █████╗  ██╔██╗ ██║███████║███████║██╔██╗ ██║██║     █████╗         ║
║     ██╔══╝  ██║╚██╗██║██╔══██║██╔══██║██║╚██╗██║██║     ██╔══╝         ║
║     ███████╗██║ ╚████║██║  ██║██║  ██║██║ ╚████║╚██████╗███████╗       ║
║     ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝       ║
║                                                                        ║
║            Ubuntu GNOME Desktop Experience Installer                   ║
║                         Version 2.1.1                                  ║
║                                                                        ║
╚════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

print_status "Initialisation du script d'installation..."
print_status "Fichier de log: $LOG_FILE"
log "=== Début de l'installation - Version $VERSION ==="
log "Options: DRY_RUN=$DRY_RUN, VERBOSE=$VERBOSE, INTERACTIVE=$INTERACTIVE, SKIP_UPGRADE=$SKIP_UPGRADE"

if [ "$DRY_RUN" = true ]; then
    echo -e "${MAGENTA}"
    echo "╔════════════════════════════════════════════════════════════════════════╗"
    echo "║  MODE DRY-RUN ACTIVÉ - Aucune modification ne sera effectuée          ║"
    echo "╚════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
fi

# Afficher le menu si aucune action n'est spécifiée
if [ -z "$ACTION" ] && [ "$INTERACTIVE" = true ] && [ "$DRY_RUN" = false ]; then
    show_menu
fi

# Si action est backup uniquement
if [ "$ACTION" = "backup" ]; then
    create_backup
    print_success "Backup créé avec succès!"
    exit 0
fi

# Si action est restore uniquement
if [ "$ACTION" = "restore" ]; then
    if [ "$INTERACTIVE" = true ]; then
        echo "Backups disponibles:"
        ls -dt "$HOME"/.gnome-config-backup-* 2>/dev/null | head -5 | nl
        echo ""
        read -p "Entrez le chemin complet du backup à restaurer (ou Entrée pour le dernier): " backup_path
    fi
    restore_backup "$backup_path"
    exit 0
fi

# Si action est remove
if [ "$ACTION" = "remove" ]; then
    if [ "$INTERACTIVE" = true ]; then
        echo ""
        echo -e "${YELLOW}⚠️  Cette action va restaurer les paramètres par défaut Ubuntu${NC}"
        if ! ask_confirmation "Voulez-vous continuer?"; then
            print_warning "Opération annulée"
            exit 0
        fi
    fi
    restore_defaults
    print_success "Restauration terminée! Reconnectez-vous pour appliquer les changements."
    exit 0
fi

# Sinon, continuer avec l'installation (ACTION=install ou pas d'ACTION en mode non-interactif)

# Vérification de l'espace disque
print_status "Vérification de l'espace disque disponible..."
if ! check_disk_space; then
    if [ "$INTERACTIVE" = true ]; then
        if ! ask_confirmation "Continuer malgré l'espace insuffisant?" "n"; then
            print_error "Installation annulée par l'utilisateur"
            exit 1
        fi
    else
        exit 1
    fi
fi

# Vérification de la connexion internet
print_status "Vérification de la connexion internet..."

# Essayer plusieurs méthodes pour détecter la connexion
check_internet() {
    # Méthode 1: wget (plus fiable que ping)
    if command_exists wget; then
        if wget -q --spider --timeout=5 http://www.google.com 2>/dev/null; then
            return 0
        fi
    fi
    
    # Méthode 2: curl
    if command_exists curl; then
        if curl -s --max-time 5 --head http://www.google.com &>/dev/null; then
            return 0
        fi
    fi
    
    # Méthode 3: ping (fallback)
    if ping -c 1 -W 3 8.8.8.8 &> /dev/null; then
        return 0
    fi
    
    return 1
}

if check_internet; then
    print_success "Connexion internet OK"
else
    print_warning "Impossible de vérifier la connexion internet"
    if [ "$INTERACTIVE" = true ]; then
        if ! ask_confirmation "Continuer malgré l'impossibilité de vérifier la connexion?" "n"; then
            print_error "Installation annulée par l'utilisateur"
            exit 1
        fi
    else
        print_error "Pas de connexion internet détectée. Le script nécessite une connexion active."
        exit 1
    fi
fi

# Vérification de la version de GNOME
print_status "Vérification de la version de GNOME Shell..."
if command_exists gnome-shell; then
    GNOME_VERSION=$(gnome-shell --version 2>/dev/null | grep -oP '\d+' | head -1)
    if [ -n "$GNOME_VERSION" ]; then
        print_success "GNOME Shell version $GNOME_VERSION détecté"
        print_verbose "Version complète: $(gnome-shell --version)"
    else
        print_error "Impossible de détecter la version de GNOME Shell"
        exit 1
    fi
else
    print_error "GNOME Shell n'est pas installé ou non détecté"
    exit 1
fi

# Vérification des droits sudo
print_status "Vérification des permissions sudo..."
if [ "$DRY_RUN" = false ]; then
    if ! sudo -v; then
        print_error "Ce script nécessite des permissions sudo"
        exit 1
    fi
    print_success "Permissions sudo OK"
    # Garder sudo actif pendant le script
    (while true; do sudo -v; sleep 50; done) &
    SUDO_KEEPER_PID=$!
    trap "kill $SUDO_KEEPER_PID 2>/dev/null" EXIT
fi

# Création du backup
if [ "$INTERACTIVE" = true ]; then
    if ask_confirmation "Créer un backup des paramètres actuels?"; then
        create_backup
    fi
else
    create_backup
fi

# Confirmation finale en mode interactif
if [ "$INTERACTIVE" = true ] && [ "$DRY_RUN" = false ]; then
    echo ""
    echo -e "${YELLOW}Cette installation va:${NC}"
    echo "  • Installer/mettre à jour des paquets système"
    echo "  • Télécharger ~100 MB de ressources"
    echo "  • Installer 12 extensions GNOME"
    echo "  • Modifier les thèmes et polices système"
    echo ""
    if ! ask_confirmation "Continuer l'installation?"; then
        print_warning "Installation annulée par l'utilisateur"
        exit 0
    fi
fi

#==============================================================================
# ÉTAPE 1: Mise à jour du système
#==============================================================================
print_status "Mise à jour des dépôts de paquets..."

if [ "$DRY_RUN" = false ]; then
    sudo apt update
    check_error "Échec de la mise à jour des dépôts" "Dépôts mis à jour"
    
    if [ "$SKIP_UPGRADE" = false ]; then
        if [ "$INTERACTIVE" = true ]; then
            if ask_confirmation "Mettre à niveau les paquets système? (peut prendre du temps)"; then
                sudo apt upgrade -y
                check_error "Échec de la mise à niveau" "Système mis à jour"
            else
                print_warning "Mise à niveau système ignorée"
            fi
        else
            sudo apt upgrade -y
            check_error "Échec de la mise à niveau" "Système mis à jour"
        fi
    else
        print_warning "Mise à niveau système ignorée (--skip-upgrade)"
    fi
else
    print_dry_run "apt update && apt upgrade -y"
fi

#==============================================================================
# ÉTAPE 2: Installation des applications nécessaires
#==============================================================================
print_status "Installation des applications nécessaires..."

PACKAGES=(
    "flatpak"
    "gnome-tweaks"
    "gnome-shell-extensions"
    "gnome-shell-extension-manager"
    "wget"
    "unzip"
    "tar"
    "dconf-cli"
    "gir1.2-gtop-2.0"
    "lm-sensors"
    "curl"
    "libglib2.0-dev-bin"
)

for package in "${PACKAGES[@]}"; do
    if command_exists "$package" || dpkg -l | grep -q "^ii  $package "; then
        print_verbose "$package déjà installé"
    else
        print_status "Installation de $package..."
        if [ "$DRY_RUN" = false ]; then
            sudo apt install -y "$package"
            check_error "Échec de l'installation de $package" "$package installé"
        else
            print_dry_run "apt install -y $package"
        fi
    fi
done

# Configuration de Flatpak
if [ "$DRY_RUN" = false ]; then
    if ! flatpak remote-list | grep -q flathub; then
        print_status "Ajout du dépôt Flathub..."
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        print_success "Dépôt Flathub ajouté"
    else
        print_verbose "Dépôt Flathub déjà configuré"
    fi
else
    print_dry_run "flatpak remote-add --if-not-exists flathub ..."
fi

#==============================================================================
# ÉTAPE 3: Création des dossiers nécessaires
#==============================================================================
print_status "Création des dossiers pour les ressources..."

DIRS=(
    "$HOME/.icons"
    "$HOME/.themes"
    "$HOME/.local/share/fonts"
    "$HOME/.local/share/gnome-shell/extensions"
    "$HOME/Downloads/gnome-config-temp"
)

for dir in "${DIRS[@]}"; do
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$dir"
        print_verbose "Dossier créé/vérifié: $dir"
    else
        print_dry_run "mkdir -p $dir"
    fi
done

print_success "Dossiers créés"

if [ "$DRY_RUN" = false ]; then
    cd "$HOME/Downloads/gnome-config-temp"
fi

#==============================================================================
# ÉTAPE 4: Téléchargement des ressources
#==============================================================================
print_status "Téléchargement des ressources (peut prendre quelques minutes)..."

declare -A DOWNLOADS=(
    ["comfortaa.zip"]="https://dl.dafont.com/dl/?f=comfortaa"
    ["JetBrainsMono.zip"]="https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
    ["Bibata-Modern-Ice.tar.xz"]="https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice-Right.tar.xz"
    ["Uos-fulldistro-icons.zip"]="https://github.com/zayronxio/Uos-fulldistro-icons/archive/refs/heads/master.zip"
    ["Lavanda-gtk-theme.tar.gz"]="https://github.com/vinceliuice/Lavanda-gtk-theme/archive/refs/tags/2024-04-28.tar.gz"
)

for file in "${!DOWNLOADS[@]}"; do
    url="${DOWNLOADS[$file]}"
    print_status "Téléchargement de $file..."
    
    if [ "$DRY_RUN" = false ]; then
        if wget --timeout=30 --tries=3 -O "$file" "$url" 2>/dev/null; then
            # Vérification de la taille du fichier
            size=$(stat -c%s "$file" 2>/dev/null || echo "0")
            if [ "$size" -gt 1000 ]; then
                print_success "$file téléchargé ($(numfmt --to=iec-i --suffix=B $size))"
            else
                print_error "$file téléchargé mais semble invalide (taille: $size bytes)"
                rm -f "$file"
            fi
        else
            print_error "Échec du téléchargement de $file"
        fi
    else
        print_dry_run "wget $url -O $file"
    fi
done

#==============================================================================
# ÉTAPE 5: Extraction et installation des polices
#==============================================================================
print_status "Installation des polices..."

# Comfortaa
if [ -f "comfortaa.zip" ] || [ "$DRY_RUN" = true ]; then
    print_status "Extraction de Comfortaa..."
    if [ "$DRY_RUN" = false ]; then
        unzip -o -q comfortaa.zip -d comfortaa 2>/dev/null
        if [ $? -eq 0 ]; then
            font_count=$(find comfortaa -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$HOME/.local/share/fonts/" \; -print | wc -l)
            if [ "$font_count" -gt 0 ]; then
                print_success "Comfortaa installé ($font_count fichiers de police)"
            else
                print_error "Aucune police trouvée dans l'archive Comfortaa"
            fi
        else
            print_error "Impossible d'extraire Comfortaa"
        fi
    else
        print_dry_run "Extraction et installation de Comfortaa"
    fi
else
    print_warning "Fichier Comfortaa non trouvé - sauté"
fi

# JetBrains Mono
if [ -f "JetBrainsMono.zip" ] || [ "$DRY_RUN" = true ]; then
    print_status "Extraction de JetBrains Mono..."
    if [ "$DRY_RUN" = false ]; then
        unzip -o -q JetBrainsMono.zip -d JetBrainsMono 2>/dev/null
        if [ $? -eq 0 ]; then
            font_count=$(find JetBrainsMono -type f -name "*.ttf" -exec cp {} "$HOME/.local/share/fonts/" \; -print | wc -l)
            if [ "$font_count" -gt 0 ]; then
                print_success "JetBrains Mono installé ($font_count fichiers de police)"
            else
                print_error "Aucune police trouvée dans l'archive JetBrains Mono"
            fi
        else
            print_error "Impossible d'extraire JetBrains Mono"
        fi
    else
        print_dry_run "Extraction et installation de JetBrains Mono"
    fi
else
    print_warning "Fichier JetBrains Mono non trouvé - sauté"
fi

# Mise à jour du cache des polices
print_status "Mise à jour du cache des polices..."
if [ "$DRY_RUN" = false ]; then
    fc-cache -f -v > /dev/null 2>&1
    check_error "Échec de la mise à jour du cache des polices" "Cache des polices mis à jour"
else
    print_dry_run "fc-cache -f -v"
fi

#==============================================================================
# ÉTAPE 6: Installation des curseurs
#==============================================================================
print_status "Installation des curseurs Bibata-Modern-Ice..."
if [ -f "Bibata-Modern-Ice.tar.xz" ] || [ "$DRY_RUN" = true ]; then
    if [ "$DRY_RUN" = false ]; then
        tar -xf Bibata-Modern-Ice.tar.xz -C "$HOME/.icons/" 2>/dev/null
        check_error "Échec de l'extraction des curseurs" "Curseurs Bibata-Modern-Ice installés"
    else
        print_dry_run "tar -xf Bibata-Modern-Ice.tar.xz"
    fi
else
    print_warning "Fichier Bibata-Modern-Ice non trouvé - sauté"
fi

#==============================================================================
# ÉTAPE 7: Installation des icônes
#==============================================================================
print_status "Installation des icônes Uos-fulldistro..."
if [ -f "Uos-fulldistro-icons.zip" ] || [ "$DRY_RUN" = true ]; then
    if [ "$DRY_RUN" = false ]; then
        unzip -o -q Uos-fulldistro-icons.zip 2>/dev/null
        if [ -d "Uos-fulldistro-icons-master" ]; then
            cp -r Uos-fulldistro-icons-master "$HOME/.icons/Uos-fulldistro-icons"
            check_error "Échec de la copie des icônes" "Icônes Uos-fulldistro installées"
        else
            print_error "Dossier Uos-fulldistro-icons-master non trouvé après extraction"
        fi
    else
        print_dry_run "Extraction et installation des icônes Uos-fulldistro"
    fi
else
    print_warning "Fichier Uos-fulldistro-icons non trouvé - sauté"
fi

#==============================================================================
# ÉTAPE 8: Installation du thème Lavanda
#==============================================================================
print_status "Installation du thème Lavanda..."
if [ -f "Lavanda-gtk-theme.tar.gz" ] || [ "$DRY_RUN" = true ]; then
    if [ "$DRY_RUN" = false ]; then
        tar -xzf Lavanda-gtk-theme.tar.gz 2>/dev/null
        if [ -d "Lavanda-gtk-theme-2024-04-28" ]; then
            cd Lavanda-gtk-theme-2024-04-28
            if [ -x "./install.sh" ]; then
                print_verbose "Exécution du script d'installation du thème..."
                # Essai sans le paramètre -t qui cause l'erreur
                if ./install.sh -c dark --tweaks nord 2>/dev/null; then
                    print_success "Thème Lavanda installé via script automatique"
                else
                    print_warning "Installation automatique échouée, installation manuelle..."
                    # Installation manuelle : chercher les thèmes dans le dossier extrait
                    theme_installed=false
                    for theme_dir in Lavanda* lavanda*; do
                        if [ -d "$theme_dir" ] && [ -d "$theme_dir/gnome-shell" ]; then
                            cp -r "$theme_dir" "$HOME/.themes/"
                            print_verbose "Thème copié : $theme_dir"
                            theme_installed=true
                        fi
                    done
                    if [ "$theme_installed" = false ]; then
                        print_warning "Aucun thème trouvé, installation de tous les variants..."
                        ./install.sh --dest "$HOME/.themes" 2>/dev/null || print_error "Échec installation manuelle"
                    fi
                fi
            else
                print_error "Script d'installation du thème Lavanda non trouvé ou non exécutable"
            fi
            cd ..
        else
            print_error "Dossier Lavanda-gtk-theme non trouvé après extraction"
        fi
    else
        print_dry_run "Extraction et installation du thème Lavanda"
    fi
else
    print_warning "Fichier Lavanda-gtk-theme non trouvé - sauté"
fi

#==============================================================================
# ÉTAPE 9: Installation des extensions GNOME
#==============================================================================
print_status "Installation des extensions GNOME..."

declare -A EXTENSIONS=(
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

install_gnome_extension() {
    local extension_uuid="$1"
    local extension_id="$2"
    
    print_status "Installation de l'extension: $extension_uuid"
    print_verbose "Extension ID: $extension_id, GNOME version: $GNOME_VERSION"
    
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Installation de $extension_uuid (ID: $extension_id)"
        return 0
    fi
    
    local info_url="https://extensions.gnome.org/extension-info/?pk=${extension_id}&shell_version=${GNOME_VERSION}"
    print_verbose "info_url: $info_url"
    local info_json=$(curl -s --max-time 10 "$info_url")
    
    # Extraction de download_url avec python (plus robuste que grep/sed)
    local download_url=$(echo "$info_json" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('download_url', ''))" 2>/dev/null)
    
    # Fallback si python échoue : utilisation de grep/sed
    if [ -z "$download_url" ]; then
        download_url=$(echo "$info_json" | grep -oP '"download_url"\s*:\s*"\K[^"]+')
    fi

    if [ -z "$download_url" ]; then
        print_warning "Impossible de trouver l'URL de téléchargement pour $extension_uuid (peut-être incompatible avec GNOME $GNOME_VERSION)"
        print_verbose "Contenu JSON retourné par l'API : $info_json"
        return 1
    fi

    print_verbose "URL de téléchargement: https://extensions.gnome.org${download_url}"

    local extension_file="${extension_uuid}.zip"
    if wget -q --timeout=30 "https://extensions.gnome.org${download_url}" -O "$extension_file"; then
        local extension_dir="$HOME/.local/share/gnome-shell/extensions/${extension_uuid}"
        mkdir -p "$extension_dir"

        if unzip -o -q "$extension_file" -d "$extension_dir"; then
            if [ -d "$extension_dir/schemas" ]; then
                glib-compile-schemas "$extension_dir/schemas/" 2>/dev/null
                print_verbose "Schémas compilés pour $extension_uuid"
            fi
            print_success "$extension_uuid installé"
            rm -f "$extension_file"
            return 0
        else
            print_warning "Échec de l'extraction de $extension_uuid"
            rm -f "$extension_file"
            return 1
        fi
    else
        print_warning "Échec du téléchargement de $extension_uuid"
        return 1
    fi
}

extension_count=0
extension_success=0

for extension_uuid in "${!EXTENSIONS[@]}"; do
    ((extension_count++))
    extension_id="${EXTENSIONS[$extension_uuid]}"
    print_verbose "Installation pour GNOME_VERSION=$GNOME_VERSION"
    if install_gnome_extension "$extension_uuid" "$extension_id"; then
        ((extension_success++))
    fi
done

print_status "$extension_success/$extension_count extensions installées avec succès"

# Si aucune extension n'a pu être installée, afficher un message explicite
if [ "$extension_success" -eq 0 ]; then
    print_error "Aucune extension GNOME n'a pu être installée. Vérifiez la compatibilité des extensions avec GNOME $GNOME_VERSION, la connexion internet, ou consultez le log pour le détail des erreurs."
fi

# Désactivation des extensions par défaut
if [ "$DRY_RUN" = false ]; then
    print_status "Désactivation des extensions par défaut..."
    gnome-extensions disable ubuntu-dock@ubuntu.com 2>/dev/null && print_success "ubuntu-dock désactivé" || print_verbose "ubuntu-dock non trouvé"
    gnome-extensions disable tiling-assistant@ubuntu.com 2>/dev/null && print_success "tiling-assistant désactivé" || print_verbose "tiling-assistant non trouvé"
else
    print_dry_run "Désactivation de ubuntu-dock et tiling-assistant"
fi

# Activation des nouvelles extensions
if [ "$DRY_RUN" = false ]; then
    print_status "Activation des nouvelles extensions..."
    
    # Attendre un peu pour que GNOME Shell détecte les nouvelles extensions
    sleep 2
    
    activated_count=0
    failed_extensions=()
    
    for extension_uuid in "${!EXTENSIONS[@]}"; do
        extension_dir="$HOME/.local/share/gnome-shell/extensions/${extension_uuid}"
        
        # Vérifier si l'extension est installée
        if [ ! -d "$extension_dir" ]; then
            print_verbose "$extension_uuid non installé, activation ignorée"
            continue
        fi
        
        # Essayer d'activer l'extension
        if gnome-extensions enable "$extension_uuid" 2>/dev/null; then
            print_verbose "✓ $extension_uuid activé"
            ((activated_count++))
        else
            print_warning "✗ Impossible d'activer $extension_uuid"
            failed_extensions+=("$extension_uuid")
        fi
    done
    
    print_success "$activated_count extensions activées"
    
    if [ ${#failed_extensions[@]} -gt 0 ]; then
        print_warning "Extensions non activées (nécessitent un redémarrage): ${failed_extensions[*]}"
    fi
    
    # Forcer le rechargement de la liste des extensions
    busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions.ReloadExtensionsList 2>/dev/null || true
    
else
    print_dry_run "Activation des extensions installées"
fi

#==============================================================================
# ÉTAPE 10: Configuration de Burn My Windows
#==============================================================================
print_status "Configuration de Burn My Windows (effet Hexagone)..."

if [ "$DRY_RUN" = false ]; then
    # Désactivation de tous les effets (simplifié)
    EFFECTS=(
        "apparition" "broken-glass" "energize-a" "energize-b" "fire"
        "glide" "glitch" "incinerate" "matrix" "paint-brush"
        "pixelate" "pixel-wheel" "pixel-wipe" "portal" "snap"
        "t-rex-attack" "tv-effect" "tv-glitch" "wisps"
    )
    
    for effect in "${EFFECTS[@]}"; do
        dconf write "/org/gnome/shell/extensions/burn-my-windows/${effect}-close-effect" false 2>/dev/null
        print_verbose "Effet $effect désactivé"
    done
    
    # Activation de l'effet Hexagone
    dconf write /org/gnome/shell/extensions/burn-my-windows/hexagon-close-effect true 2>/dev/null
    dconf write /org/gnome/shell/extensions/burn-my-windows/hexagon-animation-time 500 2>/dev/null
    
    print_success "Burn My Windows configuré avec l'effet Hexagone"
else
    print_dry_run "Configuration de Burn My Windows (effet Hexagone)"
fi

#==============================================================================
# ÉTAPE 11: Application des thèmes
#==============================================================================
print_status "Application des paramètres d'apparence..."

if [ "$DRY_RUN" = false ]; then
    # Polices
    gsettings set org.gnome.desktop.interface font-name 'Comfortaa 11' 2>/dev/null
    gsettings set org.gnome.desktop.interface document-font-name 'JetBrains Mono 11' 2>/dev/null
    gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10' 2>/dev/null
    print_success "Polices appliquées"
    
    # Thème d'icônes
    if gsettings set org.gnome.desktop.interface icon-theme 'Uos-fulldistro-icons' 2>/dev/null; then
        print_success "Thème d'icônes appliqué"
    else
        print_warning "Impossible d'appliquer le thème d'icônes"
    fi
    
    # Curseurs avec détection automatique
    CURSOR_NAME="Bibata-Modern-Ice"
    if [ -d "$HOME/.icons/$CURSOR_NAME" ]; then
        gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_NAME" 2>/dev/null
        print_success "Thème de curseurs appliqué: $CURSOR_NAME"
    else
        FOUND_CURSOR=$(ls "$HOME/.icons/" 2>/dev/null | grep -i bibata | head -n 1)
        if [ -n "$FOUND_CURSOR" ]; then
            gsettings set org.gnome.desktop.interface cursor-theme "$FOUND_CURSOR" 2>/dev/null
            print_success "Thème de curseurs appliqué: $FOUND_CURSOR"
        else
            print_warning "Aucun curseur Bibata trouvé"
        fi
    fi
    
    # Thème GTK avec détection automatique améliorée
    THEME_NAME="Lavanda-Sea"
    FOUND_THEME=""
    
    # Chercher le thème dans les deux emplacements possibles
    if [ -d "$HOME/.themes/$THEME_NAME" ]; then
        FOUND_THEME="$THEME_NAME"
    elif [ -d "/usr/share/themes/$THEME_NAME" ]; then
        FOUND_THEME="$THEME_NAME"
    else
        # Chercher tous les variants Lavanda installés
        FOUND_THEME=$(find "$HOME/.themes/" /usr/share/themes/ -maxdepth 1 -type d -iname "*lavanda*" 2>/dev/null | head -n 1 | xargs -r basename)
    fi
    
    if [ -n "$FOUND_THEME" ]; then
        gsettings set org.gnome.desktop.interface gtk-theme "$FOUND_THEME" 2>/dev/null
        print_success "Thème GTK appliqué: $FOUND_THEME"
        THEME_NAME="$FOUND_THEME"
    else
        print_warning "Aucun thème Lavanda trouvé. Le thème par défaut sera utilisé."
        THEME_NAME="Yaru"  # Fallback sur le thème par défaut Ubuntu
    fi
    
    # Thème Shell
    gsettings set org.gnome.shell.extensions.user-theme name "$THEME_NAME" 2>/dev/null
    print_success "Thème Shell configuré: $THEME_NAME"
else
    print_dry_run "Application des polices, icônes, curseurs et thèmes"
fi

#==============================================================================
# ÉTAPE 12: Nettoyage
#==============================================================================
print_status "Nettoyage des fichiers temporaires..."
if [ "$DRY_RUN" = false ]; then
    cd "$HOME"
    rm -rf "$HOME/Downloads/gnome-config-temp"
    print_success "Nettoyage terminé"
else
    print_dry_run "rm -rf ~/Downloads/gnome-config-temp"
fi

#==============================================================================
# RAPPORT FINAL
#==============================================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
if [ "$DRY_RUN" = true ]; then
    echo -e "${MAGENTA}║  ✓ Simulation terminée !                                   ║${NC}"
else
    echo -e "${GREEN}║  ✓ Installation terminée !                                 ║${NC}"
fi
echo -e "${GREEN}║                                                            ║${NC}"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}║  ✨ Aucune erreur détectée - Installation parfaite !       ║${NC}"
elif [ $ERRORS -eq 0 ]; then
    printf "${YELLOW}║  ⚠  %-2d avertissement(s) détecté(s)%27s║${NC}\n" $WARNINGS ""
else
    printf "${RED}║  ✗ %-2d erreur(s) et %-2d avertissement(s)%21s║${NC}\n" $ERRORS $WARNINGS ""
fi

echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║  📊 Statistiques:                                          ║${NC}"
printf "${GREEN}║     Extensions installées: %-2d/%-2d%25s║${NC}\n" $extension_success $extension_count ""
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║  📝 Fichier de log: %-35s║${NC}" "$(basename $LOG_FILE)"
echo -e "${GREEN}║     Emplacement: ~/.../$(basename $LOG_FILE | cut -c1-30)...║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"

if [ "$DRY_RUN" = false ]; then
    echo -e "${GREEN}║  🔄 Pour appliquer les changements:                        ║${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    
    if [ "$XDG_SESSION_TYPE" = "x11" ]; then
        echo -e "${GREEN}║  Option 1 (Rapide - X11):                                  ║${NC}"
        echo -e "${GREEN}║    Alt+F2 → tapez 'r' → Entrée                            ║${NC}"
        echo -e "${GREEN}║                                                            ║${NC}"
        echo -e "${GREEN}║  Option 2 (Recommandé):                                    ║${NC}"
        echo -e "${GREEN}║    1. Déconnectez-vous                                     ║${NC}"
        echo -e "${GREEN}║    2. Reconnectez-vous                                     ║${NC}"
    else
        echo -e "${GREEN}║  Sous Wayland, vous devez:                                 ║${NC}"
        echo -e "${GREEN}║    1. Déconnectez-vous                                     ║${NC}"
        echo -e "${GREEN}║    2. Reconnectez-vous                                     ║${NC}"
    fi
fi

echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

if [ "$DRY_RUN" = false ]; then
    if [ $ERRORS -gt 0 ]; then
        print_warning "Certaines étapes ont échoué. Consultez le log: $LOG_FILE"
        print_warning "Vous pouvez compléter manuellement via GNOME Tweaks et le Gestionnaire d'extensions"
    fi
    
    # Information sur le backup
    if [ -f "$HOME/.gnome-config-last-backup" ]; then
        backup_dir=$(cat "$HOME/.gnome-config-last-backup")
        echo -e "${CYAN}💾 Backup disponible: $backup_dir${NC}"
        echo -e "${CYAN}   Pour restaurer: dconf load /org/gnome/desktop/ < $backup_dir/desktop-settings.dconf${NC}"
        echo ""
    fi
    
    # Proposition de redémarrage GNOME Shell
    if [ "$extension_success" -gt 0 ] && [ "$INTERACTIVE" = true ]; then
        # Détection du serveur d'affichage
        if [ "$XDG_SESSION_TYPE" = "x11" ]; then
            echo ""
            if ask_confirmation "Redémarrer GNOME Shell maintenant pour activer les extensions? (X11)" "y"; then
                print_status "Redémarrage de GNOME Shell..."
                
                # Méthode 1: via busctl (plus propre)
                if busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Redémarrage pour activer les extensions...")' 2>/dev/null; then
                    print_success "GNOME Shell redémarré via busctl"
                # Méthode 2: killall (fallback)
                elif killall -3 gnome-shell 2>/dev/null; then
                    print_success "GNOME Shell redémarré via killall"
                else
                    print_warning "Impossible de redémarrer GNOME Shell automatiquement"
                    print_status "Utilisez Alt+F2, tapez 'r' et appuyez sur Entrée"
                fi
            fi
        else
            echo ""
            echo -e "${YELLOW}ℹ️  Vous êtes sous Wayland. Déconnectez-vous et reconnectez-vous pour activer les extensions.${NC}"
            echo -e "${CYAN}   Les extensions installées: $extension_success sur $extension_count${NC}"
        fi
    fi
fi

log "=== Installation terminée - Erreurs: $ERRORS, Warnings: $WARNINGS ==="

exit 0
