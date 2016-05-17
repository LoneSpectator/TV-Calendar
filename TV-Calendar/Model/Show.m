//
//  Show.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "Show.h"
#import "NetworkManager.h"
#import "SettingsManager.h"

@implementation Show

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)fetchShowDetailWithID:(NSInteger)showID
                      success:(void (^)(Show *))success
                      failure:(void (^)(NSError *))failure {
    [[NetworkManager defaultManager] GET:@"ShowDetail"
                              parameters:@{@"id": [NSString stringWithFormat:@"%ld", (long)showID]}
                                 success:^(NSDictionary *data) {
                                     NSDictionary *showData = data[@"show"];
                                     Show *show = [[Show alloc] init];
                                     show.showID = [showData[@"s_id"] integerValue];
                                     show.name = (SettingsManager.defaultManager.defaultLanguage == zh_CN) ? showData[@"s_name_cn"] : showData[@"s_name"];
                                     show.introduction = showData[@"s_description"];
                                     show.status = showData[@"status"];
                                     show.length = showData[@"length"];
                                     show.area = showData[@"area"];
                                     show.channel = showData[@"channel"];
                                     show.imageURL = [NSString stringWithFormat:@"http://www.pogdesign.co.uk%@", showData[@"s_sibox_image"]];
                                     show.updateTime = showData[@"update_time"];
#warning 未处理剧详情
                                     NSArray *epsArray = data[@"episodes"];
                                     
                                 } failure:^(NSError *error) {
                                     if (failure) {
                                         failure(error);
                                     }
                                 }];
}

@end
