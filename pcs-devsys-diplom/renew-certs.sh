#!/usr/bin/env bash

date
echo -e "\033[1mStarting renew-certs.sh...\033[0m"

export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

# Removing expired certificates
if vault write pki_int/tidy tidy_cert_store=true tidy_revoked_certs=true
then
  echo -e "\033[1mSuccessfully revoked expired certificates!\033[0m"
else
  echo -e "\033[1mSomething's wrong. Didn't manage to revoke expired certificates.\033[0m"
fi

# Generating a new certificate and writing it into the same files
if vault write -format=json pki_int/issue/example-dot-com common_name="example.com" ttl="720h" > example.com.crt
then
  echo -e "\033[1mSuccessfully generated a new certificate!\033[0m"
else
  echo -e "\033[1mSomething's wrong. Didn't manage to generate a new certificate. Interrupting the script...\033[0m"
  exit
fi
jq -r .data.certificate < example.com.crt > /home/vagrant/example.com.crt.pem
jq -r .data.issuing_ca < example.com.crt >> /home/vagrant/example.com.crt.pem
jq -r .data.private_key < example.com.crt > /home/vagrant/example.com.crt.key

# Checking if there are any errors; if no, then reboot our nginx server
if nginx -t
then
    echo -e "\033[1mRestarting nginx...\033[0m"
    if systemctl restart nginx
    then
      echo -e "\033[1mRestarted nginx successfully.\033[0m"
    else
      echo -e "\033[1m[!!!] Something's wrong. Please check it manually.\033[0m"
    fi
else
    echo -e "\033[1m[!!!] Something's wrong. Please check it manually.\033[0m"
fi