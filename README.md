# HNGi13 DevOps Stage 1 — Automated Deployment Script

## Author

**Noibi Jamiu Gbolahan**

## Overview

This project is part of the **HNGi13 DevOps Internship (Stage 1)**.
The goal is to automate the deployment of a Dockerized web application to a remote Linux server using a single Bash script.

The script handles everything — from cloning the repository to configuring Nginx as a reverse proxy and validating the deployment — all in one automated flow.


## Project Structure

hng13-stage1-devops/
├── deploy.sh \# Main automation script
└── README.md \# Documentation

The deployed app is hosted separately in another repo and served via Nginx on the EC2 instance.


## Features of the Script

 Prompts for and validates:

- GitHub Repository URL
- Personal Access Token (PAT)
- Branch name (defaults to `main`)
- Remote server SSH details
- Application internal port

Performs the following steps automatically:

1. Clones or updates the repository.
2. Checks for a valid Dockerfile or docker-compose.yml.
3. Connects to the remote server via SSH.
4. Installs and configures **Docker**, **Docker Compose**, and **Nginx**.
5. Transfers project files to the remote server.
6. Builds and runs Docker containers.
7. Sets up **Nginx reverse proxy** to route traffic to the container.
8. Validates successful deployment and logs all actions.


## Deployment Architecture

Local Machine ── deploy.sh ──► EC2 Instance
│
├── Dockerized App (HTML)
└── Nginx Reverse Proxy (Port 80)


## Live Demo

App deployed successfully at:
 **http://44.252.102.79/**


## 🪄 Usage Instructions

### 1️ Clone this repository

```bash
git clone https://github.com/<your-username>/hng13-stage1-devops.git
cd hng13-stage1-devops

2️ Make the script executable
chmod +x deploy.sh

3️ Run the deployment
./deploy.sh

Then follow the prompts to:
Enter your GitHub repo URL
Provide your PAT
Specify SSH details and port

Logging & Error Handling
All script actions are logged to a timestamped file (e.g. deploy_20251022_1430.log) for easy debugging.
Each major stage has validation and error-handling to ensure idempotent and reliable deployments.

Tools Used
Bash — Automation scripting
Docker & Docker Compose — Containerization
Nginx — Reverse proxy configuration
AWS EC2 (Ubuntu) — Hosting environment
Git — Source control and repo management




tweak it to what we build
also

Here's a tailored and polished version of the README for your project, reflecting exactly what was built and deployed:

***

# HNGi13 DevOps Stage 1 — Automated Deployment Script

## Author  
**Noibi Jamiu Gbolahan**

***

## Overview  
This project is part of the **HNGi13 DevOps Internship (Stage 1)**.  
It automates the deployment of a simple static web application served by Nginx inside a Docker container, hosted on an AWS EC2 Ubuntu server.

The provided Bash script (`deploy.sh`) performs a complete flow: cloning the project repo, installing Docker and dependencies on the server, transferring files, building and running the Docker container, and configuring Nginx for reverse proxy.

***

## Project Structure

```

hng13-stage1-devops/
├── deploy.sh          \# Main automation script
├── README.md          \# Project documentation
└── hng13-stage1-app/  \# Static website repo cloned and deployed (separate GitHub repo)

```

The static website served is a simple `index.html` running inside an Nginx Docker container.

***

## Features of the Script

Interactive prompts for:  
- GitHub repository URL  
- Personal Access Token (PAT)  
- Branch name (default `main`)  
- Remote server SSH username, IP, and SSH key path  
- Internal application port (set to 80 for HTTP)  

 Automates:  
1. Cloning or pulling the static site repo.  
2. Installing Docker, Docker Compose, and Nginx on the remote Ubuntu EC2 server.  
3. Transferring static site files and Docker config to the server (excluding `.git`).  
4. Building and running the Docker container with the static `index.html`.  
5. Setting up Nginx on the server as a reverse proxy for the container.  
6. Validating deployment via container status and HTTP requests.  

***

## Deployment Architecture

```

Local Machine ── deploy.sh ──► AWS EC2 Ubuntu Server
│
├── Dockerized Nginx serving static site (port 80)
└── Nginx reverse proxy routing traffic to container

```

***

## Live Demo

Accessible at:
 **http://44.252.102.79**

***

##  Usage Instructions

###  Clone this repository
```bash
git clone https://github.com/<your-username>/hng13-stage1-devops.git
cd hng13-stage1-devops
```


### Make the deploy script executable

```bash
chmod +x deploy.sh
```


###  Run the deployment script

```bash
./deploy.sh
```

Follow the on-screen prompts to supply your repository URL, PAT, server login details, and port.

***

## 🧾 Logging \& Error Handling

- The script logs to timestamped files (e.g., `deploy_20251022_1430.log`) for troubleshooting.
- It includes safeguards to ensure dependencies are installed and handles idempotent deployments.

***

## Technologies Used

- Bash scripting for automation
- Docker \& Docker Compose for containerization
- Nginx for serving static content and reverse proxy
- AWS EC2 (Ubuntu) for hosting
- Git for source control

***

Let me know if you want me to add or customize any particular section!

