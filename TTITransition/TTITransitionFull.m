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
		UIView *intermediateView = [toView snapshotViewAfterScreenUpdates:YES];
        [inView addSubview:intermediateView];
		intermediateView.frame = CGRectMake(self.fromPoint.x, self.fromPoint.y, 0, 0);
		intermediateView.layer.opacity = 0.3f;
		
		[UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
			fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
			toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
			
			intermediateView.frame = toView.frame;
			intermediateView.layer.opacity = 1.0f;
		}completion:^(BOOL finished) {
			[intermediateView removeFromSuperview];
			
			[inView addSubview:toView];
			[fromView removeFromSuperview];
			[transitionContext completeTransition:YES];
        }];
		
	}
	else {
        UIView *intermediateView = [fromView snapshotViewAfterScreenUpdates:YES];

        [inView addSubview:toView];
		[inView addSubview:intermediateView];
//        [fromView removeFromSuperview];
        fromView.alpha = 0;
		
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:6 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
			intermediateView.frame = CGRectMake(self.fromPoint.x, self.fromPoint.y, 0, 0);
			intermediateView.layer.opacity = 0.3f;
			
			fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
			toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
		}completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                fromView.alpha = 1;
                [intermediateView removeFromSuperview];
                [transitionContext completeTransition:NO];
            }
            else {
                [intermediateView  removeFromSuperview];
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
	return 0.5f;
}
@end
