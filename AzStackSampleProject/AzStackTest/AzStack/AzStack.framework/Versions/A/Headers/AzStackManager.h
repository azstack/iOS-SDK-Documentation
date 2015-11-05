//
//  AzStackManager.h
//  AzStack
//
//  Created by Phu Nguyen on 6/21/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define AZSERVER_PRODUCTION 1
#define AZSERVER_TEST 2

@class AzStackUser;

typedef void (^ConnectWithCompletion)(NSString * authenticatedAzStackUserID, NSError * error, BOOL successful);

@protocol AzAuthenticationDelegate <NSObject>
@required
- (void) azNonceReceived: (NSString *) nonce;
@end

@protocol AzUserInfoDelegate <NSObject>
@required
- (void) azRequestUserInfo: (NSArray *) azStackUserIds withTarget: (int) target;
@optional
- (NSArray *) azRequestListUser;
- (UIViewController *) azRequestUserInfoController: (AzStackUser *) user withAzStackUserId: (NSString *) azStackUserId;
@end

@protocol AzChatDelegate <NSObject>
@required
- (UINavigationController *) azRequestNavigationToPushChatController;
@optional
- (void) azUpdateUnreadMessageCount: (int) unreadCount;
@end

@protocol AzCallDelegate <NSObject>
@optional
- (void) azJustFinishCall: (NSDictionary *) callInfo;
@end

@interface AzStackManager : NSObject

+ (AzStackManager*)instance;

@property (nonatomic, weak) id<AzAuthenticationDelegate> azAuthenticationDelegate;

@property (nonatomic, weak) id<AzUserInfoDelegate> azUserInfoDelegate;

@property (nonatomic, weak) id<AzChatDelegate> azChatDelegate;

@property (nonatomic, weak) id<AzCallDelegate> azCallDelegate;

- (void) setAppId: (NSString *) appId;

- (void) setTintColorNavigationBar: (UIColor *) tintColorNav;

- (void) setLanguage: (NSString *) language;

- (void) setDebugLog: (BOOL) logEnable;

- (void) initial;

- (void) settingMessageNotification:(NSDictionary *) dicSetting;

- (NSDictionary *) getCurrentMessageNotificationSetting;

- (void) connectWithCompletion:(ConnectWithCompletion) blockProcessResult;

- (void) authenticateWithIdentityToken: (NSString *) authernicateToken;

- (UIViewController *) chatWithUser: (NSString *) azStackUserId withUserInfo: (NSDictionary *) userInfo;

- (UIViewController *) chatWithUser: (NSString *) azStackUserId;

- (UIViewController *) createChatGroup;

- (UIViewController *) createChat11;

- (void) sendUserInfoToAzStack:(NSArray *) userInfos withTarget: (int) target;

- (UIViewController *) chatWithGroup: (NSArray *) azStackUserIds withGroupInfo: (NSDictionary *) groupInfo;

- (UIViewController *) getChattingHistory;

- (void) callWithUser: (NSString *) azStackUserId withUserInfo: (NSDictionary *) userinfo;

- (void) callWithUser: (NSString *)azStackUserId;

- (void) setServerType: (int) serverType;

- (void) registerForRemoteNotificationsWithDeviceToken: (NSData *) deviceToken;

- (void) processLocalNotify: (UILocalNotification *)notif;

- (void) processRemoteNotify:(NSDictionary *)userInfo;

@end
