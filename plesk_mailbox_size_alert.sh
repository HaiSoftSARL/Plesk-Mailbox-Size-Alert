#!/bin/bash
# Check your Plesk managed mailbox size
# Email alert when desired size is reached
# Website: haisoft.net

## WARNING: Work in progress, do not use yet

## Settings

max_size="1000" # Size in MegaBytes (MB)
mailalert="yes" # Receive mail alerts (yes/no)
email_address="root@localhost" # Email address to receive alerts

## Directories

maildomaindir="/var/qmail/mailnames"


##############
### Script ###
##############

# Misc Vars
selfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

# Download bash API
if [ ! -f "ultimate-bash-api.sh" ]; then
	wget https://raw.githubusercontent.com/UltimateByte/ultimate-bash-api/master/ultimate-bash-api.sh
	chmod +x ultimate-bash-api.sh
fi
# shellcheck disable=SC1091
source ultimate-bash-api.sh

fn_logecho "#############################"
fn_logecho "#### Plesk Mailbox Size #####"
fn_logecho "#############################"

if [ ! -d "${maildomaindir}" ]; then
  fn_logecho "[ ERROR ] cannot find mail direcotry"
  exit 1
fi

fn_logecho "[ INFO ] Estimating mailbox amount..."
totaldomains="$(find "${maildomaindir}" -mindepth 1 -maxdepth 1 -type d | wc -l)"
totaladdresses=$(find "${maildomaindir}" -mindepth 2 -maxdepth 2 -type d | wc -l)"

fn_logecho "[ INFO ] Calculating mailbox sizes... "
echo ""
maillist="$(find "${maildomaindir}" -mindepth 2 -maxdepth 2 -type d)"
count=0
for i in ${maillist}; do
  count=$((count+1))
  echo -en "\e[1A"
  echo -e "\r\e[0K ${iteration}/${totaladdresses}"
  mailboxsizelist="du -sm ${i}"
  

done

# Send mail alert
fn_mail_alert(){
	if [ "${mailalert}" == "yes" ]; then
		fn_logecho "[INFO] Sending mail alert to: ${mailaddress}"
		echo -e "${currlog}" | mail -s "$(hostname -s) - ${pidname} - ${portcheck} killed" ${mailaddress}
	fi
	# Since this is the last action that should occur
	exit
}


fn_mail_alert
