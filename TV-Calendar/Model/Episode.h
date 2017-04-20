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
@property (copy) NSString *showName;
@property (copy) NSString *episodeName;
@property NSInteger numOfSeason;     // 第几季
@property NSInteger numOfEpisode;    // 第几集
@property NSDate *airingDate;        // 播出日期
@property BOOL isReleased;           // 是否播出
@property BOOL isWatched;            // 是否已看
@property (copy) NSString *showImageURL;
@property (copy) NSString *showVerticalImageURL;
@property (copy) NSString *showWideImageURL;

- (instancetype)init;
+ (void)markAsWatchedWithID:(NSInteger)episodeID
                    success:(void (^)())success
                    failure:(void (^)(NSError *))failure;
+ (void)unMarkAsWatchedWithID:(NSInteger)episodeID
                      success:(void (^)())success
                      failure:(void (^)(NSError *))failure;

@end
