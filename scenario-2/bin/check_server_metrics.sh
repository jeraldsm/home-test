#!/usr/bin/env bash

# Original Author: Jerald Sabu Manakkunnel

usage() {
  echo "$0 usage:" && grep " .)\ #" $0; exit 0; 
}
[ $# -eq 0 ] && usage

while getopts ":h:m:w:c:e:" arg; do
  case $arg in
    m) # Specify the metrics name. Allowd Values: "cpu, memory, disk, open_files, open_tcp_connections"
      metrics=${OPTARG}
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
[[ "${warning}" == "" ]] && warning="75"
[[ "${critical}" == "" ]] && critical="90"


# --------------- CPU USAGE ----------------#
if [[ "${metrics}" =~ "cpu" ]]; then
  CPU_CALC=$(top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}')
  CPU=$(printf %.0f $CPU_CALC)

  if [[ "${CPU}" -lt "${warning}" ]] && [[ "${CPU}" -lt "${critical}" ]]; then 
    echo -e "\n OK. CPU: ${CPU}%"
  elif [[ "${CPU}" -ge "${warning}" ]] && [[ "${CPU}" -lt "${critical}" ]]; then 
    echo -e "\n Warning! CPU: ${CPU}%"
    echo -e "\n Warning! CPU: ${CPU}%" | mail -s "Warning! CPU Alert" ${email} > /dev/null 2>&1
  elif [[ "${CPU}" -ge "${critical}" ]]; then
     echo -e "\n Critical! CPU: ${CPU}%"
    echo -e "\n Critical! CPU: ${CPU}%" | mail -s "Critical! CPU Alert" ${email} > /dev/null 2>&1
  else
    echo -e "\n Unknown CPU: ${CPU}%"  | mail -s "Unknown! CPU Alert" ${email} > /dev/null 2>&1
  fi
exit 0

fi

# --------------- MEMORY USAGE ----------------#
if [[ "${metrics}" =~ "mem" ]]; then
  FREE_DATA=$(free -m | grep Mem)
  CURRENT_MEM=$(echo $FREE_DATA | cut -f3 -d' ')
  TOTAL_MEM=$(echo $FREE_DATA | cut -f2 -d' ')
  RAM_CALC=$(echo "scale = 2; $CURRENT_MEM/$TOTAL_MEM*100" | bc)
  RAM=$(printf %.0f $RAM_CALC)

  if [[ "${RAM}" -lt "${warning}" ]] && [[ "${RAM}" -lt "${critical}" ]]; then 
    echo -e "\n OK. RAM: ${RAM}% \n"
  elif [[ "${RAM}" -ge "${warning}" ]] && [[ "${RAM}" -lt "${critical}" ]]; then 
    echo -e "\n Warning! RAM: ${RAM}%"
    echo -e "\n Warning RAM: ${RAM}%" | mail -s "Warning! Memory Alert" ${email} > /dev/null 2>&1
  elif [[ "${RAM}" -ge "${critical}" ]]; then
    echo -e "\n Critical! RAM: ${RAM}%" 
    echo -e "\n Critical! RAM: ${RAM}%" | mail -s "Critical! Memory Alert" ${email} > /dev/null 2>&1
  else
    echo -e "\n Unknown! RAM: ${RAM}%"  | mail -s "Unknown! Memory Alert" ${email} > /dev/null 2>&1
  fi  
exit 0
fi

