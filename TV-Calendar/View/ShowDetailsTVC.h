//
//  ShowDetailsTVC.h
//  TV-Calendar
//
//  Created by GaoMing on 16/5/17.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Show;

@interface ShowDetailsTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *showNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *airingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sLabel;
@property (weak, nonatomic) IBOutlet UILabel *eLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLable;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteButtonImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *favouriteButtonAIView;

@property (nonatomic) Show *show;

+ (ShowDetailsTVC *)cell;
- (void)updateWithShow:(Show *)show;

@end
