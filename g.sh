#!/bin/bash

# Define color codes
INFO='\033[0;36m'  # Cyan
BANNER='\033[0;35m' # Magenta
WARNING='\033[0;33m'
ERROR='\033[0;31m'
SUCCESS='\033[0;32m'
NC='\033[0m' # No Color

echo -e "\e[1;32m                
 /$$      /$$                 /$$           /$$                     /$$   /$$              
| $$$    /$$$                | $$          | $$                    |__/  | $$              
| $$$$  /$$$$  /$$$$$$   /$$$$$$$ /$$   /$$| $$  /$$$$$$   /$$$$$$  /$$ /$$$$$$   /$$   /$$
| $$ $$/$$ $$ /$$__  $$ /$$__  $$| $$  | $$| $$ |____  $$ /$$__  $$| $$|_  $$_/  | $$  | $$
| $$  $$$| $$| $$  \ $$| $$  | $$| $$  | $$| $$  /$$$$$$$| $$  \__/| $$  | $$    | $$  | $$
| $$\  $ | $$| $$  | $$| $$  | $$| $$  | $$| $$ /$$__  $$| $$      | $$  | $$ /$$| $$  | $$
| $$ \/  | $$|  $$$$$$/|  $$$$$$$|  $$$$$$/| $$|  $$$$$$$| $$      | $$  |  $$$$/|  $$$$$$$
|__/     |__/ \______/  \_______/ \______/ |__/ \_______/|__/      |__/   \___/   \____  $$
                                                                                  /$$  | $$
                                                                                 |  $$$$$$/
                                                                                  \______/ 


X : https://x.com/modularityx

\e[0m"

USER="union"  
PASSWORD="modularity" 

echo -e "${INFO}Updating package list...${NC}"
sudo apt update

echo -e "${INFO}Installing XFCE Desktop for lower resource usage...${NC}"
sudo apt install -y xfce4 xfce4-goodies

echo -e "${INFO}Installing XRDP for remote desktop...${NC}"
sudo apt install -y xrdp

echo -e "${INFO}Adding the user $USER with the specified password...${NC}"
sudo useradd -m -s /bin/bash $USER
echo "$USER:$PASSWORD" | sudo chpasswd

echo -e "${INFO}Adding $USER to the sudo group...${NC}"
sudo usermod -aG sudo $USER

echo -e "${INFO}Configuring XRDP to use XFCE desktop...${NC}"
echo "xfce4-session" > ~/.xsession

# Update startwm.sh to launch xfce4-session
echo -e "${INFO}Modifying startwm.sh to use XFCE session...${NC}"
sudo sed -i '/test -x \/etc\/X11\/Xsession && exec \/etc\/X11\/Xsession/,+1c\startxfce4' "/etc/xrdp/startwm.sh"

echo -e "${INFO}Configuring XRDP to use lower color depth by default...${NC}"
sudo sed -i '/^#xserverbpp=24/s/^#//; s/xserverbpp=24/xserverbpp=16/' /etc/xrdp/xrdp.ini
echo -e "${SUCCESS}XRDP configuration updated to use color depth of 16.${NC}"

# Update existing max_bpp, xres, and yres values if present, otherwise add them
echo -e "${INFO}Setting maximum resolution to 1280x720...${NC}"
sudo sed -i '/^max_bpp=/s/=.*/=16/' /etc/xrdp/xrdp.ini
sudo sed -i '/^xres=/s/=.*/=1280/' /etc/xrdp/xrdp.ini
sudo sed -i '/^yres=/s/=.*/=720/' /etc/xrdp/xrdp.ini

# If settings are not found, append them at the end of the file
grep -q '^max_bpp=' /etc/xrdp/xrdp.ini || echo 'max_bpp=16' | sudo tee -a /etc/xrdp/xrdp.ini > /dev/null
grep -q '^xres=' /etc/xrdp/xrdp.ini || echo 'xres=1280' | sudo tee -a /etc/xrdp/xrdp.ini > /dev/null
grep -q '^yres=' /etc/xrdp/xrdp.ini || echo 'yres=720' | sudo tee -a /etc/xrdp/xrdp.ini > /dev/null

echo -e "${SUCCESS}Resolution limited to 1280x720.${NC}"

echo -e "${INFO}Restarting XRDP service...${NC}"
sudo systemctl restart xrdp

echo -e "${INFO}Enabling XRDP service at startup...${NC}"
sudo systemctl enable xrdp

# Installs the necessary dependencies for Google Chrome
sudo apt install -y wget gnupg

# Adds the Google repository key
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# Adds the Google Chrome repository
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Updates the package list again
sudo apt update

# Installs Google Chrome
sudo apt install -y google-chrome-stable

# Check if UFW is installed and enabled, and add a rule for port 3389
if command -v ufw >/dev/null; then
    echo -e "${INFO}UFW is installed. Checking if it is enabled...${NC}"
    if sudo ufw status | grep -q "Status: active"; then
        echo -e "${INFO}UFW is enabled. Adding a rule to allow traffic on port 3389...${NC}"
        sudo ufw allow 3389/tcp
        echo -e "${SUCCESS}Port 3389 is now allowed through UFW.${NC}"
    else
        echo -e "${WARNING}UFW is installed but not enabled. Skipping rule addition.${NC}"
    fi
else
    echo -e "${INFO}UFW is not installed. Skipping firewall configuration.${NC}"
fi

echo -e "${SUCCESS}Installation complete. XFCE Desktop, XRDP, and Chrome browser have been installed.${NC}"
echo -e "${INFO}You can now connect via Remote Desktop with the user $USER.${NC}"
