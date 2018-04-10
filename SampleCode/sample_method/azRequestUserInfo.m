
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
