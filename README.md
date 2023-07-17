# WordPress Site Management Script

This is a command-line script written in Bash that allows you to easily create and manage WordPress sites using Docker with a LEMP (Linux, Nginx, MySQL, PHP) stack. The script automates the process of setting up a WordPress site with the latest WordPress version running in Docker containers.

## Prerequisites

Before using the script, make sure you have the following prerequisites installed on your system:

- Docker: Follow the instructions for installing Docker for your operating system from the official Docker website: [Install Docker](https://docs.docker.com/get-docker/).

- Docker Compose: Docker Compose usually comes pre-installed with Docker, but if it's not, you can install it separately following the instructions here: [Install Docker Compose](https://docs.docker.com/compose/install/).

## Getting Started

Follow the steps below to get started with the WordPress site management script:

1. **Create the Project Directory**

   Create a new directory to house your WordPress site management project:

   ```bash
   mkdir wordpress-site-management
2. **Navigate to the Project Directory**

   Change into the wordpress-site-management directory:
   ```
   cd wordpress-site-management
3. **Make the Script Executable**

   ```
   chmod +x wordpress.sh
## Usage

The script provides several subcommands that you can use to manage your WordPress sites. Each subcommand requires a site name as an argument.

1. **Create a New WordPress Site**

   To create a new WordPress site, use the `create` subcommand followed by the desired site name. The script will set up a LEMP stack using Docker containers and the latest WordPress version.

   ```
   sudo ./wordpress.sh create example.com
  Replace `example.com` with your desired site name. The script will create a directory with the site name, generate a docker-compose.yml file, and start the necessary containers. It will also add an entry to the /etc/hosts file, allowing you to access the site locally.
  If you encounter a port conflict on port 80, the script will display an error indicating that another service is already using the port. In this case, follow the instructions in the next section to resolve the port conflict.

2. **Resolving Port Conflict**

   If the script encounters a port conflict on port 80 during the creation of the WordPress site, it means that another service is already using the port. To resolve this, you have two options:

  a. Stop the Service Using Port 80 (Temporary Solution)
  You can stop the service that is using port 80 temporarily to allow the script to use the port for the WordPress container. However, please note that this might affect the functionality of the stopped service.
  
  For example, if Apache or Nginx is running and using port 80, you can stop the service using the appropriate command:
  For Apache:
   ```
   sudo systemctl stop apache2

For Nginx:
   ```
   sudo systemctl stop nginx
   
After stopping the service, you can retry creating the WordPress site:
 ```
 sudo ./wordpress.sh create example.com
 ```

b. Use a Different Port (Permanent Solution)

If stopping the service using port 80 is not an option, you can modify the docker-compose.yml file to use a different port for the WordPress container. Open the docker-compose.yml file in a text editor and locate the ports section under the wordpress service. Change the port mapping to use a different port, such as 8080:80:

```
services:
  wordpress:
    ports:
      - 8080:80
```

Save the changes to the docker-compose.yml file and retry creating the WordPress site with the updated port:

```
sudo ./wordpress.sh create example.com
```

3. **Enable/Disable a WordPress Site**

   You can enable or disable a WordPress site using the `enable` and `disable` subcommands, respectively.

   To enable a site and start the containers, use the following command:

   ```
   sudo ./wordpress.sh enable example.com
   ```
   Replace `example.com` with the site name you want to enable.


   *To disable a site and stop the containers, use the following command:*

   ```
   sudo ./wordpress.sh delete example.com
   ```
   Replace `example.com` with the site name you want to delete.
   
   ![Screenshot (143)](https://github.com/diwakarsetty/wordpress-site-management/assets/88228872/cb43a86c-94a6-4558-aee3-976eda144517)

   ![Screenshot (141)](https://github.com/diwakarsetty/wordpress-site-management/assets/88228872/37d0af97-589c-4cee-aa15-dec57899db4d)


  
