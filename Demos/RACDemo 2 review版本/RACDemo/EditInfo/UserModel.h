//
//  UserModel.h
//  RACDemo
//
//  Created by sun on 2018/1/21.
//  Copyright © 2018年 idol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (strong, nonatomic) NSString *nickName;

//11. 枚举
@property (assign, nonatomic) NSUInteger sex;//1男 2女   default 1男


@end
