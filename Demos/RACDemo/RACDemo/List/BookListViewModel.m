//
//  BookListViewModel.m
//  RACDemo
//
//  Created by idol on 2018/1/22.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "BookListViewModel.h"

@implementation BookListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupCommand];
    }
    return self;
}

- (void)setupCommand {
    
    
    self.requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":@"ios"} progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
                BookModel *model = [BookModel yy_modelWithJSON:responseObject];
                self.models = model.books;
                [subscriber sendNext:model.books];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendError:error];
            }];
            
            return [RACDisposable disposableWithBlock:^{
            }];
        }];
    }];
    
}

@end
