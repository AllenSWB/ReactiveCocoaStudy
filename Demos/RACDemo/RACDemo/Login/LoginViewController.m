//
//  LoginViewController.m
//  RACDemo
//
//  Created by idol on 2018/1/18.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"

@interface LoginViewController ()
@property (strong, nonatomic) LoginViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[LoginViewModel alloc] init];
    
    RAC(self.viewModel, phone) = self.phoneTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwdTextField.rac_textSignal;
    
    @weakify(self);

    self.loginButton.rac_command = self.viewModel.loginCommand;
    
    
    [self.loginButton.rac_command.enabled subscribeNext:^(NSNumber *x) {
        @strongify(self);
        
        if (x.boolValue) {
            self.loginButton.backgroundColor = [UIColor colorWithRed:90/255.0 green:191/255.0 blue:255/255.0 alpha:1];
        } else {
            self.loginButton.backgroundColor = [UIColor colorWithRed:90/255.0 green:228/255.0 blue:255/255.0 alpha:1];
        }
    }];
    
    [[self.loginButton.rac_command.executionSignals doNext:^(id x) {
        @strongify(self);

        [self.phoneTextField resignFirstResponder];
        [self.passwdTextField resignFirstResponder];
    }] subscribeNext:^(id x) {
        @strongify(self);

        [x subscribeNext:^(id x) {
            if (self.delegateSubject) {
                [self.delegateSubject sendNext:x];
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];

    }];
    
    [self.loginButton.rac_command.errors subscribeNext:^(id x) {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
        [SVProgressHUD dismissWithDelay:1];
    }];
  
}

- (void)dealloc {
    NSLog(@"login vc dealloc");
}


@end
