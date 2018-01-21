//
//  SignInService.m
//  ReactiveCocoaDemo
//
//  Created by idol on 2018/1/16.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "SignInService.h"

@implementation SignInService



+ (void)signInWithPhone:(NSString *)phone passwd:(NSString *)passwd completeBlock:(void(^)(BOOL success))complete {
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([phone isEqualToString:@"13611148921"] && [passwd isEqualToString:@"123456"]) {
            complete(YES);
        } else {
            complete(NO);
        }
        
    });
    
}

@end
