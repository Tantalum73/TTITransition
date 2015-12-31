//
//  TTITransition.m
//  TravelTime
//
//  Created by Andreas Neusüß on 31.07.13.
//  Copyright (c) 2013 Andreas Neusüß. All rights reserved.
//

#import "TTITransitionFull.h"

@implementation TTITransitionFull


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    [self prepareAnimationWithTransitionContext:transitionContext];
    
    if(self.open) {
//		UIView *intermediateView = [toView snapshotViewAfterScreenUpdates:YES];
//        [inView addSubview:intermediateView];
//		intermediateView.frame = CGRectMake(self.fromPoint.x, self.fromPoint.y, 0, 0);
//		intermediateView.layer.opacity = 0.3f;
        
        self.toView.alpha = 0;
        
        [self.inView addSubview:self.toView];
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
        }
        
        CGAffineTransform scale = CGAffineTransformMakeScale(0.1, 0.1);
        CGAffineTransform translation = CGAffineTransformMakeTranslation(fabs(self.fromPoint.x - self.toView.center.x), fabs(self.fromPoint.y - self.toView.center.y));
        self.toView.transform = CGAffineTransformConcat(scale, translation);
        
        
		[UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
			self.fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
			self.toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
            
            self.toView.transform = CGAffineTransformIdentity;
            self.toView.alpha = 1;
            
            [self changeTakeAlongViews];
            
//			intermediateView.frame = toView.frame;
//			intermediateView.layer.opacity = 1.0f;
        }completion:^(BOOL finished) {
            [self.fromView removeFromSuperview];
            [self removeAndCleanUptakeAlongViews];
            
            [transitionContext completeTransition:YES];
            
        }];
		
	}
    else {
        [self.inView insertSubview:self.toView atIndex:0];
        self.toView.alpha = 1;
        [self.inView addSubview:self.fromView];
        
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
        }

        
        CGAffineTransform scale = CGAffineTransformMakeScale(0.3, 0.3);
        CGAffineTransform translation = CGAffineTransformMakeTranslation(fabs(self.toPoint.x - self.fromView.center.x),fabs(self.toPoint.y - self.fromView.center.y));
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:10 initialSpringVelocity:1 options:UIViewAnimationOptionAllowAnimatedContent | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{

            
            self.fromView.transform = CGAffineTransformConcat(scale, translation);
            self.fromView.alpha = 0;
            
//            fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            self.toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
            
            [self changeTakeAlongViews];
            
        }completion:^(BOOL finished) {
            
            if ([transitionContext transitionWasCancelled]) {
                [self takeAlongTransitionCancelled];
                
                self.fromView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
                self.fromView.transform = CGAffineTransformIdentity;
                [self.toView removeFromSuperview];
                
                self.interactive = NO;
                [transitionContext completeTransition:NO];
            }
            else {
                
                [self removeAndCleanUptakeAlongViews];
                [self.fromView removeFromSuperview];
                [self.inView addSubview:self.toView];
                [transitionContext completeTransition:YES];
            }
            
            
        }];
        
    }
	
}


-(void)animationEnded:(BOOL)transitionCompleted {
	
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
//    if (self.takeAlongController) {
//        return 1.5;
//    }
//    else {
//        return 0.5f;
//    }
    return 0.5f;
}
@end
