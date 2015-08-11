//
//  EpisodesTVC.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/12.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "EpisodesTVC.h"
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
    EpisodesTVC *cell = (EpisodesTVC *)[[NSBundle mainBundle] loadNibNamed:@"EpisodesTVC"
                                                                     owner:nil
                                                                   options:nil].firstObject;
    cell.episode = episode;
    cell.backgroundImageView.image = [UIImage imageNamed:cell.episode.showWideImage];
    cell.showNameLabel.text = cell.episode.showName;
    cell.episodeNameLabel.text = cell.episode.episodeName;
    cell.SElabel.text = [NSString stringWithFormat:@"S:%ld E:%ld", (long)cell.episode.numOfSeason, (long)cell.episode.numOfEpisode];
    
    cell.overlayView.userInteractionEnabled = NO;
    cell.checkView.userInteractionEnabled = YES;
    cell.backgroundImageView.userInteractionEnabled = YES;
    [cell.backgroundImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:cell
                                                                                           action:@selector(showEpisodeDetailVC)]];
    if (cell.episode.isWatched) {
        [cell changeToChecked];
    } else {
        [cell changeToUnchecked];
    }
    return cell;
}

- (void)showEpisodeDetailVC {
    [self.delegate showEpisodeDetailVCWithEpisode:self.episode];
}

- (void)checkEpisode {
    [self.delegate checkEpisode:self.episode
                         sender:self];
}

- (void)uncheckEpisode {
    [self.delegate uncheckEpisode:self.episode
                           sender:self];
}

- (void)changeToChecked {
    self.checkView.image = nil;
    self.overlayView.hidden = YES;
    [self.checkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(uncheckEpisode)]];
}

- (void)changeToUnchecked {
    self.checkView.image = [UIImage imageNamed:@"iTunes"];
    self.overlayView.hidden = NO;
    [self.checkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(checkEpisode)]];
}

@end
