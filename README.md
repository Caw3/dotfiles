# Install locally

```
bash <(curl -s https://raw.githubusercontent.com/caw3/dotfiles/main/bin/setup-dotfiles)
```

# Install on remote
```
echo <host> > hosts
ansible-playbook playbooks/main.yml --inventory hosts
```

# Install GUI packages
```
echo localhost > hosts
sudo ansible-playbook playbooks/gui.yml --connection=local --inventory hosts
```
