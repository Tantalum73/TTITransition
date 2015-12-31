//
//  TTITransitionSuper.m
//  TTITransition
//
//  Created by Andreas Neusüß on 23.03.15.
//  Copyright (c) 2015 Andreas Neusüß. All rights reserved.
//

#import "TTITransitionSuper.h"
#import "QuartzCore/QuartzCore.h"
#import "TTITransitioningDelegate.h"

@interface TTITransitionSuper()

@property (nonatomic, strong, readwrite) UIView  * _Nullable inView;
@property (nonatomic, strong, readwrite) UIViewController  * _Nullable toVC;
@property (nonatomic, strong, readwrite) UIViewController  * _Nullable fromVC;
@property (nonatomic, strong, readwrite) UIView  * _Nullable toView;
@property (nonatomic, strong, readwrite) UIView  * _Nullable fromView;

@end

@implementation TTITransitionSuper

-(void)prepareAnimationWithTransitionContext:(id<UIViewControllerContextTransitioning> _Nonnull)transitioningContext {
    
    self.transitioningContext = transitioningContext;

    UIView *inView = [self.transitioningContext containerView];
    UIViewController *toVC = [self.transitioningContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [self.transitioningContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *toView;
    UIView *fromView;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        toView = [self.transitioningContext viewForKey:UITransitionContextToViewKey];
        fromView = [self.transitioningContext viewForKey:UITransitionContextFromViewKey];
    }
    else {
        toView = [toVC view];
        fromView = [fromVC view];
    }
    
    self.inView = inView;
    self.toVC = toVC;
    self.fromVC = fromVC;
    self.toView = toView;
    self.fromView = fromView;
}

-(void)updateInteractiveTransition:(CGFloat)percentComplete {
    [self.interactiveAnimator updateInteractiveTransition:percentComplete];
}
-(void)finishInteractiveTransition {
    [self.interactiveAnimator finishInteractiveTransition];
}
-(void)cancelInteractiveTransition {
    [self.interactiveAnimator cancelInteractiveTransition];
}
-(void)stateOfInteractionChangedToBeInteractive:(BOOL)interactive {
    self.interactive = interactive;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //empty implementation, overwritten...
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

-(CGPoint)centerOfRect:(CGRect)rect {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
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

-(NSArray *)constraintsForBackgroundView:(UIView *)view {
    NSDictionary *views = @{@"view": view};
    
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:views];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:views];
    
    NSArray *entireConstraints = [vertical arrayByAddingObjectsFromArray:horizontal];
    return entireConstraints;
    
}

-(NSArray *)constraintsForPresentedView:(UIView *)presented inView:(UIView *)inView widthProportion:(CGFloat) widthRatio heightProportion:(CGFloat) heightRatio {
    
    NSLog(@"Width Ratio: %f, HeightRatio: %f", widthRatio, heightRatio);
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:presented attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:inView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:presented attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:inView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:presented attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:inView attribute:NSLayoutAttributeWidth multiplier:widthRatio constant:0];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:presented attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:inView attribute:NSLayoutAttributeHeight multiplier:heightRatio constant:0];
    
    return @[centerX, centerY, height, width];
}


-(void)insertTakeAlongViewIntoContainerViewForContext:(_Nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *inView = [transitionContext containerView];
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    
    [fromView setNeedsLayout];
    [fromView layoutIfNeeded];
    
    [toView setNeedsLayout];
    [toView layoutIfNeeded];

    
    for (TTITakeAlongData* data in self.takeAlongDataArray) {
        [self.takeAlongController.delegateForPresented takeAlongDataWithPopulatedFinalFramesForTakeAlongData:data];

        if (self.open) {
            
            data.finalView.alpha = 0;
            data.initialView.alpha = 0;
            data.initialViewCopy.layer.zPosition = 1000;
            data.initialViewCopy.alpha = 1;
            [inView addSubview:data.initialViewCopy];
        }
        else {
            
            data.finalViewCopy.layer.zPosition = 1000;
            data.finalViewCopy.alpha = 1;
            
            [inView addSubview:data.finalViewCopy];
            data.initialView.alpha = 0;
            data.finalView.alpha = 0;
        }
        
    }
}


-(void)changeTakeAlongViews {
    for (TTITakeAlongData *data in self.takeAlongDataArray) {
        
        if (self.open) {
            data.initialViewCopy.frame = data.finalFrame;
        }
        else {
            data.finalViewCopy.frame = data.initialFrame;
        }
    }
}
-(void)removeAndCleanUptakeAlongViews {
    for (TTITakeAlongData* data in self.takeAlongDataArray) {
        
        if (self.open) {
            [data.initialViewCopy removeFromSuperview];
            data.finalView.alpha = 1;
        }
        else {
            [data.finalViewCopy removeFromSuperview];
            data.initialView.alpha = 1;
        }
        
    }
}
-(void)takeAlongTransitionCancelled {
    for (TTITakeAlongData* data in self.takeAlongDataArray) {
        
        if (self.open) {
            [data.finalViewCopy removeFromSuperview];
            [data.initialViewCopy removeFromSuperview];
            data.initialView.alpha = 1;
        }
        else {
            [data.initialViewCopy removeFromSuperview];
            [data.finalViewCopy removeFromSuperview];
            data.finalView.alpha = 1;
        }
        
    }
}

-(void)animateTakeAlongViews {
    [UIView animateWithDuration:[self transitionDuration:self.transitioningContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self changeTakeAlongViews];
    } completion:^(BOOL finished) {
        [self removeAndCleanUptakeAlongViews];
    }];
}
@end
