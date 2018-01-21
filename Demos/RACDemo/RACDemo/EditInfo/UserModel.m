//
//  UserModel.m
//  RACDemo
//
//  Created by sun on 2018/1/21.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sex = 1;
        self.nickName = @"";
    }
    return self;
}

@end
