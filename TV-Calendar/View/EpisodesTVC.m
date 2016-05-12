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
#import "User.h"

@implementation EpisodesTVC

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (EpisodesTVC *)cell {
    EpisodesTVC *cell = (EpisodesTVC *)[[NSBundle mainBundle] loadNibNamed:@"EpisodesTVC"
                                                                     owner:nil
                                                                   options:nil].firstObject;
    cell.backgroundColor = [UIColor clearColor];
    
    if (!currentUser) {
        cell.checkButton.hidden = YES;
        cell.checkButtonImageView.hidden = YES;
    }
    
    return cell;
}

- (void)updateWithEpisode:(Episode *)episode {
    self.episode = episode;
    [self.showImageView setImageWithURL:[NSURL URLWithString:episode.showSquareImageURL]
                       placeholderImage:nil];
    self.showNameLabel.text = episode.showName;
    self.episodeNameLabel.text = episode.episodeName;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    self.airingTimeLabel.text = [NSString stringWithFormat:@"播出时间：%@", [dateFormatter stringFromDate:episode.airingDate]];
    self.Slabel.text = [NSString stringWithFormat:@"%ld", (long)episode.numOfSeason];
    self.Elabel.text = [NSString stringWithFormat:@"%ld", (long)episode.numOfEpisode];
    
    
    if (self.episode.isWatched) {
        [self changeToChecked];
    } else {
        [self changeToUnchecked];
    }
}

- (void)changeToChecked {
    self.checkButtonImageView.image = [UIImage imageNamed:@"iTunes"];
    self.overlayView.hidden = YES;
}

- (void)changeToUnchecked {
    self.checkButtonImageView.image = nil;
    self.overlayView.hidden = NO;
}

@end
