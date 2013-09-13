#!/bin/bash

BACKGROUND_COLOR="black"
FONT_PATH=$HOME/.fonts/Inconsolata.otf
FONT_SIZE=70
FONT_URL="http://www.levien.com/type/myfonts/Inconsolata.otf"
WALLPAPER_SIZE="1920x1080"
WALLPAPER_PATH=$1
GITHUB_OAUTH_TOKEN_PATH=$HOME/.zen-wallpaper-oauth.token

# Make sure we have a valid wallpaper path
if [ ! -e "$WALLPAPER_PATH" ]; then
    echo "Usage: `basename $0` [wallpaper path]";
    echo "e.g. `basename $0` $HOME/Pictures/"
    exit 1;
fi

# Is imagemagick installed?
if [ -z `which convert` ]; then
    echo "Installing imagemagick"
    sudo apt-get install imagemagick
fi

# Download the font if it doesn't exist
if [ ! -e "$FONT_PATH" ]; then
    echo "Downloading `basename $FONT_PATH`"
    mkdir -p `dirname $FONT_PATH`
    wget "$FONT_URL" -O $FONT_PATH
fi

# Do we have a GitHub OAuth token
# We want a GitHub OAuth token so we aren't rate limited to 60 requests / hour for the GitHub API
if [ ! -e "$GITHUB_OAUTH_TOKEN_PATH" ]; then
    echo -n "What is your GitHub username: "
    read GITHUB_USERNAME

    echo "Requesting a GitHub OAuth token"
    RESPONSE_FILE=`mktemp --suffix=.json`
    curl --silent -u "$GITHUB_USERNAME" -d '{"note": "Zen Wallpaper Script"}' https://api.github.com/authorizations > $RESPONSE_FILE

    GITHUB_OAUTH_TOKEN=`cat $RESPONSE_FILE | grep token | awk '{print $2'} | sed -e 's/"//g' -e 's/,//g'`
    if [ -z "$GITHUB_OAUTH_TOKEN" ]; then
        echo "Did not get OAUth token:"
        cat $RESPONSE_FILE
        exit 1
    fi

    echo "Writing GitHub OAuth token to $GITHUB_OAUTH_TOKEN_PATH"
    echo "$GITHUB_OAUTH_TOKEN" | sudo tee $GITHUB_OAUTH_TOKEN_PATH
else
    GITHUB_OAUTH_TOKEN=`cat $GITHUB_OAUTH_TOKEN_PATH`
fi

# Get the text from Github's Zen API
ZEN_TEXT=`curl --silent https://api.github.com/zen | sed -e "s/'/\\\\\\\\'/g"`

# Create the wallpaper
convert \
    -size "$WALLPAPER_SIZE" \
    xc:$BACKGROUND_COLOR \
    -font "$FONT_PATH" \
    -pointsize $FONT_SIZE \
    -draw "gravity center fill white text 0,0 '$ZEN_TEXT'" \
    $WALLPAPER_PATH/zen-wallpaper.png
