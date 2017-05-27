# recover-crontab

A bash script that will help you to recover a destroyed crontab

## Why is this useful?

Cron jobs can easily be removed when the wrong command is executed. For example, crontab -r. By using this script, it will help the user to recover all their cron commands/jobs.

## Installation

```
git clone https://github.com/poanchen/recover-crontab.git
cd recover-crontab
```

## Usage

```
Usage: ./recover-crontab.sh [option] ... [arg]
Options:
-u arg : the username whose cron commands you are trying to recover
```

For example,

```
./recover-crontab.sh -u ubuntu
```
This will print out all the cron commands ran by the username ubuntu