//
//  SignInService.h
//  ReactiveCocoaDemo
//
//  Created by idol on 2018/1/16.
//  Copyright © 2018年 idol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface SignInService : NSObject

+ (void)signInWithPhone:(NSString *)phone passwd:(NSString *)passwd completeBlock:(void(^)(BOOL success))complete;

@end
