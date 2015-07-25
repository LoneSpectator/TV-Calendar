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

@protocol EpisodesTVCDelegate <NSObject>

- (void)reloadData;
- (void)showEpisodeDetailVCWithEpisode:(Episode *)episode;
- (void)checkEpisode:(Episode *)episode sender:(EpisodesTVC *)cell;
- (void)uncheckEpisode:(Episode *)episode sender:(EpisodesTVC *)cell;

@end

@interface EpisodesTVC : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *showNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *episodeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *SElabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkView;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) id <EpisodesTVCDelegate> delegate;
@property Episode *episode;

+ (EpisodesTVC *)cellWithEpisode:(Episode *)episode;
- (void)changeToChecked;
- (void)changeToUnchecked;

@end
