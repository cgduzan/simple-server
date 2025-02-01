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

# copy the service file from /tmp to /etc/systemd/system
sudo cp /tmp/simple-server.service /etc/systemd/system/simple-server.service

# replace the placeholders in the service file
sudo sed -i "s|{NODE_PATH}|$(which node)|g" /etc/systemd/system/simple-server.service
sudo sed -i "s|{INDEX_PATH}|$(pwd)/index.js|g" /etc/systemd/system/simple-server.service

# enable and start the service
sudo systemctl enable simple-server
sudo systemctl start simple-server

# check the status
sudo systemctl status simple-server