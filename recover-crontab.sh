if [[ $1 == '-h' || $1 == '--help' || $1 == '' ]]; then
  echo 'Usage: ./recover-crontab.sh [option] ... [arg]'
  echo 'Options:'
  echo '-u arg : the username whose cron commands you are trying to recover'
  echo ''
  echo 'For example, ./recover-crontab.sh -u ubuntu  #recovering the cron commands run by the username ubuntu'
elif [[ $1 == '-u' ]]; then
  if [[ $2 == '' ]]; then
    echo '[WARNING] Please specify the username whose cron commands you are trying to recover.'
  else
    stdout="$(ls /var/log/syslog* | grep '[^z]$')"
    files=($stdout)
    for eachPathToFile in "${files[@]}"
    do
      grep "CRON.*${2}" "$eachPathToFile"
    done
  fi
else
  echo '[WARNING] Invalid option'
fi