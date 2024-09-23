# Azure WordPress Setup with Terraform

## Project Overview

This project aims to set up WordPress on Azure Free Tier using Infrastructure as Code (IaC) with Terraform. The focus is on creating a Linux web application running with a MySQL database, rather than using the Azure Marketplace App Service offering. This is a work in progress.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Architecture](#architecture)
- [Setup Instructions](#setup-instructions)
- [Resources](#resources)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- Azure CLI installed and configured
- An Azure account with access to the Free Tier

## Architecture

The architecture for this setup includes:

- A Linux-based virtual machine for the WordPress application
- A MySQL database instance
- Networking components to securely connect the application and database

## Setup Instructions

1. **Clone the Repository**
    ```sh
    git clone https://github.com/yourusername/azure-wordpress.git
    cd azure-wordpress
    ```

2. **Initialize Terraform**
    ```sh
    terraform init
    ```

3. **Plan the Infrastructure**
    ```sh
    terraform plan
    ```

4. **Apply the Configuration**
    ```sh
    terraform apply
    ```

## Resources

- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [Azure Free Tier](https://azure.microsoft.com/en-us/free/)
- [WordPress](https://wordpress.org/)

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.