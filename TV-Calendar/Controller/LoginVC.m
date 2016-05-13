//
//  LoginVC.m
//  TV-Calendar
//
//  Created by GaoMing on 16/5/6.
//  Copyright © 2016年 ifLab. All rights reserved.
//

#import "LoginVC.h"
#import "User.h"
#import "NetworkManager.h"

@interface LoginVC () <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswdTextField;
@property (weak, nonatomic) IBOutlet UIImageView *confirmPasswdImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *changeStateButton;
@property (weak, nonatomic) IBOutlet UILabel *errorMesssgeLabel;

@property (nonatomic) LoginVCState state;

@end

@implementation LoginVC

+ (LoginVC *)viewController {
    LoginVC *vc = (LoginVC *)[[NSBundle mainBundle] loadNibNamed:@"LoginVC"
                                                           owner:nil
                                                         options:nil].firstObject;
    return vc;
}

- (LoginVCState)state {
    if (!_state) {
        _state = Login;
    }
    return _state;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.masksToBounds = YES;
    
    self.phoneTextField.delegate = self;
    self.passwdTextField.delegate = self;
    self.confirmPasswdTextField.delegate = self;
    
    void (^addTopView)(UIView *) = ^(UIView *view) {
        UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
        UIBarButtonItem *flexBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
        UIBarButtonItem *dismissKeyBoardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(dismissKeyBoard)];
        topView.backgroundColor = [UIColor whiteColor];
        NSArray *buttonsArray = @[flexBtn, dismissKeyBoardButton];
        if (view.class == [UITextField class]) {
            ((UITextField *)view).inputAccessoryView = topView;
            topView.items = buttonsArray;
        }
        if (view.class == [UITextView class]) {
            ((UITextView *)view).inputAccessoryView = topView;
            topView.items = buttonsArray;
        }
    };
    addTopView(self.phoneTextField);
    addTopView(self.passwdTextField);
    addTopView(self.confirmPasswdTextField);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.changeStateButton addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)changeState {
    self.state = (self.state == Login) ? Registration : Login;
    
    LoginVC __weak *weakSelf = self;
    [UIView animateWithDuration:0.7
                          delay:0.f
         usingSpringWithDamping:1.f
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         if (weakSelf.state == Login) {
                             weakSelf.confirmPasswdTextField.alpha = 0;
                             weakSelf.confirmPasswdImageView.alpha = 0;
                             
                             [weakSelf.changeStateButton setTitle:@"没有账号？马上注册！" forState:UIControlStateNormal];
                             [weakSelf.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                             [weakSelf.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
                             [weakSelf.loginButton removeTarget:self
                                                         action:@selector(registration)
                                               forControlEvents:UIControlEventTouchUpInside];
                             [weakSelf.loginButton addTarget:self
                                                      action:@selector(login)
                                            forControlEvents:UIControlEventTouchUpInside];
                             
                         } else {
                             weakSelf.confirmPasswdTextField.alpha = 1;
                             weakSelf.confirmPasswdImageView.alpha = 1;
                             
                             [weakSelf.changeStateButton setTitle:@"已有账号？马上登陆！" forState:UIControlStateNormal];
                             [weakSelf.cancelButton setTitle:@" 取消 " forState:UIControlStateNormal];
                             [weakSelf.loginButton setTitle:@"注册" forState:UIControlStateNormal];
                             [weakSelf.loginButton removeTarget:self
                                                         action:@selector(login)
                                               forControlEvents:UIControlEventTouchUpInside];
                             [weakSelf.loginButton addTarget:self
                                                      action:@selector(registration)
                                            forControlEvents:UIControlEventTouchUpInside];
                         }
                     }
                     completion:nil];
}

- (void)login {
    LoginVC __weak *weakSelf = self;
    [User loginWithPhone:self.phoneTextField.text
                password:self.passwdTextField.text
                 success:^{
                     [weakSelf dismissViewControllerAnimated:YES completion:nil];
                 } failure:^(NSError *error) {
                     if (error) {
                         NSString *errorMsg = nil;
                         if (error.domain == [NetworkManager defaultManager].webSite) {
                             errorMsg = error.userInfo[NSLocalizedDescriptionKey];
                         }
                         weakSelf.errorMesssgeLabel.text = errorMsg;
                         UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"登陆失败，请重新登陆！"
                                                                          message:errorMsg
                                                                         delegate:nil
                                                                cancelButtonTitle:@"好的"
                                                                otherButtonTitles:nil];
                         [alertV show];
                         NSLog(@"[LoginVC]%@", error);
                     }
                 }];
}

- (void)registration {
    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissKeyBoard {
    [self.phoneTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
    [self.confirmPasswdTextField resignFirstResponder];
}


@end
