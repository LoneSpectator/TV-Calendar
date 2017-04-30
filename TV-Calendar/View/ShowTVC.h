//
//  ShowTVC.h
//  TV-Calendar
//
//  Created by GaoMing on 16/5/16.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Show;

@interface ShowTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enNameLayoutConstraint;
@property (weak, nonatomic) IBOutlet UILabel *enNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteButtonImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *favouriteButtonAIView;

@property (nonatomic) Show *show;

+ (ShowTVC *)cell;
- (void)updateWithShow:(Show *)show;

@end
