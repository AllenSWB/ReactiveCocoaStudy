//
//  UserInfoViewModel.m
//  RACDemo
//
//  Created by sun on 2018/1/21.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "UserInfoViewModel.h"

@implementation UserInfoViewModel

- (instancetype)initWithModel:(UserModel *)model {
    self = [super init];
    if (self) {
        if (model) {
            self.model = model;
        } else {
            self.model = [[UserModel alloc] init];
        }
        [self setupCommand];
    }
    return self;
}
- (void)setupCommand {
    self.saveCommand = [[RACCommand alloc] initWithEnabled:[self infoChangeSignal] signalBlock:^RACSignal *(id input) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    
            //request api
//            success
            [subscriber sendNext:@"success"];
            [subscriber sendCompleted];
            
//            failure
//            [subscriber sendError:nil];
            return [RACDisposable disposableWithBlock:^{}];
            
        }];
        
    }];
}

- (RACSignal *)infoChangeSignal {
   
    RACSignal *racsignal = [RACSignal combineLatest:@[RACObserve(self.model, sex), RACObserve(self.model, nickName)] reduce:^id(NSNumber *sexNumber, NSString *name){
        return @(name.length > 0 || sexNumber.integerValue != 1);//比对原值
    }];
    
    return racsignal;
}

@end
