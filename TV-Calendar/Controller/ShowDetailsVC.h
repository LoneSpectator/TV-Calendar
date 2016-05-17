//
//  ShowDetailsVC.h
//  TV-Calendar
//
//  Created by GaoMing on 16/5/14.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowDetailsVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

+ (ShowDetailsVC *)viewControllerWithShowID:(NSInteger)showID;

@end
