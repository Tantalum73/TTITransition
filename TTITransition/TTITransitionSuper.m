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
@end
