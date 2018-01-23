//
//  UserInfoViewModel.h
//  RACDemo
//
//  Created by sun on 2018/1/21.
//  Copyright © 2018年 idol. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "UserModel.h"

@interface UserInfoViewModel : RVMViewModel

@property (strong, nonatomic) RACCommand *saveCommand;

@property (strong, nonatomic) UserModel *model;

- (instancetype)initWithModel:(UserModel *)model;

@end
