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

@property (weak, nonatomic) IBOutlet UIImageView *verticalImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;

+ (ShowTVC *)cell;
- (void)updateWithShow:(Show *)show;

@end
