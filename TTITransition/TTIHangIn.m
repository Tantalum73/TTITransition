//
//  TTIHangIn.m
//  TTITransition
//
//  Created by Andreas Neusüß on 21.11.14.
//  Copyright (c) 2014 Andreas Neusüß. All rights reserved.
//

#import "TTIHangIn.h"

@interface TTIHangIn () <UIDynamicAnimatorDelegate>
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation TTIHangIn {
    /// Snapshot of the presenting ViewController, can be blurred or darkened.
    UIView *_backgroundView;
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
    self.transitionContext = transitionContext;
    self.animator.delegate = self;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:inView];
    
    if(self.open) {
        _backgroundView = [fromView snapshotViewAfterScreenUpdates:YES];

        
        
        [inView addSubview:toView];
        [toView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [inView addConstraints:[self constraintsForPresentedView:toView inView:inView widthProportion:self.widthProportionOfSuperView heightProportion:self.heightProportionOfSuperView]];
        
        [inView layoutIfNeeded];
        
        
        CGSize sizeOfToViewController = toView.frame.size;
        
        toView.center = CGPointMake(toView.center.x, inView.frame.origin.y - sizeOfToViewController.height/2);
        
        
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[toView]];
        [self.animator addBehavior:gravity];

        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:inView];
//        self.animator.delegate = self;

        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:toView snapToPoint:inView.center];
        snap.damping = 0.5;
        
        snap.action = ^{
            if (toView.center.x == inView.center.x && toView.center.y == inView.center.y) {
                [self.animator removeAllBehaviors];
                [transitionContext completeTransition:YES];
                
                [self animateTakeAlongViews];
            }
        };
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContest:transitionContext];
        }
        [self.animator addBehavior:snap];

    }
    else {
//        [inView insertSubview:toView atIndex:0];
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[fromView]];
        gravity.magnitude = 1.5;
        [self.animator addBehavior:gravity];
        
        UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[fromView]];
//        [dynamic addLinearVelocity:CGPointMake(0, 0) forItem:fromView];
        [dynamic addAngularVelocity:1 forItem:fromView];
        [dynamic setAngularResistance:3];
        
        [inView insertSubview:toView atIndex:0];
        
        // when the view no longer intersects with its superview, go ahead and remove it
        
        dynamic.action = ^{
            if (!CGRectIntersectsRect(inView.bounds,fromView.frame)) {
 
                [self.animator removeAllBehaviors];
                
                [_backgroundView removeFromSuperview];
                
                [transitionContext completeTransition:YES];
                
                [self animateTakeAlongViews];
            }
        };
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContest:transitionContext];
        }
        [self.animator addBehavior:dynamic];
    }
    
}


-(void)animationEnded:(BOOL)transitionCompleted {
    
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

//-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
//    
//    [self.transitionContext completeTransition:YES];
//}

@end
