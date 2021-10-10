#!/usr/bin/env bash

# Original Author: Jerald Sabu Manakkunnel

usage() {
  echo "$0 usage:" && grep " .)\ #" $0; exit 0; 
}
[ $# -eq 0 ] && usage

while getopts ":h:s:w:c:e:" arg; do
  case $arg in
    s) # Specify the website name to check ssl expiry.
      website=${OPTARG}
      echo "Website is ${OPTARG}"
      ;;
    w) # Specify warning threshold
      warning=${OPTARG}
      ;;
    c) # Specify critical threshold
      critical=${OPTARG}
      ;;
    e) # Specify email Id
      email=${OPTARG}
      echo $email
      ;;            
    h | *) # Display help.
      usage
      exit 0
      ;;
  esac
done
[[ "${warning}" == "" ]] && warning="30"
[[ "${critical}" == "" ]] && critical="15"

certificate_file=$(mktemp)
echo -n | openssl s_client -servername "$website" -connect "$website":443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $certificate_file
date=$(openssl x509 -in $certificate_file -enddate -noout | sed "s/.*=\(.*\)/\1/")
date_s=$(date -d "${date}" +%s)
now_s=$(date -d now +%s)
date_diff=$(( (date_s - now_s) / 86400 ))

if [[ "${date_diff}" -gt "${warning}" ]] || [[ "${date_diff}" -gt "${date_diff}" ]]; then 
  echo "OK. $website will expire in $date_diff days"
elif [[ "${date_diff}" -le "${warning}" ]] && [[ "${date_diff}" -gt "${critical}" ]]; then 
  echo "Warning!. $website will expire in $date_diff days"
  echo -e "Warning!. $website will expire in $date_diff days" | mail -s "Warning! SSL certificate Expiry Alert" ${email} > /dev/null 2>&1
elif [[ "${date_diff}" -ge "${critical}" ]]; then
  echo -e "Critical!. $website will expire in $date_diff days" 
  echo -e "Critical!. $website will expire in $date_diff days" | mail -s "Warning! SSL certificate Expiry Alert" ${email} > /dev/null 2>&1
else
  echo -e "Unkown!. $website will expire in $date_diff days" | mail -s "Warning! SSL certificate Expiry Alert" ${email} > /dev/null 2>&1
fi  

rm "$certificate_file"

