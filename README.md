# Born2BeRoot
Set up a mini server using Debian on VM (VirtualBox).


# Prerequisites
 - download Debian image
 - have VirtualBox installed


# Overview
This project aims to set up a simple server that has the following configuration:
  1) User named faru42 that belongs to sudo group

  2) Firewall UFW that allows port 4242

  3) SSH protocol configured to communicate on port 4242

  4) Strong password policy (using cracklib):
      - max attempts: 3
      - min length pwd: 10
      - max equal characters of the previous pwd: 3
      - min 1 upper-case letter, min 1 lower-case letter, min 1 digit
      - max occurences of the same consecutive character: 3
      - no username contained inside pwd
      - root pwd has to comply with these rules

  5) Strong sudo policy:
      - max attempts: 3
      - shows custom message due to wrong pwd
      - requires tty
      - sudo log active and stored in /var/log/sudo/

  6) A script (see monitoring.sh) installed in /usr/sbin shows in stdout some system info every 10 minutes (scheduled via cron utility)
