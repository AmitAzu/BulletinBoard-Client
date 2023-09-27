# BulletinBoard-Client

## Description
The Bulletin Board iOS app is a SwiftUI-based application that allows users to import and manage a list of bulletins. Users can add new bulletins, delete existing ones, view all bulletins on a map, and share bulletins via WhatsApp. The app also requests location and local network permissions.

## Features
Three main tabs on the home screen:
- Tab 1: Lists all bulletins, swipe left to delete, and tap to view more details and share.
- Tab 2: Displays a Google Map with all bulletin locations.
- Tab 3: Create a new bulletin.

## Installation
To install and run the Bulletin Board app on your device, follow these steps:

- Clone the repo:
```bash
git clone git@github.com:AmitAzu/BulletinBoard-Client.git
```

- Open a terminal and navigate to the project directory:
```bash
cd BulletinBoard-Client
```

- Install project dependencies using CocoaPods:
```bash
cd pod install
```

- In Xcode, select your development team and a target device (e.g., iPhone or iPad).
- Build and run the app by clicking the "Run" button in Xcode.

## Configuration
First, you need to get your private ip, using the following command in the terminal:

```bash
ipconfig getifaddr en0
```

Before running the app, you need to configure your IP address in two places.


- NetworkService.swift
Open the NetworkService.swift file.
Locate the baseURL variable and replace it with your IP address:

```swift
fileprivate enum NetworkUrl: String {
    case baseURL = "your-ip-address"
}
```

- Info.plist:
Open the Info.plist file.
Under "App Transport Security Settings," add an exception domain with your IP address as follows:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>your-ip-address</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSTemporaryExceptionMinimumTLSVersion</key>
            <string>TLSv1.1</string>
        </dict>
    </dict>
</dict>
```

# Usage
- On the home screen, you'll find three tabs:
 * Tab 1: Browse and manage your bulletins.
 * Tab 2: View bulletins on a map.
 * Tab 3: Create a new bulletin.

- To delete a bulletin, swipe left on it in Tab 1.
- To view more details and share a bulletin, tap on it in Tab 1.

Ensure you've granted location and local network permissions to the app when prompted.
