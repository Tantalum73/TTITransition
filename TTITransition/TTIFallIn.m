//
//  TTIFallIn.m
//  TTITransition
//
//  Created by Andreas Neusüß on 27.03.15.
//  Copyright (c) 2015 Andreas Neusüß. All rights reserved.
//

#import "TTIFallIn.h"
@interface TTIFallIn () <UIDynamicAnimatorDelegate>
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation TTIFallIn {
    /// Snapshot of the presenting ViewController, can be blurred or darkened.
    UIView *_backgroundView;
}


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    [self prepareAnimationWithTransitionContext:transitionContext];
    self.animator.delegate = self;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.inView];
    
    
    
    if(self.open) {
//        fromView.frame = [transitionContext finalFrameForViewController:fromVC];
        
        [self.inView insertSubview:self.fromView atIndex:0];
        
        if ([UIVisualEffectView class]) {
            UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _backgroundView = [[UIVisualEffectView alloc] initWithEffect:blur];
            _backgroundView.backgroundColor = [UIColor clearColor];
            _backgroundView.layer.opacity = 0;
            [_backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.inView insertSubview:_backgroundView atIndex:0];
            
            [self.inView addConstraints:[self constraintsForBackgroundView:_backgroundView]];
        }
//        _backgroundView = [fromView snapshotViewAfterScreenUpdates:YES];
//        _backgroundView.frame = fromView.frame;
//        [inView insertSubview:_backgroundView atIndex:0];
        

        
        
        [self applyShadowEffectToView:self.toView];
        
        
        [self.inView addSubview:self.toView];
        
        [self.toView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.inView addConstraints:[self constraintsForPresentedView:self.toView inView:self.inView widthProportion:self.widthProportionOfSuperView heightProportion:self.heightProportionOfSuperView]];
        
        [self.inView layoutIfNeeded];
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
        }
        
        CGSize sizeOfToViewController = self.toView.frame.size;
        
        self.toView.center = CGPointMake(self.inView.center.x, self.inView.frame.origin.y - sizeOfToViewController.height);
        
        self.toView.layer.zPosition = sizeOfToViewController.height / 1.7;//must be grater than sizeOfToViewController.height / 2
        CATransform3D rotation =CATransform3DMakeRotation(M_PI/2.7, 1.0, 0, 0);
        rotation.m34 = -1.0/500.0;
        self.toView.layer.transform = rotation;
        CGPoint newCenter = self.inView.center;//_backgroundView.center;
        
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1.5 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent animations:^{
            
            
            [self changeTakeAlongViews];
            
            self.toView.layer.transform = CATransform3DIdentity;
            self.toView.transform = CGAffineTransformIdentity;
            
            self.toView.layer.position = newCenter;
            _backgroundView.layer.opacity = 1;
            
            
        } completion:^(BOOL finished) {
            self.toView.layer.transform = CATransform3DIdentity;
            self.toView.layer.anchorPoint = CGPointMake(0.5, 0.5);
//            toView.layer.position = newCenter;// inView.layer.position;
            
            [self removeAndCleanUptakeAlongViews];
            [transitionContext completeTransition:YES];
            
        }];
    }
    else {
        [self.inView insertSubview:self.toView atIndex:0];
        [self.inView addSubview:self.fromView];
//        fromView.alpha = 1;
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
        }
         [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            
             self.fromView.transform = CGAffineTransformMakeTranslation(0, -self.inView.bounds.size.height / 2 - self.fromView.frame.size.height / 2);
//             fromView.center = CGPointMake(self.toPoint.x, self.toPoint.y);//CGPointMake(self.toPoint.x, self.toPoint.y - fromView.frame.size.height / 1.5 );
            
            _backgroundView.alpha =0;
             
             [self changeTakeAlongViews];
             
        } completion:^(BOOL finished) {
            
            if ([transitionContext transitionWasCancelled]) {
                [self takeAlongTransitionCancelled];
                self.fromView.layer.transform = CATransform3DIdentity;
                
                [transitionContext completeTransition:NO];
            }
            else {
                [self removeAndCleanUptakeAlongViews];
                
                [self.fromView removeFromSuperview];
                self.fromView.layer.transform = CATransform3DIdentity;
                
                [_backgroundView removeFromSuperview];
                
                [transitionContext finishInteractiveTransition];
                [transitionContext completeTransition:YES];
                
                
                //resets the frame of the presenting ViewController
                self.toView.frame = self.inView.frame;
            }
            
            
        }];
    }
    
}

-(NSArray *)constraintsForToView:(UIView *)toView inView:(UIView *)inView {
    
    CGSize size = inView.frame.size;
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:toView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:inView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:toView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:inView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:toView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:size.width];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:toView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:size.height];
    
    return @[centerX, centerY, height, width];
}

-(void)animationEnded:(BOOL)transitionCompleted {
    
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.45;
}



//-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
//    
//    [self.transitionContext completeTransition:YES];
//}

@end
