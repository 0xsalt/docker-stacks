# Docker Stacks: A Docker Compose Orchestration Repo

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Release](https://img.shields.io/github/v/release/0xsalt/docker-stacks)](https://github.com/0xsalt/docker-stacks/releases)
[![Docker Compose](https://img.shields.io/badge/docker%20compose-2496ED?style=flat&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![Changelog](https://img.shields.io/badge/changelog-v0.1.1-blue)](./CHANGELOG)
[![Semantic Versioning](https://img.shields.io/badge/semver-2.0.0-green)](https://semver.org/)
[![Maintenance](https://img.shields.io/badge/maintained-yes-green.svg)](https://github.com/0xsalt/docker-stacks/graphs/commit-activity)
[![GitHub Issues](https://img.shields.io/github/issues/0xsalt/docker-stacks)](https://github.com/0xsalt/docker-stacks/issues)

## Overview

Docker Stacks is a Docker Compose orchestration repository designed to provide a flexible and developer-friendly control plane for a collection of AI-powered services. The project's core purpose is to 
  * simplify the management of multi-service applications
  * each service lives in its own Git repository
  * streamline independent development
  * eliminate friction of Git submodules or other complex tooling

## Key Features (MVP)

  * **Central Orchestration**: A single repository manages the configuration for multiple application stacks.
  * **Independent Services**: Each service is a standalone Git repository, allowing developers to work on them freely.
  * **Flexible Stacks**: Use `compose.yaml` files to define different combinations of services for various development needs.
  * **Shared Networking**: Services within a stack communicate seamlessly over a shared Docker network.
  * **Simple CLI**: A `Makefile` provides easy-to-use commands for common tasks like starting, stopping, and logging.
  * **Primary Service**: The initial MVP includes the integration of the `discord-llm-bot` service.

## Project Structure

```
docker-stacks/
├── .git/                    # Git repository metadata
├── .gitignore              # Git ignore patterns
├── .prjroot                # Project root marker
├── .bmad-core/             # BMad Method infrastructure
├── Makefile                # Build and operation commands
├── docs/                   # Project documentation
│   ├── architecture/       # Architecture specifications
│   ├── epics/             # Epic definitions
│   └── stories/           # User story definitions
├── scripts/                # Utility and management scripts
│   └── bootstrap.sh       # Repository setup script
├── services/               # Independent service repositories
│   ├── discord-llm-bot/   # Discord LLM bot service
│   ├── next-docker-app/   # Next.js application service
│   └── other-services/    # Additional services
├── stacks/                 # Stack composition definitions
│   ├── stack_discord-llm-bot/  # Discord bot stack
│   │   ├── compose.yaml    # Docker Compose configuration
│   │   └── .env           # Environment variables
│   ├── stack_new-project/ # New project stack
│   │   ├── compose.yaml   # Docker Compose configuration
│   │   └── .env          # Environment variables
│   └── other-stacks/     # Additional stack configurations
└── services.lock.json    # Service dependency lock file
```

## Directory Structure

### Core Directories

- **`services/`**: Contains cloned Git repositories for each independent service. Each service is developed and versioned separately.
- **`stacks/`**: Contains stack composition definitions using Docker Compose. Each stack directory includes compose.yaml and environment files.
- **`scripts/`**: Houses utility scripts for repository management, bootstrapping, and operational tasks.
- **`.bmad-core/`**: BMad Method infrastructure for development workflow and tooling.

### Configuration Files

- **`.prjroot`**: Marks the project root for tooling and scripts
- **`.gitignore`**: Configured to ignore sensitive files while preserving repository structure
- **`Makefile`**: Provides standardized commands for stack operations
- **`services.lock.json`**: Tracks service versions and dependencies

## Getting Started

1. Clone the repository
2. Run the bootstrap script: `scripts/bootstrap.sh`
3. Use `make` commands for stack operations
4. Refer to individual stack documentation in `stacks/` directories

## Makefile Commands

The repository includes a Makefile with the following commands:

- `make help` - Display available commands and usage
- `make bootstrap` - Initialize the development environment
- `make up STACK=stack-name` - Start the specified Docker stack
- `make down STACK=stack-name` - Stop the specified Docker stack
- `make logs STACK=stack-name` - View logs for the specified stack
- `make clean` - Clean up Docker resources

Example usage:

```bash
make bootstrap
make up STACK=stack_discord-llm-bot
make logs STACK=stack_discord-llm-bot
make down STACK=stack_discord-llm-bot
make clean
```

## Architecture

For detailed architecture information, see:
- `docs/architecture/source-tree.md` - Complete source tree specification
- `docs/architecture/` - Additional architectural documentation