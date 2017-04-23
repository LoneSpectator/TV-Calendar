//
//  Season.h
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Season : NSObject

@property NSInteger showID;
@property (copy) NSString *name;
@property NSInteger seNum;          // 第几季
@property NSInteger quantityOfEpisode;       // 有几集
@property NSMutableArray *episodesArray;  // 集列表
@property (copy) NSDate *firstAiringDate; // 开播日期
@property (copy) NSDate *lastAiringDate;  // 结束日期
@property NSString *status;               // 当前状态

@end
