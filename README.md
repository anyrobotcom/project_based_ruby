# UniRPA - Robotic Process Automation for United Ideas

Update test 1

## Prerequesites

See `New Bot - <your platform>` in Wiki.

## Install dependencies (macOS)

```shell
windows@developer> brew install postgresql # If not installed
macbook@developer> brew install google-chrome # We use Chrome for everything
macbook@developer> brew install chromedriver # Needed for Waitir
```

## Install dependencies (Windows)

```shell
windows@developer> choco install postgresql # If not installed
windows@developer> choco install googlechrome # We use Chrome for everything
windows@developer> choco install chromedriver # Needed for Waitir
```

## Run

```shell
macbook@developer> mkdir ~/AnyRobot
macbook@developer> cd ~/AnyRobot
macbook@developer> git clone git@gitlab.unitedideas.co:anyrobot/projectrpa.git
macbook@developer> cd projectrpa
macbook@developer> brew bundle
macbook@developer> bundle install
macbook@developer> cp config/config.example.yml config/config.yml
macbook@developer> cp config/database.example.yml config/database.yml
macbook@developer> bundle exec rake doctor
macbook@developer> bundle exec rake db:migrate
macbook@developer> bundle exec rake runner general/check_health
```

The last command should return something like:

```
Your full setup details (your 'user agent string'): "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36"
Your IP address appears to be: 89.64.3.221
```

## Console (easier do develop tasks)

```shell
macbook@developer> bundle exec rake console
```
