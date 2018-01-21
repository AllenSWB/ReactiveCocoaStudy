//
//  AppDelegate.m
//  RACCommandExample
//
//  Created by Ole Gammelgaard Poulsen on 05/12/13.
//  Copyright (c) 2013 SHAPE. All rights reserved.
//

#import "AppDelegate.h"
#import "SubscribeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	SubscribeViewController *subscribeViewController = [SubscribeViewController new];
	UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:subscribeViewController];
	self.window.rootViewController = mainNavigationController;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end