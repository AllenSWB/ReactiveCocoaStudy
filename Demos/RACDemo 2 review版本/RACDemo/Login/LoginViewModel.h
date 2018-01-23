//
//  LoginViewModel.h
//  RACDemo
//
//  Created by idol on 2018/1/18.
//  Copyright © 2018年 idol. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface LoginViewModel : RVMViewModel

//3. readonly
@property (strong, nonatomic) RACCommand *loginCommand;

//1. copy
//2. model
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *password;

@end
