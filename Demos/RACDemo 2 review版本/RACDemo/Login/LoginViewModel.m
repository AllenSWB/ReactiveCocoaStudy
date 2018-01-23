//
//  LoginViewModel.m
//  RACDemo
//
//  Created by idol on 2018/1/18.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpLoginCommand];
    }
    return self;
}

- (void)setUpLoginCommand {
    
    self.loginCommand = [[RACCommand alloc] initWithEnabled:[self isParametersValid] signalBlock:^RACSignal *(id input) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //4. weak
            if ([self.phone isEqualToString:@"13611148921"] && [self.password isEqualToString:@"123456"]) {
                [subscriber sendNext:@"13611148921用户登录成功"];
                [subscriber sendCompleted];
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"XXXXX" code:0 userInfo:@{NSLocalizedDescriptionKey:@"账号or密码错误"}];
                [subscriber sendError:error];
            }
            
            });
            
            return [RACDisposable disposableWithBlock:^{ }];
            
        }];
        
    }];
    
}
- (RACSignal *)isParametersValid {
    
    return [RACSignal combineLatest:@[RACObserve(self, phone), RACObserve(self, password)] reduce:^id (NSString *phone, NSString *passwd){
        return @(phone.length == 11 && passwd.length > 5 && passwd.length < 13);
    }];
    
}


@end
