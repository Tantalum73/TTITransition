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
    UIView *inView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
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
	if(self.open) {
//		UIView *intermediateView = [toView snapshotViewAfterScreenUpdates:YES];
//        [inView addSubview:intermediateView];
//		intermediateView.frame = CGRectMake(self.fromPoint.x, self.fromPoint.y, 0, 0);
//		intermediateView.layer.opacity = 0.3f;
        
        toView.alpha = 0;
        
        [inView addSubview:toView];
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
        }
        
        CGAffineTransform scale = CGAffineTransformMakeScale(0.1, 0.1);
        CGAffineTransform translation = CGAffineTransformMakeTranslation(fabs(self.fromPoint.x - toView.center.x), fabs(self.fromPoint.y - toView.center.y));
        toView.transform = CGAffineTransformConcat(scale, translation);
        
        
		[UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
			fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
			toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
            
            toView.transform = CGAffineTransformIdentity;
            toView.alpha = 1;
            
            [self changeTakeAlongViews];
            
//			intermediateView.frame = toView.frame;
//			intermediateView.layer.opacity = 1.0f;
        }completion:^(BOOL finished) {
            [fromView removeFromSuperview];
            [self removeAndCleanUptakeAlongViews];
            
            [transitionContext completeTransition:YES];
            
        }];
		
	}
    else {
        [inView insertSubview:toView atIndex:0];
        toView.alpha = 1;
        [inView addSubview:fromView];
        
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
        }

        
        CGAffineTransform scale = CGAffineTransformMakeScale(0.3, 0.3);
        CGAffineTransform translation = CGAffineTransformMakeTranslation(fabs(self.toPoint.x - fromView.center.x),fabs(self.toPoint.y - fromView.center.y));
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:10 initialSpringVelocity:1 options:UIViewAnimationOptionAllowAnimatedContent | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{

            
            fromView.transform = CGAffineTransformConcat(scale, translation);
            fromView.alpha = 0;
            
//            fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
            
            [self changeTakeAlongViews];
            
        }completion:^(BOOL finished) {
            [self removeAndCleanUptakeAlongViews];
            
            if ([transitionContext transitionWasCancelled]) {
                fromView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
                fromView.transform = CGAffineTransformIdentity;
                [toView removeFromSuperview];
                
                self.interactive = NO;
                [transitionContext completeTransition:NO];
            }
            else {
                
                [fromView removeFromSuperview];
                [inView addSubview:toView];
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
