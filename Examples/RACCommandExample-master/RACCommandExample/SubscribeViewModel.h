//
//  Created by Ole Gammelgaard Poulsen on 05/12/13.
//  Copyright (c) 2012 SHAPE A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SubscribeViewModel : NSObject

@property(nonatomic, strong) RACCommand *subscribeCommand;

// write to this property
@property(nonatomic, strong) NSString *email;

// read from this property
@property(nonatomic, strong) NSString *statusMessage;

@end