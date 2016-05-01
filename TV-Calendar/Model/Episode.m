//
//  Episode.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/25.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "Episode.h"

@implementation Episode

- (instancetype)init
{
    self = [super init];
    if (self) {
        _episodeID = 0;
        _episodeName = @"";
        _showID = 0;
        _showName = @"";
        _numOfSeason = 0;
        _numOfEpisode = 0;
        _airingDate = nil;
        _isReleased = NO;
        _isWatched = NO;
        _showWideImageURL = @"";
        _showSquareImageURL = @"";
    }
    return self;
}

@end