# --------------- DISK USAGE ----------------#
if [[ "${metrics}" =~ "disk" ]]; then
  DISK=$(df -lh | awk '{if ($6 == "/") { print $5 }}' | head -1 | cut -d'%' -f1)

  if [[ "${DISK}" -lt "${warning}" ]] && [[ "${DISK}" -lt "${critical}" ]]; then 
    echo -e "\n OK. DISK: ${DISK}%"
  elif [[ "${DISK}" -ge "${warning}" ]] && [[ "${DISK}" -lt "${critical}" ]]; then 
    echo -e "\n Warning! DISK: ${DISK}%"
    echo -e "\n Warning! DISK: ${DISK}%" | mail -s "Warning! DISK Alert" ${email} > /dev/null 2>&1
  elif [[ "${DISK}" -ge "${critical}" ]]; then
    echo -e "\n Critical! DISK: ${DISK}%"
    echo -e "\n Critical! DISK: ${DISK}%" | mail -s "Critical! DISK Alert" ${email} > /dev/null 2>&1
  else
    echo -e "\n Unknown! DISK: ${DISK}%"  | mail -s "Unknown! DISK Alert" ${email} > /dev/null 2>&1
  fi
exit 0  
fi

# --------------- OPEN_FILES USAGE ----------------#
if [[ "${metrics}" =~ "open_files" ]]; then
  OPEN_FILES=$(lsof | wc -l)

  if [[ "${OPEN_FILES}" -lt "${warning}" ]] && [[ "${OPEN_FILES}" -lt "${critical}" ]]; then 
    echo -e "\n OK. OPEN_FILES: ${OPEN_FILES}"
  elif [[ "${OPEN_FILES}" -ge "${warning}" ]] && [[ "${OPEN_FILES}" -lt "${critical}" ]]; then 
    echo -e "\n Warning! OPEN_FILES: ${OPEN_FILES}"
    echo -e "\n Warning! OPEN_FILES: ${OPEN_FILES}" | mail -s "Warning! OPEN_FILES Alert" ${email} > /dev/null 2>&1
  elif [[ "${OPEN_FILES}" -ge "${critical}" ]]; then
    echo -e "\n Critical! OPEN_FILES: ${OPEN_FILES}"
    echo -e "\n Critical! OPEN_FILES: ${OPEN_FILES}" | mail -s "Critical! OPEN_FILES Alert" ${email} > /dev/null 2>&1
  else
    echo -e "\n Unknown! OPEN_FILES: ${OPEN_FILES}"  | mail -s "Unknown! OPEN_FILES Alert" ${email} > /dev/null 2>&1
  fi
exit 0  
fi

# --------------- OPEN_TCP_CONNECTIONS ----------------#
if [[ "${metrics}" =~ "open_tcp_connection" ]]; then
  OPEN_TCP_CONNECTIONS=$(netstat -tn | tail -n +3 | wc -l)

  if [[ "${OPEN_TCP_CONNECTIONS}" -lt "${warning}" ]] && [[ "${OPEN_TCP_CONNECTIONS}" -lt "${critical}" ]]; then 
    echo -e "\n OK. OPEN_TCP_CONNECTIONS: ${OPEN_TCP_CONNECTIONS}"
  elif [[ "${OPEN_TCP_CONNECTIONS}" -ge "${warning}" ]] && [[ "${OPEN_TCP_CONNECTIONS}" -lt "${critical}" ]]; then 
    echo -e "\n Warning! OPEN_TCP_CONNECTIONS: ${OPEN_TCP_CONNECTIONS}"
    echo -e "\n Warning! OPEN_TCP_CONNECTIONS: ${OPEN_TCP_CONNECTIONS}" | mail -s "Warning! OPEN_TCP_CONNECTIONS Alert" ${email} > /dev/null 2>&1
  elif [[ "${OPEN_TCP_CONNECTIONS}" -ge "${critical}" ]]; then
    echo -e "\n Critical! OPEN_TCP_CONNECTIONS: ${OPEN_TCP_CONNECTIONS}"
    echo -e "\n Critical! OPEN_TCP_CONNECTIONS: ${OPEN_TCP_CONNECTIONS}" | mail -s "Critical! OPEN_TCP_CONNECTIONS Alert" ${email} > /dev/null 2>&1
  else
    echo -e "\n Unknown! OPEN_TCP_CONNECTIONS: ${OPEN_TCP_CONNECTIONS}"  | mail -s "Unknown! OPEN_TCP_CONNECTIONS Alert" ${email} > /dev/null 2>&1
  fi
exit 0  
fi
