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
@property NSInteger seNum;                            // 第几季
@property NSInteger quantityOfEpisode;                // 有几集
@property (nonatomic) NSMutableArray *episodesArray;  // 集列表
@property (nonatomic, copy) NSString *status;         // 当前状态
@property (nonatomic) NSDate *firstAiringDate;        // 开播日期
@property (nonatomic) NSDate *lastAiringDate;         // 结束日期
@property BOOL isAllWatched;                          // 是否全部已看过

- (instancetype)init;
+ (void)markAsWatchedWithShowID:(NSInteger)showID
                          SeNum:(NSInteger)seNum
                        success:(void (^)())success
                        failure:(void (^)(NSError *))failure;

+ (void)unMarkAsWatchedWithShowID:(NSInteger)showID
                            SeNum:(NSInteger)seNum
                          success:(void (^)())success
                          failure:(void (^)(NSError *))failure;

@end
