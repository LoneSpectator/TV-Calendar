//
//  ShowDetailsTVEpHeaderView.m
//  TV-Calendar
//
//  Created by GaoMing on 2017/4/25.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "ShowDetailsTVEpHeaderView.h"
#import "Season.h"
#import "Episode.h"

@implementation ShowDetailsTVEpHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.checkButtonAIView.hidden = YES;
}

+ (ShowDetailsTVEpHeaderView *)view {
    ShowDetailsTVEpHeaderView *view = (ShowDetailsTVEpHeaderView *)[[NSBundle mainBundle] loadNibNamed:@"ShowDetailsTVEpHeaderView" owner:nil options:nil].firstObject;
    [view.infoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:view
                                                                                action:@selector(viewTouchUpInside)]];
    return view;
}

- (void)updateWithSeason:(Season *)season openTag:(BOOL)openTag {
    self.season = season;
    self.seNumLabel.text = [NSString stringWithFormat:@"%ld", (long)season.seNum];
    self.openTag = openTag;
    self.signLabel.transform = openTag ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
    if (self.season.isAllWatched) {
        [self.checkButtonImageView setImage:[UIImage imageNamed:@"EpisodeCheckButtonBlue"]];
    } else {
        [self.checkButtonImageView setImage:[UIImage imageNamed:@"EpisodeCheckButtonGray"]];
    }
    [self reloadData];
}

- (void)viewTouchUpInside {
    self.openTag = !self.openTag;
    ShowDetailsTVEpHeaderView __weak *weakSelf = self;
    [UIView animateWithDuration:0.5
                     animations:^{
                         weakSelf.signLabel.transform = weakSelf.tag ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
                     }];
    if (self.setOpenTagBlock) {
        self.setOpenTagBlock();
    }
}

- (void)markAllAsWatched {
    self.checkButton.hidden = YES;
    self.checkButtonImageView.hidden = YES;
    self.checkButtonAIView.hidden = NO;
    [self.checkButtonAIView startAnimating];
    
    ShowDetailsTVEpHeaderView __weak *weakSelf = self;
    [Season markAsWatchedWithShowID:self.season.showID
                              SeNum:self.season.seNum
                            success:^{
                                weakSelf.season.isAllWatched = YES;
                                for (Episode *ep in weakSelf.season.episodesArray) {
                                    if (ep.isReleased) {
                                        ep.isWatched = YES;
                                    }
                                }
                                [weakSelf reloadData];
                                if (weakSelf.refreshTableViewBlock) {
                                    weakSelf.refreshTableViewBlock();
                                }
                                weakSelf.checkButton.hidden = NO;
                                weakSelf.checkButtonImageView.hidden = NO;
                                weakSelf.checkButtonAIView.hidden = YES;
                                [weakSelf.checkButtonAIView stopAnimating];
                            }
                            failure:^(NSError *error) {
                                NSLog(@"[ShowDetailsTVEpHeaderView]%@", error);
                                weakSelf.checkButton.hidden = NO;
                                weakSelf.checkButtonImageView.hidden = NO;
                                weakSelf.checkButtonAIView.hidden = YES;
                                [weakSelf.checkButtonAIView stopAnimating];
                            }];
}

- (void)unMarkAllAsWatched {
    self.checkButton.hidden = YES;
    self.checkButtonImageView.hidden = YES;
    self.checkButtonAIView.hidden = NO;
    [self.checkButtonAIView startAnimating];
    
    ShowDetailsTVEpHeaderView __weak *weakSelf = self;
    [Season unMarkAsWatchedWithShowID:self.season.showID
                                SeNum:self.season.seNum
                              success:^(){
                                  weakSelf.season.isAllWatched = NO;
                                  for (Episode *ep in weakSelf.season.episodesArray) {
                                      if (ep.isReleased) {
                                          ep.isWatched = NO;
                                      }
                                  }
                                  [weakSelf reloadData];
                                  if (weakSelf.refreshTableViewBlock) {
                                      weakSelf.refreshTableViewBlock();
                                  }
                                  weakSelf.checkButton.hidden = NO;
                                  weakSelf.checkButtonImageView.hidden = NO;
                                  weakSelf.checkButtonAIView.hidden = YES;
                                  [weakSelf.checkButtonAIView stopAnimating];
                              }
                              failure:^(NSError *error) {
                                  NSLog(@"[ShowDetailsTVEpHeaderView]%@", error);
                                  weakSelf.checkButton.hidden = NO;
                                  weakSelf.checkButtonImageView.hidden = NO;
                                  weakSelf.checkButtonAIView.hidden = YES;
                                  [weakSelf.checkButtonAIView stopAnimating];
                              }];
}

- (void)reloadData {
    ShowDetailsTVEpHeaderView __weak *weakSelf = self;
    [UIView animateWithDuration:0.5
                     animations:^{
                         if (weakSelf.season.isAllWatched) {
                             [weakSelf.checkButtonImageView setImage:[UIImage imageNamed:@"EpisodeCheckButtonBlue"]];
                         } else {
                             [weakSelf.checkButtonImageView setImage:[UIImage imageNamed:@"EpisodeCheckButtonGray"]];
                         }
                     }];
    if (self.season.isAllWatched) {
        [self.checkButton removeTarget:self
                                action:@selector(markAllAsWatched)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.checkButton addTarget:self
                             action:@selector(unMarkAllAsWatched)
                   forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.checkButton removeTarget:self
                                action:@selector(unMarkAllAsWatched)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.checkButton addTarget:self
                             action:@selector(markAllAsWatched)
                   forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
