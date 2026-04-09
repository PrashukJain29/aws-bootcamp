#!/bin/bash
set -e

echo "🚀 Setting up AWS Bootcamp environment..."

# Backend setup
echo "📦 Setting up Flask backend..."
cd /workspaces/aws-bootcamp/backend-flask

# Create virtual environment
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "✓ Virtual environment created"
fi

# Activate venv and install dependencies
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
echo "✓ Backend dependencies installed"

# Frontend setup
echo "📦 Setting up React frontend..."
cd /workspaces/aws-bootcamp/frontend-react-js

# Install npm dependencies
if [ ! -d "node_modules" ]; then
    npm install
    echo "✓ Frontend dependencies installed"
else
    echo "✓ Node modules already installed"
fi

# Environment setup
echo "🔧 Configuring AWS..."
export AWS_CLI_AUTO_PROMPT=on-partial
echo 'export AWS_CLI_AUTO_PROMPT=on-partial' >> ~/.bashrc

# Install AWS CLI v2
echo "📥 Installing AWS CLI v2..."
if ! command -v aws &> /dev/null; then
    cd /tmp
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws/
    echo "✓ AWS CLI v2 installed"
else
    echo "✓ AWS CLI already installed"
fi

# Install PostgreSQL client
echo "📥 Installing PostgreSQL client..."
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
sudo apt update
sudo apt install -y postgresql-client-13 libpq-dev
echo "✓ PostgreSQL client installed"
cd /workspaces/aws-bootcamp

# Create environment file template if it doesn't exist
if [ ! -f "/workspaces/aws-bootcamp/.env" ]; then
    cat > /workspaces/aws-bootcamp/.env << 'EOF'
# Backend
FLASK_APP=app.py
FLASK_ENV=development
FLASK_DEBUG=1

# Frontend
REACT_APP_BACKEND_URL=http://localhost:5000

# AWS
AWS_DEFAULT_REGION=us-east-1
EOF
    echo "✓ Created .env template"
fi

echo ""
echo "✅ Environment setup complete!"
echo ""
echo "Quick start:"
echo "  Backend:  cd backend-flask && source venv/bin/activate && python app.py"
echo "  Frontend: cd frontend-react-js && npm start"
