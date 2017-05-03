//
//  TopShowTVC.m
//  TV-Calendar
//
//  Created by GaoMing on 2017/5/3.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import "TopShowTVC.h"
#import "NetworkManager.h"
#import "UIKit+AFNetworking.h"
#import "Show.h"
#import "SettingsManager.h"

@implementation TopShowTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.placeBackgroundView.layer.masksToBounds = YES;
    self.placeBackgroundView.layer.cornerRadius = 12.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (TopShowTVC *)cell {
    TopShowTVC *cell = (TopShowTVC *)[[NSBundle mainBundle] loadNibNamed:@"TopShowTVC"
                                                                   owner:nil
                                                                 options:nil].firstObject;
    return cell;
}

- (void)updateWithShow:(Show *)show place:(NSInteger)place {
    self.show = show;
    [self.showImageView setImageWithURL:[NSURL URLWithString:show.imageURL]
                       placeholderImage:nil];
    if (SettingsManager.defaultManager.defaultLanguage == zh_CN) {
        self.showNameLabel.text = show.chName;
    } else {
        self.showNameLabel.text = show.enName;
    }
    self.placeLabel.text = [NSString stringWithFormat:@"%ld", (long)place];
    if (place == 1) {
        self.placeBackgroundView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:149.0/255.0 blue:0.0/255.0 alpha:1.0];
    } else {
        self.placeBackgroundView.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:173.0/255.0 blue:248.0/255.0 alpha:1.0];
    }
}

@end
