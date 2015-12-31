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
@end

@implementation TTIHangIn {
    /// Snapshot of the presenting ViewController, can be blurred or darkened.
    UIView *_backgroundView;
}


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    [self prepareAnimationWithTransitionContext:transitionContext];
    
    self.animator.delegate = self;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.inView];
    
    if(self.open) {
//        _backgroundView = [fromView snapshotViewAfterScreenUpdates:YES];

        

        
        [self.inView addSubview:self.toView];
        
        
        [self.toView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.inView addConstraints:[self constraintsForPresentedView:self.toView inView:self.inView widthProportion:self.widthProportionOfSuperView heightProportion:self.heightProportionOfSuperView]];
        
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
        }
        
        [self.inView layoutIfNeeded];
        
        
        CGSize sizeOfToViewController = self.toView.frame.size;
        
        self.toView.center = CGPointMake(self.toView.center.x, self.inView.frame.origin.y - sizeOfToViewController.height/2);
        
        
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.toView]];
        [self.animator addBehavior:gravity];

        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.inView];
//        self.animator.delegate = self;

        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.toView snapToPoint:self.inView.center];
        snap.damping = 0.5;
        
        snap.action = ^{
            if (self.toView.center.x == self.inView.center.x && self.toView.center.y == self.inView.center.y) {
                [self.animator removeAllBehaviors];
                [self animateTakeAlongViews];

                
                [transitionContext completeTransition:YES];
                
            }
        };
        
        [self.animator addBehavior:snap];

    }
    else {
//        [inView insertSubview:toView atIndex:0];
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.fromView]];
        gravity.magnitude = 1.5;
        [self.animator addBehavior:gravity];
        
        UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[self.fromView]];
//        [dynamic addLinearVelocity:CGPointMake(0, 0) forItem:fromView];
        [dynamic addAngularVelocity:1 forItem:self.fromView];
        [dynamic setAngularResistance:3];
        
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
        }
        
        [self.inView insertSubview:self.toView atIndex:0];
        
        // when the view no longer intersects with its superview, go ahead and remove it
        
        [self animateTakeAlongViews];
        dynamic.action = ^{
            if (!CGRectIntersectsRect(self.inView.bounds, self.fromView.frame)) {
 
                [self.animator removeAllBehaviors];
                
                [_backgroundView removeFromSuperview];

                [transitionContext completeTransition:YES];
                
            }
        };
        
        [self.animator addBehavior:dynamic];
    }
    
}


-(void)animationEnded:(BOOL)transitionCompleted {
    
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.7;
}

//-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
//    
//    [self.transitionContext completeTransition:YES];
//}

@end
