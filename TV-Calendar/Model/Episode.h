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
@property (nonatomic, copy) NSString *showName;              // 剧名称
@property (nonatomic, copy) NSString *showImageURL;          // 剧照图
@property (nonatomic, copy) NSString *showVerticalImageURL;  // 海报图
@property (nonatomic, copy) NSString *showWideImageURL;      // 横向长图
@property (nonatomic, copy) NSString *episodeName;           // 集名称
@property NSInteger seNum;                                   // 第几季
@property NSInteger epNum;                                   // 第几集
@property (nonatomic) NSDate *airingDate;                    // 播出日期
@property BOOL isReleased;                                   // 是否播出
@property BOOL isWatched;                                    // 是否已看

- (instancetype)init;
+ (void)markAsWatchedWithID:(NSInteger)episodeID
                    success:(void (^)())success
                    failure:(void (^)(NSError *))failure;
+ (void)unMarkAsWatchedWithID:(NSInteger)episodeID
                      success:(void (^)())success
                      failure:(void (^)(NSError *))failure;

@end
