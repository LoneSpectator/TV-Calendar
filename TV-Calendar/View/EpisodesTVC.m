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
    self.checkButtonAIView.hidden = YES;
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
    [self.showImageView setImageWithURL:[NSURL URLWithString:episode.showVerticalImageURL]
                       placeholderImage:nil];
    self.showNameLabel.text = episode.showName;
    self.episodeNameLabel.text = episode.episodeName;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    self.airingTimeLabel.text = [NSString stringWithFormat:@"播出时间：%@", [dateFormatter stringFromDate:episode.airingDate]];
    self.sLabel.text = [NSString stringWithFormat:@"%ld", (long)episode.numOfSeason];
    self.eLabel.text = [NSString stringWithFormat:@"%ld", (long)episode.numOfEpisode];
    
    if (self.episode.isWatched) {
        self.infoView.alpha = 0.3;
    } else {
        self.infoView.alpha = 1;
    }
    [self reloadData];
}

- (void)markAsWatched {
    self.checkButton.hidden = YES;
    self.checkButtonImageView.hidden = YES;
    self.checkButtonAIView.hidden = NO;
    [self.checkButtonAIView startAnimating];
    
    EpisodesTVC __weak *weakSelf = self;
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
    
    EpisodesTVC __weak *weakSelf = self;
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
    EpisodesTVC __weak *weakSelf = self;
    [UIView animateWithDuration:0.5
                     animations:^{
#warning 少图片
                         if (weakSelf.episode.isWatched) {
                             [weakSelf.checkButtonImageView setImage:[UIImage imageNamed:@""]];
                             weakSelf.infoView.alpha = 0.3;
                             [weakSelf.checkButton setTitle:@"没看过" forState:UIControlStateNormal];
                         } else {
                             [weakSelf.checkButtonImageView setImage:[UIImage imageNamed:@""]];
                             weakSelf.infoView.alpha = 1;
                             [weakSelf.checkButton setTitle:@"已看" forState:UIControlStateNormal];
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
}

@end
