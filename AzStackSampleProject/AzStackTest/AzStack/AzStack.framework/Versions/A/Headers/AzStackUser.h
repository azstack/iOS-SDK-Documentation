//
//  StackUser.h
//  AzStack
//
//  Created by Nguyen Van Phu on 10/29/15.
//
//

#import <Foundation/Foundation.h>

@interface AzStackUser : NSObject

@property (nonatomic, strong) NSString* fullname;
@property (nonatomic, strong) NSString* avatar;
@property (nonatomic, strong) NSNumber* sex;
@property (nonatomic, strong) NSString* phoneNumber;
@property (nonatomic, strong) NSString* statusMessage;
@property (nonatomic, strong) NSString * azStackUserId;

@end
