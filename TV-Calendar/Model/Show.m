//
//  Show.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "Show.h"
#import "NetworkManager.h"
#import "SettingsManager.h"
#import "Season.h"
#import "Episode.h"
#import "User.h"

@implementation Show

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nextEpTime = [NSDate new];
        _seasonsArray = [NSMutableArray array];
    }
    return self;
}

+ (void)fetchShowDetailWithID:(NSInteger)showID
                      success:(void (^)(Show *))success
                      failure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    if (currentUser) {
        parameters = @{@"id": [NSString stringWithFormat:@"%ld", (long)showID],
                       @"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                       @"u_token": currentUser.token};
    } else {
        parameters = @{@"id": [NSString stringWithFormat:@"%ld", (long)showID]};
    }
    [[NetworkManager defaultManager] GET:@"ShowDetail"
                              parameters:parameters
                                 success:^(NSDictionary *data) {
                                     NSDictionary *showData = data[@"show"];
                                     Show *show = [[Show alloc] init];
                                     show.showID = [showData[@"s_id"] integerValue];
                                     show.enName = showData[@"s_name"];
                                     show.chName = showData[@"s_name_cn"];
                                     show.introduction = showData[@"s_description"];
                                     show.status = showData[@"status"];
                                     show.length = showData[@"length"];
                                     show.area = showData[@"area"];
                                     show.channel = showData[@"channel"];
                                     show.imageURL = [NSString stringWithFormat:@"http:%@", showData[@"s_sibox_image"]];
                                     NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                                     [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                                     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                     show.nextEpTime = [dateFormatter dateFromString:showData[@"next_ep_time"]];
                                     show.isFavorite = [data[@"subscribed"] boolValue];
                                     for (NSDictionary *seData in data[@"seasons"]) {
                                         Season *se = [[Season alloc] init];
                                         se.showID = show.showID;
                                         se.seNum = [seData[@"se_id"] integerValue];
                                         se.quantityOfEpisode = [seData[@"count_of_ep"] integerValue];
                                         for (NSDictionary *epData in seData[@"episodes"]) {
                                             Episode *ep = [[Episode alloc] init];
                                             ep.episodeID = [epData[@"e_id"] integerValue];
                                             ep.seNum = se.seNum;
                                             ep.epNum = [epData[@"e_num"] integerValue];
                                             ep.episodeName = epData[@"e_name"];
                                             [se.episodesArray addObject:ep];
                                         }
                                         [show.seasonsArray addObject:se];
                                     }
                                     if (success) {
                                         success(show);
                                     }
                                     
                                 } failure:^(NSError *error) {
                                     if (failure) {
                                         failure(error);
                                     }
                                 }];
}

+ (void)addToFavouritesWithID:(NSInteger)showID
                      success:(void (^)())success
                      failure:(void (^)(NSError *))failure {
    [[NetworkManager defaultManager] GET:@"AddShowToFavourites"
                              parameters:@{@"s_id": [NSString stringWithFormat:@"%ld", (long)showID],
                                           @"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"u_token": currentUser.token}
                                 success:^(NSDictionary *msg) {
//                                     NSLog(@"[Show]%@", msg[@"OK"]);
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

+ (void)removeFromFavouritesWithID:(NSInteger)showID
                           success:(void (^)())success
                           failure:(void (^)(NSError *))failure {
    [[NetworkManager defaultManager] GET:@"RemoveShowFromFavourites"
                              parameters:@{@"s_id": [NSString stringWithFormat:@"%ld", (long)showID],
                                           @"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"u_token": currentUser.token}
                                 success:^(NSDictionary *msg) {
//                                     NSLog(@"[Show]%@", msg[@"OK"]);
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
