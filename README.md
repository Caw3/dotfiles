# Install locally

```
bash <(curl -s httsp://raw.githubusercontent.com/caw3/dotfiles/main/bin/setup-dotfiles)
```

# Install on remote
```
echo <host> > hosts
ansible-playbook playbooks/main.yml --inventory hosts
```
