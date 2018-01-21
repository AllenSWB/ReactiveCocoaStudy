//
//  MRCViewControllerAnimatedTransition.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 15/12/8.
//  Copyright © 2015年 leichunfeng. All rights reserved.
//

#import "MRCViewControllerAnimatedTransition.h"

@interface MRCViewControllerAnimatedTransition ()

@property (nonatomic, assign, readwrite) UINavigationControllerOperation operation;
@property (nonatomic, weak, readwrite) MRCViewController *fromViewController;
@property (nonatomic, weak, readwrite) MRCViewController *toViewController;

@end

@implementation MRCViewControllerAnimatedTransition

- (instancetype)initWithNavigationControllerOperation:(UINavigationControllerOperation)operation
                                   fromViewController:(MRCViewController *)fromViewController
                                     toViewController:(MRCViewController *)toViewController {
    self = [super init];
    if (self) {
        self.operation = operation;
        self.fromViewController = fromViewController;
        self.toViewController = toViewController;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    MRCViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MRCViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    if (self.operation == UINavigationControllerOperationPush) { // push
        [[transitionContext containerView] addSubview:fromViewController.snapshot];
        fromViewController.view.hidden = YES;
        
        CGRect frame = [transitionContext finalFrameForViewController:toViewController];
        toViewController.view.frame = CGRectOffset(frame, CGRectGetWidth(frame), 0);
        [[transitionContext containerView] addSubview:toViewController.view];

        [UIView animateWithDuration:duration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             fromViewController.snapshot.alpha = 0.0;
                             fromViewController.snapshot.frame = CGRectInset(fromViewController.view.frame, 20, 20);
                             toViewController.view.frame = CGRectOffset(toViewController.view.frame, -CGRectGetWidth(toViewController.view.frame), 0);
                         }
                         completion:^(BOOL finished) {
                             fromViewController.view.hidden = NO;
                             [fromViewController.snapshot removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    } else if (self.operation == UINavigationControllerOperationPop) { // pop
        MRCSharedAppDelegate.window.backgroundColor = [UIColor blackColor];
        
        [fromViewController.view addSubview:fromViewController.snapshot];
        
        BOOL tabBarHidden = fromViewController.tabBarController.tabBar.hidden;
        
        fromViewController.navigationController.navigationBar.hidden = YES;
        fromViewController.tabBarController.tabBar.hidden = YES;
        
        toViewController.snapshot.alpha = 0.5;
        toViewController.snapshot.transform = CGAffineTransformMakeScale(0.95, 0.95);
        
        UIView *toViewWrapperView = [[UIView alloc] initWithFrame:[transitionContext containerView].bounds];
        [toViewWrapperView addSubview:toViewController.view];
        
        toViewWrapperView.hidden = YES;
        
        [[transitionContext containerView] addSubview:toViewWrapperView];
        [[transitionContext containerView] addSubview:toViewController.snapshot];
        [[transitionContext containerView] bringSubviewToFront:fromViewController.view];
        
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fromViewController.view.frame = CGRectOffset(fromViewController.view.frame, CGRectGetWidth(fromViewController.view.frame), 0);
                             toViewController.snapshot.alpha = 1.0;
                             toViewController.snapshot.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             MRCSharedAppDelegate.window.backgroundColor = [UIColor whiteColor];
                             
                             toViewController.navigationController.navigationBar.hidden = NO;
                             toViewController.tabBarController.tabBar.hidden = tabBarHidden;
                             
                             [fromViewController.snapshot removeFromSuperview];
                             [toViewController.snapshot removeFromSuperview];
                             
                             [toViewWrapperView removeFromSuperview];
                             
                             if (![transitionContext transitionWasCancelled]) {
                                 for (UIView *subview in toViewWrapperView.subviews) {
                                     [[transitionContext containerView] addSubview:subview];
                                 }
                             }
                             
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
}

@end
