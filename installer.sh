#!/bin/bash

USERNAME=haydn

main () {

    check_if_sudo
    prepare_system
    install_snap_packages
    add_repositories
    install_libssl
    install_apt_packages
    set_up_java
    set_up_nodejs
    set_up_golang
    install_stern
    install_kubectl
    install_helm
    install_minikube
    install_docker_compose
    configure_vim
    install_and_configure_zsh
    download_and_configure_kubectx
    finish_system_preparation

}

check_if_sudo () {
    if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

}

prepare_system () {

    unset ZSH_CUSTOM
    unset ZSH

    echo 'Updating all packages'
    apt update -y
    apt upgrade -y
    apt install lsb-release ca-certificates apt-transport-https software-properties-common -y
    
    apt remove firefox-esr -y
    apt remove firefox -y
    apt install curl -y

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
    snap install zoom-client
    snap install code --classic

}

add_repositories () {
    
    add-apt-repository ppa:danielrichter2007/grub-customizer
    #azure-cli
    rm /etc/apt/sources.list.d/archive_uri-https_packages_microsoft_com_repos_azure-cli_-jammy.list
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
    AZ_REPO=$(lsb_release -cs)
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list

    # Chrome
    rm /etc/apt/sources.list.d/archive_uri-http_dl_google_com_linux_chrome_deb_-jammy.list
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
    add-apt-repository "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" -y
    
    # Docker
    rm /usr/share/keyrings/docker-archive-keyring.gpg
    rm /etc/apt/sources.list.d/docker.list
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

}

install_libssl(){

    wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb
    dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb
    rm libssl1.1_1.1.0g-2ubuntu4_amd64.deb

    wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl-dev_1.1.0g-2ubuntu4_amd64.deb
    dpkg -i libssl-dev_1.1.0g-2ubuntu4_amd64.deb
    rm libssl-dev_1.1.0g-2ubuntu4_amd64.deb

}
install_apt_packages () {

    apt update
    apt install libssl1.1 -y
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
    apt install spotify-client -y
    apt install vlc -y
    apt install virtualbox -y
    apt install azure-cli -y
    apt install google-chrome-stable -y
    apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    apt install pulseaudio -y
    apt install pavucontrol -y
    apt install bison -y
    apt install yad -y

}

set_up_java () {
    
    runuser -l $USERNAME -c 'curl -s "https://get.sdkman.io" | bash'
    source "/home/$USERNAME/.sdkman/bin/sdkman-init.sh"
    sdk install java 11.0.16-amzn 
    sdk install java 17.0.4-amzn

}

set_up_nodejs () {
    
    runuser -l $USERNAME -c 'wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash'
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install --lts
    nvm use --lts
}

set_up_golang () {

    runuser -l $USERNAME -c 'rm -rf  /home/$USERNAME/.gvm'

    runuser -l $USERNAME -c 'zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)'
    source /home/$USERNAME/.gvm/scripts/gvm
    gvm install go1.4 -B
    gvm use go1.4
    gvm install go1.19 -B
    gvm use go1.19
}

install_kubectl () {
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
}

install_helm () {

    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    helm plugin install https://github.com/databus23/helm-diff
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

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
}

configure_vim () {

    rm /home/$USERNAME/.vimrc

    runuser -l $USERNAME -c 'mkdir -p /home/$USERNAME.vim/autoload /home/$USERNAME/.vim/bundle && \
    curl -LSso /home/$USERNAME.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim#' 

    touch /home/$USERNAME/.vimrc

    chown $USERNAME:$USERNAME /home/$USERNAME/.vimrc

    echo "execute pathogen#infect()" >> /home/$USERNAME/.vimrc
    echo "syntax on" >> /home/$USERNAME/.vimrc
    echo "filetype plugin indent on" >> /home/$USERNAME/.vimrc
    echo "set number" >> /home/$USERNAME/.vimrc

    # configure vim airline plugin

    rm -rf /home/$USERNAME/.vim/bundle/vim-airline

    runuser -l $USERNAME -c 'git clone https://github.com/vim-airline/vim-airline /home/$USERNAME/.vim/bundle/vim-airline'
}

