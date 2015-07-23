//
//  EpisodesTVC.h
//  TV-Calendar
//
//  Created by GaoMing on 15/4/12.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Episode;

@interface EpisodesTVC : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *showNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *episodeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *SElabel;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIView *overlayView;

+ (EpisodesTVC *)cellWithEpisode:(Episode *)episode;

@end
