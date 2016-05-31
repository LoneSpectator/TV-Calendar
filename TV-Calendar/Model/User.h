//
//  User.h
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property NSInteger ID;
@property (copy) NSString *name;
@property (copy) NSString *phone;
@property (copy) NSString *avatarImageURL;
@property (readonly, copy) NSString *token;
@property NSInteger status;

//+ (void)checkLogin:(UIViewController *)sender;
+ (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(void (^)())success
               failure:(void (^)(NSError *))failure;
+ (BOOL)loginWithCache;
+ (void)logout;
+ (void)registerWithPhone:(NSString *)phone
                 userName:(NSString *)userName
                 password:(NSString *)password
                  success:(void (^)())success
                  failure:(void (^)(NSError *))failure;

@end

extern User *currentUser;
