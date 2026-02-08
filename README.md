# My Homelab

This repository contains a collection of self-hosted services orchestrated with Docker Compose.

## Services

The following services are configured in this repository:

| Service | Description | Service | Description |
| :--- | :--- | :--- | :--- |
| **Authelia** | Authentication & SSO | **Booklore** | eBook Manager |
| **Code-Server** | VS Code in the browser | **CrowdSec** | Security automation |
| **Diun** | Docker Image Update Notifier | **Folding@Home** | Distributed computing |
| **FoundryVTT** | Virtual Tabletop | **Gotify** | Push notifications |
| **Homepage** | Dashboard | **IT-Tools** | Developer tools |
| **n8n** | Workflow automation | **Nextcloud** | Productivity suite |
| **OnlyOffice** | Document server | **OpenWebUI** | LLM UI |
| **Paperless** | Document management | **Pi-hole** | Ad blocking |
| **Pterodactyl** | Game server management | **Rallly** | Scheduling & polls |
| **Traefik** | Reverse proxy | **Uptime Kuma** | Monitoring |
| **Vaultwarden** | Password manager | **YT-Downloader** | Video downloader |

## Usage

This repository includes a helper script to manage all stacks.

### Update All Stacks
To pull the latest images and restart all services:

```bash
./update-all-compose.sh
```

Run with `--dry-run` to see what would happen without making changes:

```bash
./update-all-compose.sh --dry-run
```

Disclaimer: this script was written by AI, use at your own peril.

## Credits

Special thanks to the following projects and communities for their resources, guides, and inspiration:

- [James Turland's JimsGarage](https://github.com/JamesTurland/JimsGarage/)
- [LinuxServer.io](https://linuxserver.io/)

If I forgot anyone let me know and I'll add them.
