//
//  EpisodesTVC.h
//  TV-Calendar
//
//  Created by GaoMing on 15/4/12.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Episode;
@class EpisodesTVC;

@interface EpisodesTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *showNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *episodeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *airingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sLabel;
@property (weak, nonatomic) IBOutlet UILabel *eLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *checkButtonAIView;
@property (weak, nonatomic) IBOutlet UIImageView *checkButtonImageView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;

@property (nonatomic) Episode *episode;

+ (EpisodesTVC *)cell;
- (void)updateWithEpisode:(Episode *)episode;

@end
