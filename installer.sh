#!/bin/bash

ZOOM_VERSION=5.10.4.2845

main () {

    check_if_sudo
    prepare_system
    install_snap_packages
    add_repositories

}

check_if_sudo () {
    if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

}

prepare_system () {

    unset ZSH_CUSTOM
    unset ZSH

    echo 'Updating all packages'
    apt update
    apt upgrade
    
    apt remove firefox-esr -y
    apt remove firefox -y

}

install_snap_packages () {
    snap install core
    snap install office365webdesktop --beta
    snap install firefox
    snap install snap-store
    snap install whatsie
    snap install python38
    snap install gimp
    snap install bitwarden
    snap install snap-store
    snap install slack
    snap install spotify
    snap install gitkraken
    snap install teams
    snap install install
    snap install zoom

}

add_repositories () {
    #azure-cli
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ focal main" -y

    # Chrome
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
    add-apt-repository "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" -y

    # Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

install_apt_packages () {

    apt update 
    apt install gettext -y
    apt install git -y
    apt install snapd -y
    apt install fonts-powerline -y
    apt install vim -y
    apt install bmon -y
    apt install htop -y
    apt install telnet -y
    apt install nmap -y
    apt install grub-customizer -y
    apt install vim -y
    apt install git -y
    apt install apt-transport-https -y
    apt install ca-certificates -y
    apt install curl -y
    apt install software-properties-common -y
    apt install zsh -y
    apt install sshuttle -y
    apt install gnupg -y
    apt install lsb-release -y
    apt install sassc libglib2.0-dev-bin libxml2-utils -y
    apt install gnome-shell-extension-appindicator -y
    apt install plymouth plymouth-themes -y
    apt install gnome-shell-extension-volume-mixer -y
    apt install gnome-tweaks -y
    apt install gparted -y
    apt install net-tools -y
    apt install gnome-software -y
    apt install gnome-shell-extensions -y
    apt install openjdk-11-jdk -y
    apt install openjdk-17-jdk -y
    apt install spotify-client -y
    apt install vlc -y
    apt install virtualbox -y
    apt install azure-cli -y
    apt install google-chrome-stable -y
    apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    apt install pulseaudio -y
    apt install pavucontrol -y

}

set_up_java () {
    
    curl -s "https://get.sdkman.io" | bash
    sdk install java 11.0.16-amzn 
    sdk install java 17.0.4 

}

install_zoom () {
    echo "Downloading Zoom version $ZOOM_VERSION"
    wget -P /tmp https://cdn.zoom.us/prod/$ZOOM_VERSION/zoom_amd64.deb

    echo 'Installing Zoom'
    apt install /tmp/zoom_amd64.deb -y

}

install_gitkraken () {
    echo "Downloading Gitkraken"
    wget -P /tmp https://release.gitkraken.com/linux/gitkraken-amd64.deb

    echo "Installing Gitkraken"
    apt install /tmp/gitkraken-amd64.deb -y
}

set_up_nodejs () {
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    nvm install --lts
    nvm use --lts
}

set_up_go () {

}
install_minikube () {
    if ! [ -x "$(command -v minikube)" ]; then
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        install minikube-linux-amd64 /usr/local/bin/minikube
        minikube config  set memory 8192
        minikube config set cpus 4
        minikube config set driver virtualbox
        minikube start --container-runtime=containerd
        rm minikube-linux-amd64
    fi
}

install_stern () {
    if ! [ -x "$(command -v stern)" ]; then 
        wget https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64
        mv stern_linux_amd64 /usr/local/bin/stern
        chmod +x /usr/local/bin/stern
    fi
}

install_docker_compose () {
	mkdir -p /usr/local/lib/docker/cli-plugins
	curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
	chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

configure_vim () {
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    touch ~/.vimrc

    echo "execute pathogen#infect()" >> ~/.vimrc
    echo "syntax on" >> ~/.vimrc
    echo "filetype plugin indent on" >> ~/.vimrc
    echo "set number" >> ~/.vimrc

    # configure vim airline plugin

    rm -rf ~/.vim/bundle/vim-airline

    git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
}

install_and_configure_zsh () {
    
    rm -rf ~/.oh-my-zsh

    rm -rf ~/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt

    rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    git clone http://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh

    git clone http://github.com/superbrothers/zsh-kubectl-prompt ~/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

    THEME="powerlevel10k/powerlevel10k"; sed -i s/^ZSH_THEME=".\+"$/ZSH_THEME=\"$THEME\"/g ~/.zshrc

    sed 's/\(^plugins=([^)]*\)/\1 docker docker-compose zsh-autosuggestions zsh-syntax-highlighting/' ~/.zshrc

    echo "" >> ~/.zshrc
    echo "#Adding kubectl autocompletion" >> ~/.zshrc
    echo "source <(kubectl completion zsh)" >> ~/.zshrc
    echo "" >> ~/.zshrc
    echo "#Adding az cli autocompletion" >> ~/.zshrc
    echo "source ~/.oh-my-zsh/completions/az.completion" >> ~/.zshrc
    echo "" >> ~/.zshrc
    echo "#Adding minikube autocompletion" >> ~/.zshrc
    echo "source <(minikube completion zsh)" >> ~/.zshrc
    echo "" >> ~/.zshrc
    echo "#Adding helm autocompletion" >> ~/.zshrc
    echo "source <(helm completion zsh)" >> ~/.zshrc
    echo "" >> ~/.zshrc
    echo "#Adding Stern Autocompletion" >> ~/.zshrc
    echo "source <(stern --completion zsh)" >> ~/.zshrc
    echo "" >> ~/.zshrc
    echo "#Adding zsh reload step" >> ~/.zshrc
    echo "autoload -U compinit && compinit" >> ~/.zshrc
    echo "" >> ~/.zshrc

    echo "#Adding kubectl aliases" >> ~/.zshrc
    echo "" >> ~/.zshrc
    echo "alias watch='watch -d '" >> ~/.zshrc
    echo "alias k='kubectl'" >> ~/.zshrc
    echo "alias kc='k config view --minify | grep name'"  >> ~/.zshrc
    echo "alias c='clear'" >> ~/.zshrc
    echo "alias kd='kubectl describe'" >> ~/.zshrc
    echo "alias ke='kubectl explain'" >> ~/.zshrc
    echo "alias kf='kubectl create -f'" >> ~/.zshrc
    echo "alias kg='kubectl get pods --show-labels'" >> ~/.zshrc
    echo "alias kh='kubectl --help | more'" >> ~/.zshrc
    echo "alias kgns='kubectl get namespaces'" >> ~/.zshrc
    echo "alias l='ls -lrt'" >> ~/.zshrc
    echo "alias ll='vi ls -rt | tail -1'" >> ~/.zshrc
    echo "alias kgaa='kubectl get all'" >> ~/.zshrc
    echo "alias kgcm='kubectl get configmap'" >> ~/.zshrc
    echo "alias kgs='kubectl get secret'" >> ~/.zshrc
    echo "alias kgp='kubectl get pod'" >> ~/.zshrc
    echo "alias kging='kubectl get ingress'" >> ~/.zshrc
    echo "alias kgsv='kubectl get service'" >> ~/.zshrc
    echo "alias h='helm'" >> ~/.zshrc
    echo "alias ctx='kubectx'" >> ~/.zshrc
    echo "alias ns='kubens'" >> ~/.zshrc
}

configure_az-cli_completion () {
    wget https://raw.githubusercontent.com/Azure/azure-cli/dev/az.completion -P /tmp

    mv /tmp/az.completion ~/.oh-my-zsh/completions/az.completion
}

download_and_configure_kubectx () {
    rm -rf ~/.kubectx

    git clone https://github.com/ahmetb/kubectx ~/.kubectx

    mv ~/.kubectx/kubectx /usr/local/bin/kubectx

    mv ~/.kubectx/kubens /usr/local/bin/kubens
    apt-get -f install virtualbox-6.1 -y
    chmod +x /usr/local/bin/kubectx

    chmod +x /usr/local/bin/kubens

    mkdir -p ~/.oh-my-zsh/completions

    chmod -R 755 ~/.oh-my-zsh/completions

    cp -s ~/.kubectx/completion/_kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh

    cp -s ~/.kubectx/completion/_kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh
}

install_and_configure_gui_themes () {

    #gtk-theme
    rm -rf ~/.WhiteSur-gtk-theme

    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme ~/.WhiteSur-gtk-theme

    bash ~/.WhiteSur-gtk-theme/install.sh -n default -b default -c light -t default -m --right --silent-mode  -i ubuntu

    bash ~/.WhiteSur-gtk-theme/tweaks.sh -f default -F -s -d -b default

    bash ~/.WhiteSur-gtk-theme/tweaks.sh -g 

    # Grub themes

    rm -rf ~/.grub-themes

    git clone https://github.com/vinceliuice/grub2-themes ~/.grub-themes

    bash ~/.grub-themes/install.sh -b -t vimix -s 1080p

    #icon themes

    rm -rf ~/.WhiteSur-icon-theme

    git clone https://github.com/vinceliuice/WhiteSur-icon-theme ~/.WhiteSur-icon-theme

    bash ~/.WhiteSur-icon-theme/install.sh -t default


}

finish_system_preparation () {
    usermod -aG docker $USER
    apt autoremove
}


check_if_sudo

install_snap_packages
add_spotify_repository
add_virtualbox_repository
add_azure_cli_repository
add_chrome_repository
add_docker_repository
add_vscode_repository
add_onedrive_repository

prepare_system

install_apt_packages

set_up_java
install_zoom
install_gitkraken
install_slack
install_postman
install_node_version_manager
install_minikube
install_stern
configure_vim
install_and_configure_zsh
configure_az-cli_completion
download_and_configure_kubectx
install_and_configure_gui_themes

finish_system_preparation

