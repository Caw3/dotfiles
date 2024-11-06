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

ifneq ($(shell command -v brew),)
	PKG_INSTALL = brew install
	FONT_PACKAGE_NAME = font-jetbrains-mono
	SHELLCHECK = ShellChec
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

install: init ansible git ripgrep htop fzf wget curl rsync scripts ## Basic install
init: bash tmux vim ## Lightweight configuration
gui: $(FONT_PACKAGE_NAME) alacritty gnome-settings ## Install alacritty

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

emacs: git
	$(PKG_CHECK) || $(PKG_INSTALL) $@
	$(PKG_INSTALL) cmake
	$(LN)/.config/doom
	@git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
	@~/.config/emacs/bin/doom install

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

# Tools
scripts:
	$(LN)/.bin
	grep '$$HOME/.bin' $(HOME)/.bash_profile || \
		echo 'export PATH=$$PATH:$$HOME/.bin' >> \
		$(HOME)/.bash_profile
	$(PKG_CHECK) || $(PKG_INSTALL) fzf

alacritty: $(FONT_PACKAGE_NAME) ## Init alacritty (Terminal emulator)
	if [ ! $$(command -v apt-get) = ""  ]; then \
		sudo apt-get update; \
		sudo apt-get install -y software-properties-common; \
		sudo add-apt-repository -y ppa:aslatter/ppa; \
	fi
	$(PKG_CHECK) || $(PKG_INSTALL) alacritty
	mkdir -p ${HOME}/.config/alacritty 2> /dev/null
	$(LN)/.config/alacritty/alacritty.toml

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
