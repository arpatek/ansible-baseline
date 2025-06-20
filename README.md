# Ansible Lab

This repository provides a modular Ansible setup for provisioning secure and customized Linux development environments. It includes hardened SSH configuration, CLI tooling, and a themed Oh My Zsh setup using best practices and POSIX standards.

## Directory Structure

```
ansible-lab/
├── ansible.cfg                  # Global Ansible configuration
├── inventories/
│   └── hosts.ini                # Inventory of target machines
├── LICENSE                      # Project license (MIT)
├── playbooks/
│   ├── full_setup.yml           # Full-stack provisioning
│   ├── oh_my_zsh_setup.yml      # Zsh + theme + aliases
│   ├── sshd_hardening.yml       # Secure SSH configuration
│   └── system_tools.yml         # Core and extra CLI utilities
└── roles/
    ├── core_utils/              # Essential tools: git, vim, etc.
    ├── extra_utils/             # Optional CLI tools: curl, bat, htop, etc.
    ├── oh_my_zsh/               # Zsh config, aliases, theme
    └── sshd_config_hardening/   # Hardened sshd_config + handler
```

## Inventory Format

Define your hosts inside an inventory group (host block) in `inventories/hosts.ini`. For example:

```
[targets]
10.10.1.10 ansible_user=root
10.10.1.11 ansible_user=root
```

## Usage

Each playbook requires the `-e "host=<group>"` flag, where `group` matches the inventory block name (e.g. `targets`). This ensures Ansible targets the correct group of machines.

### Run individual playbooks:

```sh
ansible-playbook -i inventories/hosts.ini playbooks/system_tools.yml -e "host=targets"
ansible-playbook -i inventories/hosts.ini playbooks/oh_my_zsh_setup.yml -e "host=targets"
ansible-playbook -i inventories/hosts.ini playbooks/sshd_hardening.yml -e "host=targets"
```

### Run full environment setup:

```sh
ansible-playbook -i inventories/hosts.ini playbooks/full_setup.yml -e "host=targets"
```

> **Note:** The `-e "host=..."` variable must match the inventory block name. This repository dynamically targets groups using this variable.

## Features

- Hardened `sshd_config` with root login and password authentication disabled
- POSIX-focused CLI stack: `git`, `vim`, `most`, `curl`, `htop`, `bat`, etc.
- Custom Oh My Zsh theme with Git, Python venv, and abbreviated path display
- Aliases and environment tuning built for terminal-native workflows

## License

MIT License. See `LICENSE` file for full text.
