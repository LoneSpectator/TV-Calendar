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
@property (nonatomic, copy) NSString *enName;            // 英文名
@property (nonatomic, copy) NSString *chName;            // 中文名
@property (nonatomic, copy) NSString *imageURL;          // 剧照图
@property (nonatomic, copy) NSString *verticalImageURL;  // 海报图
@property (nonatomic, copy) NSString *wideImageURL;      // 横向长图
@property (nonatomic, copy) NSString *status;            // 当前状态
@property NSInteger seNumOfLastEp;                       // 最后播出集的季号
@property NSInteger epNumOfLastEp;                       // 最后播出集的集号
@property (nonatomic) NSDate *nextEpTime;                // 下一集播出时间
@property (nonatomic, copy) NSString *area;              // 地区
@property (nonatomic, copy) NSString *channel;           // 电视台
@property (nonatomic, copy) NSString *length;            // 每集长度
@property (nonatomic, copy) NSString *introduction;      // 介绍
@property NSInteger quantityOfSeason;                    // 总季数
@property NSInteger quantityOfEpisode;                   // 总集数
@property (nonatomic) NSMutableArray *seasonsArray;      // 季列表
@property BOOL isFavorite;                               // 是否关注
@property NSInteger quantityOfWatchedEpisode;            // 已看过集数
@property float percentOfWatched;                        // 已看过的百分比

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
