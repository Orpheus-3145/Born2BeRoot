# LVM partitions set during setup:
#
#   DEVICE                     SIZE     TYPE   MOUNT POINT 
#  _________________________________________________________
# | sda                       | 30.8G | disk  |             |
# | ├─sda1                    |  487M | part  | /boot       |
# | ├─sda2                    |    1K | part  |             |
# | └─sda5                    | 30.3G | part  |             |
# |   └─sda5_crypt            | 30.3G | crypt |             |
# |     ├─faru42--vg-home     |  4.7G | lvm   | /home       |
# |     ├─faru42--vg-root     |  9.3G | lvm   | /           |
# |     ├─faru42--vg-swap     |  2.1G | lvm   | [SWAP]      |
# |     ├─faru42--vg-var      |  2.8G | lvm   | /var        |
# |     ├─faru42--vg-tmp      |  2.8G | lvm   | /tmp        |
# |     ├─faru42--vg-srv      |  2.8G | lvm   | /srv        |
# |     └─faru42--vg-var--log |  3.7G | lvm   | /var/log    |
#  ─────────────────────────────────────────────────────────

# basic operations
su -
apt update && apt upgrade
apt insall vim
apt install sudo

# Users and groups
addgroup faru42
usermod -aG sudo,faru42 faru

# UFW
apt install ufw
ufw enable
ufw allow 4242/tcp

# SSH
(apt install openssh-server)
vim /etc/ssh/sshd_config  # decomment and set 4242 instead of 22 in the port
systemctl restart ssh
# [on VirtualBox, in VM Debian: settings -> network -> advanced -> port forwarding: add new rule and set 4242 as host port and guest port ]
# to connect from a client run the command: ssh localhost[@user_name] 4242

# PWD POLICY
apt install libpam-cracklib
vim /etc/pam.d/common-password
# at the line 'password   requisite       pam_cracklib.so'
# add: retry=3 minlen=10 difok=7 ucredit=1 lcredit=1 dcredit=1 maxrepeat=3 reject_username enforce_for_root
vim /etc/login.defs
# modify the three lines with:
# PASS_MAX_DAYS   30
# PASS_MIN_DAYS   2
# PASS_WARN_AGE   7

# SUDO POLICY
visudo
# add following lines:
# Defaults        passwd_tries=3
# Defaults        badpass_message="Password incorrect, kindly try it again"
# Defaults        requiretty
# Defaults        logfile="/var/log/sudo.log"
# Defaults        log_input
# Defaults        log_output
# Defaults        iolog_dir=/var/log/sudo

# monitoring (see file monitoring.sh)
cd /usr/sbin
touch monitoring.sh
chmod 744 monitoring.sh

# CRON
vim /etc/crontab
# add following line
# */10 *   * * *  root    /bin/bash /usr/sbin/monitoring.sh
