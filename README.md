# 1. Tạo ứng dụng
AZStack sẽ cung cấp cho bạn ID của ứng dụng (appID) và 1 RSA public key (appKey); appID sẽ được lưu trong ứng dụng (client) của bạn, còn public key sẽ được lưu trên server của bạn.

Mỗi user duy nhất của ứng dụng của bạn cần 1 định danh duy nhất trên AZStack (dạng chuỗi): azStackUserID.

Ví dụ ứng dụng của bạn sử dụng email để định danh duy nhất người dùng. Bạn có 2 user: user1@email.com, user2@abc.com thì 2 người này cần 2 azStackUserID khác nhau, có thể là: user1_email_com, user2_abc_com hoặc có thể dùng chính email làm azStackUserID.

Tương tự nếu hệ thống của bạn sử dụng số điện thoại, username, ... để định danh duy nhất người dùng thì cũng có thể dùng chính số điện thoại, username, ... để làm azStackUserID.

Để tránh phức tạp thì định danh user trên hệ thống của bạn (username, email, phone number, ...) cũng nên là định danh trên AZStack (azStackUserID).
2 app khác nhau có thể có 2 user trùng azStackUserID.


# 2. Add the SDK to your Xcode Project
### 2.1. Download AZStack Framework tại:

[download link]

>a. Giải nén bạn sẽ có: AzStack.framework, AzStackRes.bundle


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
Bước này là bắt buộc, nếu không khi chạy chương trình sẽ sinh lỗi crash:
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

