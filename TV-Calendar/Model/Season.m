//
//  Season.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "Season.h"
#import "NetworkManager.h"
#import "User.h"

@implementation Season

- (instancetype)init {
    self = [super init];
    if (self) {
        _showID = 0;
        _name = @"";
        _seNum = 0;
        _quantityOfEpisode = 0;
        _episodesArray = [NSMutableArray array];
    }
    return self;
}

+ (void)markAsWatchedWithShowID:(NSInteger)showID
                          SeNum:(NSInteger)seNum
                        success:(void (^)())success
                        failure:(void (^)(NSError *))failure {
#warning
    //*/
    if (success) {
        success();
    }/*/
    [[NetworkManager defaultManager] GET:@"MarkSeAsWatched"
                              parameters:@{@"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"u_token": currentUser.token,
                                           @"showID": [NSString stringWithFormat:@"%ld", (long)showID],
                                           @"seNum": [NSString stringWithFormat:@"%ld", (long)seNum]}
                                 success:^(NSDictionary *msg) {
//                                     NSLog(@"[Season]%@", msg[@"OK"]);
                                     if (success) {
                                         success();
                                     }
                                 }
                                 failure:^(NSError *error) {
                                     if (failure) {
                                         failure(error);
                                     }
                                 }];
    //*/
}

+ (void)unMarkAsWatchedWithShowID:(NSInteger)showID
                            SeNum:(NSInteger)seNum
                          success:(void (^)())success
                          failure:(void (^)(NSError *))failure {
#warning
    //*/
    if (success) {
        success();
    }/*/
    [[NetworkManager defaultManager] GET:@"UnMarkSeAsWatched"
                              parameters:@{@"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"u_token": currentUser.token,
                                           @"showID": [NSString stringWithFormat:@"%ld", (long)showID],
                                           @"seNum": [NSString stringWithFormat:@"%ld", (long)seNum]}
                                 success:^(NSDictionary *msg) {
//                                     NSLog(@"[Season]%@", msg[@"OK"]);
                                     if (success) {
                                         success();
                                     }
                                 }
                                 failure:^(NSError *error) {
                                     if (failure) {
                                         failure(error);
                                     }
                                 }];
    //*/
}

@end
