//
//  ShowList.h
//  TV-Calendar
//
//  Created by GaoMing on 16/5/24.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowList : NSObject

@property (copy) NSMutableArray *list;
@property NSInteger page;
@property NSInteger countOfPage;
@property NSInteger countOfShow;

- (instancetype)init;
- (void)fetchAllShowListFirstPageWithLimit:(NSInteger)limit
                                   success:(void (^)())success
                                   failure:(void (^)(NSError *))failure;
- (int)fetchAllShowListNextPageWithLimit:(NSInteger)limit
                                 success:(void (^)())success
                                 failure:(void (^)(NSError *))failure;

@end
