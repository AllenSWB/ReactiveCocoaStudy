//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by idol on 2018/1/16.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import "SignInService.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] init];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(0, 400, 100, 100);
    btn.backgroundColor = [UIColor blueColor];
    btn.enabled = NO;
    btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"按钮点击了");//此时按钮
        return [RACSignal empty];
    }];
    
    [[btn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
         NSLog(@"按钮点击了===");//
    }];
    


    RACSignal *isPhoneValidSignal = [_phoneTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([self isPhoneNumberValid:value]);
    }];
    
    RACSignal *isPasswdValidSignal = [_passwdTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([self isPasswdValid:value]);
    }];
    
  
    RACSignal *signiiiSignal = [RACSignal combineLatest:@[isPhoneValidSignal,isPasswdValidSignal] reduce:^id _Nonnull(NSNumber *phoneValid, NSNumber *passwdValid){
        return @(phoneValid.boolValue && passwdValid.boolValue);
    }];
    
    RAC(_loginButton, titleLabel.textColor) = [signiiiSignal map:^id _Nullable(id  _Nullable value) {
        return [(NSNumber *)value boolValue] ? [UIColor blueColor] : [UIColor lightGrayColor];
    }];
    
    
    RAC(_loginButton, enabled) = signiiiSignal;
    
//    [signiiiSignal subscribeNext:^(id  _Nullable x) {
//        _loginButton.enabled = [(NSNumber *)x boolValue];
//    }];

    
    
    [[[[_loginButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] doNext:^(__kindof UIControl * _Nullable x) {
        x.enabled = YES;
    }] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
        return [self signInSignal];
    }] subscribeNext:^(id  _Nullable x) {
        _loginButton.enabled = YES;
        BOOL success = [(NSNumber *)x boolValue];
        
        if (success) {
            NSLog(@"登录成功");
        } else {
            NSLog(@"登录失败");
        }
        
    }];
    
    
    
    ////    KVO
    @weakify(self)
    [RACObserve(self.phoneTextField, text) subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        NSLog(@"phone textField 值改变了 : %@",x); // becomeFirstResponser -> resignFirstResponser 之后会走
    }];
    
    // 冷信号 热信号
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"触发信号");
        [subscriber sendNext:@"hahaha"];
        [subscriber sendCompleted];
        
        return nil;
    }] replay];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅 %@",x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"新的订阅者 %@",x);
    }];
    
    //RACCommand    //这个和 RAC(_loginButton, enabled) = signiiiSignal; 不能共存
//    _loginButton.rac_command = [[RACCommand alloc] initWithEnabled:isPhoneValidSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//         NSLog(@"登录按钮可以点击啦啦啦啦");
//        return [RACSignal empty];
//    }];
    
    
}

- (RACSignal *)signInSignal {
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [SignInService signInWithPhone:self.phoneTextField.text passwd:self.passwdTextField.text completeBlock:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (BOOL)isPhoneNumberValid:(NSString *)phone {
    if (phone.length == 11) {
        return YES;
    }
    return NO;
}

- (BOOL)isPasswdValid:(NSString *)passwd {
    if (passwd.length > 5 && passwd.length < 12) {
        return YES;
    }
    return NO;
}



@end
