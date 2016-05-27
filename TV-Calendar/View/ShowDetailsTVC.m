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
    return cell;
}

- (void)updateWithShow:(Show *)show {
    self.show = show;
    [self.showImageView setImageWithURL:[NSURL URLWithString:show.imageURL]
                       placeholderImage:nil];
    self.showNameLabel.text = show.name;
    self.airingTimeLabel.text = show.airingTime;
    self.sLabel.text = [NSString stringWithFormat:@"%ld", (long)show.lastEp.numOfSeason];
    self.eLabel.text = [NSString stringWithFormat:@"%ld", (long)show.lastEp.numOfEpisode];
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
    } else {
        [self.favouriteButtonImageView setImage:[UIImage imageNamed:@""]];
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
