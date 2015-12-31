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
    
    [self prepareAnimationWithTransitionContext:transitionContext];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.inView.frame];
    
    if(!self.colorForBackgroundView) {
        self.colorForBackgroundView = [UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1];
    }
    backgroundView.backgroundColor = self.colorForBackgroundView;
    
    
    [self.inView insertSubview:backgroundView atIndex:0];

    [backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.inView addConstraints:[self constraintsForBackgroundView:backgroundView]];
    
    
    self.fromView.alpha = 1;
    self.toView.alpha = 0;
    
    [self.inView insertSubview:self.fromView aboveSubview:backgroundView];
    [self.inView insertSubview:self.toView belowSubview:self.fromView];
    
    self.toView.alpha = 0;
    
    CGAffineTransform scale = CGAffineTransformMakeScale(1.7, 1.7);
    
    
    self.toView.transform = scale;
    
    if (self.takeAlongController) {
        [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]/2.0 delay:0 options:
     UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        
        self.fromView.transform = scale;
        self.fromView.alpha = 0;
        
    } completion:^(BOOL finished) {
    }];

    
    self.transitioningContext = transitionContext;
    [self animateTakeAlongViews];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]/2.0 delay:[self transitionDuration:transitionContext]/2.0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        self.toView.alpha = 1;
        self.toView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        if ([transitionContext transitionWasCancelled]) {
            [self takeAlongTransitionCancelled];
            
            self.toView.transform = CGAffineTransformIdentity;
            [self.toView removeFromSuperview];
            self.fromView.transform = CGAffineTransformIdentity;
            [backgroundView removeFromSuperview];
            
            self.interactive = NO;
            
            [transitionContext completeTransition:NO];
        }
        else {
            [self removeAndCleanUptakeAlongViews];
            self.toView.transform = CGAffineTransformIdentity;
            self.toView.alpha = 1;
//            [fromView removeFromSuperview];
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
