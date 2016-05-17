//
//  Show.h
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Show : NSObject

@property NSInteger showID;
@property (copy) NSString *name;
@property (copy) NSString *introduction;    // 介绍
@property (copy) NSString *status;          // 当前状态
@property (copy) NSString *length;
@property (copy) NSString *area;
@property (copy) NSString *channel;
@property (copy) NSString *imageURL;
@property (copy) NSString *verticalImageURL;
@property (copy) NSString *wideImageURL;
@property (copy) NSString *updateTime;
@property NSInteger constOfSeason;          // 有几季
@property bool isFavorite;                  // 是否关注

+ (void)fetchShowDetailWithID:(NSInteger)showID
                      success:(void (^)(Show *))success
                      failure:(void (^)(NSError *))failure;

@end
