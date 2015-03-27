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
    UIDynamicAnimator *_dynamicAnimator;
    UIAttachmentBehavior *_pan;
    UIDynamicItemBehavior *_dynamicItemBehavior;
}

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer * screenEdgePanGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizerUpDown;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizerLeftRight;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizerEdge;
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
- (UIPanGestureRecognizer *)panGestureRecognizerUpDown {
    if(!_panGestureRecognizerUpDown) {
        _panGestureRecognizerUpDown = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panUpDownAction:)];
        _panGestureRecognizerUpDown.delegate = self;
    }
    return _panGestureRecognizerUpDown;
}
- (UIPanGestureRecognizer *)panGestureRecognizerLeftRight {
    if(!_panGestureRecognizerLeftRight) {
        _panGestureRecognizerLeftRight = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panLeftRightAction:)];
        _panGestureRecognizerLeftRight.delegate = self;
    }
    return _panGestureRecognizerLeftRight;
}
- (UIPanGestureRecognizer *)panGestureRecognizerEdge {
    if(!_panGestureRecognizerEdge) {
        _panGestureRecognizerEdge = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToEdgeAction:)];
        _panGestureRecognizerEdge.delegate = self;
        
        
        [self resetAnimator];
        
    }
    return _panGestureRecognizerEdge;
}

