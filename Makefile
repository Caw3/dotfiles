REMOTE_USER := carl
REMOTE_HOST := 178.62.227.207
REMOTE_KEY := ${HOME}/.ssh/id_vps

PKG_INSTALL := sudo dnf install -y
LN := @ln -vsf {${PWD},${HOME}}


help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: init ssh git tools gui gnome-settings
init: bash tmux vim ## Lightweight configuration
tools: docker golang
gui: font zathura alacritty ## Init GUI applications

bash: ## Init bash
	$(LN)/.bashrc

tmux: ## Init tmux
	@command -v $@ > /dev/null 2>&1 || $(PKG_INSTALL) $@
	$(LN)/.tmux.conf

vim: ## Init vim
	$(LN)/.vimrc
	$(LN)/.vim

git: ## Init git configs
	@command -v $@ > /dev/null 2>&1 || $(PKG_INSTALL) $@
	$(LN)/.gitconfig
	$(LN)/.git_template

ssh: rsync ## sync ssh configuration with a remote host
	@test -f $(REMOTE_KEY) && \
		(rsync -avz --mkpath -e "ssh -o StrictHostKeyChecking=no -i $(REMOTE_KEY)" \
		--exclude "known_hosts*" \
		--exclude "authorized_keys" \
		$(REMOTE_USER)@$(REMOTE_HOST):~/.ssh ${HOME} && \
		chmod 600 ${HOME}/.ssh/*) || echo "No key found!"
rsync:
	@command -v $@ > /dev/null 2>&1 || $(PKG_INSTALL) $@

# Tools
docker: ## Install docker
	$(PKG_INSTALL) $@ $@-compose
	sudo usermod -aG ${USER}
	sudo systemctl enable docker.service

golang: ## Install golang
	$(PKG_INSTALL) $@
	export PATH=$PATH:/usr/local/go/bin

# GUI 
zathura: ## Init zathura (PDF reader)
	@command -v $@ > /dev/null 2>&1 || $(PKG_INSTALL) $@
	@mkdir -p ${HOME}/.config/$@ 2> /dev/null
	$(LN)/.config/$@/zathurarc

alacritty: ## Init alacritty (Terminal emulator)
	@command -v $@ > /dev/null 2>&1 || $(PKG_INSTALL) $@
	@mkdir -p ${HOME}/.config/$@ 2> /dev/null
	$(LN)/.config/$@/alacritty.yml

font: jetbrains-mono-fonts # Install fonts
jetbrains-mono-fonts:
	@command -v $@ > /dev/null 2>&1 || $(PKG_INSTALL) $@

dconf-editor:
	@command -v $@ > /dev/null 2>&1 || $(PKG_INSTALL) $@

gnome-settings: dconf-editor font ## Init Gnome specific settings
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
