//
//  ShowDetailsTVEpCell.m
//  TV-Calendar
//
//  Created by GaoMing on 2017/4/25.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "ShowDetailsTVEpCell.h"
#import "Episode.h"
#import "User.h"

@implementation ShowDetailsTVEpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.checkButtonAIView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (ShowDetailsTVEpCell *)cell {
    ShowDetailsTVEpCell *cell = (ShowDetailsTVEpCell *)[[NSBundle mainBundle] loadNibNamed:@"ShowDetailsTVEpCell" owner:nil options:nil].firstObject;
    return cell;
}

- (void)updateWithEpisode:(Episode *)episode {
    self.episode = episode;
    if (episode.epNum < 10) {
        self.epNumLabel.text = [NSString stringWithFormat:@"0%ld", (long)episode.epNum];
    } else {
        self.epNumLabel.text = [NSString stringWithFormat:@"%ld", (long)episode.epNum];
    }
    self.epNameLabel.text = episode.episodeName;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"MM-dd"];
    self.epAiringDateLabel.text = [dateFormatter stringFromDate:episode.airingDate];
    
    
    if (!currentUser) {
        self.checkButtonAIView.hidden = YES;
        self.checkButton.hidden = YES;
        self.checkButtonImageView.hidden = YES;
    } else {
        [self reloadData];
    }
}

- (void)markAsWatched {
    self.checkButton.hidden = YES;
    self.checkButtonImageView.hidden = YES;
    self.checkButtonAIView.hidden = NO;
    [self.checkButtonAIView startAnimating];
    
    ShowDetailsTVEpCell __weak *weakSelf = self;
    [Episode markAsWatchedWithID:self.episode.episodeID
                         success:^(){
                             weakSelf.episode.isWatched = YES;
                             [weakSelf reloadData];
                             weakSelf.checkButton.hidden = NO;
                             weakSelf.checkButtonImageView.hidden = NO;
                             weakSelf.checkButtonAIView.hidden = YES;
                             [weakSelf.checkButtonAIView stopAnimating];
                         }
                         failure:^(NSError *error) {
                             NSLog(@"[EpisodesTVC]%@", error);
                             weakSelf.checkButton.hidden = NO;
                             weakSelf.checkButtonImageView.hidden = NO;
                             weakSelf.checkButtonAIView.hidden = YES;
                             [weakSelf.checkButtonAIView stopAnimating];
                         }];
}

- (void)unMarkAsWatched {
    self.checkButton.hidden = YES;
    self.checkButtonImageView.hidden = YES;
    self.checkButtonAIView.hidden = NO;
    [self.checkButtonAIView startAnimating];
    
    ShowDetailsTVEpCell __weak *weakSelf = self;
    [Episode unMarkAsWatchedWithID:self.episode.episodeID
                           success:^(){
                               weakSelf.episode.isWatched = NO;
                               [weakSelf reloadData];
                               weakSelf.checkButton.hidden = NO;
                               weakSelf.checkButtonImageView.hidden = NO;
                               weakSelf.checkButtonAIView.hidden = YES;
                               [weakSelf.checkButtonAIView stopAnimating];
                           }
                           failure:^(NSError *error) {
                               NSLog(@"[EpisodesTVC]%@", error);
                               weakSelf.checkButton.hidden = NO;
                               weakSelf.checkButtonImageView.hidden = NO;
                               weakSelf.checkButtonAIView.hidden = YES;
                               [weakSelf.checkButtonAIView stopAnimating];
                           }];
}

- (void)reloadData {
    if (self.episode.isReleased) {
        self.epAiringDateLabel.hidden = YES;
        
        ShowDetailsTVEpCell __weak *weakSelf = self;
        [UIView animateWithDuration:0.5
                         animations:^{
                             if (weakSelf.episode.isWatched) {
                                 [weakSelf.checkButtonImageView setImage:[UIImage imageNamed:@"EpisodeCheckButtonBlue"]];
                             } else {
                                 [weakSelf.checkButtonImageView setImage:[UIImage imageNamed:@"EpisodeCheckButtonGray"]];
                             }
                         }];
        if (self.episode.isWatched) {
            [self.checkButton removeTarget:self
                                    action:@selector(markAsWatched)
                          forControlEvents:UIControlEventTouchUpInside];
            [self.checkButton addTarget:self
                                 action:@selector(unMarkAsWatched)
                       forControlEvents:UIControlEventTouchUpInside];
        } else {
            [self.checkButton removeTarget:self
                                    action:@selector(unMarkAsWatched)
                          forControlEvents:UIControlEventTouchUpInside];
            [self.checkButton addTarget:self
                                 action:@selector(markAsWatched)
                       forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        self.checkButtonImageView.hidden = YES;
        self.checkButton.hidden = YES;
        self.checkButtonAIView.hidden = YES;
    }
}

@end
