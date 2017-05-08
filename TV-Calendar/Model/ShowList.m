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
#import "User.h"

@implementation ShowList

- (NSMutableArray *)list {
    if (!_list) {
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _quantityOfShow = 0;
        _page = 0;
        _quantityOfPage = 0;
    }
    return self;
}

- (void)fetchTopShowListWithSuccess:(void (^)())success
                            failure:(void (^)(NSError *))failure {
    ShowList __weak *weakSelf = self;
    [[NetworkManager defaultManager] GET:@"TopShowList"
                              parameters:@{@"time":[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]*1000]}
                                 success:^(NSDictionary *data) {
                                     weakSelf.list = [[NSMutableArray alloc] init];
                                     for (NSDictionary *showData in data) {
                                         Show *show = [[Show alloc] init];
                                         show.showID = [showData[@"s_id"] integerValue];
                                         show.enName = showData[@"s_name"];
                                         show.chName = showData[@"s_name_cn"];
                                         show.imageURL = showData[@"s_sibox_image"];
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

- (void)fetchTipShowListWithSuccess:(void (^)())success
                            failure:(void (^)(NSError *))failure {
#warning 待实现
    //*/
    [self fetchTopShowListWithSuccess:success failure:failure];
    /*/
    ShowList __weak *weakSelf = self;
    [[NetworkManager defaultManager] GET:@"TipShowList"
                              parameters:@{}
                                 success:^(NSDictionary *data) {
                                     weakSelf.list = [[NSMutableArray alloc] init];
                                     for (NSDictionary *showData in data) {
                                         Show *show = [[Show alloc] init];
                                         show.showID = [showData[@"s_id"] integerValue];
                                         show.enName = showData[@"s_name"];
                                         show.chName = showData[@"s_name_cn"];
                                         show.imageURL = showData[@"s_sibox_image"];
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
    //*/
}

- (void)fetchAllShowListFirstPageWithTag:(NSString *)tag
                                 success:(void (^)())success
                                 failure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    if (!currentUser) {
        parameters = @{@"flag": tag,
                       @"lan": (SettingsManager.defaultManager.defaultLanguage == zh_CN) ? @"cn" : @"en"};
    } else {
        parameters = @{@"flag": tag,
                       @"lan": (SettingsManager.defaultManager.defaultLanguage == zh_CN) ? @"cn" : @"en",
                       @"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                       @"u_token": currentUser.token};;
    }
    ShowList __weak *weakSelf = self;
    [[NetworkManager defaultManager] GET:@"AllShows"
                              parameters:parameters
                                 success:^(NSDictionary *data) {
//                                     weakSelf.page = 0;
//                                     weakSelf.quantityOfPage = [data[@"countShow"] integerValue];
//                                     weakSelf.countOfPage = ceil(weakSelf.countOfShow / 20.0);
                                     weakSelf.list = [[NSMutableArray alloc] init];
                                     for (NSDictionary *showData in data) {
                                         Show *show = [[Show alloc] init];
                                         show.showID = [showData[@"s_id"] integerValue];
                                         show.enName = showData[@"s_name"];
                                         show.chName = showData[@"s_name_cn"];
                                         show.status = showData[@"status"];
                                         show.area = showData[@"area"];
                                         show.channel = showData[@"channel"];
                                         show.imageURL = showData[@"s_sibox_image"];
                                         show.verticalImageURL = showData[@"s_vertical_image"];
                                         show.isFavorite = [showData[@"subscribed"] boolValue];
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

/*/
- (int)fetchAllShowListNextPageWithLimit:(NSInteger)limit
                                 success:(void (^)())success
                                 failure:(void (^)(NSError *))failure {
    self.page++;
    if (self.page >= self.quantityOfPage) {
        return 1;
    }
    ShowList __weak *weakSelf = self;
    [[NetworkManager defaultManager] GET:@"AllShows"
                              parameters:@{@"startPage": [NSString stringWithFormat:@"%ld", (long)self.page],
                                           @"itemPerPage": [NSString stringWithFormat:@"%ld", (long)limit]}
                                 success:^(NSDictionary *data) {
                                     NSArray *showsDataArray = data[@"shows"];
                                     for (NSDictionary *showData in showsDataArray) {
                                         Show *show = [[Show alloc] init];
                                         show.showID = [showData[@"s_id"] integerValue];
                                         show.enName = showData[@"s_name"];
                                         show.chName = showData[@"s_name_cn"];
                                         show.status = showData[@"status"];
                                         show.area = showData[@"area"];
                                         show.channel = showData[@"channel"];
                                         show.imageURL = showData[@"s_sibox_image"];
                                         show.verticalImageURL = showData[@"s_vertical_image"];
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
}//*/

- (void)fetchFavouriteShowListWithSuccess:(void (^)())success
                                  failure:(void (^)(NSError *))failure {
    ShowList __weak *weakSelf = self;
    [[NetworkManager defaultManager] GET:@"FavouriteShows"
                              parameters:@{@"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                                           @"u_token": currentUser.token}
                                 success:^(NSDictionary *data) {
                                     [weakSelf.list removeAllObjects];
                                     NSArray *showsDataArray = data[@"mySubscribe"];
                                     for (NSDictionary *showData in showsDataArray) {
                                         Show *show = [[Show alloc] init];
                                         show.showID = [showData[@"s_id"] integerValue];
                                         show.enName = showData[@"s_name"];
                                         show.chName = showData[@"s_name_cn"];
                                         show.status = showData[@"status"];
                                         show.area = showData[@"area"];
                                         show.channel = showData[@"channel"];
                                         show.imageURL = showData[@"s_sibox_image"];
                                         show.verticalImageURL = showData[@"s_vertical_image"];
                                         show.wideImageURL = showData[@"s_sibig_image"];
                                         show.quantityOfEpisode = [showData[@"count_of_ep"] integerValue];
                                         show.quantityOfWatchedEpisode = [showData[@"count_of_syn_ep"] integerValue];
                                         show.percentOfWatched = [showData[@"percent"] floatValue];
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

- (void)searchShowByName:(NSString *)name
                 success:(void (^)())success
                 failure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    if (!currentUser) {
        parameters = @{@"words": [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
    } else {
        parameters = @{@"words": [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                       @"u_id": [NSString stringWithFormat:@"%ld", (long)currentUser.ID],
                       @"u_token": currentUser.token};
    }
    ShowList __weak *weakSelf = self;
    [[NetworkManager defaultManager] GET:@"SearchShowByName"
                              parameters:parameters
                                 success:^(NSDictionary *data) {
                                     weakSelf.page = 0;
                                     weakSelf.list = [[NSMutableArray alloc] init];
                                     for (NSDictionary *showData in data) {
                                         Show *show = [[Show alloc] init];
                                         show.showID = [showData[@"s_id"] integerValue];
                                         show.enName = showData[@"s_name"];
                                         show.chName = showData[@"s_name_cn"];
                                         show.isFavorite = [showData[@"subscribed"] boolValue];
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

@end
