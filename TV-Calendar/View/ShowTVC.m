//
//  ShowTVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/16.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "ShowTVC.h"
#import "Show.h"
#import "UIKit+AFNetworking.h"
#import "SettingsManager.h"

@implementation ShowTVC

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (ShowTVC *)cell {
    ShowTVC *cell = (ShowTVC *)[[NSBundle mainBundle] loadNibNamed:@"ShowTVC"
                                                             owner:nil
                                                           options:nil].firstObject;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)updateWithShow:(Show *)show {
    [self.verticalImageView setImageWithURL:[NSURL URLWithString:show.verticalImageURL]
                           placeholderImage:nil];
    self.nameLabel.text = (SettingsManager.defaultManager.defaultLanguage == zh_CN) ? show.chName : show.enName;
    self.statusLabel.text = [NSString stringWithFormat:@"状态：%@", show.status];
    self.areaLabel.text = [NSString stringWithFormat:@"区域：%@", show.area];
    self.channelLabel.text = [NSString stringWithFormat:@"出品：%@", show.channel];
}

@end
