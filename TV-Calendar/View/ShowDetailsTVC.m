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
    cell.statusNameLabel.text = LocalizedString(@"状态");
    cell.lastEpNamelabel.text = LocalizedString(@"播出进度");
    cell.nextEpTimeNameLabel.text = LocalizedString(@"下集时间");
    cell.areaNameLabel.text = LocalizedString(@"地区");
    cell.channelNameLabel.text = LocalizedString(@"电视台");
    cell.lengthNameLabel.text = LocalizedString(@"长度");
    [cell showLessIntroduction:NULL];
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
    self.statusLabel.text = show.status;
    if (show.seNumOfLastEp < 10) {
        self.sLabel.text = [NSString stringWithFormat:@"0%ld", (long)show.seNumOfLastEp];
    } else {
        self.sLabel.text = [NSString stringWithFormat:@"%ld", (long)show.seNumOfLastEp];
    }
    if (show.epNumOfLastEp < 10) {
        self.eLabel.text = [NSString stringWithFormat:@"0%ld", (long)show.epNumOfLastEp];
    } else {
        self.eLabel.text = [NSString stringWithFormat:@"%ld", (long)show.epNumOfLastEp];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    self.nextEpTimeLabel.text = [dateFormatter stringFromDate:show.nextEpTime];
    self.areaLabel.text = show.area;
    self.channelLabel.text = show.channel;
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
        [self.favouriteButtonImageView setImage:[UIImage imageNamed:@"ShowFavouriteButtonRed"]];
    } else {
        [self.favouriteButtonImageView setImage:[UIImage imageNamed:@"ShowFavouriteButtonWhite"]];
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

- (void)showMoreIntroduction:(UIButton *)sender {
    self.introductionLable.numberOfLines = 0;
    [self.introductionLable sizeToFit];
    [self.fullIntroductionButton setTitle:LocalizedString(@"收起▲") forState:UIControlStateNormal];
    [self.fullIntroductionButton removeTarget:self
                                       action:@selector(showMoreIntroduction:)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.fullIntroductionButton addTarget:self
                                    action:@selector(showLessIntroduction:)
                          forControlEvents:UIControlEventTouchUpInside];
    if (self.refreshTableViewBlock) {
        self.refreshTableViewBlock();
    }
}

- (void)showLessIntroduction:(UIButton *)sender {
    self.introductionLable.numberOfLines = 8;
    [self.introductionLable sizeToFit];
    [self.fullIntroductionButton setTitle:LocalizedString(@"展开▼") forState:UIControlStateNormal];
    [self.fullIntroductionButton removeTarget:self
                                       action:@selector(showLessIntroduction:)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.fullIntroductionButton addTarget:self
                                    action:@selector(showMoreIntroduction:)
                          forControlEvents:UIControlEventTouchUpInside];
    if (self.refreshTableViewBlock) {
        self.refreshTableViewBlock();
    }
}

@end
