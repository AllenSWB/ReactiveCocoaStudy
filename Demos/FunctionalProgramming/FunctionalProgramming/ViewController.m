//
//  ViewController.m
//  FunctionalProgramming
//
//  Created by idol on 2018/1/16.
//  Copyright © 2018年 idol. All rights reserved.
//

#import "ViewController.h"
#import <RXCollections/RXCollection.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *array = @[@(23), @(32), @(43)];
    
    NSArray *mapArray =  [array rx_mapWithBlock:^id(id each) {
        NSNumber *eachObj = (NSNumber *)each;
        return [NSString stringWithFormat:@"元素%@",eachObj];
    }];
    
    NSLog(@"map result : %@",mapArray);
    
    NSArray *filterArray = [array rx_filterWithBlock:^BOOL(id each) {
        NSNumber *eachObj = (NSNumber *)each;
        return eachObj.integerValue > 31;
    }];
    
     NSLog(@"filter result : %@",filterArray);
    
    
    NSNumber *sum = [array rx_foldWithBlock:^id(id memo, id each) {
       return @([memo integerValue] + [each integerValue]);
    }];
    
     NSLog(@"sum result : %@",sum);
    
    NSArray *strArray = @[@"a", @"b", @"c"];
    
//    NSString *newObj =  [strArray rx_foldWithBlock:^id(id memo, id each) {
//        return [NSString stringWithFormat:@"%@%@",memo,each];
//    }];
    
    NSString *newObj =  [strArray rx_foldInitialValue:@"OO" block:^id(id memo, id each) {
        return [NSString stringWithFormat:@"%@%@",memo,each];
    }];
    
    NSLog(@"fold result is %@", newObj);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
