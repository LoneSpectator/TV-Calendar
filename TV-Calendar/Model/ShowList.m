//
//  ShowList.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/24.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "ShowList.h"
#import "NetworkManager.h"
#import "Show.h"
#import "SettingsManager.h"

@implementation ShowList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _list = [[NSMutableArray alloc] init];
        _page = 0;
        _countOfPage = 0;
        _countOfShow = 0;
    }
    return self;
}

- (void)fetchAllShowListFirstPageWithLimit:(NSInteger)limit
                                   success:(void (^)())success
                                   failure:(void (^)(NSError *))failure {
    ShowList __weak *weakSelf = self;
    [[NetworkManager defaultManager] GET:@"AllShow"
                              parameters:@{@"startPage": @"0",
                                           @"itemPerPage": [NSString stringWithFormat:@"%ld", (long)limit]}
                                 success:^(NSDictionary *data) {
                                     weakSelf.page = 0;
                                     weakSelf.countOfShow = [data[@"num"] integerValue];
                                     weakSelf.countOfPage = ceil(weakSelf.countOfShow / 20.0);
                                     weakSelf.list = [[NSMutableArray alloc] init];
                                     NSArray *showsDataArray = data[@"shows"];
                                     for (NSDictionary *showData in showsDataArray) {
                                         Show *show = [[Show alloc] init];
                                         show.showID = [showData[@"s_id"] integerValue];
                                         show.name = (SettingsManager.defaultManager.defaultLanguage == zh_CN) ? showData[@"s_name_cn"] : showData[@"s_name"];
                                         show.status = showData[@"status"];
                                         show.area = showData[@"area"];
                                         show.channel = showData[@"channel"];
                                         show.imageURL = [NSString stringWithFormat:@"http:%@", showData[@"s_sibox_image"]];
                                         show.verticalImageURL = [NSString stringWithFormat:@"http:%@", showData[@"s_vertical_image"]];
                                         [weakSelf.list addObject:show];
                                     }
                                     if (success) {
                                         success();
                                     }
                                 }
                                 failure:^(NSError *error) {
                                     if (failure) {
                                         failure(error);
                                     }
                                 }];
}

- (int)fetchAllShowListNextPageWithLimit:(NSInteger)limit
                                 success:(void (^)())success
                                 failure:(void (^)(NSError *))failure {
    self.page++;
    if (self.page >= self.countOfPage) {
        return 1;
    }
    ShowList __weak *weakSelf = self;
    [[NetworkManager defaultManager] GET:@"AllShow"
                              parameters:@{@"startPage": [NSString stringWithFormat:@"%ld", (long)self.page],
                                           @"itemPerPage": [NSString stringWithFormat:@"%ld", (long)limit]}
                                 success:^(NSDictionary *data) {
                                     NSArray *showsDataArray = data[@"shows"];
                                     for (NSDictionary *showData in showsDataArray) {
                                         Show *show = [[Show alloc] init];
                                         show.showID = [showData[@"s_id"] integerValue];
                                         show.name = (SettingsManager.defaultManager.defaultLanguage == zh_CN) ? showData[@"s_name_cn"] : showData[@"s_name"];
                                         show.status = showData[@"status"];
                                         show.area = showData[@"area"];
                                         show.channel = showData[@"channel"];
                                         show.imageURL = [NSString stringWithFormat:@"http:%@", showData[@"s_sibox_image"]];
                                         show.verticalImageURL = [NSString stringWithFormat:@"http:%@", showData[@"s_vertical_image"]];
                                         [weakSelf.list addObject:show];
                                     }
                                     if (success) {
                                         success();
                                     }
                                 }
                                 failure:^(NSError *error) {
                                     if (failure) {
                                         failure(error);
                                     }
                                 }];
    return 0;
}

@end