- (void)resetAnimator {
    if (!_dynamicAnimator) {
        _dynamicAnimator= [[UIDynamicAnimator alloc] initWithReferenceView:self.targetViewController.view.window];
    }
    
    [_dynamicAnimator removeAllBehaviors];
    
    _dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.targetViewController.view]];
    _dynamicItemBehavior.allowsRotation = NO;
    
    
    [_dynamicAnimator addBehavior:_dynamicItemBehavior];
}
-(instancetype) initWithTargeViewController:(UIViewController *)target interactiveAnimator:(TTITransitionSuper *)animator gestureType:(TTIGestureRecognizerType)gestureType rectForPullDownToStart:(CGRect)rectToStart{
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
            case TTIGestureRecognizerPullUpDown: {
                [self.targetViewController.view addGestureRecognizer:self.panGestureRecognizerUpDown];
            }
                break;
            case TTIGestureRecognizerPullLeftRight: {
                [self.targetViewController.view addGestureRecognizer:self.panGestureRecognizerLeftRight];
            }
                break;
            case TTIGestureRecognizerPanToEdge: {
                [self.targetViewController.view addGestureRecognizer:self.panGestureRecognizerEdge];
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
-(CGPoint)centerOfRect:(CGRect)rect {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

- (void) panToEdgeAction:(UIPanGestureRecognizer *)gr {
    CGPoint touch = [gr locationInView:self.targetViewController.view.window];
    CGPoint centerOfTargetRect = self.animator.toPoint;
    
    CGFloat distanceBetweenInteractionAndEdge = [self distanceBetweenPoint1:centerOfTargetRect andPoint2:touch];
    
    //    NSLog(@"Point of interaction: x: %f, y: %f", touch.x, touch.y);
    //    NSLog(@"Translation: x %f, y %f", translation.x, translation.y);
    //    NSLog(@"distanceBetweenInteractionAndFromPoint %f", distanceBetweenInteractionAndFromPoint);
    
    switch (gr.state) {
        case UIGestureRecognizerStateBegan: {
            self.animator.interactive = YES;
            
            _pointOfFirstInteraction = touch;
            
            [self resetAnimator];
            
            
            CGPoint pointinsideAnimatedView = [gr locationInView:gr.view];
            
            UIOffset offset = UIOffsetMake(pointinsideAnimatedView.x - CGRectGetMidX(gr.view.bounds), pointinsideAnimatedView.y - CGRectGetMidY(gr.view.bounds));
            
            CGPoint anchor = [gr locationInView:gr.view.superview];
            
            _pan = [[UIAttachmentBehavior alloc] initWithItem:self.targetViewController.view offsetFromCenter:offset attachedToAnchor:anchor];
            
            [_dynamicAnimator addBehavior:_pan];
            
//            [self.targetViewController dismissViewControllerAnimated:YES completion:nil];
            [self.targetViewController.view.layer removeAllAnimations];
            
            
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            //panning...
            _pan.anchorPoint = touch;
            
            CGFloat distanceBetweenStartOfInteractionAndFromPoint = [self distanceBetweenPoint1:self.animator.toPoint andPoint2:_pointOfFirstInteraction];
            CGFloat animationRatio = fabsf( 1-( distanceBetweenStartOfInteractionAndFromPoint / distanceBetweenInteractionAndEdge));
                        NSLog(@"Animation Ratio: %f", animationRatio);
            [self.animator.interactiveAnimator updateInteractiveTransition:animationRatio];
            
        }
            break;
        case UIGestureRecognizerStateEnded: {
            CGPoint velocity = [gr velocityInView:self.targetViewController.view.window];
//            return;
            
            [_dynamicAnimator removeAllBehaviors];
            
            BOOL dismiss = false;
            
            if (fabs(velocity.y > 250)) {
                dismiss = velocity.y < 0; //schnell nach oben gezogen
            }
            else {
                dismiss = touch.y < ([UIScreen mainScreen].bounds.size.height / 3); //nach oben gezogen
            }
            
            

            if(dismiss) {
                CGFloat distance = [self distanceBetweenPoint1:self.targetViewController.view.center andPoint2:CGPointMake(centerOfTargetRect.x, centerOfTargetRect.y - (self.targetViewController.view.frame.size.height / 1.5))];
                CGFloat velocityOfGesture = sqrtf(velocity.x * velocity.x + velocity.y * velocity.y);
                
                [UIView animateWithDuration:[self.animator transitionDuration:self.animator.context] delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:velocityOfGesture / distance options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent animations:^{
                    
                    CGPoint newCenter  = CGPointMake(centerOfTargetRect.x, centerOfTargetRect.y - (self.targetViewController.view.frame.size.height / 1.5));

                    self.targetViewController.view.center = newCenter;
                    
                } completion:^(BOOL finished) {
                    [self.animator.context finishInteractiveTransition];
//                    [self.animator.context completeTransition:YES];
                    [self.targetViewController dismissViewControllerAnimated:YES completion:nil];
                }];
            }
            else {
                //snap to centre.
                //TODO position specified in animator
                CGFloat distance = [self distanceBetweenPoint1:self.targetViewController.view.center andPoint2:self.animator.fromPoint];
                CGFloat velocityOfGesture = sqrtf(velocity.x * velocity.x + velocity.y * velocity.y);
                
                [UIView animateWithDuration:[self.animator transitionDuration:self.animator.context] delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:velocityOfGesture / distance options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent animations:^{
                    
                    self.targetViewController.view.center = self.animator.fromPoint;//newCenter;
                    
                } completion:^(BOOL finished) {
                    [self.animator.context cancelInteractiveTransition];
//                    [self.animator.context completeTransition:NO];
                }];

            }
        }
            break;
            
        default:
            break;
    }
    
}


- (void) panUpDownAction:(UIPanGestureRecognizer *)gr {
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

- (void) panLeftRightAction:(UIPanGestureRecognizer *)gr {
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
            
            switch (touch.x > self.animator.fromPoint.x) {
                case true: {
                    if(velocity.x > 0) {
                        [self.animator.interactiveAnimator cancelInteractiveTransition];
                    }
                    else {
                        [self.animator.interactiveAnimator finishInteractiveTransition];
                    }
                }
                    break;
                    
                case false: {
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
    CGPoint touch = [self.targetViewController.view convertPoint:[gestureRecognizer locationInView:self.targetViewController.view.window] fromView:self.targetViewController.view.window];
    
    
    if (!CGRectContainsPoint(self.rectForPullPanGestureToStart, touch)) {
        NSLog(@"RECT NOT CONTAINS POINT OF TOUCH");
        return NO;
    }
    return YES;
}

@end
