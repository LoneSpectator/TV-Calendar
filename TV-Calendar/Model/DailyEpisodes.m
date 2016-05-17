//
//  DailyEpisodes.m
//  TV-Calendar
//
//  Created by GaoMing on 15/5/9.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "DailyEpisodes.h"
#import "Episode.h"
#import "NetworkManager.h"
#import "SettingsManager.h"
#import "User.h"

@implementation DailyEpisodes

- (NSMutableArray *)list {
    if (!_list) {
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}

+ (void)fetchDailyEpisodesWithDate:(NSDate *)date
                           success:(void (^)(DailyEpisodes *))success
                           failure:(void (^)(NSError *))failure {
    void (^successBlock)(NSArray *data) = ^(NSArray *data) {
        DailyEpisodes *dailyEpisodes = [[DailyEpisodes alloc] init];
        for (NSDictionary *epData in data) {
            Episode *ep = [[Episode alloc] init];
            ep.episodeID = [epData[@"e_id"] integerValue];
            ep.showID = [epData[@"s_id"] integerValue];
            ep.episodeName = (SettingsManager.defaultManager.defaultLanguage == zh_CN) ? epData[@"e_name"] : epData[@"e_name"];
            ep.showName = (SettingsManager.defaultManager.defaultLanguage == zh_CN) ? epData[@"s_name_cn"] : epData[@"s_name"];
            ep.numOfEpisode = [epData[@"e_num"] integerValue];
            ep.numOfSeason = [epData[@"se_id"] integerValue];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            ep.airingDate = [dateFormat dateFromString:epData[@"e_time"]];
            NSTimeInterval secondsInterval= [ep.airingDate timeIntervalSinceDate:[NSDate date]];
            ep.isReleased = secondsInterval <= 0 ? YES : NO;
            ep.showVerticalImageURL = [NSString stringWithFormat:@"http://www.pogdesign.co.uk%@", epData[@"s_vertical_image"]];
            [dailyEpisodes.list addObject:ep];
        }
        if (success) {
            success(dailyEpisodes);
        }
    };
    void (^failureBlock)(NSError *error) = ^(NSError *error) {
        if (failure) {
            failure(error);
        }
    };
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"Z"];
    NSString *timeZoneStr = [dateFormatter stringFromDate:[NSDate new]];
    timeZoneStr = [timeZoneStr substringToIndex:3];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    if (!currentUser) {
        [[NetworkManager defaultManager] GET:@"DailyEpisodes"
                                  parameters:@{@"date": dateStr}
                                     success:successBlock
                                     failure:failureBlock];
    } else {
        [[NetworkManager defaultManager] GET:@"MyDailyEpisodes"
                                  parameters:@{@"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                               @"u_token": currentUser.token,
                                               @"date": dateStr,
                                               @"timezone": timeZoneStr}
                                     success:successBlock
                                     failure:failureBlock];
    }
}

@end
