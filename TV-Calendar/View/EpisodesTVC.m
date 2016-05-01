//
//  EpisodesTVC.m
//  TV-Calendar
//
//  Created by GaoMing on 15/4/12.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

#import "EpisodesTVC.h"
#import "Episode.h"
#import "UIKit+AFNetworking.h"

@implementation EpisodesTVC

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (EpisodesTVC *)cell {
    EpisodesTVC *cell = (EpisodesTVC *)[[NSBundle mainBundle] loadNibNamed:@"EpisodesTVC"
                                                                     owner:nil
                                                                   options:nil].firstObject;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)updateWithEpisode:(Episode *)episode {
    self.episode = episode;
    [self.showImageView setImageWithURL:[NSURL URLWithString:self.episode.showSquareImageURL]
                       placeholderImage:nil];
    self.showNameLabel.text = self.episode.showName;
    self.episodeNameLabel.text = self.episode.episodeName;
    self.Slabel.text = [NSString stringWithFormat:@"%ld", (long)self.episode.numOfSeason];
    self.Elabel.text = [NSString stringWithFormat:@"%ld", (long)self.episode.numOfEpisode];
    
    self.checkView.userInteractionEnabled = YES;
    self.showImageView.userInteractionEnabled = YES;
    
    if (self.episode.isWatched) {
        [self changeToChecked];
    } else {
        [self changeToUnchecked];
    }
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
    self.checkView.image = [UIImage imageNamed:@"iTunes"];
    self.overlayView.hidden = YES;
    [self.checkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(uncheckEpisode)]];
}

- (void)changeToUnchecked {
    self.checkView.image = nil;
    self.overlayView.hidden = NO;
    [self.checkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(checkEpisode)]];
}

@end
