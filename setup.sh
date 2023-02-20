# PARTIZIONAMENTO LVM IN FASE DI SETUP INSTALLAZIONE:
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

#!/bin/bash
su -
apt update && apt upgrade
apt insall vim
apt install sudo

# UTENTI E GRUPPI
addgroup faru42
usermod -aG sudo,faru42 faru

# UFW
apt install ufw
ufw enable
ufw allow 4242/tcp

# SSH
(apt install openssh-server)
vim /etc/ssh/sshd_config  # decommentare e inserire 4242 al posto di 22 per la porta
systemctl restart ssh
# [ in VirtualBox, sulla VM Debian: Impostazioni-> Rete->   ]
# [ Avanzate-> Inoltro delle porte: aggiungere nuova regola ]
# [ e settare 4242 in porta host e porta guest              ]

# PWD POLICY
apt install libpam-cracklib
vim /etc/pam.d/common-password
# alla voce 'password   requisite       pam_cracklib.so'
# aggiungere alla lista: retry=3 minlen=10 difok=7 ucredit=1 lcredit=1 dcredit=1 maxrepeat=3 reject_username enforce_for_root
vim /etc/login.defs
# modificare le 3 voci con i valori passati
# PASS_MAX_DAYS   30
# PASS_MIN_DAYS   2
# PASS_WARN_AGE   7

# SUDO POLICY
visudo
# aggiungere le seguenti voci:
# Defaults        passwd_tries=3
# Defaults        badpass_message="Password incorrect, kindly try it again"
# Defaults        requiretty
# Defaults        logfile="/var/log/sudo.log"
# Defaults        log_input
# Defaults        log_output
# Defaults        iolog_dir=/var/log/sudo

# monitoring.sh
cd /usr/sbin
touch monitoring.sh
chmod 744 monitoring.sh
vim monitoring.sh
# inserire il seguente script
#  __________________________________________________________________________________________________________
# |#!/bin/bash                                                                                               |
# |if (cat /etc/fstab | grep -q  mapper)                                                                     |
# |then                                                                                                      |
# |    lvm_use="in use"                                                                                      |
# |else                                                                                                      |
# |    lvm_use="not in use"                                                                                  |
# |fi                                                                                                        |
# |                                                                                                          |
# |wall "    ||=> Architecture: $(uname -a)                                                                  |
# |    ||=> Physical CPU: $(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)                          |
# |    ||=> Virtual CPU: $(grep "processor" /proc/cpuinfo | wc -l)                                           |
# |    ||=> RAM usage: $(free -m | grep Mem | awk '{printf("%d/%d MB (%.2f%%)", $3, $2, $3/$2 * 100)}')      |
# |    ||=> Disk usage: $(df -h --total | grep total | awk '{printf("%.1f/%.1f GB (%.2f%%)", $3, $2, $5)}')  |
# |    ||=> CPU usage: $(top -bn1 | grep '^%Cpu' | awk '{printf("%.1f%%", $2 + $4)}')                        |
# |    ||=> Last boot: $(who -b | awk '{print $3}') $(who -b | awk '{print $4}')                             |
# |    ||=> LVM $lvm_use                                                                                     |
# |    ||=> Active connections: $(ss -lntup | grep LISTEN | wc -l)                                           |
# |    ||=> Users currently logged in: $(who | wc -l)                                                        |
# |    ||=> IP: $(hostname -I) MAC: $(ip link show | grep link/ether | awk '{print $2}')                     |
# |    ||=> Sudo executions: $(cat /var/log/sudo.log | grep COMMAND | wc -l) "                               |
#  ────────────────────────────────────────────────────────────────────────────────────────────────────────── 

# CRON
vim /etc/crontab
# aggiungere la seguente linea
# */10 *   * * *  root    /bin/bash /usr/sbin/monitoring.sh

# RESTART
shutdown -r now
