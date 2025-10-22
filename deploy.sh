#!/bin/bash

# Prompt for input
read -p "Enter Git repository URL: " REPO_URL
read -p "Enter Personal Access Token (PAT): " PAT
read -p "Enter branch name (default: main): " BRANCH
BRANCH=${BRANCH:-main}
read -p "Enter remote server username: " SERVER_USER
read -p "Enter remote server IP: " SERVER_IP
read -p "Enter SSH key path: " SSH_KEY
read -p "Enter application internal port (e.g. 80): " APP_PORT

# Step 1: Clone or pull repo on local
if [ ! -d "./repo_clone" ]; then
  git clone --branch $BRANCH https://$PAT@${REPO_URL#https://} repo_clone
else
  cd repo_clone
  git pull origin $BRANCH
  cd ..
fi

# Step 2: SSH to remote - prepare directory
ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" "rm -rf /home/$SERVER_USER/hng13-stage1-app && mkdir -p /home/$SERVER_USER/hng13-stage1-app"

# Step 3: Copy necessary files (avoid .git)
scp -i "$SSH_KEY" repo_clone/Dockerfile repo_clone/docker-compose.yml repo_clone/index.html "$SERVER_USER@$SERVER_IP:/home/$SERVER_USER/hng13-stage1-app/"

# Step 4: Install Docker, Docker Compose, Nginx if missing on remote
ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" <<'ENDSSH'
sudo apt update -y
sudo apt install -y docker.io docker-compose nginx
sudo systemctl enable nginx
ENDSSH

# Step 5: Add user to docker group
ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" "sudo usermod -aG docker $USER"

# Step 6: Build and run Docker containers
ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" <<EOF
cd /home/$SERVER_USER/hng13-stage1-app
docker-compose down
docker-compose build
docker-compose up -d
EOF

# Step 7: Configure Nginx proxy on remote to forward port 80 to APP_PORT
NGINX_CONF="/etc/nginx/sites-available/myapp"
ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" "sudo bash -c 'cat > $NGINX_CONF'" <<EOL
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:$APP_PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOL

ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" <<EOF
sudo ln -sf $NGINX_CONF /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
EOF

# Step 8: Validate deployment
echo "Validating deployment..."
ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" "docker ps"
ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" "curl -I http://localhost"

echo "Deployment completed successfully. Check the app on your server IP."
