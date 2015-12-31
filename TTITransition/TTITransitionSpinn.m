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
    
    [self prepareAnimationWithTransitionContext:transitionContext];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.inView.frame];
    
    if(!self.colorForBackgroundView) {
        self.colorForBackgroundView = [UIColor lightGrayColor];
    }
    backgroundView.backgroundColor = self.colorForBackgroundView;
    

    

    [self.inView addSubview:self.fromView];
    self.fromView.alpha = 1;
    self.toView.alpha = 0;
   // [inView insertSubview:toView aboveSubview:backgroundView];
    [self.inView addSubview:self.toView];
    if (self.takeAlongController) {
        [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
    }
    
    CGFloat angle = M_PI;
    
    CGAffineTransform scale = CGAffineTransformMakeScale(2, 2);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    
    CGAffineTransform concatted = CGAffineTransformConcat(scale, rotation);
    
    self.toView.transform = concatted;//CGAffineTransformConcat(scale, rotation);
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionCalculationModePaced animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:[self transitionDuration:transitionContext] relativeDuration:1 animations:^{
            [self changeTakeAlongViews];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.25 animations:^{
            self.fromView.transform = concatted;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.25 animations:^{
            self.fromView.transform = rotation;
            self.fromView.alpha = 0;
            self.fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            
            self.toView.alpha = 1;
            self.toView.transform = CGAffineTransformIdentity;
        }];
    } completion:^(BOOL finished) {
        
        if ([transitionContext transitionWasCancelled]) {
            [self takeAlongTransitionCancelled];
//            toView.transform = CGAffineTransformIdentity;
            [self.toView removeFromSuperview];
//            fromView.transform = CGAffineTransformIdentity;
            [backgroundView removeFromSuperview];
            
            self.interactive = NO;
            
            [transitionContext completeTransition:NO];
        }
        else {
            [self removeAndCleanUptakeAlongViews];
            self.toView.transform = CGAffineTransformIdentity;
            [self.fromView removeFromSuperview];
            [backgroundView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }

    }];
    
    
//    slightly newer version:
//    [UIView animateWithDuration:[self transitionDuration:transitionContext]/2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        
//        fromView.transform = concatted;
//        fromView.alpha = 0;
//        
//    } completion:^(BOOL finished) {
////        [fromView removeFromSuperview];
//    }];
//    
//    toView.transform = CGAffineTransformConcat(scale, CGAffineTransformMakeRotation(-angle));
//    
//    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext]/2 delay:[self transitionDuration:transitionContext]/2 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        
//        toView.alpha = 1;
//        toView.transform = CGAffineTransformIdentity;
//        
//    } completion:^(BOOL finished) {
//        if ([transitionContext transitionWasCancelled]) {
//            toView.transform = CGAffineTransformIdentity;
//            [toView removeFromSuperview];
//            fromView.transform = CGAffineTransformIdentity;
//            [backgroundView removeFromSuperview];
//            
//            self.interactive = NO;
//            
//            [transitionContext completeTransition:NO];
//        }
//        else {
//            toView.transform = CGAffineTransformIdentity;
//            [fromView removeFromSuperview];
//            [backgroundView removeFromSuperview];
//            [transitionContext completeTransition:YES];
//        }
//        
//    }];
    
    
    //old version:
//    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotation.fromValue = [NSNumber numberWithDouble:0];
//    rotation.fromValue = [NSNumber numberWithDouble:M_PI*1.5];
//    
//    rotation.fillMode = kCAFillModeForwards;
//    rotation.additive = YES;
//    
//    //    rotation.duration = 1;
//    rotation.repeatCount = 3;
//    
//    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scale.fromValue = [NSNumber numberWithDouble:0];
//    scale.toValue = [NSNumber numberWithDouble:-1];
//    scale.additive = YES;
//    
//    CAAnimationGroup *fromViewAnimationGroup = [CAAnimationGroup animation];
//    fromViewAnimationGroup.duration = [self transitionDuration:transitionContext]/2;
//    fromViewAnimationGroup.animations = @[rotation, scale];
//   
//    
//    CAAnimationGroup *secondStep = [CAAnimationGroup animation];
//    
//    
//    [CATransaction setCompletionBlock:^{
//        [fromView removeFromSuperview];
//        
//        scale.fromValue = [NSNumber numberWithDouble:-1];
//        scale.toValue = [NSNumber numberWithDouble:0];
//        //        scale.additive = YES;
//        
//        [inView addSubview:toView];
//        
//        [CATransaction begin];
//        [CATransaction setCompletionBlock:^{
//            [transitionContext completeTransition:YES];
//        }];
//        [toView.layer addAnimation:fromViewAnimationGroup forKey:@"animationGrooup"];
//    }];
//    [fromView.layer addAnimation:fromViewAnimationGroup forKey:@"animationGroup"];
//    [CATransaction commit];
    
}


-(void)animationEnded:(BOOL)transitionCompleted {
    
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

@end
