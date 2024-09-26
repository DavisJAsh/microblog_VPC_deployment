#!/bin/bash

#Add all changes to Git
#Commit the changes with a message
#Push the changes to GitHub using your token


# Load GitHub Personal Access Token
GITHUB_TOKEN=$(cat ~/.secrets/github_token)

# Set up the GitHub repository URL with the token (replace with your repo details)
REPO_URL="https://$GITHUB_TOKEN@github.com/DavisJAsh/microblog_VPC_deployment"

# Navigate to the repository directory
cd ~/microblog_VPC_deployment

# Add all changes
git add .

# Commit the changes with a message
git commit -m "Automated from Jenkins"

# Push the changes to the repository
git push $REPO_URL main
