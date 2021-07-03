# Install

## Prerequesites

* Mac with macOS
* Homebrew
* Rbenv
* Chrome
* Chromedriver

## Install

```shell
ssh-keygen -t ed25519 -C "edward@edward.robots.anyrobot.cloud" # generate key
# add key to GitLab instance
cd ~
mkdir AnyRobot
cd ~/AnyRobot
git clone git@gitlab.unitedideas.co:anyrobot/unirpa.git
cd unirpa
cp config/config.example.yml config/config.yml
# now edit config
chmod +x install.rb
./install.rb
```