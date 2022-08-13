SHELL=/bin/bash 
REMOTE_USER = ${USER}
REMOTE_HOST = 178.62.227.207
REMOTE_KEY = ${HOME}/.ssh/id_vps
LN = @ln -vsfn {${PWD},${HOME}}
PKG_CHECK = @command -v $@ > /dev/null 2>&1

ifneq ($(shell command -v dnf),)
	PKG_INSTALL = sudo dnf install -y
	FONT_PACKAGE_NAME = jetbrains-mono-fonts
	SHELLCHECK = ShellCheck
	SSH = openssh
endif

ifneq ($(shell command -v apt),)
	PKG_INSTALL = sudo apt install -y
	FONT_PACKAGE_NAME = fonts-jetbrains-mono
	SHELLCHECK = shellcheck
	SSH = ssh
endif

.PHONY: all init tools gui

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: init ssh git tools gui gnome-settings
init: bash tmux vim ## Lightweight configuration
tools: docker golang shell perl ## Extra tools
gui: $(FONT_PACKAGE_NAME) zathura alacritty ## Init GUI applications

test: docker ## test the makefile
	sudo docker build ${PWD} --rm -t test.fedora \
		--build-arg TARGET=all \
		--build-arg PLATTFORM=fedora \
		--build-arg PKG_INSTALL="dnf install -y"
	sudo docker build ${PWD} --rm -t test.ubuntu \
		--build-arg TARGET=all \
		--build-arg PLATTFORM=ubuntu \
		--build-arg PKG_INSTALL="apt install -y"

bash: ## Init bash
	$(LN)/.bashrc

tmux: ## Init tmux
	$(PKG_CHECK) || $(PKG_INSTALL) $@
	$(LN)/.tmux.conf

vim: ## Init vim
	$(PKG_CHECK) || $(PKG_INSTALL) $@
	$(LN)/.vimrc
	$(LN)/.vim

git: ## Init git configs
	$(PKG_CHECK) || $(PKG_INSTALL) $@
	$(LN)/.gitconfig
	$(LN)/.git_template

ssh: rsync ## sync ssh configuration with a remote host
	$(PKG_CHECK) || $(PKG_INSTALL) $(SSH)
	@test -f $(REMOTE_KEY) && \
		(rsync -avz --mkpath -e "ssh -o StrictHostKeyChecking=no -i $(REMOTE_KEY)" \
		--exclude "known_hosts*" \
		--exclude "authorized_keys" \
		$(REMOTE_USER)@$(REMOTE_HOST):~/.ssh ${HOME} && \
		chmod 600 ${HOME}/.ssh/*) || echo "No key found!"
rsync:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

# Tools
docker: ## Install docker
	$(PKG_INSTALL) docker docker-compose
	sudo systemctl enable docker.service
	[ "${USER}" = "" ] || \
		sudo usermod -aG docker ${USER}

golang: ## Install golang
	$(PKG_INSTALL) golang
	sudo mkdir -p /usr/local/go
	sudo chmod ga+rwx /usr/local/go
	grep GOPATH ${HOME}/.bash_profile || \
		echo "export GOPATH=/usr/local/go" >> \
		${HOME}/.bash_profile
	echo ${PATH} | grep -q "$$GOPATH/bin" || \
		echo "export PATH=$$PATH:$$GOPATH/bin" >> \
		${HOME}/.bash_profile
	source ${HOME}/.bash_profile && \
		go install golang.org/x/tools/gopls@latest && \
		go install github.com/go-delve/delve/cmd/dlv@latest

shell: ## Install shellscripting tools
	$(PKG_INSTALL) $(SHELLCHECK) shfmt

perl: ## Install perl tools
	$(PKG_INSTALL) perl perl-doc perltidy

# GUI 
zathura: zathura-pdf-poppler ## Init zathura (PDF reader)
	$(PKG_CHECK) || $(PKG_INSTALL) $@
	mkdir -p ${HOME}/.config/zathura 2> /dev/null
	xdg-mime default org.pwmt.zathura.desktop application/pdf
	$(LN)/.config/zathura/zathurarc

zathura-pdf-poppler:
	$(PKG_INSTALL) $@

alacritty: $(FONT_PACKAGE_NAME) ## Init alacritty (Terminal emulator)
	@[ "$$(command -v apt)" = "" ] || \
		sudo add-apt-repository -y ppa:aslatter/ppa
	$(PKG_CHECK) || $(PKG_INSTALL) alacritty
	mkdir -p ${HOME}/.config/alacritty 2> /dev/null
	$(LN)/.config/alacritty/alacritty.yml

$(FONT_PACKAGE_NAME):
	$(PKG_INSTALL) $@

dconf-editor:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

gnome-settings: dconf-editor $(FONT_PACKAGE_NAME) ## Init Gnome specific settings
	dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:swapescape']"
	dconf write /org/gnome/desktop/wm/keybindings/close "['<Super>q']"
	dconf write /org/gnome/desktop/wm/keybindings/cycle-windows "['<Super>c']"
	dconf write /org/gnome/desktop/wm/keybindings/cycle-windows-backwards "['<Shift><Super>c']"
	dconf write /org/gnome/desktop/wm/keybindings/maximize "['<Super>k']"
	dconf write /org/gnome/desktop/wm/keybindings/unmaximize "['<Super>j']"
	dconf write /org/gnome/desktop/wm/keybindings/toggle-maximized "['<Super>m']"
	dconf write /org/gnome/desktop/wm/keybindings/minimize "['<Shift><Super>m']"
	dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-down "['<Shift><Super>j']"
	dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-left "['<Shift><Super>h']"
	dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-right "['<Shift><Super>l']"
	dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-up "['<Shift><Super>k']"
	dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-right "['<Shift><Super>n']"
	dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-left "['<Shift><Super>p']"
	dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-left "['<Super>p']"
	dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-right "['<Super>n']"
	dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"
	dconf write /org/gnome/desktop/interface/monospace-font-name "'JetBrains Mono 10'"
	dconf write /org/gnome/mutter/keybindings/toggle-tiled-left "['<Super>h']"
	dconf write /org/gnome/mutter/keybindings/toggle-tiled-right "['<Super>l']"
	dconf write /org/gnome/desktop/interface/clock-show-date true
	dconf write /org/gnome/desktop/interface/clock-show-weekday true
	dconf write /org/gnome/desktop/interface/show-battery-percentage true
	dconf write /org/gnome/desktop/interface/enable-hot-corners false
	dconf write /org/gnome/mutter/workspaces-only-on-primary true
	dconf write /org/gnome/shell/keybindings/toggle-message-tray "['<Super>v']"
	dconf write /org/gnome/shell/keybindings/focus-active-notification "['<Shift><Super>v']"
	dconf write /org/gnome/mutter/keybindings/switch-monitor "['']"
