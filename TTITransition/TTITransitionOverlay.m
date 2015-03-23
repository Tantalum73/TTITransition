//
//  TTITransition.m
//  TravelTime
//
//  Created by Andreas Neusüß on 31.07.13.
//  Copyright (c) 2013 Andreas Neusüß. All rights reserved.
//

#import "TTITransitionOverlay.h"
#import "UIImage+ImageEffects.h"

@interface TTITransitionOverlay ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation TTITransitionOverlay {
    UIImageView *_blurredBackgroundView;
}

-(instancetype)init {
    return self = [super init];
}
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
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
	if(self.open) {
        		//toView.frame = CGRectMake(self.fromPoint.x, self.fromPoint.y, fromView.frame.size.width-20, fromView.frame.size.height-40);
        if(fromView) {
            toView.frame = CGRectMake(fromView.frame.origin.x+10, fromView.frame.origin.y+20, fromView.frame.size.width-20, fromView.frame.size.height-40);
            
        }
        else {
            toView.frame = CGRectMake(screenRect.origin.x+10, screenRect.origin.y+20, screenRect.size.width-20, screenRect.size.height-40);
        }
        toView.layer.opacity = 1.0f;
        
        

        UIGraphicsBeginImageContextWithOptions(fromView.frame.size, NO, fromView.window.screen.scale);
        [fromView drawViewHierarchyInRect:fromView.frame afterScreenUpdates:NO];
        UIImage *fromShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();


        UIImage *blurredFrom = [fromShot applyStandardBlurForTourTime];
        _blurredBackgroundView = [[UIImageView alloc] initWithImage:blurredFrom];
        _blurredBackgroundView.layer.opacity = 0.0f;
        
        [inView insertSubview:_blurredBackgroundView belowSubview:toView];


         UIView *toShot = [toView snapshotViewAfterScreenUpdates:YES];

        toShot.frame = CGRectMake(self.fromPoint.x-150/2, self.fromPoint.y, 150, 150);

        [self applyShadowEffectToView:toShot];
        [self applyBorderToView:toShot];
        [self applyShadowEffectToView:toView];
        [self applyBorderToView:toView];
        toShot.layer.opacity = 0.4;
        
        [inView addSubview:toShot];

        
        [UIView animateWithDuration:([self transitionDuration:transitionContext]/5)*4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            
            if(fromView) {
                toShot.frame = CGRectMake(fromView.frame.origin.x+10, fromView.frame.origin.y+20, fromView.frame.size.width-20, fromView.frame.size.height-40);
                
            }
            else {
                toShot.frame = CGRectMake(screenRect.origin.x+10, screenRect.origin.y+20, screenRect.size.width-20, screenRect.size.height-40);
            }

            
                        toShot.layer.opacity = 1.0f;
            
            			fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            			toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
            
            
            _blurredBackgroundView.layer.opacity = 1.0f;
            
            
            		}completion:^(BOOL finished) {

                        [inView addSubview:toView];
                        [toShot removeFromSuperview];
                        
                        self.interactiveAnimator = TTIPercentDrivenInteractionTransitionController.new;
                        
                        
                        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            

            		}];

	}
	else {
        //state: toShot:removed, toView: added, _blurredBackgroundView: added
        
        
		fromView.frame = [transitionContext initialFrameForViewController:fromVC];
		toView.frame = [transitionContext finalFrameForViewController:toVC];

		UIView *fromShot = [fromView snapshotViewAfterScreenUpdates:NO];
		fromShot.frame = fromView.frame;
        [self applyShadowEffectToView:fromShot];
		
        [inView addSubview:fromShot];
//		[fromView removeFromSuperview];
        fromView.alpha = 0;
		
//		UIGraphicsBeginImageContextWithOptions(toView.frame.size, NO, toView.window.screen.scale);
//		[toView drawViewHierarchyInRect:toView.frame afterScreenUpdates:YES];
//		UIImage *toShot = UIGraphicsGetImageFromCurrentImageContext();
//		UIGraphicsEndImageContext();
//		
//		UIImage *blurredTo = [toShot applyStandardBlurForTourTime];
//		UIImageView *blurredToView = [[UIImageView alloc] initWithImage:blurredTo];
//		blurredToView.layer.opacity = 1.0f;
//		
//		[inView insertSubview:blurredToView belowSubview:fromShot];
        
		[inView insertSubview:toView belowSubview:_blurredBackgroundView];
		
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:6 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
			fromShot.frame = CGRectMake(self.fromPoint.x, self.fromPoint.y, 0, 0);
			fromShot.layer.opacity = 0.3f;
			_blurredBackgroundView.layer.opacity = 0.0f;
			
//			toView.layer.opacity = 1.0f;
			

			fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
			toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
            
		}completion:^(BOOL finished) {
                        
            if ([transitionContext transitionWasCancelled]) {
                
                [fromShot removeFromSuperview];
                
                fromView.alpha = 1;
            
//                [_blurredBackgroundView removeFromSuperview];
                fromView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
                
                [transitionContext completeTransition:NO];
            }
            else {
                [fromShot removeFromSuperview];
                [fromView removeFromSuperview];
                [_blurredBackgroundView removeFromSuperview];
                
                [inView addSubview:toView];
                toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
                self.interactiveAnimator = nil;
                
                [transitionContext completeTransition:YES];
            }
			
		}];
	}

}

-(void)animationEnded:(BOOL)transitionCompleted {
	
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return (self.open) ? 0.6f : 0.5f;
}
-(void)applyBorderToView:(UIView *)view {
    view.layer.borderWidth = 4.0f;
    view.layer.borderColor = [UIColor lightTextColor].CGColor;
    
    
}
-(void)applyShadowEffectToView:(UIView *)view {
    view.layer.shadowRadius = 4.0f;
    view.layer.shadowOpacity = 0.6f;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(3, 3);
}
@end
