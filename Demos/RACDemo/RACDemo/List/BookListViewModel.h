//
//  BookListViewModel.h
//  RACDemo
//
//  Created by idol on 2018/1/22.
//  Copyright © 2018年 idol. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "BookModel.h"

@interface BookListViewModel : RVMViewModel

@property (strong, nonatomic) RACCommand *requestCommand;

@property (strong, nonatomic) NSArray *models;

@end
