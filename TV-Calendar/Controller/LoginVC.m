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
#import "LocalizedString.h"

@interface LoginVC () <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswdTextField;
@property (weak, nonatomic) IBOutlet UIImageView *confirmPasswdImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *changeStateButton;
@property (weak, nonatomic) IBOutlet UILabel *errorMesssgeLabel;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *AIView;

@property (nonatomic) LoginVCState state;

@end

@implementation LoginVC

+ (void)showLoginViewControllerWithSender:(UIViewController *)sender {
    LoginVC *vc = (LoginVC *)[[NSBundle mainBundle] loadNibNamed:@"LoginVC"
                                                           owner:nil
                                                         options:nil].firstObject;
    [sender showDetailViewController:vc sender:sender];
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
    self.AIView.alpha = 0;
    self.overlayView.alpha = 0;
    
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
                             
                             [weakSelf.changeStateButton setTitle:LocalizedString(@"没有账号？马上注册！")
                                                         forState:UIControlStateNormal];
                             [weakSelf.cancelButton setTitle:LocalizedString(@"取消")
                                                    forState:UIControlStateNormal];
                             [weakSelf.loginButton setTitle:LocalizedString(@"登陆")
                                                   forState:UIControlStateNormal];
                             [weakSelf.loginButton removeTarget:self
                                                         action:@selector(registration)
                                               forControlEvents:UIControlEventTouchUpInside];
                             [weakSelf.loginButton addTarget:self
                                                      action:@selector(login)
                                            forControlEvents:UIControlEventTouchUpInside];
                             
                         } else {
                             weakSelf.confirmPasswdTextField.alpha = 1;
                             weakSelf.confirmPasswdImageView.alpha = 1;
                             
                             [weakSelf.changeStateButton setTitle:LocalizedString(@"已有账号？马上登陆！")
                                                         forState:UIControlStateNormal];
                             [weakSelf.cancelButton setTitle:LocalizedString(@"取消")
                                                    forState:UIControlStateNormal];
                             [weakSelf.loginButton setTitle:LocalizedString(@"注册")
                                                   forState:UIControlStateNormal];
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
    [self startWaiting];
    LoginVC __weak *weakSelf = self;
    [User loginWithPhone:self.phoneTextField.text
                password:self.passwdTextField.text
                 success:^{
                     [weakSelf endWaiting];
                     [weakSelf dismissViewControllerAnimated:YES completion:nil];
                 }
                 failure:^(NSError *error) {
                     [weakSelf endWaiting];
                     if (error) {
                         if (error.domain == [NetworkManager defaultManager].webSite) {
                             weakSelf.errorMesssgeLabel.text = error.userInfo[NSLocalizedDescriptionKey];
                         } else {
                             UIAlertController *ac = [UIAlertController alertControllerWithTitle:LocalizedString(@"登陆失败，请重新登陆！")
                                                                                         message:nil
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                             [ac addAction:[UIAlertAction actionWithTitle:LocalizedString(@"好的")
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil]];
                             [weakSelf presentViewController:ac
                                                    animated:YES
                                                  completion:nil];
                         }
                         NSLog(@"[LoginVC]%@", error);
                     }
                 }];
}

- (void)registration {
    if (![self.passwdTextField.text isEqualToString:self.confirmPasswdTextField.text]) {
        self.errorMesssgeLabel.text = LocalizedString(@"两次输入密码不一致，请检查后重试！");
        return;
    }
    
    [self startWaiting];
    LoginVC __weak *weakSelf = self;
    [User registerWithPhone:self.phoneTextField.text
                   userName:self.phoneTextField.text
                   password:self.passwdTextField.text
                    success:^{
                        [weakSelf endWaiting];
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                    failure:^(NSError *error) {
                        [weakSelf endWaiting];
                        if (error.domain == [NetworkManager defaultManager].webSite) {
                            weakSelf.errorMesssgeLabel.text = error.userInfo[NSLocalizedDescriptionKey];
                        } else {
                            UIAlertController *ac = [UIAlertController alertControllerWithTitle:LocalizedString(@"注册失败，请重新注册！")
                                                                                        message:nil
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                            [ac addAction:[UIAlertAction actionWithTitle:@"好的"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil]];
                            [weakSelf presentViewController:ac
                                                   animated:YES
                                                 completion:nil];
                        }
                        NSLog(@"[LoginVC]%@", error);
                    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissKeyBoard {
    [self.phoneTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
    [self.confirmPasswdTextField resignFirstResponder];
}

- (void)startWaiting {
    [self.AIView startAnimating];
    LoginVC __weak *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.overlayView.alpha = 0.66;
        weakSelf.AIView.alpha = 1;
    }];
}

- (void)endWaiting {
    [self.AIView stopAnimating];
    LoginVC __weak *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.AIView.alpha = 0;
        weakSelf.overlayView.alpha = 0;
    }];
}

@end
