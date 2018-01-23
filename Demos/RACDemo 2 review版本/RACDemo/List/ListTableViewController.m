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
  
  
//  [self.viewModel.requestCommand.executionSignals subscribeNext:^(id x) {
//
//  }];
  
  //9. 选这个 不用下个
    [requestsignal subscribeNext:^(NSArray *models) {
        [self.tableView reloadData];
    }];
  
//    [RACObserve(self.viewModel, models) subscribeNext:^(id x) {
//        [self.tableView reloadData];
//    }];
  
//  RACEvent
  
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

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


@end
