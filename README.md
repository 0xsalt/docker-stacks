# Docker Stacks: A Docker Compose Orchestration Repo

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
├── .gitignore
├── Makefile
├── scripts/
│   └── bootstrap.sh
├── services/
│   ├── discord-llm-bot/
│   ├── next-docker-app/
│   └── other-services/
├── stacks/
│   ├── stack_discord-llm-bot/
│   │   ├── compose.yaml
│   │   └── .env
└── services.lock.json
```

