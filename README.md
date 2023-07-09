## How to run Scripts

## Prerequisites

- AWS CLI configured with valid credentials and appropriate permissions to modify security groups.
- `jq` tool installed on the system for JSON parsing.
- `curl` command available for retrieving the current public IP address.

## 1. AWS Security Group IP Updater
This script allows you to automatically update the IP address in specific AWS security groups to ensure access control based on your current public IP address.

## Usage

1. Clone the repository or download the shell script to your local machine.

2. Make the shell script executable:
   ```bash
   chmod +x aws-security-group-ip-updater.sh
Open the shell script using a text editor and modify the following variables according to your requirements:

    security_group_name: The name of the target security group.
    region: The AWS region where the security group resides.
    server_detail: Any identifier or name for server with which security group is associated
    description: The description to identify the specific IP rule.
    profile: AWS profile to use to run the AWS cli commands

Save the modified script.

Run the script: ./aws-security-group-ip-updater.sh

The script will retrieve your current public IP address, check if it matches the IP already added in the security group rule using description, and update it if necessary.

You can schedule the scripts to run at regular intervals using cron or any other task scheduler of your choice.

Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request for develop branch.
