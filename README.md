# Ansible Baseline

A modular Ansible setup for provisioning secure, customised Linux development environments. Covers hardened SSH configuration, a POSIX-focused CLI stack, and a themed Oh My Zsh setup — structured for reuse, idempotent re-runs, and selective execution via tags.

## Requirements

- Ansible >= 2.12
- Python 3.x on the control node
- Target hosts: **Debian 11+ or Ubuntu 20.04+**
- SSH key-based access to target machines (`PasswordAuthentication` is disabled after hardening)

## Directory Structure

```
ansible-baseline/
├── ansible.cfg                  # Global Ansible configuration
├── inventories/
│   └── hosts.ini                # Inventory of target machines
├── LICENSE                      # MIT License
├── playbooks/
│   ├── full_setup.yml           # Full-stack provisioning (all roles)
│   ├── oh_my_zsh_setup.yml      # Zsh + theme + aliases
│   ├── sshd_hardening.yml       # Secure SSH configuration
│   └── system_tools.yml         # Core and extra CLI utilities
└── roles/
    ├── core_utils/              # Essential tools: git, vim, curl, zsh
    ├── extra_utils/             # Optional CLI tools: neovim, bat, htop, jq, tmux, etc.
    ├── oh_my_zsh/               # Zsh config, aliases, gg3 custom theme
    └── sshd_config_hardening/   # Hardened sshd_config + restart handler
```

## Inventory

Update `inventories/hosts.ini` to match your environment:

```ini
[dev]
10.10.10.10 ansible_user=deploy ansible_ssh_private_key_file=~/.ssh/id_rsa
10.10.10.11 ansible_user=deploy ansible_ssh_private_key_file=~/.ssh/id_rsa
```

## Usage

Each playbook requires `-e "host=<group>"`, where `<group>` matches the inventory block name.

### Run individual playbooks

```sh
ansible-playbook playbooks/system_tools.yml    -e "host=dev"
ansible-playbook playbooks/oh_my_zsh_setup.yml -e "host=dev"
ansible-playbook playbooks/sshd_hardening.yml  -e "host=dev"
```

### Run full environment setup

```sh
ansible-playbook playbooks/full_setup.yml -e "host=dev"
```

### Run by tag

All tasks are tagged for selective execution:

| Tag | Scope |
|---|---|
| `core` | Core CLI utilities and dotfiles |
| `extra` | Extra CLI utilities |
| `zsh` | Oh My Zsh install and config |
| `security` | SSH hardening |
| `dotfiles` | All dotfile deployments |
| `install` | All package installations |

```sh
# Only install packages, skip dotfiles
ansible-playbook playbooks/full_setup.yml -e "host=dev" --tags install

# Only apply SSH hardening
ansible-playbook playbooks/full_setup.yml -e "host=dev" --tags security

# Only deploy dotfiles (no package installs)
ansible-playbook playbooks/full_setup.yml -e "host=dev" --tags dotfiles
```

### Override default package lists

Package lists are defined in each role's `defaults/main.yml` and can be overridden at runtime:

```sh
ansible-playbook playbooks/system_tools.yml -e "host=dev" \
  -e '{"core_utils_packages": ["vim", "curl", "git", "zsh", "ripgrep"]}'
```

## Features

- Hardened `sshd_config`: root login, password auth, X11 forwarding, and empty passwords all disabled
- Configurable package lists via role defaults — override without editing role files
- Custom Oh My Zsh theme (`gg3`) with Git branch + SHA, Python venv indicator, and smart path truncation
- Idempotent — safe to re-run; existing config files are backed up before replacement
- OS family guard on all `apt` tasks (`when: ansible_os_family == "Debian"`)

## License

MIT License. See `LICENSE` for full text.
