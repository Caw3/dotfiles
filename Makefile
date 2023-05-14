SHELL=/bin/bash 
REMOTE_KEY = ./key
LN = @ln -vsfn {${PWD},${HOME}}
PKG_CHECK = @command -v $@ > /dev/null 2>&1

ifneq ($(shell command -v dnf),)
	PKG_INSTALL = sudo dnf install -y
	FONT_PACKAGE_NAME = jetbrains-mono-fonts
	SHELLCHECK = ShellCheck
	SSH = openssh
endif

ifneq ($(shell command -v apt-get),)
	PKG_INSTALL = sudo apt-get install -y
	FONT_PACKAGE_NAME = fonts-jetbrains-mono
	SHELLCHECK = shellcheck
	SSH = ssh
endif

.PHONY: all init tools gui ssh git

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: init git ansible wget curl rsync gui scripts ## Basic install
init: bash tmux vim ## Lightweight configuration
tools: docker golang shell latex pandoc ## Extra tools
gui: $(FONT_PACKAGE_NAME) zathura alacritty gnome-settings ## Init GUI applications

bash: ## Init bash
	$(LN)/.bashrc
	$(LN)/.inputrc

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
	$(PKG_CHECK) || $(PKG_INSTALL) gh

ssh: ansible rsync key ## sync ssh configuration with a remote host
	@[ "${REMOTE_HOST}" ] || ( echo "Please specify remote host with REMOTE_HOST=<user>@<host ip>"; exit 1)
	$(PKG_CHECK) || $(PKG_INSTALL) $(SSH)
	@test -f $(REMOTE_KEY) && \
		(rsync -avz --mkpath -e "ssh -o StrictHostKeyChecking=no -i $(REMOTE_KEY)" \
		--exclude "known_hosts*" \
		$(REMOTE_HOST):~/.ssh ${HOME} && \
		chmod 600 ${HOME}/.ssh/*) || echo "No key found!"
	@rm $(REMOTE_KEY) -f

key: 
	@ansible-vault decrypt --output $(REMOTE_KEY) encrypted_key

ansible:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

rsync:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

# Tools
scripts:
	$(LN)/.bin
	grep '$$HOME/.bin' $(HOME)/.bash_profile || \
		echo 'export PATH=$$PATH:$$HOME/.bin' >> \
		$(HOME)/.bash_profile
	$(PKG_CHECK) || $(PKG_INSTALL) fzf

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
	grep '$$GOPATH/bin' $(HOME)/.bash_profile || \
		echo 'export PATH=$$PATH:$$GOPATH/bin' >> \
		${HOME}/.bash_profile
	if [ "$$GO111MODULE" = "on" ]; then \
		source ${HOME}/.bash_profile && \
		go install golang.org/x/tools/gopls@latest && \
		go install github.com/go-delve/delve/cmd/dlv@latest; \
	fi

shell: ## Install shellscripting tools
	$(PKG_INSTALL) $(SHELLCHECK) shfmt

pandoc: latex curl wget ## Install pandoc tools
	$(PKG_INSTALL) pandoc librsvg2-tools

latex: ## Install latex tools
	$(PKG_INSTALL) texlive

wget:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

curl:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

# GUI 
zathura: zathura-pdf-mupdf ## Init zathura (PDF reader)
	$(PKG_CHECK) || $(PKG_INSTALL) $@
	xdg-mime default org.pwmt.zathura.desktop application/pdf

zathura-pdf-mupdf:
	$(PKG_INSTALL) $@

alacritty: $(FONT_PACKAGE_NAME) ## Init alacritty (Terminal emulator)
	if [ ! $$(command -v apt-get) = ""  ]; then \
		sudo apt-get update; \
		sudo apt-get install -y software-properties-common; \
		sudo add-apt-repository -y ppa:aslatter/ppa; \
	fi
	$(PKG_CHECK) || $(PKG_INSTALL) alacritty
	mkdir -p ${HOME}/.config/alacritty 2> /dev/null
	$(LN)/.config/alacritty/alacritty.yml

$(FONT_PACKAGE_NAME):
	$(PKG_INSTALL) $@

dconf-editor:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

gnome-settings: dconf-editor $(FONT_PACKAGE_NAME) ## Init Gnome specific settings
	dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"
	dconf write /org/gnome/desktop/wm/keybindings/close "['<Super>q', '<Alt>F4']"
	dconf write /org/gnome/shell/keybindings/toggle-message-tray "['<Super>v']"
	dconf write /org/gnome/shell/keybindings/focus-active-notification "['<Shift><Super>v']"
	dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"
	dconf write /org/gnome/desktop/interface/clock-show-date true
	dconf write /org/gnome/desktop/interface/clock-show-weekday true
	dconf write /org/gnome/desktop/interface/show-battery-percentage true
	dconf write /org/gnome/desktop/interface/enable-hot-corners false
	dconf write /org/gnome/mutter/workspaces-only-on-primary true
	dconf write /org/gnome/desktop/peripherals/mouse/accel-profile "'flat'"
	dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
	dconf write /org/gnome/desktop/wm/keybindings/maximize "['<Super>k', '<Super>Up']"
	dconf write /org/gnome/desktop/wm/keybindings/unmaximize "['<Super>j', '<Super>Down']"
	dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-down \
		"['<Shift><Super>Down']"
	dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-left \
		"['<Shift><Super>Left']"
	dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-right \
		"['<Shift><Super>Right']"
	dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-up \
		"['<Shift><Super>Up']"
	dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-right \
		"['<Shift><Super><Alt>Right']"
	dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-left \
		"['<Shift><Super><Alt>Left']"
	dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-left \
		"['<Super><Alt>Left']"
	dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-right \
		"['<Super><Alt>Right']"
	dconf write /org/gnome/mutter/keybindings/toggle-tiled-left "['<Super>Left']"
	dconf write /org/gnome/mutter/keybindings/toggle-tiled-right "['<Super>Right']"
	dconf write /org/gnome/shell/favorite-apps '["firefox.desktop", "Alacritty.desktop"]'
