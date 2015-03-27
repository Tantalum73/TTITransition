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
    UIView *_backgroundView;
}

-(instancetype)initWithSizeOfToViewController:(CGSize)size {
    if (self = [super init]) {
        self.sizeOfToViewController = size;
    }
    
    return self;
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
        
        _backgroundView = [fromView snapshotViewAfterScreenUpdates:YES];
        [inView insertSubview:_backgroundView aboveSubview:fromView];
        [fromView removeFromSuperview];
        
        
        if(CGSizeEqualToSize(self.sizeOfToViewController, CGSizeZero)) {
            self.sizeOfToViewController = CGSizeMake(300, 200);
        }
        toView.frame = CGRectMake(inView.bounds.origin.x + (inView.bounds.size.width - self.sizeOfToViewController.width) / 2, -self.sizeOfToViewController.height, self.sizeOfToViewController.width, self.sizeOfToViewController.height);//CGRectMake(0, [UIScreen mainScreen].bounds.origin.y- self.sizeOfToViewController.height, self.sizeOfToViewController.width, self.sizeOfToViewController.height);
        
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = - 1.0 / 500.0 ;
        //        inView.layer.sublayerTransform = perspective;
        
        
        [inView addSubview:toView];
        [inView insertSubview:fromView atIndex:0];
        
        toView.layer.zPosition = 400;
        CATransform3D rotation =CATransform3DMakeRotation(M_PI/2.7, 1.0, 0, 0);
        rotation.m34 = -1.0/500.0;
        toView.layer.transform = rotation;
        //        toView.layer.transform.m34 = -1.0 / 500.0;
        //        toView.layer.anchorPoint = CGPointMake(0.5, 0);
        CGPoint newCenter = _backgroundView.center;//[inView convertPoint:_backgroundView.center fromView:toView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            toView.layer.transform = CATransform3DIdentity;
            toView.transform = CGAffineTransformIdentity;
            
            toView.layer.position = newCenter;
            //            toView.layer
            toView.frame = CGRectMake(toView.frame.origin.x, toView.frame.origin.y - 100, toView.frame.size.width, toView.frame.size.height);
            //            toView.center = newCenter;
            
        } completion:^(BOOL finished) {
            toView.layer.transform = CATransform3DIdentity;
            toView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            toView.layer.position = newCenter;// inView.layer.position;
            [transitionContext completeTransition:YES];
            
        }];
    }
    else {
        [inView insertSubview:toView atIndex:0];
        [inView addSubview:fromView];
        fromView.alpha = 1;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            fromView.center = CGPointMake(self.toPoint.x, self.toPoint.y - fromView.frame.size.height / 1.5 );
            
            _backgroundView.alpha =0;
        } completion:^(BOOL finished) {
            
            //            NSLog(@"Completion with finished %d", finished);
            
            if ([transitionContext transitionWasCancelled]) {
                fromView.layer.transform = CATransform3DIdentity;
                //                NSLog(@"was cancelled");
                
                [transitionContext completeTransition:NO];
            }
            else {
                [fromView removeFromSuperview];
                fromView.layer.transform = CATransform3DIdentity;
                [_backgroundView removeFromSuperview];
                
                [transitionContext finishInteractiveTransition];
                [transitionContext completeTransition:YES];
            }
            
            
        }];
    }
    
}

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
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
        
        _backgroundView = [fromView snapshotViewAfterScreenUpdates:YES];
        [inView insertSubview:_backgroundView aboveSubview:fromView];
        [fromView removeFromSuperview];
        
        
        if(CGSizeEqualToSize(self.sizeOfToViewController, CGSizeZero)) {
            self.sizeOfToViewController = CGSizeMake(300, 200);
        }
        toView.frame = CGRectMake(inView.bounds.origin.x + (inView.bounds.size.width - self.sizeOfToViewController.width) / 2, -self.sizeOfToViewController.height, self.sizeOfToViewController.width, self.sizeOfToViewController.height);//CGRectMake(0, [UIScreen mainScreen].bounds.origin.y- self.sizeOfToViewController.height, self.sizeOfToViewController.width, self.sizeOfToViewController.height);
        
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = - 1.0 / 500.0 ;
//        inView.layer.sublayerTransform = perspective;
        
        
        [inView addSubview:toView];
        [inView insertSubview:fromView atIndex:0];
        
        toView.layer.zPosition = 400;
        CATransform3D rotation =CATransform3DMakeRotation(M_PI/2.7, 1.0, 0, 0);
        rotation.m34 = -1.0/500.0;
        toView.layer.transform = rotation;
//        toView.layer.transform.m34 = -1.0 / 500.0;
//        toView.layer.anchorPoint = CGPointMake(0.5, 0);
        CGPoint newCenter = _backgroundView.center;//[inView convertPoint:_backgroundView.center fromView:toView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            toView.layer.transform = CATransform3DIdentity;
            toView.transform = CGAffineTransformIdentity;
            
            toView.layer.position = newCenter;
            //            toView.layer
            toView.frame = CGRectMake(toView.frame.origin.x, toView.frame.origin.y - 100, toView.frame.size.width, toView.frame.size.height);
            //            toView.center = newCenter;
            
        } completion:^(BOOL finished) {
            toView.layer.transform = CATransform3DIdentity;
            toView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            toView.layer.position = newCenter;// inView.layer.position;
            [transitionContext completeTransition:YES];
            
        }];
    }
    else {
        [inView insertSubview:toView atIndex:0];
        [inView addSubview:fromView];
        fromView.alpha = 1;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            fromView.center = CGPointMake(self.toPoint.x, self.toPoint.y - fromView.frame.size.height / 1.5 );
            
            _backgroundView.alpha =0;
        } completion:^(BOOL finished) {
            
//            NSLog(@"Completion with finished %d", finished);
            
            if ([transitionContext transitionWasCancelled]) {
                fromView.layer.transform = CATransform3DIdentity;
//                NSLog(@"was cancelled");
                
                [transitionContext completeTransition:NO];
            }
            else {
                [fromView removeFromSuperview];
                fromView.layer.transform = CATransform3DIdentity;
                [_backgroundView removeFromSuperview];
                
                [transitionContext finishInteractiveTransition];
                [transitionContext completeTransition:YES];
            }
            
            
        }];
    }
}

-(void)animationEnded:(BOOL)transitionCompleted {
    
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;//0.45;
}



//-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
//    
//    [self.transitionContext completeTransition:YES];
//}

@end
