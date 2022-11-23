#!/bin/bash
 1 #!/bin/bash
 2 tot_mem=$(free -m | grep Mem | awk '{print $2}')
 3 usage_mem=$(free -m | grep Mem | awk '{print $3}')
 4 perc_mem=$(free -m | grep Mem | awk '{printf("%.2f%%", $3/$2 * 100.0)}')
 5
 6 if cat /etc/fstab | grep -q mapper
 7 then
 8     lvm_use="in use"
 9 else
10     lvm_use="not in use"
11 fi
12
13 wall   "#Architecture: $(uname -a)
14 #Physical CPU: $(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
15 #Virtual CPU: $(grep "^processor" /proc/cpuinfo | wc -l)
16 #RAM usage: "$usage_mem/$tot_mem MB" ${perc_mem}
17 #Disk usage: `df -hm --total | grep total | awk '{printf("%s/%s MB (%.2f%%)", $3, $2, $5)}'`
18 #CPU usage: $((100 - $free_cpu))%"
19 #Last boot: $(who -b | awk '{print $3}') $(who -b | awk '{print $4}')
20 #LVM $(lvm_use)
21 #Active connections: $(ss -lntup | grep LISTEN | wc -l)
22 #Users currently logged in: $(who | wc -l)
23 #IP: $(hostname -I) MAC: $(vmstat 1 2 | tail -l | awk '{print $15}')
24 #Sudo executions: $(history | grep sudo | wc -l)
