//
//  Episode.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "Episode.h"
#import "NetworkManager.h"
#import "User.h"

@implementation Episode

- (NSString *)showName {
    if (!_showName) {
        _showName = @"";
    }
    return _showName;
}

- (NSString *)showImageURL {
    if (!_showImageURL) {
        _showImageURL = @"";
    }
    return _showImageURL;
}

- (NSString *)showVerticalImageURL {
    if (!_showVerticalImageURL) {
        _showVerticalImageURL = @"";
    }
    return _showVerticalImageURL;
}

- (NSString *)showWideImageURL {
    if (!_showWideImageURL) {
        _showWideImageURL = @"";
    }
    return _showWideImageURL;
}

- (NSString *)episodeName {
    if (!_episodeName) {
        _episodeName = @"";
    }
    return _episodeName;
}

- (NSDate *)airingDate {
    if (!_airingDate) {
        _airingDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return _airingDate;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showID = -1;
        _episodeID = -1;
        _seNum = 0;
        _epNum = 0;
        _isReleased = NO;
        _isWatched = NO;
    }
    return self;
}

+ (void)markAsWatchedWithID:(NSInteger)episodeID
                    success:(void (^)())success
                    failure:(void (^)(NSError *))failure {
    [[NetworkManager defaultManager] GET:@"MarkEpAsWatched"
                              parameters:@{@"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"u_token": currentUser.token,
                                           @"e_id": [NSString stringWithFormat:@"%ld", (long)episodeID]}
                                 success:^(NSDictionary *msg) {
//                                     NSLog(@"[Episode]%@", msg[@"OK"]);
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

+ (void)unMarkAsWatchedWithID:(NSInteger)episodeID
                      success:(void (^)())success
                      failure:(void (^)(NSError *))failure {
    [[NetworkManager defaultManager] GET:@"UnMarkEpAsWatched"
                              parameters:@{@"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"u_token": currentUser.token,
                                           @"e_id": [NSString stringWithFormat:@"%ld", (long)episodeID]}
                                 success:^(NSDictionary *msg) {
//                                     NSLog(@"[Episode]%@", msg[@"OK"]);
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
