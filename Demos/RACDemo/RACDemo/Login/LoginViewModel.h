//
//  LoginViewModel.h
//  RACDemo
//
//  Created by idol on 2018/1/18.
//  Copyright © 2018年 idol. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface LoginViewModel : RVMViewModel

@property (strong, nonatomic) RACCommand *loginCommand;

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *password;

@end
