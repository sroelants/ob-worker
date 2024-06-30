#!/bin/bash

#Install dependencies
sudo apt-get update
sudo apt-get install python3 pip curl cargo -y;

# Check out OpenBench code
git clone https://github.com/sroelants/OpenBench
cd OpenBench/Client/;

# Install python dependencies
pip install -r requirements.txt --break-system-packages;

# Install systemd service
sudo touch /etc/systemd/system/openbench-worker.service;
sudo bash -c "cat > /etc/systemd/system/openbench-worker.service <<'EOL'
[Unit]
Description=OpenBench Worker
After=network.target

[Service]
Type=simple
StandardError=inherit
ExecStart=/usr/bin/python3 client.py -U "sroelants" -P $OB_PASSWORD -S "https://chess.samroelants.com" -T 8 -N 1
User=$(whoami)
WorkingDirectory=$(pwd)
Restart=on-failure
RestartSec=600

[Install]
WantedBy=multi-user.target
EOL";

# Enable and start worker service
sudo systemctl daemon-reload;
sudo systemctl enable openbench-worker.service;
sudo systemctl start openbench-worker.service;

# Do a daily restart? Not sure what this is about
sudo crontab -l > mycron;
echo "0 * * * * sudo systemctl restart openbench-worker" >> mycron;
sudo crontab mycron
