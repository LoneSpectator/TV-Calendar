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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _episodeID = 0;
        _episodeName = @"";
        _showID = 0;
        _showName = @"";
        _numOfSeason = 0;
        _numOfEpisode = 0;
        _airingDate = nil;
        _isReleased = NO;
        _isWatched = NO;
        _showWideImageURL = @"";
        _showSquareImageURL = @"";
    }
    return self;
}

- (void)markAsWatchedWithSuccess:(void (^)())success
                         failure:(void (^)(NSError *))failure {
    Episode __weak *weakSelf = self;
    [[NetworkManager defaultManager] GET:@"MarkEpAsWatched"
                              parameters:@{@"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"e_id": [NSString stringWithFormat:@"%ld", (long)self.episodeID]}
                                 success:^(NSDictionary *msg) {
//                                     NSLog(@"[Episode]%@", msg[@"OK"]);
                                     weakSelf.isWatched = YES;
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

- (void)unMarkAsWatchedWithSuccess:(void (^)())success
                           failure:(void (^)(NSError *))failure {
    Episode __weak *weakSelf = self;
    [[NetworkManager defaultManager] GET:@"UnMarkEpAsWatched"
                              parameters:@{@"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"e_id": [NSString stringWithFormat:@"%ld", (long)self.episodeID]}
                                 success:^(NSDictionary *msg) {
//                                     NSLog(@"[Episode]%@", msg[@"OK"]);
                                     weakSelf.isWatched = NO;
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
