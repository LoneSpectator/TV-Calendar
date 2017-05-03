//
//  TopShowTVC.h
//  TV-Calendar
//
//  Created by GaoMing on 2017/5/3.
//  Copyright © 2017年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Show;

@interface TopShowTVC : UITableViewCell

@property (nonatomic) Show *show;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *showNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIView *placeBackgroundView;

+ (TopShowTVC *)cell;
- (void)updateWithShow:(Show *)show place:(NSInteger)place;

@end
