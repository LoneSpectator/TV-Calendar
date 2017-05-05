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

- (NSMutableArray *)episodesArray {
    if (!_episodesArray) {
        _episodesArray = [NSMutableArray array];
    }
    return _episodesArray;
}

- (NSString *)status {
    if (!_status) {
        _status = @"";
    }
    return _status;
}

- (NSDate *)firstAiringDate {
    if (!_firstAiringDate) {
        _firstAiringDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return _firstAiringDate;
}

- (NSDate *)lastAiringDate {
    if (!_lastAiringDate) {
        _lastAiringDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return _lastAiringDate;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _showID = -1;
        _seNum = 0;
        _quantityOfEpisode = 0;
        _isAllWatched = NO;
    }
    return self;
}

+ (void)markAsWatchedWithShowID:(NSInteger)showID
                          SeNum:(NSInteger)seNum
                        success:(void (^)())success
                        failure:(void (^)(NSError *))failure {
    [[NetworkManager defaultManager] GET:@"MarkSeAsWatched"
                              parameters:@{@"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"u_token": currentUser.token,
                                           @"s_id": [NSString stringWithFormat:@"%ld", (long)showID],
                                           @"se_id": [NSString stringWithFormat:@"%ld", (long)seNum]}
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
}

+ (void)unMarkAsWatchedWithShowID:(NSInteger)showID
                            SeNum:(NSInteger)seNum
                          success:(void (^)())success
                          failure:(void (^)(NSError *))failure {
    [[NetworkManager defaultManager] GET:@"UnMarkSeAsWatched"
                              parameters:@{@"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"u_token": currentUser.token,
                                           @"s_id": [NSString stringWithFormat:@"%ld", (long)showID],
                                           @"se_id": [NSString stringWithFormat:@"%ld", (long)seNum]}
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
}

@end
