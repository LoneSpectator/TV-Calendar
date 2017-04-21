//
//  ShowDetailsTVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/17.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "ShowDetailsTVC.h"
#import "Show.h"
#import "Episode.h"
#import "User.h"
#import "NetworkManager.h"
#import "UIKit+AFNetworking.h"
#import "SettingsManager.h"
#import "LocalizedString.h"

@implementation ShowDetailsTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (ShowDetailsTVC *)cell {
    ShowDetailsTVC *cell = (ShowDetailsTVC *)[[NSBundle mainBundle] loadNibNamed:@"ShowDetailsTVC"
                                                                         owner:nil
                                                                       options:nil].firstObject;
    cell.favouriteButtonAIView.hidden = YES;
    cell.enNameLayoutConstraint.constant = (SettingsManager.defaultManager.defaultLanguage == zh_CN) ? 25.0 : 0.0;
    [cell layoutIfNeeded];
    return cell;
}

- (void)updateWithShow:(Show *)show {
    self.show = show;
    [self.showImageView setImageWithURL:[NSURL URLWithString:show.imageURL]
                       placeholderImage:nil];
    if (SettingsManager.defaultManager.defaultLanguage == zh_CN) {
        self.showNameLabel.text = show.chName;
        self.enNameLabel.text = show.enName;
    } else {
        self.showNameLabel.text = show.enName;
    }
    self.statusNameLabel.text = LocalizedString(@"状态");
    self.statusLabel.text = show.status;
    self.lastEpNamelabel.text = LocalizedString(@"播出进度");
    if (show.lastEp.numOfSeason < 10) {
        self.sLabel.text = [NSString stringWithFormat:@"0%ld", (long)show.lastEp.numOfSeason];
    } else {
        self.sLabel.text = [NSString stringWithFormat:@"%ld", (long)show.lastEp.numOfSeason];
    }
    if (show.lastEp.numOfEpisode < 10) {
        self.eLabel.text = [NSString stringWithFormat:@"0%ld", (long)show.lastEp.numOfEpisode];
    } else {
        self.eLabel.text = [NSString stringWithFormat:@"%ld", (long)show.lastEp.numOfEpisode];
    }
    self.airingTimeNameLabel.text = LocalizedString(@"下集时间");
    self.airingTimeLabel.text = show.airingTime;
    self.areaNameLabel.text = LocalizedString(@"地区");
    self.areaLabel.text = show.area;
    self.channelNameLabel.text = LocalizedString(@"电视台");
    self.channelLabel.text = show.channel;
    self.lengthNameLabel.text = LocalizedString(@"长度");
    self.lengthLabel.text = show.length;
    self.introductionLable.text = show.introduction;
    if (!currentUser) {
        self.favouriteButtonAIView.hidden = YES;
        self.favouriteButton.hidden = YES;
        self.favouriteButtonImageView.hidden = YES;
    } else {
        [self.favouriteButton addTarget:self
                                 action:@selector(favouriteButtonTouchUpInside)
                       forControlEvents:UIControlEventTouchUpInside];
        [self reloadData];
    }
}

- (void)reloadData {
    if (self.show.isFavorite) {
#warning 少图片
        [self.favouriteButtonImageView setImage:[UIImage imageNamed:@""]];
        [self.favouriteButton setTitle:@"已订阅" forState:UIControlStateNormal];
    } else {
        [self.favouriteButtonImageView setImage:[UIImage imageNamed:@""]];
        [self.favouriteButton setTitle:@"订阅" forState:UIControlStateNormal];
    }
}

- (void)favouriteButtonTouchUpInside {
    self.favouriteButton.hidden = YES;
    self.favouriteButtonImageView.hidden = YES;
    self.favouriteButtonAIView.hidden = NO;
    [self.favouriteButtonAIView startAnimating];
    
    ShowDetailsTVC __weak *weakSelf = self;
    if (self.show.isFavorite) {
        [Show removeFromFavouritesWithID:self.show.showID
                                 success:^{
                                     weakSelf.show.isFavorite = NO;
                                     [weakSelf reloadData];
                                     weakSelf.favouriteButton.hidden = NO;
                                     weakSelf.favouriteButtonImageView.hidden = NO;
                                     weakSelf.favouriteButtonAIView.hidden = YES;
                                     [weakSelf.favouriteButtonAIView stopAnimating];
                                 }
                                 failure:^(NSError *error) {
                                     NSLog(@"[ShowDetailsTVC]%@", error);
                                     weakSelf.favouriteButton.hidden = NO;
                                     weakSelf.favouriteButtonImageView.hidden = NO;
                                     weakSelf.favouriteButtonAIView.hidden = YES;
                                     [weakSelf.favouriteButtonAIView stopAnimating];
                                 }];
    } else {
        [Show addToFavouritesWithID:self.show.showID
                            success:^{
                                weakSelf.show.isFavorite = YES;
                                [weakSelf reloadData];
                                weakSelf.favouriteButton.hidden = NO;
                                weakSelf.favouriteButtonImageView.hidden = NO;
                                weakSelf.favouriteButtonAIView.hidden = YES;
                                [weakSelf.favouriteButtonAIView stopAnimating];
                            }
                            failure:^(NSError *error) {
                                NSLog(@"[ShowDetailsTVC]%@", error);
                                weakSelf.favouriteButton.hidden = NO;
                                weakSelf.favouriteButtonImageView.hidden = NO;
                                weakSelf.favouriteButtonAIView.hidden = YES;
                                [weakSelf.favouriteButtonAIView stopAnimating];
                            }];
    }
}

@end
