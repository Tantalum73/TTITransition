//
//  TTITransitionSuper.m
//  TTITransition
//
//  Created by Andreas Neusüß on 23.03.15.
//  Copyright (c) 2015 Andreas Neusüß. All rights reserved.
//

#import "TTITransitionSuper.h"

@implementation TTITransitionSuper


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
@end
