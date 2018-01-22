//
//  ListTableViewController.m
//  RACDemo
//
//  Created by idol on 2018/1/22.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "ListTableViewController.h"
#import "BookListViewModel.h"
#import "ListTableViewCell.h"

@interface ListTableViewController ()

@property (strong, nonatomic) BookListViewModel *viewModel;

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.viewModel = [[BookListViewModel alloc] init];
    
    RACSignal *requestsignal = [self.viewModel.requestCommand execute:nil];
    
    
    [requestsignal subscribeNext:^(NSArray *models) {
        [self.tableView reloadData];
    }];
    
    [requestsignal subscribeError:^(NSError *error) {
        NSLog(@"出错 : %@",error);
    }];
    
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableViewCell" forIndexPath:indexPath];
    
    BookModelSub *model = self.viewModel.models[indexPath.row];
    
    cell.model = model;
    
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%190/255.0 green:arc4random()%190/255.0 blue:arc4random()%190/255.0 alpha:1];
    
//    cell.rac_prepareForReuseSignal        //用于即将复用时的清理工作

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


@end
