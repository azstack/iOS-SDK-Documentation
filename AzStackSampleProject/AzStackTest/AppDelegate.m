//
//  AppDelegate.m
//  AzStackTest
//
//  Created by Phu Nguyen on 6/22/15.
//  Copyright (c) 2015 Phu Nguyen. All rights reserved.
//

#import "AppDelegate.h"
#import "AzStackTestController.h"
#import <AzStack/AzStackManager.h>
#import <AzStack/AzStackUser.h>
#import "ThirdPartyImplement.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Set APP ID
    [[AzStackManager instance] setAppId:@"26870527d2ac628002dda81be54217cf"];
    
    // SET AZSTACK DELEGATE
    [AzStackManager instance].azAuthenticationDelegate = [ThirdPartyImplement instance];
    [AzStackManager instance].azUserInfoDelegate = [ThirdPartyImplement instance];
    [AzStackManager instance].azChatDelegate = [ThirdPartyImplement instance];
    [AzStackManager instance].azCallDelegate = [ThirdPartyImplement instance];
    
    // INITIAL
    [[AzStackManager instance] setTintColorNavigationBar:[UIColor blackColor]];
    [[AzStackManager instance] setLanguage:@"en"];
    [[AzStackManager instance] setServerType:AZSERVER_TEST];
    [[AzStackManager instance] initial];
    
    AzStackTestController * azStackTestController = [[AzStackTestController alloc] init];
    azStackTestController.title = @"Authenticating ...";
    
    // CONNECT
    [[AzStackManager instance] connectWithCompletion:^(NSString * authenticatedAzStackUserID, NSError *error, BOOL successful) {
        if (successful) {
            NSLog(@"Authent successful, authenticatedAzStackUserID: %@", authenticatedAzStackUserID);
            dispatch_async(dispatch_get_main_queue(), ^{
                azStackTestController.title = [NSString stringWithFormat:@"Your azStackUserID: %@", authenticatedAzStackUserID];
            });
        } else {
            NSLog(@"Authent failed. ResponseCode: %ld. Error Message: %@", (long)error.code, [error description]);
        }
    }];
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:azStackTestController];
    navController.navigationBar.translucent = YES;
    
    self.window.rootViewController = navController;
    self.window.rootViewController.view.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
