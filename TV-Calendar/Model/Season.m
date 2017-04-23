//
//  Season.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "Season.h"

@implementation Season

- (instancetype)init {
    self = [super init];
    if (self) {
        _showID = 0;
        _name = @"";
        _seNum = 0;
        _quantityOfEpisode = 0;
        _episodesArray = [NSMutableArray array];
    }
    return self;
}

@end
