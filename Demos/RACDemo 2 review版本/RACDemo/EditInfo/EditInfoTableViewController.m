//
//  EditInfoTableViewController.m
//  RACDemo
//
//  Created by sun on 2018/1/21.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "EditInfoTableViewController.h"

@interface EditInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) UIBarButtonItem *saveBtn;

@property (strong, nonatomic) UserInfoViewModel *viewModel;

@property (strong, nonatomic) UserModel *userModel;

@end

@implementation EditInfoTableViewController
- (instancetype)init {
  self = [super init];
  if (self) {
    [self setupViews];
  }
  return self;
}

//10. ui
- (void)setupViews{
  // ui
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:nil];
    self.navigationItem.rightBarButtonItem = self.saveBtn;
    
    self.tableView.tableFooterView = [UIView new];
    
    
    self.viewModel = [[UserInfoViewModel alloc] initWithModel:self.userModel];
    
    RAC(self.viewModel.model, nickName) = self.nameTextField.rac_textSignal;
    
    @weakify(self);
    
    [[self.maleButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);

        self.viewModel.model.sex = 1;
    }];
    
    [[self.femaleButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);

        self.viewModel.model.sex = 2;
    }];
    
    RAC(self, userModel) = RACObserve(self.viewModel, model);
  
  //12. selected
    [RACObserve(self.viewModel.model, sex) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        
        if (x.integerValue == 1) {
            [self.maleButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
            [self.femaleButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        } else {
            [self.femaleButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
            [self.maleButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        }
    }];
    
    self.saveBtn.rac_command = self.viewModel.saveCommand;
  //12.
  //self.saveBtn.rac_command.executionSignals.switchToLatest
  
    [self.saveBtn.rac_command.executionSignals subscribeNext:^(RACSignal *blockSignal) {
        @strongify(self);

        [blockSignal subscribeNext:^(RACSignal *x) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
    [self.saveBtn.rac_command.errors subscribeNext:^(id x) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        [SVProgressHUD dismissWithDelay:1];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}


- (void)dealloc {
    NSLog(@"edit vc dealloc");
}


@end
