//
//  Show.h
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Show : NSObject

@property NSInteger ID;
@property (copy) NSString *name;
@property NSInteger constOfSeason; // 有几季
@property (copy) NSString *status; // 当前状态
@property bool isFavorite;         // 是否关注

@end
