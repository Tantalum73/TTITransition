//
//  TTITransitionSpinn.m
//  TTITransition
//
//  Created by Andreas Neusüß on 30.11.14.
//  Copyright (c) 2014 Andreas Neusüß. All rights reserved.
//

#import "TTITransitionSpinn.h"
#import "TTITransitioningDelegate.h"

@implementation TTITransitionSpinn

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *inView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:inView.frame];
    
    if(!self.colorForBackgroundView) {
        self.colorForBackgroundView = [UIColor lightGrayColor];
    }
    backgroundView.backgroundColor = self.colorForBackgroundView;
    
    [inView insertSubview:backgroundView atIndex:0];

    
    UIView *toView;
    UIView *fromView;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    }
    else {
        toView = [toVC view];
        fromView = [fromVC view];
    }

    [inView addSubview:fromView];
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.fromValue = [NSNumber numberWithDouble:0];
    rotation.fromValue = [NSNumber numberWithDouble:M_PI*1.5];
    
    rotation.fillMode = kCAFillModeForwards;
    rotation.additive = YES;
    
    //    rotation.duration = 1;
    rotation.repeatCount = 3;
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = [NSNumber numberWithInt:0.5];
    scale.toValue = [NSNumber numberWithInt:-1];
    scale.additive = YES;
    
    CAAnimationGroup *fromViewAnimationGroup = [CAAnimationGroup animation];
    fromViewAnimationGroup.duration = [self transitionDuration:transitionContext]/2;
    fromViewAnimationGroup.animations = @[rotation, scale];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        NSLog(@"Complete");
        [fromView removeFromSuperview];
        
        scale.fromValue = [NSNumber numberWithInt:-1];
        scale.toValue = [NSNumber numberWithInt:0.5];
        //        scale.additive = YES;
        
        [inView addSubview:toView];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            NSLog(@"Complete done");
            [transitionContext completeTransition:YES];
        }];
        [toView.layer addAnimation:fromViewAnimationGroup forKey:@"animationGrooup"];
    }];
    [fromView.layer addAnimation:fromViewAnimationGroup forKey:@"animationGroup"];
    [CATransaction commit];
    
}


-(void)animationEnded:(BOOL)transitionCompleted {
    
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8f;
}

@end
