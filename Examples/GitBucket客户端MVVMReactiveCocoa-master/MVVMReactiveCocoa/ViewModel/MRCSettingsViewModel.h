//
//  MRCSettingsViewModel.h
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 15/3/4.
//  Copyright (c) 2015年 leichunfeng. All rights reserved.
//

#import "MRCTableViewModel.h"

@interface MRCSettingsViewModel : MRCTableViewModel

@property (nonatomic, copy) NSString *adURL;
@property (nonatomic, strong, readonly) RACCommand *logoutCommand;

@end
