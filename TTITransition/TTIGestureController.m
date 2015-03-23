//
//  TTIGestureController.m
//  TTITransition
//
//  Created by Andreas Neusüß on 23.03.15.
//  Copyright (c) 2015 Andreas Neusüß. All rights reserved.
//

#import "TTIGestureController.h"
@interface TTIGestureController()

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer * screenEdgePanGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;

@end

@implementation TTIGestureController


- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer {
    if(!_screenEdgePanGestureRecognizer) {
        _screenEdgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanAction:)];
    }
    return _screenEdgePanGestureRecognizer;
}
- (UIPinchGestureRecognizer *)pinchGestureRecognizer {
    if(!_pinchGestureRecognizer) {
        _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
        
    }
    return _pinchGestureRecognizer;
}

-(instancetype) initWithTargeViewController:(UIViewController *)target interactiveAnimator:(TTITransitionSuper *)animator gestureType:(GestureRecognizerType)gestureType {
    self = [super init];
    if (self) {
        self.targetViewController = target;
        self.animator = animator;
        
        
        switch (gestureType) {
            case TTIGestureRecognizerPinch: {
                [self.targetViewController.view addGestureRecognizer:self.pinchGestureRecognizer];
            }
                break;
            case TTIGestureRecognizerLeftEdge: {
                self.screenEdgePanGestureRecognizer.edges = UIRectEdgeLeft;
                [self.targetViewController.view addGestureRecognizer:self.screenEdgePanGestureRecognizer];
            }
                break;
            case TTIGestureRecognizerRightEdge: {
                self.screenEdgePanGestureRecognizer.edges = UIRectEdgeRight;
                [self.targetViewController.view addGestureRecognizer:self.screenEdgePanGestureRecognizer];
            }
                break;
            default:
                break;
        }
        
    }
    
    return self;
}

- (void) pinchAction:(UIPinchGestureRecognizer *)gr {
    
//    NSLog(@"Scale: %f", gr.scale);
    CGFloat animationRatio = 1-gr.scale;
    
    CGFloat normalizedRatio = MIN(MAX(0, animationRatio), 1);
//    NSLog(@"Ratio: %f", animationRatio);
//    NSLog(@"Normalized Ratio: %f", normalizedRatio);
    switch (gr.state) {
        case UIGestureRecognizerStateBegan: {
            self.animator.interactive = YES;
            
            [self.targetViewController dismissViewControllerAnimated:true completion:^{
                [self.targetViewController.view removeGestureRecognizer:self.screenEdgePanGestureRecognizer];
            }];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            [self.animator.interactiveAnimator updateInteractiveTransition:normalizedRatio];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (normalizedRatio > 0.05) {
                [self.animator.interactiveAnimator finishInteractiveTransition];
            }
            else {
                [self.animator.interactiveAnimator cancelInteractiveTransition];
            }
        }
            break;
        default:
            break;
    }

}

- (void) screenEdgePanAction:(UIScreenEdgePanGestureRecognizer *)gr {
    
    // Location reference
    CGPoint location = [gr locationInView:[self.targetViewController.view window]];
    
    // Velocity reference
    CGPoint velocity = [gr velocityInView:[self.targetViewController.view window]];
    
    
    switch (gr.state) {
        case UIGestureRecognizerStateBegan: {
//            [self.delegate stateOfInteractionChangedToBeInteractive:YES];
            self.animator.interactive = YES;
            
            [self.targetViewController dismissViewControllerAnimated:true completion:^{
                [self.targetViewController.view removeGestureRecognizer:self.screenEdgePanGestureRecognizer];
            }];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            // Get the ratio of the animation depending on the touch location.
            // When location is at the left of the screen the animation is at its initial phase.
            // Moving to the right, the animation proceed, while moving to the right it is reverse played
            CGFloat animationRatio = location.x / CGRectGetWidth([self.targetViewController.view window].bounds);
            [self.animator.interactiveAnimator updateInteractiveTransition:animationRatio];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (velocity.x > 0) {
                [self.animator.interactiveAnimator finishInteractiveTransition];
            }
            else {
                [self.animator.interactiveAnimator cancelInteractiveTransition];
            }
        }
            break;
        default:
            break;
    }
}

@end
