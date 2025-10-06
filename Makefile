SHELL=/bin/bash 
REMOTE_KEY = ~/.ssh/key
LN = @ln -vsfn {${PWD},${HOME}}
PKG_CHECK = @command -v $@ > /dev/null 2>&1

ifneq ($(shell command -v dnf),)
	PKG_INSTALL = sudo dnf install -y
	FONT_PACKAGE_NAME = jetbrains-mono-fonts
endif

ifneq ($(shell command -v brew),)
	PKG_INSTALL = brew install
	FONT_PACKAGE_NAME = font-jetbrains-mono
endif

ifneq ($(shell command -v apt-get),)
	PKG_INSTALL = sudo apt-get install -y
	FONT_PACKAGE_NAME = fonts-jetbrains-mono
endif

.PHONY: help install init

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: init vim ansible git ripgrep htop fzf wget curl rsync podman podman-compose jq scripts ## Basic install
init: bash tmux vim ## Lightweight configuration (bash, vim, tmux)

bash: ## Init bash
	$(LN)/.bashrc
	$(LN)/.inputrc

tmux: ## Init tmux
	$(PKG_CHECK) || $(PKG_INSTALL) $@
	$(LN)/.tmux.conf

vim: ## Init vim
	$(PKG_CHECK) || $(PKG_INSTALL) $@
	$(LN)/.vimrc

jq: 
	$(PKG_CHECK) || $(PKG_INSTALL) $@

git: 
	$(PKG_CHECK) || $(PKG_INSTALL) $@

podman: 
	$(PKG_CHECK) || $(PKG_INSTALL) $@

podman-compose: 
	$(PKG_CHECK) || $(PKG_INSTALL) $@

ansible:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

rsync:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

fzf:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

ripgrep:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

htop:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

wget:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

curl:
	$(PKG_CHECK) || $(PKG_INSTALL) $@

key: ## Decrypt ssh-key
	@ansible-vault decrypt --output $(REMOTE_KEY) ~/.ssh/key

scripts: ## Make a .bin dir, update path, and symlink scripts to it
	$(LN)/.bin
	grep '$$HOME/.bin' $(HOME)/.bash_profile || \
		echo 'export PATH=$$PATH:$$HOME/.bin' >> \
		$(HOME)/.bash_profile

alacritty: $(FONT_PACKAGE_NAME) ## Init alacritty
	if [ ! $$(command -v apt-get) = ""  ]; then \
		sudo apt-get update; \
		sudo apt-get install -y software-properties-common; \
		sudo add-apt-repository -y ppa:aslatter/ppa; \
	fi
	$(PKG_CHECK) || $(PKG_INSTALL) alacritty
	mkdir -p ${HOME}/.config/alacritty 2> /dev/null
	$(LN)/.alacritty.toml

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
	dconf write /org/gnome/shell/favorite-apps '["firefox.desktop", "Alacritty.desktop"]'
