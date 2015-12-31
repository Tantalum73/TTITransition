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
    
    [self prepareAnimationWithTransitionContext:transitionContext];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
	if(self.open) {
        		//toView.frame = CGRectMake(self.fromPoint.x, self.fromPoint.y, fromView.frame.size.width-20, fromView.frame.size.height-40);
        if(self.fromView) {
            self.toView.frame = CGRectMake(self.fromView.frame.origin.x+10, self.fromView.frame.origin.y+20, self.fromView.frame.size.width-20, self.fromView.frame.size.height-40);
            
        }
        else {
            self.toView.frame = CGRectMake(screenRect.origin.x+10, screenRect.origin.y+20, screenRect.size.width-20, screenRect.size.height-40);
        }
        self.toView.layer.opacity = 1.0f;
        
        
        [self.inView insertSubview:self.toView atIndex:0];
        [self.inView insertSubview:self.fromView atIndex:0];
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
        }
        [self.toView removeFromSuperview];

        UIGraphicsBeginImageContextWithOptions(self.fromView.frame.size, NO, self.fromView.window.screen.scale);
        [self.fromView drawViewHierarchyInRect:self.fromView.frame afterScreenUpdates:YES];
        UIImage *fromShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        
        UIImage *blurredFrom = [fromShot applyStandardBlurForTourTime];
        _blurredBackgroundView = [[UIImageView alloc] initWithImage:blurredFrom];
        _blurredBackgroundView.layer.opacity = 0.0f;
        
        [self.inView insertSubview:_blurredBackgroundView belowSubview:self.toView];

        [_blurredBackgroundView setTranslatesAutoresizingMaskIntoConstraints:false];
        [self.inView addConstraints:[super constraintsForBackgroundView:_blurredBackgroundView]];
        
        
        [self.inView layoutIfNeeded];
        
 
         UIView *toShot = [self.toView snapshotViewAfterScreenUpdates:YES];

        toShot.frame = CGRectMake(self.fromPoint.x-150/2, self.fromPoint.y, 150, 150);

        [self applyShadowEffectToView:toShot];
        [self applyBorderToView:toShot];
        [self applyShadowEffectToView:self.toView];
        [self applyBorderToView:self.toView];
        toShot.layer.opacity = 0.4;
        
        [self.inView addSubview:toShot];

        
        [UIView animateWithDuration:([self transitionDuration:transitionContext]/5)*4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            if(self.fromView) {
                toShot.frame = CGRectMake(self.fromView.frame.origin.x+10, self.fromView.frame.origin.y+20, self.fromView.frame.size.width-20, self.fromView.frame.size.height-40);
                
            }
            else {
                toShot.frame = CGRectMake(screenRect.origin.x+10, screenRect.origin.y+20, screenRect.size.width-20, screenRect.size.height-40);
            }

            [self changeTakeAlongViews];
            
                        toShot.layer.opacity = 1.0f;
            
            			self.fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            			self.toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
            
            
            _blurredBackgroundView.layer.opacity = 1.0f;
            
            
            		}completion:^(BOOL finished) {
                        [self removeAndCleanUptakeAlongViews];
                        
                        [self.inView addSubview:self.toView];
                        [toShot removeFromSuperview];
                        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            		}];

	}
	else {
		self.fromView.frame = [transitionContext initialFrameForViewController:self.fromVC];
		self.toView.frame = [transitionContext finalFrameForViewController:self.toVC];

		[self.inView insertSubview:self.toView belowSubview:_blurredBackgroundView];
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
        }
        
        CGAffineTransform scale = CGAffineTransformMakeScale(0.5, 0.5);
        CGAffineTransform translation = CGAffineTransformMakeTranslation((self.toPoint.x < self.fromView.center.x)?
                                                                         -fabs(self.toPoint.x - self.fromView.center.x) : fabs(self.toPoint.x - self.fromView.center.x)
                                                                         
                                                                         ,(self.toPoint.y < self.fromView.center.y)?
                                                                         -fabs(self.toPoint.y - self.fromView.center.y) : fabs(self.toPoint.y - self.fromView.center.y));
 
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:4 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            
            [self changeTakeAlongViews];
            
            self.fromView.transform = CGAffineTransformConcat(scale, translation);;
            self.fromView.alpha = 0;
            
			_blurredBackgroundView.alpha = 0.0f;
            
//			fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
			self.toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
            
		}completion:^(BOOL finished) {
                        
            if ([transitionContext transitionWasCancelled]) {
                [self takeAlongTransitionCancelled];
                self.fromView.alpha = 1;
                self.fromView.transform = CGAffineTransformIdentity;
                [self.toView removeFromSuperview];
            
                self.fromView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
                self.interactive = NO;
                
                [transitionContext completeTransition:NO];
            }
            else {
                [self removeAndCleanUptakeAlongViews];
                [self.fromView removeFromSuperview];
                [_blurredBackgroundView removeFromSuperview];
                
                [self.inView addSubview:self.toView];
                self.toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
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

@end
