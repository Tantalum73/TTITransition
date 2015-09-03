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
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation TTIFallIn {
    /// Snapshot of the presenting ViewController, can be blurred or darkened.
    UIView *_backgroundView;
}


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIView *inView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    self.context = transitionContext;
    
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
    self.transitionContext = transitionContext;
    self.animator.delegate = self;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:inView];
    
    
    
    if(self.open) {
//        fromView.frame = [transitionContext finalFrameForViewController:fromVC];
        
        [inView insertSubview:fromView atIndex:0];
        
        if ([UIVisualEffectView class]) {
            UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _backgroundView = [[UIVisualEffectView alloc] initWithEffect:blur];
            _backgroundView.backgroundColor = [UIColor clearColor];
            _backgroundView.layer.opacity = 0;
            [_backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [inView insertSubview:_backgroundView atIndex:0];
            
            [inView addConstraints:[self constraintsForBackgroundView:_backgroundView]];
        }
//        _backgroundView = [fromView snapshotViewAfterScreenUpdates:YES];
//        _backgroundView.frame = fromView.frame;
//        [inView insertSubview:_backgroundView atIndex:0];
        

        
        
        [self applyShadowEffectToView:toView];
        
        
        [inView addSubview:toView];
        
        [toView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [inView addConstraints:[self constraintsForPresentedView:toView inView:inView widthProportion:self.widthProportionOfSuperView heightProportion:self.heightProportionOfSuperView]];
        
        [inView layoutIfNeeded];
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContest:transitionContext];
        }
        
        CGSize sizeOfToViewController = toView.frame.size;
        
        toView.center = CGPointMake(inView.center.x, inView.frame.origin.y - sizeOfToViewController.height);
        
        toView.layer.zPosition = sizeOfToViewController.height / 1.7;//must be grater than sizeOfToViewController.height / 2
        CATransform3D rotation =CATransform3DMakeRotation(M_PI/2.7, 1.0, 0, 0);
        rotation.m34 = -1.0/500.0;
        toView.layer.transform = rotation;
        CGPoint newCenter = inView.center;//_backgroundView.center;
        
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1.5 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent animations:^{
            
            
            [self changeTakeAlongViews];
            
            toView.layer.transform = CATransform3DIdentity;
            toView.transform = CGAffineTransformIdentity;
            
            toView.layer.position = newCenter;
            _backgroundView.layer.opacity = 1;
            
            
        } completion:^(BOOL finished) {
            toView.layer.transform = CATransform3DIdentity;
            toView.layer.anchorPoint = CGPointMake(0.5, 0.5);
//            toView.layer.position = newCenter;// inView.layer.position;
            
            [self removeAndCleanUptakeAlongViews];
            [transitionContext completeTransition:YES];
            
        }];
    }
    else {
        [inView insertSubview:toView atIndex:0];
        [inView addSubview:fromView];
//        fromView.alpha = 1;
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContest:transitionContext];
        }
         [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            
             fromView.transform = CGAffineTransformMakeTranslation(0, -inView.bounds.size.height / 2 - fromView.frame.size.height / 2);
//             fromView.center = CGPointMake(self.toPoint.x, self.toPoint.y);//CGPointMake(self.toPoint.x, self.toPoint.y - fromView.frame.size.height / 1.5 );
            
            _backgroundView.alpha =0;
             
             [self changeTakeAlongViews];
             
        } completion:^(BOOL finished) {
            [self removeAndCleanUptakeAlongViews];
            
            if ([transitionContext transitionWasCancelled]) {
                fromView.layer.transform = CATransform3DIdentity;
                
                [transitionContext completeTransition:NO];
            }
            else {
                [fromView removeFromSuperview];
                fromView.layer.transform = CATransform3DIdentity;
                
                [_backgroundView removeFromSuperview];
                
                [transitionContext finishInteractiveTransition];
                [transitionContext completeTransition:YES];
                
                
                //resets the frame of the presenting ViewController
                toView.frame = inView.frame;
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
