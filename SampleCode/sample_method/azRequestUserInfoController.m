- (UIViewController *) azRequestUserInfoController:(AzStackUser *)user withAzStackUserId:(NSString *)azStackUserId {

    // Return your friend info controller

    ContactController * controller = [[ContactController alloc] init];
    controller.azStackUserId = azStackUserId;

    return controller;
    
    // Return nil to use default friend info controller in SDK
    // return nil;
}