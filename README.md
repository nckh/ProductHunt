# Product Hunt

A quite simple Product Hunt client, made to experiment with diffable data sources.

## Setup

1. Set your Product Hunt API access key in your app's Info.plist.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  ...
  <key>ProductHuntAPIAccessToken</key>
  <string>[SET YOUR PRODUCT HUNT ACCESS KEY HERE]</string>
  ...
</dict>
```

2. To run on a device, select your development team in "Signing & Capabilities."

## TODO

* Unit tests of presenter classes.
* A lot more documentation comments.
* Display GIF and video media.
* Retry fetching data on network reconnection.
