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
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy-MM-dd"];
    [[NetworkManager defaultManager] GET:@"SelectOneDateEp"
                              parameters:@{@"date": [dayFormatter stringFromDate:date]}
                                 success:^(NSArray *data) {
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
                                         ep.showSquareImageURL = [NSString stringWithFormat:@"http://www.pogdesign.co.uk%@", epData[@"s_vertical_image"]];
                                         [dailyEpisodes.list addObject:ep];
                                     }
                                     if (success) {
                                         success(dailyEpisodes);
                                     }
                                 }
                                 failure:^(NSError *error) {
                                     if (failure) {
                                         failure(error);
                                     }
                                 }];
}

@end
