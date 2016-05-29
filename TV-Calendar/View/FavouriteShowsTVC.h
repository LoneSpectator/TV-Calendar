//
//  FavouriteShowsTVC.h
//  TV-Calendar
//
//  Created by GaoMing on 16/5/29.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Show;

@interface FavouriteShowsTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *showNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentOfWatchedLabel;
@property (weak, nonatomic) IBOutlet UIView *percentOfWatchedBackgroungColorView;

+ (FavouriteShowsTVC *)cell;
- (void)updateWithShow:(Show *)show;

@end
