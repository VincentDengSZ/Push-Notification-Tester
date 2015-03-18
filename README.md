### Push Notification Tester
This app will give you a push notification token as well as record push notifications sent to the device. It will also broadcast your push notification token soit can be used with APNS pusher (https://github.com/blommegard/APNS-Pusher).

![Alt text](screenshot.png?raw=true "Screenshot")

#### Building this project:
Requirements:
- Latest xcode
- Latest git
- Cocopods (http://http://cocoapods.org/)

Run this:
```
git clone https://github.com/izackp/Push-Notification-Tester.git
cd Push-Notification-Tester
git submodule update --init --recursive
pod install
```

Open the PushNotificationTester.xcworkspace file in xcode. Then follow the *Building to a device* and *Making this project use your provisioning files* sections.

##### Building to a device:
Follow these instructions: http://code.tutsplus.com/tutorials/how-to-test-your-app-on-an-ios-device--mobile-13861

In order to build to the device make sure you have:
 - Apple Dev Account
 - An App Id
 - An iOS Device
 - A .p12 and .cer file in your keychain
 - Dev and Distribution Provisioning Files
    - You may have to download and install these (doubleclick). There is a method to sync them through xcode's account settings in preferences, but it doesn't always work.

##### Making this project use your provisioning files:
- Open PushNotificationTester.xcworkspace in xcode
- Go to `Info.plist`
- Set the bundle id property to the App ID you have created (com.company.pushnotificationtester)
- Go to the build settings for the target `PushNotificationTester`
- Set the code signing identity to the certificate you have created
- Right below, Set the provisioning files to the ones you have created
- You should be able to build and run to the device. If you have not enabled push notifications for your App ID you will see related errors.

##### Generating push certificates:
 - Go to https://developer.apple.com
 - Go to your App Id (com.company.pushnotificationtester)
 - Enable push notifications
 - Follow the instructions to add a Distribution and a Development certificate
 - A third party service (such as urban airship) will need the resulting .p12 stored in your keychain to communicate with apple servers (send push notifications).
 - Go to the provisioning files you have created and Edit them
 - When editing you want to toggle any device enabled for that provisioning file on and off.
 - Then we regenerate/download the provisioning files.
   - We do this because the previous provisioning files do not know that we have enabled push notifications.

At this point, verify you have the correct provisioning files set in in your build settings. Then you should be able to build to a device and receive a push notification token.

##### Sending a push notification:
 - Download and run https://github.com/blommegard/APNS-Pusher
 - Run the Push Notification Tester on a device
 - In APNS pusher, select the push notification certificate you have created in the previous section (Generating Push Certificates)
   - If you're running debug build you want to select the sandbox (or development) certificate otherwise you should use the production certificate.
 - If your phone and the APNS Pusher app is on the same network you will see your phones name in the dropdown menu. Double click this menu and you will see your token automatically filled in.
    - if you do not see your phone you will have to enter your token manually
 - Press push and you're done!
