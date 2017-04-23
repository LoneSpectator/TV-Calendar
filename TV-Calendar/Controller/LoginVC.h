//
//  LoginVC.h
//  TV-Calendar
//
//  Created by GaoMing on 16/5/6.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController

typedef enum{
    Login,
    Registration,
} LoginVCState;

+ (void)showLoginViewControllerWithSender:(UIViewController *)sender;

@end
