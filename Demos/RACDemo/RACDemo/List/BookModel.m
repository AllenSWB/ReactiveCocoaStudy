//
//  BookModel.m
//  RACDemo
//
//  Created by idol on 2018/1/22.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"books" : [BookModelSub class]};
}

@end

@implementation BookModelSub


@end
