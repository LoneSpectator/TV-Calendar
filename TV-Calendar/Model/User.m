//
//  User.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "User.h"
#import "NetworkManager.h"
#import <CommonCrypto/CommonDigest.h>

User *currentUser = nil;

@interface User ()

@property (readwrite, copy) NSString *token;

@end

@implementation User

+ (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(void (^)())success
               failure:(void (^)(NSError *))failure {
    [[NetworkManager defaultManager] POST:@"LoginByPassword"
                               parameters:@{@"u_phone": phone,
                                            @"u_passwd": [self md5HexDigest:password]}
                                  success:^(NSDictionary *userData) {
                                      User *user = [[User alloc] init];
                                      user.ID = [userData[@"u_id"] integerValue];
                                      user.name = userData[@"u_name"];
                                      user.phone = userData[@"u_phone"];
                                      user.token = userData[@"u_token"];
                                      user.status = [userData[@"u_status"] integerValue];
                                      currentUser = user;
                                      NSFileManager* fm = [NSFileManager defaultManager];
                                      if (![fm fileExistsAtPath:[User plistPath]]) {
                                          if ([fm createFileAtPath:[User plistPath] contents:nil attributes:nil]) {
                                              [userData writeToFile:[User plistPath] atomically:YES];
                                          } else {
                                              NSLog(@"[User]用户信息文件创建失败");
                                          }
                                      } else {
                                          NSLog(@"[User]用户信息文件存在");
                                      }
                                      if (success) {
                                          success();
                                      }
                                  }
                                  failure:^(NSError *error) {
                                      if (failure) {
                                          failure(error);
                                      }
                                  }];
}

+ (BOOL)loginWithCache {
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[User plistPath]] && [fm isReadableFileAtPath:[User plistPath]]) {
        NSDictionary *userData = [[NSDictionary alloc] initWithContentsOfFile:[User plistPath]];
        User *user = [[User alloc] init];
        user.ID = [userData[@"u_id"] integerValue];
        user.name = userData[@"u_name"];
        user.phone = userData[@"u_phone"];
        user.token = userData[@"u_token"];
        user.status = [userData[@"u_status"] integerValue];
        currentUser = user;
    } else {
        return NO;
    }
    return NO;
}

+ (void)logout {
    currentUser = nil;
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[User plistPath]]) {
        NSError *err;
        [fm removeItemAtPath:[User plistPath] error:&err];
        if (err) {
            NSLog(@"[User]%@", err);
        }
    }
}

+ (NSString *)plistPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:@"UserInfo.plist"];
    return plistPath;
}

+ (NSString *)md5HexDigest:(NSString *)str {
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (unsigned int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end
