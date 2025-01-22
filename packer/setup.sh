echo Installing Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install --lts
node -e "console.log('Running Node.js ' + process.version)"

echo Installing Git
sudo yum update -y
sudo yum install git -y
git --version

echo Installing Simple Server
git clone https://github.com/cgduzan/simple-server.git
cd simple-server/server/
npm i
# it's a JS file, nothing to "build" here

# get path to node
NODE_PATH=$(which node)

# create a service file
sudo touch /etc/systemd/system/simple-server.service
echo "[Unit]" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "Description=Simple Server" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "After=multi-user.target" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "[Service]" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "ExecStart=$NODE_PATH $(pwd)/index.js" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "Restart=always" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "RestartSec=10" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "User=ec2-user" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "SyslogIdentifier=simple-server" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "Environment=NODE_ENV=production" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "[Install]" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null
echo "WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/simple-server.service > /dev/null

# enable and start the service
sudo systemctl enable simple-server
sudo systemctl start simple-server

# check the status
sudo systemctl status simple-server