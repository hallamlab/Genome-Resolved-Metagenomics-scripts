#!/bin/bash
#SBATCH --job-name=network_diag
#SBATCH --output=network_diag.out
#SBATCH --time=00:05:00
#SBATCH --nodes=1                 # Number of nodes
#SBATCH --ntasks=1
#SBATCH --account=st-shallam-1    # Account name
#SBATCH --mem=512M
#SBATCH --mail-user=jcsm2010@mail.ubc.ca   # Where to send the mail
#SBATCH --error=network.diagnosticserr.txt   # Standard error log file


echo "========================================"
echo " Network Diagnostics Test"
echo " Run date: $(date)"
echo " Node hostname: $(hostname)"
echo "========================================"

echo -e "\n[1/6] Checking DNS resolution..."
nslookup google.com 2>&1 || echo "DNS resolution failed, FUCK!"

echo -e "\n[2/6] Checking ICMP ping..."
ping -c 3 google.com 2>&1 || echo "Ping failed (ICMP may be blocked),FUCK!!"

echo -e "\n[3/6] Checking HTTP access..."
curl -I http://example.com --max-time 10 2>&1 || echo "HTTP access failed, FUCK it!"

echo -e "\n[4/6] Checking HTTPS access..."
curl -I https://www.google.com --max-time 10 2>&1 || echo "HTTPS access failed, goddammn!"

echo -e "\n[5/6] Checking FTP access..."
curl -I ftp://speedtest.tele2.net --max-time 10 2>&1 || echo "FTP access failed, this shit!"

echo -e "\n[6/6] Checking general TCP connectivity (port 443)..."
timeout 5 bash -c "cat < /dev/null > /dev/tcp/google.com/443" 2>/dev/null \
    && echo "TCP connection to google.com:443 succeeded" \
    || echo "TCP connection to google.com:443 failed"

echo -e "\n[Summary]"
echo "If you saw 'succeeded' or HTTP headers, you have outbound internet access."
echo "If most tests failed, outbound connections are restricted."
echo "========================================"
