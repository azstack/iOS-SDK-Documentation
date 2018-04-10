- (NSArray *) azRequestFriendList{
    NSMutableArray * users = [[NSMutableArray alloc] init];
    
    AzStackUser * user1 = [[AzStackUser alloc] init];
    user1.fullname = @"phunv8";
    user1.azStackUserId = @"phunv8";
    
    AzStackUser * user2 = [[AzStackUser alloc] init];
    user2.fullname = @"anhtt";
    user2.azStackUserId = @"anhtt";
    
    AzStackUser * user3 = [[AzStackUser alloc] init];
    user3.fullname = @"gianglh";
    user3.azStackUserId = @"gianglh";
    
    AzStackUser * user4 = [[AzStackUser alloc] init];
    user4.fullname = @"luannb3";
    user4.azStackUserId = @"luannb3";
    
    AzStackUser * user5 = [[AzStackUser alloc] init];
    user5.fullname = @"tannt4";
    user5.azStackUserId = @"tannt4";
    
    AzStackUser * user6 = [[AzStackUser alloc] init];
    user6.fullname = @"0912323549823";
    user6.azStackUserId = @"0912323549823";
    
    AzStackUser * user7 = [[AzStackUser alloc] init];
    user7.fullname = @"091232354982345";
    user7.azStackUserId = @"091232354982345";
    
    [users addObject:user1];
    [users addObject:user2];
    [users addObject:user3];
    [users addObject:user4];
    [users addObject:user5];
    
    [users addObject:user6];
    [users addObject:user7];
    
    return users;
}
