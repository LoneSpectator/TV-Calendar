//
//  EpisodeDetailVC.h
//  TV-Calendar
//
//  Created by GaoMing on 15/5/12.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Episode;

@interface EpisodeDetailVC : UIViewController

+ (EpisodeDetailVC *)viewController;

- (void)updateWithEpisode:(Episode *)episode;

@end
