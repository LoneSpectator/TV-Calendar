//
//  ShowTVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/16.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "ShowTVC.h"
#import "Show.h"
#import "UIKit+AFNetworking.h"
#import "SettingsManager.h"
#import "User.h"

@implementation ShowTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.favouriteButtonAIView.hidden = YES;
    self.enNameLayoutConstraint.constant = (SettingsManager.defaultManager.defaultLanguage == zh_CN) ? 25.0 : 0.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (ShowTVC *)cell {
    ShowTVC *cell = (ShowTVC *)[[NSBundle mainBundle] loadNibNamed:@"ShowTVC"
                                                             owner:nil
                                                           options:nil].firstObject;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)updateWithShow:(Show *)show {
    self.show = show;
    if (SettingsManager.defaultManager.defaultLanguage == zh_CN) {
        self.nameLabel.text = show.chName;
        self.enNameLabel.text = show.enName;
    } else {
        self.nameLabel.text = show.enName;
    }
    self.nameLabel.text = (SettingsManager.defaultManager.defaultLanguage == zh_CN) ? show.chName : show.enName;
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
        [self.favouriteButtonImageView setImage:[UIImage imageNamed:@"ShowFavouriteButtonGray"]];
    }
}

- (void)favouriteButtonTouchUpInside {
    self.favouriteButton.hidden = YES;
    self.favouriteButtonImageView.hidden = YES;
    self.favouriteButtonAIView.hidden = NO;
    [self.favouriteButtonAIView startAnimating];
    
    ShowTVC __weak *weakSelf = self;
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
