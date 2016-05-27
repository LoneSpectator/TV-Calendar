//
//  DailyEpisodes.h
//  TV-Calendar
//
//  Created by GaoMing on 15/5/9.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyEpisodes : NSObject

@property (copy, nonatomic) NSMutableArray *list;

+ (void)fetchDailyEpisodesWithDate:(NSDate *)date
                           success:(void (^)(DailyEpisodes *))success
                           failure:(void (^)(NSError *))failure;

@end
