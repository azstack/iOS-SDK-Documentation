//
//  ThirdPartyImplement.m
//  AzStack
//
//  Created by Nguyen Van Phu on 7/27/15.
//
//

#import "ThirdPartyImplement.h"
#import <AzStack/AzStackManager.h>
#import <AzStack/AzStackUser.h>

@implementation ThirdPartyImplement

- (id) init {
    self = [super init];
    if (self != nil) {
    }
    return self;
}

static ThirdPartyImplement *ins;

+ (ThirdPartyImplement*)instance {
    
    @synchronized(self) {
        if (!ins){
            ins = [[self alloc] init];
        }
    }
    return ins;
}

#pragma mark AzStackLoginDelegate

- (void) azNonceReceived:(NSString *)nonce {
    //Authenticate with azStackUserID: user1
    NSString* azStackUserID = @"user2";
    NSString* url = [NSString stringWithFormat:@"http://azstack.com/test/gettoken_test.php?azStackUserID=%@&nonce=%@", azStackUserID, nonce];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:60];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if ([httpResponse statusCode] == 200) {
            NSString * resGetToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (resGetToken) {
                NSData *jsonData = [resGetToken dataUsingEncoding:NSUTF8StringEncoding];
                id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
                NSString * token =  json[@"token"];
                [[AzStackManager instance] authenticateWithIdentityToken:token];
            }
        }
    }];
}

#pragma mark AzStackUserInfoDelegate

- (void) azRequestUserInfo:(NSArray *)azStackUserIds withTarget:(int)target{
    // Request user info in your server by HTTP, Socket... IMPORTANT: Your function doesnt block main thread
    // In this test project, We fake return user info
    
    NSMutableArray * userInfoArrays = [[NSMutableArray alloc] init];
    
    for (NSString * azStackUserId in azStackUserIds) {
        NSDictionary * fakeData =
                                @{
                                  @"azstackuserid": azStackUserId,
                                  @"sex": @(1),
                                  @"avatar": @"http://0.gravatar.com/avatar/ad516503a11cd5ca435acc9bb6523536?s=256",
                                  @"fullname": azStackUserId};
        [userInfoArrays addObject:fakeData];
    }
    
    // When you get user info in your server --> call this function to send user info to AzStackSDK
    
    [[AzStackManager instance] sendUserInfoToAzStack:userInfoArrays withTarget:target];
}

- (NSArray *) azRequestListUser{
    NSMutableArray * users = [[NSMutableArray alloc] init];
    AzStackUser * user1 = [[AzStackUser alloc] init];
    user1.fullname = @"User 1";
    user1.azStackUserId = @"user1";
    
    AzStackUser * user2 = [[AzStackUser alloc] init];
    user2.fullname = @"User 2";
    user2.azStackUserId = @"user2";
    
    AzStackUser * user3 = [[AzStackUser alloc] init];
    user3.fullname = @"User 3";
    user3.azStackUserId = @"user3";
    
    AzStackUser * user4 = [[AzStackUser alloc] init];
    user4.fullname = @"User 4";
    user4.azStackUserId = @"user4";
    
    AzStackUser * user5 = [[AzStackUser alloc] init];
    user5.fullname = @"User 5";
    user5.azStackUserId = @"user5";
    
    AzStackUser * user6 = [[AzStackUser alloc] init];
    user6.fullname = @"User 6";
    user6.azStackUserId = @"user6";
    
    AzStackUser * user7 = [[AzStackUser alloc] init];
    user7.fullname = @"User 7";
    user7.azStackUserId = @"user7";
    
    [users addObject:user1];
    [users addObject:user2];
    [users addObject:user3];
    [users addObject:user4];
    [users addObject:user5];
    [users addObject:user6];
    [users addObject:user7];
    
    return users;
}

- (UIViewController *) azRequestUserInfoController:(AzStackUser *)user withAzStackUserId:(NSString *)azStackUserId {
    // Return your controller friend info
    
    // Return nil to use default friend info controller
    return nil;
}

#pragma mark AzStackChatDelegate

- (UINavigationController *) azRequestNavigationToPushChatController{
    return self.navForChatController;
}

- (void) azUpdateUnreadMessageCount:(int)unreadCount {
}

#pragma mark AzStackCallDelegate

- (void) azJustFinishCall:(NSDictionary *)callInfo{
    NSLog(@"Receive call log %@", callInfo);
}

#pragma mark Others

@end
