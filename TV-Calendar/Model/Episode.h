//
//  Episode.h
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Episode : NSObject

@property NSInteger episodeID;
@property NSInteger showID;
@property NSInteger seasonID;
@property (copy) NSString *episodeName;
@property (copy) NSString *showName;
@property (copy) NSString *seasonName;
@property (copy) NSString *showWideImage;
@property (copy) NSString *showSquareImage;
@property NSInteger numOfSeason;     // 第几季
@property NSInteger numOfEpisode;    // 第几集
@property NSDate *airingDate;        // 播出日期
@property bool isReleased;           // 是否播出
@property bool isWatched;            // 是否已看

@end
