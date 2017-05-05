//
//  ShowList.h
//  TV-Calendar
//
//  Created by GaoMing on 16/5/24.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowList : NSObject

@property (nonatomic) NSMutableArray *list;
@property NSInteger quantityOfShow;
@property NSInteger page;
@property NSInteger quantityOfPage;

- (instancetype)init;
- (void)fetchTopShowListWithSuccess:(void (^)())success
                            failure:(void (^)(NSError *))failure;
- (void)fetchTipShowListWithSuccess:(void (^)())success
                            failure:(void (^)(NSError *))failure;
- (void)fetchAllShowListFirstPageWithLimit:(NSInteger)limit
                                   success:(void (^)())success
                                   failure:(void (^)(NSError *))failure;
- (int)fetchAllShowListNextPageWithLimit:(NSInteger)limit
                                 success:(void (^)())success
                                 failure:(void (^)(NSError *))failure;
- (void)fetchFavouriteShowListWithSuccess:(void (^)())success
                                  failure:(void (^)(NSError *))failure;
- (void)searchShowByName:(NSString *)name
                 success:(void (^)())success
                 failure:(void (^)(NSError *))failure;

@end
