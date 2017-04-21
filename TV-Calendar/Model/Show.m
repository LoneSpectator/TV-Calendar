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
#import "Episode.h"
#import "User.h"

@implementation Show

- (instancetype)init
{
    self = [super init];
    if (self) {
        
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
                                     show.airingTime = showData[@"update_time"];
                                     show.isFavorite = [data[@"subscribed"] boolValue];
#warning 未处理集详情
                                     NSArray *epsArray = data[@"episodes"];
                                     show.lastEp = [[Episode alloc] init];
                                     for (NSDictionary *epData in epsArray) {
                                         if ([epData[@"e_status"] isEqualToString:@"已播放"]) {
                                             show.lastEp.numOfSeason = [epData[@"se_id"] integerValue];
                                             show.lastEp.numOfEpisode = [epData[@"e_num"] integerValue];
                                             break;
                                         }
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
