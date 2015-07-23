//
//  DailyEpisodes.m
//  TV-Calendar
//
//  Created by GaoMing on 15/5/9.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "DailyEpisodes.h"
#import "Episode.h"

@implementation DailyEpisodes

- (NSMutableArray *)list {
    if (!_list) {
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}

+ (DailyEpisodes *)dailyEpisodesWithDate:(NSDate *)date {
    DailyEpisodes *dailyEpisodes = [[DailyEpisodes alloc] init];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    Episode *ep;
    for (int i = 0; i < [greCalendar component:NSCalendarUnitDay fromDate:date]; i++) {
        ep = [[Episode alloc] init];
        if (i%3==0) {
            ep.episodeID = i%3;
            ep.showID = i%3;
            ep.episodeName = @"Clown in the Dumps";
            ep.showName = @"The Simpsons";
            ep.showWideImage = @"The-Simpsons";
            ep.numOfSeason = 26;
            ep.numOfEpisode = i;
            ep.airingDate = date;
            ep.isReleased = YES;
            ep.isWatched = i%2;
        } else if (i%3==1) {
            ep.episodeID = i%3;
            ep.showID = i%3;
            ep.episodeName = @"Late Afternoon in the Garden of Bob and ";
            ep.showName = @"Bob's Burgers";
            ep.showWideImage = @"Bobs-Burgers";
            ep.numOfSeason = 5;
            ep.numOfEpisode = i;
            ep.airingDate = date;
            ep.isReleased = YES;
            ep.isWatched = i%2;
        } else {
            ep.episodeID = i%3;
            ep.showID = i%3;
            ep.episodeName = @"15 Chefs Compete";
            ep.showName = @"Hell's Kitchen (US)";
            ep.showWideImage = @"Hells-Kitchen-US";
            ep.numOfSeason = 14;
            ep.numOfEpisode = i;
            ep.airingDate = date;
            ep.isReleased = YES;
            ep.isWatched = i%2;
        }
        [dailyEpisodes.list addObject:ep];
    }
    return dailyEpisodes;
}

@end
