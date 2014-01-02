zen-wallpaper
=============

Automatically generated, GitHub Zen API powered wallpaper.

![photos-js-screenshot](http://taeram.github.io/media/zen-wallpaper.png)

Requirements
============

* A [GitHub](https://github.com/) account

### First Time Setup

Simply run the script, and it will install all necessary dependencies, and generate a GitHub OAuth token.

The script requires a single argument, which is the path that the auto generated wallpaper will be saved to.

```bash
./zen-wallpaper.sh $HOME/Pictures
```

Once the script has been run for the first time, you'll find a `zen-wallpaper.png` file in your `$HOME/Pictures` directory,
assuming that's the path you used.

Now, set the wallpaper as your desktop background.

When you want a new Zen saying, simply re-run the script with the same arguments. The script will overwrite the
original `zen-wallpaper.png` file, and Ubuntu will detect the change and automatically show the new wallpaper.



[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/taeram/zen-wallpaper/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

