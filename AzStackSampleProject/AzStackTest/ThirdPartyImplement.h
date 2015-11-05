//
//  ThirdPartyImplement.h
//  AzStack
//
//  Created by Nguyen Van Phu on 7/27/15.
//
//

#import <Foundation/Foundation.h>
#import <AzStack/AzStackManager.h>

@interface ThirdPartyImplement : NSObject <AzAuthenticationDelegate, AzUserInfoDelegate, AzCallDelegate, AzChatDelegate>

+ (ThirdPartyImplement*)instance;

@property (nonatomic, weak) UINavigationController * navForChatController;

@end
