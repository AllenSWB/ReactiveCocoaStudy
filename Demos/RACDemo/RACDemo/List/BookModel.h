//
//  BookModel.h
//  RACDemo
//
//  Created by idol on 2018/1/22.
//  Copyright © 2018年 idol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject

@property (strong, nonatomic) NSArray *books;

@end

@interface BookModelSub : NSObject

@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSArray *author;

@end
