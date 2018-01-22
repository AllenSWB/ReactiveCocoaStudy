//
//  ViewController.m
//  RACDemo
//
//  Created by idol on 2018/1/18.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "EditInfoTableViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UIButton *listButton;

@property (strong, nonatomic) UserModel *user;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[self.button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
//        [self performSegueWithIdentifier:@"toLogin" sender:self];
//    }];
    
    self.editButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self performSegueWithIdentifier:@"toEdit" sender:self];
        return [RACSignal empty];
    }];

    
    [[self.listButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        [self performSegueWithIdentifier:@"toList" sender:self];
    }];
    
//    
//    //createSignal: 返回的是一个RACDynamicSignal对象
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        //do something
//        
//        [subscriber sendNext:@1];//产生新value 通过实现了<RACSubscriber>协议的subscriber 发送出去
//        
//        [subscriber sendCompleted];
//        
//        [subscriber sendError:[NSError errorWithDomain:@"XXX" code:500 userInfo:nil]];
//        
//        return [RACDisposable disposableWithBlock:^{
//            //用于取消订阅后的清理资源工作
//        }];
//    }];
//    
//    
//    [signal subscribeNext:^(id x) {
//       //订阅signal的next事件
//        
//    }];
//    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toLogin"]) {
        LoginViewController *loginVC = (LoginViewController *)(((UINavigationController *)[segue destinationViewController]).topViewController);
        loginVC.delegateSubject = [RACSubject subject];
        [loginVC.delegateSubject subscribeNext:^(id x) {
            self.resultLabel.text = (NSString *)x;
        }];
    }
}


@end
