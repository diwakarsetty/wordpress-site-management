#!/bin/bash

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    # Install Docker (assuming Ubuntu)
    sudo apt-get update
    sudo apt-get install docker.io -y
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    # Install Docker Compose (assuming Ubuntu)
    sudo apt-get update
    sudo apt-get install docker-compose -y
fi

# Create WordPress site using the latest version
create_wordpress_site() {
    # Check if the site name is provided as an argument
    if [ -z "$1" ]; then
        echo "Please provide a site name as an argument."
        exit 1
    fi

    # Create a directory for the site
    site_name=$1
    mkdir $site_name
    cd $site_name

    # Create docker-compose.yml file
    cat <<EOT > docker-compose.yml
version: '3'
services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress

  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    ports:
      - 8080:80
    volumes:
      - ./wp-content:/var/www/html/wp-content
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
volumes:
  db_data:
EOT

    # Create a local WordPress directory for storing content
    mkdir wp-content

    # Start the containers
    docker-compose up -d

    # Add entry to /etc/hosts
    sudo -- sh -c "echo '127.0.0.1 $site_name' >> /etc/hosts"

    # Check if the site is up and healthy
    site_up=$(docker-compose ps -q wordpress)
    if [ -n "$site_up" ]; then
        echo "WordPress site $site_name is up and healthy."

        # Prompt the user to open the site in a browser
        read -p "Press Enter to open http://$site_name in your browser..."
        xdg-open "http://$site_name"
    else
        echo "Failed to start the WordPress site."
    fi
}

# Enable/disable the site by stopping/starting the containers
enable_disable_site() {
    if [ -z "$1" ]; then
        echo "Please provide a site name as an argument."
        exit 1
    fi

    site_name=$1

    # Stop or start the containers
    docker-compose -f $site_name/docker-compose.yml $2
}

# Delete the site by removing the containers and local files
delete_site() {
    if [ -z "$1" ]; then
        echo "Please provide a site name as an argument."
        exit 1
    fi

    site_name=$1

    # Stop and remove the containers
    docker-compose -f $site_name/docker-compose.yml down

    # Remove the directory
    rm -rf $site_name

    # Remove the entry from /etc/hosts
    sudo sed -i "/$site_name/d" /etc/hosts

    echo "WordPress site $site_name deleted."
}

# Check the subcommand provided by the user
case "$1" in
    create)
        create_wordpress_site "$2"
        ;;
    enable)
        enable_disable_site "$2" "start"
        ;;
    disable)
        enable_disable_site "$2" "stop"
        ;;
    delete)
        delete_site "$2"
        ;;
    *)
        echo "Usage: $0 {create|enable|disable|delete} <site_name>"
        exit 1
esac
