# Azure WordPress Terraform Deployment

This repository contains Terraform configurations to build infrastructure for a Linux-based WordPress web application on the free tier of Azure.

## Overview

The Terraform scripts in this project will:

1. Create a Resource Group.
2. Set up a Virtual Network and Subnets.
3. Deploy a Linux-based Virtual Machine.
4. Configure Network Security Groups.
5. Set up Azure Database for MySQL.
6. Deploy WordPress on the Virtual Machine.
7. Configure necessary DNS settings.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- An [Azure account](https://azure.microsoft.com/en-us/free/) with free tier subscription.
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and configured.

## Usage

1. **Clone the repository:**
    ```sh
    git clone https://github.com/yourusername/azure-wordPress.git
    cd azure-wordPress
    ```

2. **Initialize Terraform:**
    ```sh
    terraform init
    ```

3. **Plan the deployment:**
    ```sh
    terraform plan
    ```

4. **Apply the configuration:**
    ```sh
    terraform apply
    ```

5. **Access your WordPress site:**
   After the deployment is complete, you can access your WordPress site using the public IP address of the Virtual Machine.

## Resources Created

- **Resource Group:** A container that holds related resources for the Azure solution.
- **Virtual Network and Subnets:** Network infrastructure for the VM.
- **Linux Virtual Machine:** The server where WordPress will be installed.
- **Network Security Groups:** Security rules to control inbound and outbound traffic.
- **Azure Database for MySQL:** Managed MySQL database service for WordPress.
- **DNS Settings:** Configuration for domain name resolution.

## Cleanup

To destroy the infrastructure created by Terraform, run:
```sh
terraform destroy
```

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Terraform](https://www.terraform.io/)
- [Azure](https://azure.microsoft.com/)
