# 0. Quick Start
<a href="https://www.youtube.com/watch?v=MTQo9T2Eua4" target="_blank">
    <img src="http://azstack.com/docs/static/video_demo.png" alt=" " width="300" border="10" />
</a>

Download demo project at: https://github.com/azstack/iOS-SDK-Sample-Project/archive/master.zip

# 1. Create application
AZStack will provide an application ID (appID) for your application and a RSA key pair (public key, private key); appID and public key will be stored inside your app (client), private key will be stored in your server.

# 2. Add the SDK to your Xcode Project
### 2.1. Download AZStack Framework at:

https://github.com/azstack/iOS-SDK/archive/master.zip

>a. Unzip the zip file you will have: AzStack.framework, AzStackRes.bundle, AzStackCall.a


>b. Drag the AzStack.framework and AzStackRes.bundle to Frameworks in Project Navigator. Create a new group Frameworks if it does not exist.

>c. Choose Create groups for any added folders.

>d. Deselect Copy items into destination group's folder. This references the SDK where you installed it rather than copying the SDK into your app.


![Add the SDK 1](http://azstack.com/docs/static/AddTheSDK1.png "Add the SDK 1")

![Add the SDK 2](http://azstack.com/docs/static/AddTheSDK2.png "Add the SDK 2")


### 2.2. Configure Xcode Project
> a. Add Linker Flag
Open the "Build Settings" tab, in the "Linking" section, locate the "Other Linker Flags" setting and add the "-ObjC" flag:

![Add Linker Flag](http://azstack.com/docs/static/ConfigOtherLinkerFlags.png "Add Linker Flag")

Note:
This step is required, otherwise crash will happen:
```objective-c
[AzFMDatabase columnExists:inTableWithName:]: unrecognized selector sent to instance 0x...
```
> b. Add other frameworks and libraries
Open the "Build Phases" tab, in the "Link Binary With Libraries" section, add frameworks and libraries:

- CoreGraphics
- CoreLocation
- libxml2
- MobileCoreServices
- CoreMedia
- QuartzCore
- AssetsLibrary
- CoreTelephony
- CoreText
- MapKit
- libz
- SystemConfiguration
- AVFoundation
- ImageIO
- MessageUI
- Security
- CFNetwork
- AudioToolbox
- MediaPlayer
- libsqlite3.0.dylib

> c. If you need the function “call”, please add file “AzStackCall.a” in “Link Binary With Libraries”

![Add other frameworks and libraries](http://azstack.com/docs/static/Libraries.png "Add other frameworks and libraries")

# 3. Concepts and flow

### 3.1. User ID

Each unique user of your application need 01 unqiue identifier (azStackUserID) in AZStack server. Its format type is string and called: azStackUserID. 

For example, if your user use email to identify user, and you have 2 different users: user1@email.com, user2@abc.com then they need 2 different azStackUserID, like: user1_email_com, user2_abc_com. Or can use their emails (user1@email.com, user2@email.com) as azStackUserID.

Another example, if your system use mobile number, username, ... to identify user then can use it as azStackUserID.

To avoid complexity, please use same user id in your database (username, email, phone number, ...) as in AZStack (azStackUserID).
(Two different apps can have 2 users with same azStackUserID)

### 3.2. Authentication

You need to initiate our sdk and process the authentication before sending/receiving message or making/receiving a call. The authentication will be made between three parties: Client (with sdk), AZStack Server and your server. This process is to make sure the connection is secured and user is authorized.

Process is described by a model below:

![AZStack init and authentication](http://azstack.com/docs/static/ios_authentication.png "AZStack init and authentication")

#### Step 0: 

Go to https://developer.azstack.com/

    a. Create project

    b. Generate RSA key pair and secret code

    c. Update Authentication URL which used to authenticate user between AZStack and your server

#### Step 1: 

Initialize SDK with your appID, public key, and then call this method: [[AzStackManager instance] initial]

#### Step 2: 

Call [[AzStackManager instance] connectWithAzStackUserId...] to execute authentication process.

#### Step 3: 

After calling connectWithAzStackUserId method, AZStack SDK will encrypt the following string:
```objective-c
{"azStackUserID":"...", "userCredentials":"..."}
```
using RSA 2048 algorithm with your public key. The Identity Token is returned and will be sent to AZStack server.

#### Step 4: 

AZStack decrypts Identity Token using RSA 2048 algorithm with the private key generated at step 0. Then AZStack will use the public key generated at step 0 to encrypt the following string:
```objective-c
{"azStackUserID":"...", "userCredentials":"...", "timestamp": ..., "appId":"...", "code":"..."}
```
"code" is generated as below:
```objective-c
md5(appId + "_" + timestamp + "_" + secret_code)
```
The encryption process returns Authentication Token. AZStack will send the Authentication Token to your server via Authentication URL (updated at step 0).

#### Step 5: 

On your server side, you need decrypt Authentication Token receiving from AZStack server to get the "code". Compare "code" with the following string:
```objective-c
md5(appId + "_" + timestamp + "_" + secret_code)
```
If they are the same, execute authentication with azStackUserID and userCredentials on your backend. Please see sample code writing in PHP here: https://github.com/azstack/Backend-example/tree/master/php


# 4. SDK initialization

AZStack SDK initialization should be called when the application open, at the beginning of the function:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
```
### 4.1. Setup AppID
```objective-c
[[AzStackManager instance] setAppId:@"YOUR_APP_ID_HERE"];
```

### 4.2. Setup Public Key
```objective-c
[[AzStackManager instance] setPublicKey:@"YOUR_PUBLIC_KEY_HERE"];
```
### 4.3. Setup delegates of AZStack:
- AzUserInfoDelegate
- AzChatDelegate
- AzCallDelegate

We will explain those delegates [at step 5]. Please see sample code here: https://github.com/azstack/iOS-SDK-Documentation/tree/master/SampleCode/sample%20delegate

### 4.4. Setting some parameters:
- Title color, button on navigation bar to match with your app screen:

  Notes: This setup only impact UIViewController of SDK, not impacted on other UIViewController inside your app

```objective-c
[[AzStackManager instance] setTintColorNavigationBar:[UIColor whiteColor]];
```
- Set language displayed in AzStack SDK

  By default, SDK will check system language to see if it support system language or not. If not, SDK will use English as default. 

```objective-c
[[AzStackManager instance] setLanguage:@"vi"];
```
  Input parameter is language code. Example: English: “en”, Vietnamese: “vi” 

- Debug log display:

  Allow to display debug log of SDK or not?

```objective-c
[[AzStackManager instance] setDebugLog:YES];
```

### 4.5. Initial SDK:
```objective-c
[[AzStackManager instance] initial];
```

After setting up all parametters/ configuration, you can call this function to init the SDK. This function is required to store the configuration and initiate all the element of the SDK. Note: Just call only ONE time when open the application.

### 4.6. Modify Info.plist file
> a. Allow application to receive message, incoming call in background mode

Add below code into file Info.plist (in dict tag)
```objective-c
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
    <string>voip</string>
</array>
```

> b. Allow application to use location via GPS (send location feature)

Add below code into file Info.plist (in dict tag)
```objective-c
<key>NSLocationWhenInUseUsageDescription</key>
<string>Would you like to use your GPS</string>
```


### 4.7. Connect and authenticate with AZStack Server
```objective-c
//connect AZ
[[AzStackManager instance] connectWithAzStackUserId:@"YOUR_AZSTACK_USER_ID" userCredentials:@"YOUR_USER_CREDENTIALS" fullname:@"NAME_FOR_PUSH_NOTIFICATION" completion:^(NSString *authenticatedAzStackUserID, NSError *error, BOOL successful) {
    if (successful) {
        AzStackLog(@"Connect AzStack Server Successful: authenticatedAzStackUserID : %@", authenticatedAzStackUserID);
    }
    else{
        AzStackLog(@"Connect AzStack Server Fail! ResponseCode: %d, Error Message: %@", error.code, [error description]);
    }
}];
```

Parameter:

    YOUR_AZSTACK_USER_ID: your user ID on your system, as described above

    YOUR_USER_CREDENTIALS: can be your password, token on your system. AZStack will not use this information. It's forwared to your server to authenticate your user

    NAME_FOR_PUSH_NOTIFICATION: optional, used to display on push notification

Authorization process between your application (AZStack SDK), AZStack server and your server is described in step 3.

# 5. Process delegates of AZStack SDK
### 5.1. AzUserInfoDelegate
> a. Request information of some users
```objective-c
- (void) azRequestUserInfo: (NSArray *) azStackUserIds withTarget: (int) target;
```
This function is caleld by AZStack SDK in order to inform SDK need to collect user information in array: listAzStackUserIDs.


Now, you can get information from user at client (if stored) or from your server, then pass information to AZStack SDK by calling function: 
```objective-c
[[AzStackManager instance] sendUserInfoToAzStack:listUserInfo withTarget:purpose.intValue];
```
See sample code here: https://github.com/azstack/iOS-SDK-Documentation/blob/master/SampleCode/sample%20method/azRequestUserInfo.m

> b. Request your user's friend list
```objective-c
- (NSArray *) azRequestFriendList;
```

AZStack SDK will call this function to fetch the user’s friend list (when you create new group chat, or add new member to group chat)

See sample code here: https://github.com/azstack/iOS-SDK-Documentation/blob/master/SampleCode/sample%20method/azRequestFriendList.m

> c. Need 1 controller to display user information
```objective-c
- (UIViewController *) azRequestUserInfoController:(AzStackUser *)user withAzStackUserId:(NSString *)azStackUserId;
```

AZStack SDK will call this function to retrieve UIViewController in order to display user information.

See sample code here: https://github.com/azstack/iOS-SDK-Documentation/blob/master/SampleCode/sample%20method/azRequestUserInfoController.m

### 5.2. AzCallDelegate
```objective-c
- (void) azJustFinishCall: (NSDictionary *) callInfo;
```

This function will be called when the call is ended.

### 5.3. AzChatDelegate

> a. Request navigation controller
```objective-c
- (UINavigationController *) azRequestNavigationToPushChatController;
```

This function AZStack SDK call to retrieve UINavigationController in order to push ChatController when user clicks on In-app Notification 

![In-app Notification](http://azstack.com/docs/static/FakeNotification.png "In-app Notification")

or after makeing a group.

> b. Notify when unread message count changed
```objective-c
- (void) azUpdateUnreadMessageCount: (int) unreadCount;
```
AZStack SDK call this function to inform when unread messages changed.


# 6. Create chat window (ChatController)
```objective-c
UIViewController* chatController =  [[AzStackManager instance] chatWithUser:self.contact.username withUserInfo:@{@"name": self.contact.fullname}];
```

```objective-c
- (UIViewController *) chatWithUser: (NSString *) azStackUserId;
```
Call this function to create chat controller (chat window with 1 user).

In case, you want to call Controller to select user then call:
```objective-c
[[AzStackManager instance] createChat11];
```
This Controller will retriev user lise from AzUserInfoDelegate 

# 7. Call to single user
```objective-c
[[AzStackManager instance] callWithUser:self.contact.username withUserInfo:@{@"name": self.contact.fullname}];
```
```objective-c
[[[AzStackManager instance] callWithUser: azStackUserId];
```

Use this function to make a call to a user from current user.

# 8. Create group chat
```objective-c
- (UIViewController *) chatWithGroup: (NSArray *) azStackUserIds withGroupInfo: (NSDictionary *) groupInfo;
```

azStackUserIds: Array of AZStackUserIds 

In case you want to call controller to get azStackUserIds easily, you can call this function:
```objective-c
[[AzStackManager instance] createChatGroup];
```

This will get list of users from t? AzUserInfoDelegate 

# 9. Push notification
### 9.1. Register for push notification

Firstly, you have to register push notification for your app, in function:
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
```

add this code:
```objective-c
if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
} else {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}
```

### 9.2. Send Device Token to AZStack server and process push notification / local notification
See sample code:
```objective-c
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    [[AzStackManager instance] registerForRemoteNotificationsWithDeviceToken:deviceToken];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    if ([identifier isEqualToString:@"declineAction"]){
    } else if ([identifier isEqualToString:@"answerAction"]){
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {
    [[AzStackManager instance] processLocalNotify:notif];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[AzStackManager instance] processRemoteNotify:userInfo];
}
```
### 9.3. Process when user click on local notification / push notification:
```objective-c
[[AzStackManager instance] processRemoteNotify:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
if (locationNotification) {
    [[AzStackManager instance] processLocalNotify:locationNotification];
}
```
this code has to be called at the end of the function:
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
```
(Before function didFinishLaunchingWithOptions return)
### 9.4. Update account name to display in notification
AZStack need your account name to display in the remote notification. So, when you update your account name, call bellow function to update the latest name:

```objective-c
[[AzStackManager instance] updateFullnameForPushNotification:@"NEW_NAME"];
```

 