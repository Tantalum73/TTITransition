//
//  TTIGestureController.m
//  TTITransition
//
//  Created by Andreas Neusüß on 23.03.15.
//  Copyright (c) 2015 Andreas Neusüß. All rights reserved.
//

#import "TTIGestureController.h"
@interface TTIGestureController() {
    CGPoint _pointOfFirstInteraction;
}

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer * screenEdgePanGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
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
- (UIPanGestureRecognizer *)panGestureRecognizer {
    if(!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}

-(instancetype) initWithTargeViewController:(UIViewController *)target interactiveAnimator:(TTITransitionSuper *)animator gestureType:(TTIGestureRecognizerType)gestureType rectForPullDownToStart:(CGRect)rectToStart{
    self = [super init];
    if (self) {
        self.targetViewController = target;
        self.animator = animator;
        self.rectForPullDownToStart = rectToStart;
        
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
            case TTIGestureRecognizerPullDown: {
                [self.targetViewController.view addGestureRecognizer:self.panGestureRecognizer];
            }
                break;
            case TTIGestureRecognizerPullUp: {
                
            }
                break;
            default:
                break;
        }
        
    }
    
    return self;
}

- (CGFloat) distanceBetweenPoint1:(CGPoint)pt1 andPoint2:(CGPoint) pt2 {
    return hypotf(fabs( pt1.x - pt2.x ), fabs( pt1.y - pt2.y));
}
- (void) panAction:(UIPanGestureRecognizer *)gr {
    CGPoint touch = [gr locationInView:self.targetViewController.view.window];

    
    CGFloat distanceBetweenInteractionAndFromPoint = [self distanceBetweenPoint1:self.animator.fromPoint andPoint2:touch];
    
//    NSLog(@"Point of interaction: x: %f, y: %f", touch.x, touch.y);
//    NSLog(@"Translation: x %f, y %f", translation.x, translation.y);
//    NSLog(@"distanceBetweenInteractionAndFromPoint %f", distanceBetweenInteractionAndFromPoint);

    switch (gr.state) {
        case UIGestureRecognizerStateBegan: {
            self.animator.interactive = YES;
            
            _pointOfFirstInteraction = touch;
            
            [self.targetViewController dismissViewControllerAnimated:true completion:^{
                
            }];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat distanceBetweenStartOfInteractionAndFromPoint = [self distanceBetweenPoint1:self.animator.fromPoint andPoint2:_pointOfFirstInteraction];
            CGFloat animationRatio = fabsf( 1-( distanceBetweenStartOfInteractionAndFromPoint / distanceBetweenInteractionAndFromPoint));
//            NSLog(@"Animation Ratio: %f", animationRatio);
            [self.animator.interactiveAnimator updateInteractiveTransition:animationRatio];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            CGPoint velocity = [gr velocityInView:self.targetViewController.view.window];
            
            switch (touch.y > self.animator.fromPoint.y) {
                case true: {
                    if(velocity.y > 0) {
                        [self.animator.interactiveAnimator cancelInteractiveTransition];
                    }
                    else {
                        [self.animator.interactiveAnimator finishInteractiveTransition];
                    }
                }
                    break;
                    
                case false: {
                    if (velocity.y > 0) {
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
            break;
            
        default:
            break;
    }
    
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
                
            }];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            [self.animator.interactiveAnimator updateInteractiveTransition:normalizedRatio];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (gr.velocity < 0) {//(normalizedRatio > 0.05) {
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
                
            }];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            // Get the ratio of the animation depending on the touch location.
            // When location is at the left of the screen the animation is at its initial phase.
            // Moving to the right, the animation proceed, while moving to the right it is reverse played
            CGFloat animationRatio = (location.x-10) / CGRectGetWidth([self.targetViewController.view window].bounds);
//            NSLog(@"Ratio : %f", animationRatio);
            [self.animator.interactiveAnimator updateInteractiveTransition:MAX(0, animationRatio)];
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


#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint touch = [gestureRecognizer locationInView:self.targetViewController.view.window];
    
    if (!CGRectContainsPoint(self.rectForPullDownToStart, touch)) {
        NSLog(@"RECT NOT CONTAINS POINT OF TOUCH");
        return NO;
    }
    return YES;
}

@end
