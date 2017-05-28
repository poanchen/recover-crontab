function showCronCommandFormat {
  echo "[INFO]    - - - - -"
  echo "[INFO]    | | | | |"
  echo "[INFO]    | | | | +----- day of week (0 - 6) (Sunday=0)"
  echo "[INFO]    | | | +------- month (1 - 12)"
  echo "[INFO]    | | +--------- day(s) of month (1 - 31)"
  echo "[INFO]    | +----------- hour(s) (0 - 23)"
  echo "[INFO]    +------------- minute(s) (0 - 59)"
}
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
    for eachPathToFile in "${files[@]}"; do
      grep "CRON.*${2}" "$eachPathToFile" > output.txt
    done
    fileSize=$(wc -c <"output.txt")
    if [[ fileSize -eq 0 ]]; then
      echo "[WARNING] No cron commands/jobs are ran by the username ${2}."
    else
      while IFS= read -r line; do
        if [[ $line =~ CMD\ .(.*). ]]; then
            echo "${BASH_REMATCH[1]}" >> output1.txt
        fi
      done < output.txt
      awk '!a[$0]++' output1.txt > output.txt
      i=0
      lines=()
      while IFS= read -r line; do
        echo "[INFO]    How often do you want this commmand to run?"
        echo "[COMMAND] $line"
        echo "[INFO]    * * * * * $line"
        showCronCommandFormat
        echo "[INFO]    For example,"
        echo "[INFO]    1 * * * *"
        read input </dev/tty
        echo "[INFO]    $input $line"
        lines[i]="$input $line"
        ((i+=1))
        showCronCommandFormat
      done < output.txt
      echo ""
      echo "[INFO]    Please copy the following lines into your crontab files. (They are also saved in the output.txt file)"
      ((i-=1))
      rm output.txt
      rm output1.txt
      for i in `seq 0 $i`; do
        echo "${lines[$i]}"
        echo "${lines[$i]}" >> output.txt
      done
      echo ""
    fi
  fi
else
  echo '[WARNING] Invalid option'
fi