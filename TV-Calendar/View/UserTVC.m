//
//  UserTVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/1.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "UserTVC.h"

@implementation UserTVC

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (UserTVC *)cell {
    UserTVC *cell = (UserTVC *)[[NSBundle mainBundle] loadNibNamed:@"UserTVC"
                                                             owner:nil
                                                           options:nil].firstObject;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

@end