install_and_configure_zsh () {
    
    rm -rf /home/$USERNAME/.oh-my-zsh

    rm -rf /home/$USERNAME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt

    rm -rf /home/$USERNAME/.oh-my-zsh/custom/themes/powerlevel10k

    runuser -l $USERNAME -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

    runuser -l $USERNAME -c 'git clone http://github.com/superbrothers/zsh-kubectl-prompt /home/$USERNAME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt'

    runuser -l $USERNAME -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$USERNAME/.oh-my-zsh/custom/themes/powerlevel10k'

    THEME="powerlevel10k/powerlevel10k"; sed -i s/^ZSH_THEME=".\+"$/ZSH_THEME=\"$THEME\"/g /home/$USERNAME/.zshrc

    sed 's/\(^plugins=([^)]*\)/\1 docker docker-compose zsh-autosuggestions zsh-syntax-highlighting/' /home/$USERNAME/.zshrc

    echo "" >> /home/$USERNAME/.zshrc
    echo "#Adding kubectl autocompletion" >> /home/$USERNAME/.zshrc
    echo "source <(kubectl completion zsh)" >> /home/$USERNAME/.zshrc
    echo "" >> /home/$USERNAME/.zshrc
    echo "#Adding az cli autocompletion" >> /home/$USERNAME/.zshrc
    echo "source /home/$USERNAME/.oh-my-zsh/completions/az.completion" >> /home/$USERNAME/.zshrc
    echo "" >> /home/$USERNAME/.zshrc
    echo "#Adding minikube autocompletion" >> /home/$USERNAME/.zshrc
    echo "source <(minikube completion zsh)" >> /home/$USERNAME/.zshrc
    echo "" >> /home/$USERNAME/.zshrc
    echo "#Adding helm autocompletion" >> /home/$USERNAME/.zshrc
    echo "source <(helm completion zsh)" >> /home/$USERNAME/.zshrc
    echo "" >> /home/$USERNAME/.zshrc
    echo "#Adding Stern Autocompletion" >> /home/$USERNAME/.zshrc
    echo "source <(stern --completion zsh)" >> /home/$USERNAME/.zshrc
    echo "" >> /home/$USERNAME/.zshrc
    echo "#Adding zsh reload step" >> /home/$USERNAME/.zshrc
    echo "autoload -U compinit && compinit" >> /home/$USERNAME/.zshrc
    echo "" >> /home/$USERNAME/.zshrc

    echo "#Adding kubectl aliases" >> /home/$USERNAME/.zshrc
    echo "" >> /home/$USERNAME/.zshrc
    echo "alias watch='watch -d '" >> /home/$USERNAME/.zshrc
    echo "alias k='kubectl'" >> /home/$USERNAME/.zshrc
    echo "alias kc='k config view --minify | grep name'"  >> /home/$USERNAME/.zshrc
    echo "alias c='clear'" >> /home/$USERNAME/.zshrc
    echo "alias kd='kubectl describe'" >> /home/$USERNAME/.zshrc
    echo "alias ke='kubectl explain'" >> /home/$USERNAME/.zshrc
    echo "alias kf='kubectl create -f'" >> /home/$USERNAME/.zshrc
    echo "alias kg='kubectl get pods --show-labels'" >> /home/$USERNAME/.zshrc
    echo "alias kh='kubectl --help | more'" >> /home/$USERNAME/.zshrc
    echo "alias kgns='kubectl get namespaces'" >> /home/$USERNAME/.zshrc
    echo "alias l='ls -lrt'" >> /home/$USERNAME/.zshrc
    echo "alias ll='vi ls -rt | tail -1'" >> /home/$USERNAME/.zshrc
    echo "alias kgaa='kubectl get all'" >> /home/$USERNAME/.zshrc
    echo "alias kgcm='kubectl get configmap'" >> /home/$USERNAME/.zshrc
    echo "alias kgs='kubectl get secret'" >> /home/$USERNAME/.zshrc
    echo "alias kgp='kubectl get pod'" >> /home/$USERNAME/.zshrc
    echo "alias kging='kubectl get ingress'" >> /home/$USERNAME/.zshrc
    echo "alias kgsv='kubectl get service'" >> /home/$USERNAME/.zshrc
    echo "alias h='helm'" >> /home/$USERNAME/.zshrc
    echo "alias ctx='kubectx'" >> /home/$USERNAME/.zshrc
    echo "alias ns='kubens'" >> /home/$USERNAME/.zshrc
}

download_and_configure_kubectx () {
    rm -rf /home/$USERNAME/.kubectx

    runuser -l $USERNAME -c 'git clone https://github.com/ahmetb/kubectx /home/$USERNAME/.kubectx'

    mv /home/$USERNAME/.kubectx/kubectx /usr/local/bin/kubectx

    mv /home/$USERNAME/.kubectx/kubens /usr/local/bin/kubens

    chmod +x /usr/local/bin/kubectx

    chmod +x /usr/local/bin/kubens

    runuser -l $USERNAME -c 'mkdir -p /home/$USERNAME/.oh-my-zsh/completions'

    chmod -R 755 /home/$USERNAME/.oh-my-zsh/completions

    cp -s /home/$USERNAME/.kubectx/completion/_kubectx.zsh /home/$USERNAME/.oh-my-zsh/completions/_kubectx.zsh

    cp -s /home/$USERNAME/.kubectx/completion/_kubens.zsh /home/$USERNAME/.oh-my-zsh/completions/_kubens.zsh
}

configure_az-cli_completion () {
    wget https://raw.githubusercontent.com/Azure/azure-cli/dev/az.completion -P /tmp

    mv /tmp/az.completion ~/.oh-my-zsh/completions/az.completion
}

install_and_configure_gui_themes () {

    #gtk-theme
    rm -rf /home/$USERNAME/.WhiteSur-gtk-theme
    rm -rf /home/$USERNAME/.WhiteSur-icon-theme

    runuser -l $USERNAME -c 'git clone https://github.com/vinceliuice/WhiteSur-gtk-theme  runuser -l $USERNAME -c  /home/$USERNAME/.WhiteSur-gtk-theme'
    runuser -l $USERNAME -c 'git clone https://github.com/vinceliuice/WhiteSur-icon-theme  runuser -l $USERNAME -c  /home/$USERNAME/.WhiteSur-icon-theme'
    runuser -l $USERNAME -c wget https://github.com/vinceliuice/WhiteSur-wallpapers/raw/main/1080p/WhiteSur-light.png -P /home/$USERNAME/Pictures/

    bash /home/$USERNAME/.WhiteSur-gtk-theme/install.sh -n default -b default -c light -t default -m --right --silent-mode  -i ubuntu

    bash /home/$USERNAME/.WhiteSur-gtk-theme/tweaks.sh -f default -F -s -d -b default

    bash /home/$USERNAME/.WhiteSur-gtk-theme/tweaks.sh -g

    bash /home/$USERNAME/.WhiteSur-icon-theme/install.sh -t default

    # Grub themes

    rm -rf /home/$USERNAME/.grub-themes

    runuser -l $USERNAME -c 'git clone https://github.com/vinceliuice/grub2-themes /home/$USERNAME/.grub-themes'

    bash /home/$USERNAME/.grub-themes/install.sh -b -t vimix -s 1080p

}

finish_system_preparation () {
    usermod -aG docker $USER
    apt autoremove
}

main