![Add other frameworks and libraries](http://azstack.com/docs/static/Libraries.png "Add other frameworks and libraries")

# 3. Concepts and flow

Trước khi người dùng có thể gửi và nhận tin nhắn thì cần quá trình khởi tạo SDK và xác thực. Việc xác thực 1 user được thực hiện bởi 3 bên: client (AZStack SDK), AZStack server và server của bạn; đảm bảo việc bạn có thể cho phép / không cho phép 1 user nào đó xác thực / sử dụng dịch vụ chat/call bất cứ lúc nào.

Quá trình được mô tả bởi biểu đồ dưới:

![AZStack init and authentication](http://azstack.com/docs/static/IosAuthentication.png "AZStack init and authentication")

# 4. Khởi tạo SDK
Bước khởi tạo AZStack nên được đặt ngay lúc app khởi chạy, ngay đầu hàm:
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
```
### 4.1. Thiết lập AppID
```objective-c
[[AzStackManager instance] setAppId:@"YOUR_APP_ID_HERE"];
```

### 4.2. Thiết lập Server
```objective-c
[[AzStackManager instance] setServerType: AZSERVER_PRODUCTION];
```
- AZSERVER_PRODUCTION: Server dùng để chạy thật, nên sử dụng khi sản phẩm của bạn đã hoàn thiện và ổn định
- AZSERVER_TEST: Server phục vụ khi test, nên sử dụng trong quá trình phát triển sản phẩm.

### 4.3. Thiết lập các delegate của AZStack:
- AzAuthenticationDelegate
- AzUserInfoDelegate
- AzChatDelegate
- AzCallDelegate

Chúng tôi sẽ giải thích các delegate này [tại bước 5]. Xem code mẫu [tại đây].

### 4.4. Thiết lập 1 số thông số:
- Set màu title, button trên thanh navigation bar cho phù hợp với màu app của bạn

  Lưu ý: setup này sẽ chỉ có tác dụng trên các UIViewController của SDK chứ  không ảnh hưởng tới các UIViewController khác trong app của bạn

```objective-c
[[AzStackManager instance] setTintColorNavigationBar:[UIColor whiteColor]];
```
- Set ngôn ngữ được hiển thị trong AzStack SDK

  Mặc định ngôn ngữ của SDK sẽ lấy ngôn ngữ hệ thống, nếu SDK không hỗ trợ ngôn ngữ đó thì tự động chuyển sang tiếng anh.

```objective-c
[[AzStackManager instance] setLanguage:@"vi"];
```
  Tham số truyền vào là mã ngôn ngữ. VD: Tiếng Anh là “en”, Tiếng Việt là “vi” 

- Set hiển thị debug log:

  Cho phép hiển thị debug log của SDK hay không?

```objective-c
[[AzStackManager instance] setDebugLog:YES];
```

### 4.5. Kết nối và xác thực vào AZStack Server
```objective-c
//connect AZ
[[AzStackManager instance] connectWithCompletion:^(NSString * authenticatedAzStackUserID, NSError *error, BOOL successful) {
        if (successful) {
            AzStackLog(@"Connect AzStack Server Successful: authenticatedAzStackUserID : %@", authenticatedAzStackUserID);
        }
        else{
            AzStackLog(@"Connect AzStack Server Fail! ResponseCode: %d, Error Message: %@", error.code, [error description]);
        }
    }];
```

Hàm này nên được gọi ngay sau khi user của bạn thực hiện xác thực thành công với server của bạn.

Quy trình xác thực giữa ứng dụng của bạn (AZStack SDK), AZStack server và server của bạn được mô tả ở bước 3.

# 5. Thực hiện các hàm delegate của AZStack SDK
### 5.1. AzAuthenticationDelegate:
```objective-c
- (void) azNonceReceived:(NSString *)nonce
```

Sau khi client kết nối thành công đến AZStack bằng cách gọi hàm [[AzStackManager instance] connectWithCompletion:] ở bước 4.5 thì AZStack sẽ trả về none cho client.

Hàm delegate này được AZStack SDK gọi sau khi nhận được none từ AZStack server gửi về, hàm này cần thực hiện việc gửi: azStackUserID, nonce lên server của bạn để lấy 1 authenToken.

Về phía server của bạn, authenToken phải được sinh ra bằng cách mã hoá chuỗi:
```objective-c
{"azStackUserID":"user_1", "nonce":"none_1"}
```
bằng publicKey được sinh ra ở bước 1. Trong đó user_1 và none_1 là do client truyền lên. Xem code PHP mẫu tại đây.

Sau khi client nhận được authenToken từ server của bạn, bạn cần gửi authenToken này nên để xác thực trên phía server AzStack để hoàn tất quá trình xác thực và connect vào Server AzStack

```objective-c
[[AzStackManager instance] authenticateWithIdentityToken:authenToken];
```
### 5.2. AzUserInfoDelegate
> a. Yêu cầu thông tin 1 user
```objective-c
- (void) azRequestUserInfo: (NSArray *) azStackUserIds withTarget: (int) target;
```
Hàm này được AZStack SDK gọi để thông báo rằng SDK cần lấy thông tin của những người có  nằm trong mảng: listAzStackUserIDs.


Lúc này bạn có thể lấy thông tin về các user này trên nội bộ client (nếu có sẵn) hoặc lấy trên server của bạn, sau đó cần trả thông tin cho AZStack SDK bằng cách gọi hàm: 
```objective-c
[[AzStackManager instance] sendUserInfoToAzStack:listUserInfo withTarget:purpose.intValue];
```
Xem code mẫu tại đây.

> b. Yêu cầu danh sách user của bạn 
```objective-c
- (NSArray *) azRequestListUser;
```

AZStack SDK sẽ gọi hàm này để lấy về danh sách bạn bè (chẳng hạn lúc cần tạo group mới, ...)

Xem code mẫu tại đây.

> c. Yêu cầu 1 controller để hiển thị thông tin của user
```objective-c
- (UIViewController *) azRequestUserInfoController: (AzUser *) user withAppUserId: (NSString *) appUserId;
```

AZStack SDK sẽ gọi hàm này để lấy về UIViewController để hiển thị thông tin của user.

Xem code mẫu tại đây.

### 5.3. AzCallDelegate
```objective-c
- (void) azJustFinishCall: (NSDictionary *) callInfo;
```
Hàm này AZStack SDK gọi để thông báo cuộc gọi kết thúc.

### 5.4. AzChatDelegate

> a. Yêu cầu navigation controller
```objective-c
- (UINavigationController *) azRequestNavigationToPushChatController;
```

Hàm này AZStack SDK gọi để lấy về UINavigationController dùng để push ChatController khi mà người dùng nhấn vào In-app Notification 

![In-app Notification](http://azstack.com/docs/static/FakeNotification.png "In-app Notification")

hoặc khi tạo group xong.

Xem code mẫu tại đây.
> b. Thông báo số tin nhắn chưa đọc thay đổi
```objective-c
- (void) azUpdateUnreadMessageCount: (int) unreadCount;
```
Hàm này AZStack SDK gọi để thông báo khi số tin nhắn chưa đọc thay đổi.


# 6. Tạo 1 cửa sổ chat (ChatController)
```objective-c
UIViewController* chatController =  [[AzStackManager instance] chatWithUser:self.contact.username withUserInfo:@{@"name": self.contact.fullname}];
```

```objective-c
- (UIViewController *) chatWithUser: (NSString *) azStackUserId;
```
Bạn gọi hàm này để tạo 1 chat controller (cửa sổ chat với 1 user).

Trong trường hợp bạn muốn gọi controller để lựa chọn user thì gọi:
```objective-c
[[AzStackManager instance] createChat11];
```
Controller này sẽ lấy danh sách user từ AzUserInfoDelegate 

# 7. Gọi điện đến 1 người
```objective-c
[[AzStackManager instance] callWithUser:self.contact.username withUserInfo:@{@"name": self.contact.fullname}];
```
```objective-c
[[[AzStackManager instance] callWithUser: azStackUserId];
```

Bạn gọi hàm này khi cần gọi điện đến 1 user.

# 8. Tạo chat nhóm
```objective-c
- (UIViewController *) chatWithGroup: (NSArray *) azStackUserIds withGroupInfo: (NSDictionary *) groupInfo;
```

Truyền vào list azStackUserIds mà bạn muốn tạo nhóm

Trong trường hợp bạn muốn gọi controller để lựa chọn list azStackUserIds cho thuận tiện thì gọi hàm:
```objective-c
[[AzStackManager instance] createChatGroup];
```

Controller này sẽ lấy list user đầu vào từ AzUserInfoDelegate 

# 9. Push notification
### 9.1. Register for push notification

Đầu tiên bạn phải đăng ký việc gửi push notification cho ứng dụng của bạn, trong hàm:
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
```

thêm đoạn code:
```objective-c
if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
} else {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}
```

### 9.2. Gửi Devicede Token lên cho AZStack server và xử lý push notification / local notification
Xem code mẫu:
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
### 9.3. Xử lý khi người dùng click vào local notification / push notification:
```objective-c
[[AzStackManager instance] processRemoteNotify:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
if (locationNotification) {
    [[AzStackManager instance] processLocalNotify:locationNotification];
}
```
đoạn code này phải gọi cuối cùng của hàm:
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
```
(trước khi hàm didFinishLaunchingWithOptions return)

 

