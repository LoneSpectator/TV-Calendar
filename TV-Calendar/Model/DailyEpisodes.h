//
//  DailyEpisodes.h
//  TV-Calendar
//
//  Created by GaoMing on 15/5/9.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyEpisodes : NSObject

@property (nonatomic, copy) NSMutableArray *list;

+ (DailyEpisodes *)dailyEpisodesWithDate:(NSDate *)date;

@end
