//
//  Show.h
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Episode;

@interface Show : NSObject

@property NSInteger showID;
@property (copy) NSString *enName;
@property (copy) NSString *chName;
@property (copy) NSString *introduction;    // 介绍
@property (copy) NSString *status;          // 当前状态
@property NSInteger seNumOfLastEp;
@property NSInteger epNumOfLastEp;
@property (copy) NSDate *nextEpTime;
@property (copy) NSString *area;
@property (copy) NSString *channel;
@property (copy) NSString *length;
@property (copy) NSString *imageURL;
@property (copy) NSString *verticalImageURL;
@property (copy) NSString *wideImageURL;
@property NSInteger quantityOfSeason;       // 总季数
@property NSInteger quantityOfEpisode;      // 总集数
@property NSMutableArray *seasonsArray;     // 季列表
@property BOOL isFavorite;                  // 是否关注
@property NSInteger constOfWatchedEpisode;  // 已看过集数
@property float percentOfWatched;

- (instancetype)init;
+ (void)fetchShowDetailWithID:(NSInteger)showID
                      success:(void (^)(Show *))success
                      failure:(void (^)(NSError *))failure;
+ (void)addToFavouritesWithID:(NSInteger)showID
                      success:(void (^)())success
                      failure:(void (^)(NSError *))failure;
+ (void)removeFromFavouritesWithID:(NSInteger)showID
                           success:(void (^)())success
                           failure:(void (^)(NSError *))failure;

@end
