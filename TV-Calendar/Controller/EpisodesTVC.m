//
//  EpisodesTVC.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/12.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "EpisodesTVC.h"
#import "UIImage+BlurredFrame.h"
#import "Episode.h"

@implementation EpisodesTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (EpisodesTVC *)cellWithEpisode:(Episode *)episode {
    EpisodesTVC *cell = (EpisodesTVC *)[[NSBundle mainBundle] loadNibNamed:@"EpisodesTVC" owner:nil options:nil].firstObject;
    cell.backgroundImageView.image = [UIImage imageNamed:episode.showWideImage];
    cell.backgroundImageView.image = [cell.backgroundImageView.image applyLightEffectAtFrame:CGRectMake(0, 0, cell.backgroundImageView.image.size.width, cell.backgroundImageView.image.size.height)];
    cell.showNameLabel.text = episode.showName;
    cell.episodeNameLabel.text = episode.episodeName;
    cell.SElabel.text = [NSString stringWithFormat:@"S:%ld E:%ld", (long)episode.numOfSeason, (long)episode.numOfEpisode];
    
    cell.view.layer.masksToBounds = YES;
    [cell.view.layer setCornerRadius:cell.view.frame.size.height/2];
    
    cell.overlayView.hidden = !episode.isWatched;
    cell.overlayView.userInteractionEnabled = NO;
    return cell;
}

@end
