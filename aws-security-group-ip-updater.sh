#!/bin/bash

# Retrieve the current public IP address
public_ip=$(curl -s https://api.ipify.org)

# Function to check and update security group
check_and_update_security_group() {
    echo "<<===================================================>>"
    # Retrieve security group details
    security_group=$(aws ec2 describe-security-groups --group-name "$1" --region "$2" --profile $5 --query 'SecurityGroups[].IpPermissions[?FromPort==`22`].IpRanges')
    echo $1;
    # Check if the rule already exists
    Description=$4
    Result=$(echo "$security_group" | jq --arg desc "$Description" '.[][][] | select(.Description == $desc)')

    echo "Check for $4 IP: $Result"
    echo "============================"

    old_ip=''

    if [ -n "$Result" ]; then
        old_ip=$(echo "$Result" | jq -r '.CidrIp')
        # Remove "/32" from the end of the variable
        old_ip="${old_ip%/*}"
        echo "OLD IP in AWS for $3: $old_ip"
    else
        echo "There was no old IP found for $4 in $3 security group."
    fi

    echo "$4 Public IP Address: $6"
    echo "============================"

    # Compare old IP with current public IP
    if [ "$old_ip" == "$6" ]; then
        echo "FINAL Result ====>>> IP already exists for $4 in $3 security group in AWS."
    else
        if [ -n "$old_ip" ]; then
            # Remove old IP
            aws ec2 revoke-security-group-ingress --group-name "$1" --region "$2" --profile $5 --protocol tcp --port 22 --cidr "$old_ip"
            echo "Old IP Removed."
        else
            echo "There was no old IP."
        fi
        # Add new public IP
        aws ec2 authorize-security-group-ingress --group-name "$1" --region "$2" --profile $5 --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges="[{CidrIp=$6/32, Description=$4}]"
        echo "============================"
        echo "FINAL Result ====>>> New Public IP address added for $4 in $3 security group in AWS."
    fi
    echo "<<===================================================>>"
}

# Parameters to Call function for security group
security_group_name="security-group-name"
region="us-west-1"
server_detail="Server-Name"
#your profile name for running AWS CLI
profile="default"
#The rule description which is added in AWS security Group. This needs to be accurate otherwise script will not run properly
description="Developer-Name"

# Call function for each security group
check_and_update_security_group $security_group_name $region $server_detail $description $profile $public_ip
