#!/bin/bash

# Configuration
CPU_THRESHOLD=80
MEM_THRESHOLD=85
DISK_THRESHOLD=90

echo "============================================="
echo "       SecOps Advanced System Monitor        "
echo "============================================="
echo "Timestamp: $(date)"

# CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "CPU Load: ${CPU_USAGE}%"

# Memory Usage
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
printf "Memory Load: %.2f%%\n" "${MEM_USAGE}"

# Disk Usage
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
echo "Disk Usage: ${DISK_USAGE}%"

# Network Active Sockets
ACTIVE_CONN=$(netstat -an | grep ESTABLISHED | wc -l)
echo "Active TCP Connections: ${ACTIVE_CONN}"

# Warning Alerts
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "[!] WARNING: High CPU usage detected: ${CPU_USAGE}%"
fi

if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
    echo "[!] WARNING: High Memory usage detected"
fi

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "[!] WARNING: Low Disk Space!"
fi