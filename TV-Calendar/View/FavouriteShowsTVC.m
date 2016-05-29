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

@implementation FavouriteShowsTVC

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (FavouriteShowsTVC *)cell {
    FavouriteShowsTVC *cell = (FavouriteShowsTVC *)[[NSBundle mainBundle] loadNibNamed:@"FavouriteShowsTVC"
                                                                                 owner:nil
                                                                               options:nil].firstObject;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)updateWithShow:(Show *)show {
    [self.showImageView setImageWithURL:[NSURL URLWithString:show.imageURL]
                       placeholderImage:nil];
    self.showNameLabel.text = show.name;
    self.percentOfWatchedLabel.text = [NSString stringWithFormat:@"已看过 %.1f%%", show.percentOfWatched];
    if (show.percentOfWatched >= 0.99) {
        self.percentOfWatchedBackgroungColorView.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1.0];
    } else if (show.percentOfWatched >= 0.8) {
        self.percentOfWatchedBackgroungColorView.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1.0];
    } else if (show.percentOfWatched >= 0.6) {
        self.percentOfWatchedBackgroungColorView.backgroundColor = [UIColor colorWithRed:94.0/255.0 green:178.0/255.0 blue:191.0/255.0 alpha:1.0];
    } else if (show.percentOfWatched >= 0.4) {
        self.percentOfWatchedBackgroungColorView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:178.0/255.0 blue:15.0/255.0 alpha:1.0];
    } else if (show.percentOfWatched >= 0.2) {
        self.percentOfWatchedBackgroungColorView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:86.0/255.0 blue:31.0/255.0 alpha:1.0];
    } else {
        self.percentOfWatchedBackgroungColorView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
}

@end
