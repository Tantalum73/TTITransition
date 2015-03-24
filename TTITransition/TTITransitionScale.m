//
//  TTITransitionScale.m
//  TTITransition
//
//  Created by Andreas Neusüß on 06.12.14.
//  Copyright (c) 2014 Andreas Neusüß. All rights reserved.
//

#import "TTITransitionScale.h"

@implementation TTITransitionScale


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *inView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:inView.frame];
    
    if(!self.colorForBackgroundView) {
        self.colorForBackgroundView = [UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1];
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
    fromView.alpha = 1;
    toView.alpha = 0;
    [inView insertSubview:toView aboveSubview:backgroundView];
    
    
    CGAffineTransform scale = CGAffineTransformMakeScale(1.5, 1.5);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]/2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        fromView.transform = scale;
        fromView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    
    toView.transform = scale;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]/2 delay:[self transitionDuration:transitionContext]/2 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        toView.alpha = 1;
        toView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            toView.transform = CGAffineTransformIdentity;
            [toView removeFromSuperview];
            fromView.transform = CGAffineTransformIdentity;
            [backgroundView removeFromSuperview];
            
            self.interactive = NO;
            
            [transitionContext completeTransition:NO];
        }
        else {
            toView.transform = CGAffineTransformIdentity;
            [fromView removeFromSuperview];
            [backgroundView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }

    }];
    
    
//    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    opacity.fromValue = [NSNumber numberWithFloat:1.0];
//    opacity.fromValue = [NSNumber numberWithFloat:0.5];
//    
//    opacity.fillMode = kCAFillModeForwards;
////    opacity.additive = YES;
//    opacity.removedOnCompletion = NO;
//    
//    
    //    rotation.duration = 1;
//    opacity.repeatCount = 3;
    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext]/2 animations:^{
//        fromView.alpha = 0;
//    }];
//    
//    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scale.fromValue = [NSNumber numberWithDouble:0.5];
//    scale.toValue = [NSNumber numberWithDouble:4];
//    scale.additive = YES;
//    scale.duration = [self transitionDuration:transitionContext]/2;
//    
//    
//    [CATransaction begin];
//    [CATransaction setCompletionBlock:^{
//        [fromView removeFromSuperview];
//        
//        scale.fromValue = [NSNumber numberWithInt:4];
//        scale.toValue = [NSNumber numberWithInt:0.5];
//        //        scale.additive = YES;
//        
//        [inView addSubview:toView];
//        
//        [CATransaction begin];
//        
//        toView.alpha = 0;
//        [UIView animateWithDuration:[self transitionDuration:transitionContext]/2 animations:^{
//            toView.alpha = 1;
//        }];
//        
//        [CATransaction setCompletionBlock:^{
//            [transitionContext completeTransition:YES];
//        }];
//        [toView.layer addAnimation:scale forKey:@"scale"];
//    }];
//    [fromView.layer addAnimation:scale forKey:@"scale"];
//    [CATransaction commit];
    
}


-(void)animationEnded:(BOOL)transitionCompleted {
    
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8f;
}


@end
