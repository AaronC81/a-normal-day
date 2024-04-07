# A Normal Day in the Killer Robot Factory

My submission to Gosu Game Jam 6 - see the [itch.io page](https://orangeflash81.itch.io/a-normal-day)!

## Running

```
bundle install
bundle exec ruby ./src/main.rb
```

## Building

### macOS

```
./package_macos
```

Should just work! If uploading to itch, upload the generated .zip, NOT the .app! If you upload the
.app, macOS or Chrome will try to zip the .app automatically and get it wrong, stripping the
execute bit off the `Ruby` binary and breaking it.

### Windows

```
gem install ocra
.\package_windows.bat
```

When the game opens, wait a second and then close it again.