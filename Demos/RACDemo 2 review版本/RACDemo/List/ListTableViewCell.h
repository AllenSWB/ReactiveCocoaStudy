//
//  ListTableViewCell.h
//  RACDemo
//
//  Created by idol on 2018/1/22.
//  Copyright © 2018年 idol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

//@class BookModel;//谁用谁导入

@interface ListTableViewCell : UITableViewCell

@property (strong, nonatomic) BookModelSub *model;

@end
