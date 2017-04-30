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
#import "LocalizedString.h"

@implementation EpisodesTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.checkButtonAIView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (EpisodesTVC *)cell {
    EpisodesTVC *cell = (EpisodesTVC *)[[NSBundle mainBundle] loadNibNamed:@"EpisodesTVC"
                                                                     owner:nil
                                                                   options:nil].firstObject;
    return cell;
}

- (void)updateWithEpisode:(Episode *)episode {
    self.episode = episode;
    [self.showVerticalImageView setImageWithURL:[NSURL URLWithString:episode.showVerticalImageURL]
                       placeholderImage:nil];
    self.showNameLabel.text = episode.showName;
    self.episodeNameLabel.text = episode.episodeName;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    self.airingTimeLabel.text = [NSString stringWithFormat:@"播出时间：%@", [dateFormatter stringFromDate:episode.airingDate]];
    if (episode.seNum < 10) {
        self.sLabel.text = [NSString stringWithFormat:@"0%ld", (long)episode.seNum];
    } else {
        self.sLabel.text = [NSString stringWithFormat:@"%ld", (long)episode.seNum];
    }
    if (episode.epNum < 10) {
        self.eLabel.text = [NSString stringWithFormat:@"0%ld", (long)episode.epNum];
    } else {
        self.eLabel.text = [NSString stringWithFormat:@"%ld", (long)episode.epNum];
    }
    
    if (!currentUser) {
        self.checkButtonAIView.hidden = YES;
        self.checkButton.hidden = YES;
        self.checkButtonImageView.hidden = YES;
    } else {
        if (self.episode.isWatched) { // 避免刷新时的闪动
            [self.checkButtonImageView setImage:[UIImage imageNamed:@"EpisodeCheckButtonBlue"]];
            self.infoView.alpha = 0.3;
        } else {
            [self.checkButtonImageView setImage:[UIImage imageNamed:@"EpisodeCheckButtonGray"]];
            self.infoView.alpha = 1;
        }
        [self reloadData];
    }
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
                         if (weakSelf.episode.isWatched) {
                             [weakSelf.checkButtonImageView setImage:[UIImage imageNamed:@"EpisodeCheckButtonBlue"]];
                             weakSelf.infoView.alpha = 0.3;
                         } else {
                             [weakSelf.checkButtonImageView setImage:[UIImage imageNamed:@"EpisodeCheckButtonGray"]];
                             weakSelf.infoView.alpha = 1;
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
