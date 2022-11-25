#!/bin/bash
if (cat /etc/fstab | grep -q  mapper)
then
    lvm_use="in use"
else
    lvm_use="not in use"
fi

wall "    ||=> Architecture: $(uname -a)
    ||=> Physical CPU: $(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
    ||=> Virtual CPU: $(grep "processor" /proc/cpuinfo | wc -l)
    ||=> RAM usage: $(free -m | grep Mem | awk '{printf("%d/%d MB (%.2f%%)", $3, $2, $3/$2 * 100)}')
    ||=> Disk usage: $(df -h --total | grep total | awk '{printf("%.1f/%.1f GB (%.2f%%)", $3, $2, $5)}')
    ||=> CPU usage: $(top -bn1 | grep '^%Cpu' | awk '{printf("%.1f%%", $2 + $4)}')
    ||=> Last boot: $(who -b | awk '{print $3}') $(who -b | awk '{print $4}')
    ||=> LVM $lvm_use
    ||=> Active connections: $(ss -lntup | grep LISTEN | wc -l)
    ||=> Users currently logged in: $(who | wc -l)
    ||=> IP: $(hostname -I) MAC: $(ip link show | grep link/ether | awk '{print $2}')
    ||=> Sudo executions: $(cat /var/log/sudo.log | grep COMMAND | wc -l) "