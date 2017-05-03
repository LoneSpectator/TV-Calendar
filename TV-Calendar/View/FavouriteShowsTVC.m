//
//  FavouriteShowsTVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/29.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "FavouriteShowsTVC.h"
#import "Show.h"
#import "UIKit+AFNetworking.h"
#import "SettingsManager.h"
#import "LocalizedString.h"

@implementation FavouriteShowsTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (FavouriteShowsTVC *)cell {
    FavouriteShowsTVC *cell = (FavouriteShowsTVC *)[[NSBundle mainBundle] loadNibNamed:@"FavouriteShowsTVC"
                                                                                 owner:nil
                                                                               options:nil].firstObject;
    return cell;
}

- (void)updateWithShow:(Show *)show {
    [self.wideImageURL setImageWithURL:[NSURL URLWithString:show.wideImageURL]
                      placeholderImage:nil];
    self.showNameLabel.text = (SettingsManager.defaultManager.defaultLanguage == zh_CN) ? show.chName : show.enName;
    self.quantityOfWatchedLabel.text = [NSString stringWithFormat:@"%@%ld   %@%ld", LocalizedString(@"总集数"), (long)show.quantityOfEpisode, LocalizedString(@"已看"), show.quantityOfWatchedEpisode];
    self.percentOfWatchedLabel.text = [NSString stringWithFormat:@"%.0f%%", show.percentOfWatched*100];
    [self.watchedProgressView setProgress:show.percentOfWatched animated:NO];
    if (show.percentOfWatched >= 0.99) {
        [self.watchedProgressView setProgressTintColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1.0]];
    } else if (show.percentOfWatched >= 0.8) {
        [self.watchedProgressView setProgressTintColor:[UIColor colorWithRed:153.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1.0]];
    } else if (show.percentOfWatched >= 0.6) {
        [self.watchedProgressView setProgressTintColor:[UIColor colorWithRed:94.0/255.0 green:178.0/255.0 blue:191.0/255.0 alpha:1.0]];
    } else if (show.percentOfWatched >= 0.4) {
        [self.watchedProgressView setProgressTintColor:[UIColor colorWithRed:247.0/255.0 green:178.0/255.0 blue:15.0/255.0 alpha:1.0]];
    } else if (show.percentOfWatched >= 0.2) {
        [self.watchedProgressView setProgressTintColor:[UIColor colorWithRed:233.0/255.0 green:86.0/255.0 blue:31.0/255.0 alpha:1.0]];
    } else {
        [self.watchedProgressView setProgressTintColor:[UIColor colorWithRed:204.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    }
}

@end
