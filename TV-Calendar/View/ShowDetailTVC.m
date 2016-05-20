//
//  ShowDetailTVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/17.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "ShowDetailTVC.h"

@implementation ShowDetailTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (ShowDetailTVC *)cell {
    ShowDetailTVC *cell = (ShowDetailTVC *)[[NSBundle mainBundle] loadNibNamed:@"ShowDetailTVC"
                                                                         owner:nil
                                                                       options:nil].firstObject;
    
    cell.introductionLable.text = @"";
    
    return cell;
}

@end
