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
    CGPoint _initialCenter;
    UIDynamicAnimator *_dynamicAnimator;
    UIAttachmentBehavior *_pan;
    UIDynamicItemBehavior *_dynamicItemBehavior;
    UISnapBehavior *_snapBevavior;
    UIGestureRecognizer *_activeGestureRecognizer;
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

-(void)setGestureType:(TTIGestureRecognizerType)gestureType {
    _gestureType = gestureType;
    [self.targetViewController.view removeGestureRecognizer:_activeGestureRecognizer];
    
    switch (gestureType) {
        case TTIGestureRecognizerPinch: {
            //                [self.targetViewController.view addGestureRecognizer:self.pinchGestureRecognizer];
            _activeGestureRecognizer = self.pinchGestureRecognizer;
        }
            break;
        case TTIGestureRecognizerLeftEdge: {
            self.screenEdgePanGestureRecognizer.edges = UIRectEdgeLeft;
            //                [self.targetViewController.view addGestureRecognizer:self.screenEdgePanGestureRecognizer];
            _activeGestureRecognizer = self.screenEdgePanGestureRecognizer;
        }
            break;
        case TTIGestureRecognizerRightEdge: {
            self.screenEdgePanGestureRecognizer.edges = UIRectEdgeRight;
            //                [self.targetViewController.view addGestureRecognizer:self.screenEdgePanGestureRecognizer];
            _activeGestureRecognizer = self.screenEdgePanGestureRecognizer;
        }
            break;
        case TTIGestureRecognizerPullUpDown: {
            //                [self.targetViewController.view addGestureRecognizer:self.panGestureRecognizerUpDown];
            _activeGestureRecognizer = self.panGestureRecognizerUpDown;
        }
            break;
        case TTIGestureRecognizerPullLeftRight: {
            //                [self.targetViewController.view addGestureRecognizer:self.panGestureRecognizerLeftRight];
            _activeGestureRecognizer = self.panGestureRecognizerLeftRight;
        }
            break;
        case TTIGestureRecognizerPanToEdge: {
            //                [self.targetViewController.view addGestureRecognizer:self.panGestureRecognizerEdge];
            _activeGestureRecognizer = self.panGestureRecognizerEdge;
        }
            break;
        default:
            break;
    }
    
    [self.targetViewController.view addGestureRecognizer:_activeGestureRecognizer];
}


- (void)resetAnimator {
    if (!_dynamicAnimator) {
        _dynamicAnimator= [[UIDynamicAnimator alloc] initWithReferenceView:self.targetViewController.view.window];
    }
    
    [_dynamicAnimator removeAllBehaviors];
    _dynamicAnimator.delegate = nil;
    
    _dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.targetViewController.view]];
    _dynamicItemBehavior.allowsRotation = NO;
    
    
    [_dynamicAnimator addBehavior:_dynamicItemBehavior];
}
-(instancetype) initWithTargeViewController:(UIViewController *)target interactiveAnimator:(TTITransitionSuper *)animator gestureType:(TTIGestureRecognizerType)gestureType rectForPullDownToStart:(CGRect)rectToStart{
    self = [super init];
    if (self) {
        self.targetViewController = target;
        self.interactiveAnimator = animator;
        self.gestureType = gestureType;
        
        
       
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
    CGPoint centerOfTargetRect = self.interactiveAnimator.toPoint;
    
    CGFloat distanceBetweenInteractionAndEdge = [self distanceBetweenPoint1:centerOfTargetRect andPoint2:touch];
    
    //    NSLog(@"Point of interaction: x: %f, y: %f", touch.x, touch.y);
    //    NSLog(@"Translation: x %f, y %f", translation.x, translation.y);
    //    NSLog(@"distanceBetweenInteractionAndFromPoint %f", distanceBetweenInteractionAndFromPoint);
    
    switch (gr.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactiveAnimator.interactive = YES;
            
            _pointOfFirstInteraction = touch;
            _initialCenter = gr.view.center;
            
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
            
            CGFloat distanceBetweenStartOfInteractionAndDestination = [self distanceBetweenPoint1:self.interactiveAnimator.toPoint andPoint2:_pointOfFirstInteraction];
            
            CGFloat animationRatio = MIN(distanceBetweenInteractionAndEdge / distanceBetweenStartOfInteractionAndDestination, 1.0);
            
//            NSLog(@"Normalized Animation Ratio: %f", animationRatio);
            [self.interactiveAnimator.interactiveAnimator updateInteractiveTransition:animationRatio];
            
        }
            break;
        case UIGestureRecognizerStateEnded: {
            CGPoint velocity = [gr velocityInView:self.targetViewController.view.window];
//            return;
            
            [_dynamicAnimator removeBehavior:_pan];
            
            BOOL dismiss = false;
            
            if (fabs(velocity.y) > 250.0) {
                dismiss = velocity.y < 0; //schnell nach oben gezogen
            }
            else {
                dismiss = touch.y < ([UIScreen mainScreen].bounds.size.height / 10.0); //pulled to top
            }
            
            
            CGPoint pointToSnapTo;
            id<UIDynamicAnimatorDelegate> dynamicsDelegate;
            
            if(dismiss) {
                pointToSnapTo = CGPointMake(centerOfTargetRect.x, centerOfTargetRect.y - (self.targetViewController.view.frame.size.height / 1.8));

                dynamicsDelegate = self;
                _dynamicItemBehavior.resistance = 300;
            }
            else {
                pointToSnapTo = _initialCenter;
            }
            
            _snapBevavior = [[UISnapBehavior alloc] initWithItem:self.targetViewController.view snapToPoint:pointToSnapTo];
            _snapBevavior.damping = 0.1;
            [_dynamicItemBehavior addLinearVelocity:velocity forItem:self.targetViewController.view];
            _dynamicAnimator.delegate = dynamicsDelegate;
            
            [_dynamicAnimator addBehavior:_snapBevavior];

        }
            break;
            
        default:
            break;
    }
    
}
-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self.targetViewController dismissViewControllerAnimated:YES completion:nil];
    self.targetViewController.view.alpha = 0;
    [self.interactiveAnimator.transitioningContext finishInteractiveTransition];
    //                    [self.animator.context completeTransition:YES];
    
    [self.targetViewController.view removeGestureRecognizer:_activeGestureRecognizer];
}


- (void) panUpDownAction:(UIPanGestureRecognizer *)gr {
    CGPoint touch = [gr locationInView:self.targetViewController.view.window];

    
    CGFloat distanceBetweenInteractionAndFromPoint = [self distanceBetweenPoint1:self.interactiveAnimator.fromPoint andPoint2:touch];
    
//    NSLog(@"Point of interaction: x: %f, y: %f", touch.x, touch.y);
//    NSLog(@"Translation: x %f, y %f", translation.x, translation.y);
//    NSLog(@"distanceBetweenInteractionAndFromPoint %f", distanceBetweenInteractionAndFromPoint);

    switch (gr.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactiveAnimator.interactive = YES;
            
            _pointOfFirstInteraction = touch;
            
            [self.targetViewController dismissViewControllerAnimated:true completion:^{
                
            }];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat distanceBetweenStartOfInteractionAndFromPoint = [self distanceBetweenPoint1:self.interactiveAnimator.fromPoint andPoint2:_pointOfFirstInteraction];
            CGFloat animationRatio = 1 - (distanceBetweenInteractionAndFromPoint / distanceBetweenStartOfInteractionAndFromPoint);
            
            CGFloat normalizedRatio = MIN(MAX(0, animationRatio), 1);
//            NSLog(@"Animation Ratio: %f", animationRatio);
//            NSLog(@"normalized Animation Ratio: %f", normalizedRatio);
            [self.interactiveAnimator.interactiveAnimator updateInteractiveTransition:normalizedRatio];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            CGPoint velocity = [gr velocityInView:self.targetViewController.view.window];
            
            switch (touch.y > self.interactiveAnimator.fromPoint.y) {
                case true: {
                    if(velocity.y > 0) {
                        [self.interactiveAnimator.interactiveAnimator cancelInteractiveTransition];
                    }
                    else {
                        [self.interactiveAnimator.interactiveAnimator finishInteractiveTransition];
                        [gr.view removeGestureRecognizer:gr];
                    }
                }
                    break;
                    
                case false: {
                    if (velocity.y > 0) {
                        [self.interactiveAnimator.interactiveAnimator finishInteractiveTransition];
                        [gr.view removeGestureRecognizer:gr];
                    }
                    else {
                        [self.interactiveAnimator.interactiveAnimator cancelInteractiveTransition];
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
    
    
    CGFloat distanceBetweenInteractionAndFromPoint = [self distanceBetweenPoint1:self.interactiveAnimator.fromPoint andPoint2:touch];
    
    //    NSLog(@"Point of interaction: x: %f, y: %f", touch.x, touch.y);
    //    NSLog(@"Translation: x %f, y %f", translation.x, translation.y);
    //    NSLog(@"distanceBetweenInteractionAndFromPoint %f", distanceBetweenInteractionAndFromPoint);
    
    switch (gr.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactiveAnimator.interactive = YES;
            
            _pointOfFirstInteraction = touch;
            
            [self.targetViewController dismissViewControllerAnimated:true completion:^{
                
            }];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat distanceBetweenStartOfInteractionAndFromPoint = [self distanceBetweenPoint1:self.interactiveAnimator.fromPoint andPoint2:_pointOfFirstInteraction];
            CGFloat animationRatio = fabs( 1-( distanceBetweenStartOfInteractionAndFromPoint / distanceBetweenInteractionAndFromPoint));
            //            NSLog(@"Animation Ratio: %f", animationRatio);
            [self.interactiveAnimator.interactiveAnimator updateInteractiveTransition:animationRatio];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            CGPoint velocity = [gr velocityInView:self.targetViewController.view.window];
            
            switch (touch.x > self.interactiveAnimator.fromPoint.x) {
                case true: {
                    if(velocity.x > 0) {
                        [self.interactiveAnimator.interactiveAnimator cancelInteractiveTransition];
                    }
                    else {
                        [self.interactiveAnimator.interactiveAnimator finishInteractiveTransition];
                        [gr.view removeGestureRecognizer:gr];
                    }
                }
                    break;
                    
                case false: {
                    if (velocity.x > 0) {
                        [self.interactiveAnimator.interactiveAnimator finishInteractiveTransition];
                        [gr.view removeGestureRecognizer:gr];
                    }
                    else {
                        [self.interactiveAnimator.interactiveAnimator cancelInteractiveTransition];
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
            self.interactiveAnimator.interactive = YES;
            
            [self.targetViewController dismissViewControllerAnimated:true completion:^{
                
            }];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            [self.interactiveAnimator.interactiveAnimator updateInteractiveTransition:normalizedRatio];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (gr.velocity < 0) {//(normalizedRatio > 0.05) {
                [self.interactiveAnimator.interactiveAnimator finishInteractiveTransition];
                [gr.view removeGestureRecognizer:gr];
            }
            else {
                [self.interactiveAnimator.interactiveAnimator cancelInteractiveTransition];
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
            self.interactiveAnimator.interactive = YES;
            
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
            [self.interactiveAnimator.interactiveAnimator updateInteractiveTransition:MAX(0, animationRatio)];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (velocity.x > 0) {
                [self.interactiveAnimator.interactiveAnimator finishInteractiveTransition];
                [gr.view removeGestureRecognizer:gr];
            }
            else {
                [self.interactiveAnimator.interactiveAnimator cancelInteractiveTransition];
            }
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint touch = [self.targetViewController.view convertPoint:[gestureRecognizer locationInView:self.targetViewController.view.window] fromView:self.targetViewController.view];
    
    
    if (!CGRectContainsPoint(self.rectForPullPanGestureToStart, touch)) {
        NSLog(@"RECT NOT CONTAINS POINT OF TOUCH");
        return NO;
    }
    return YES;
}

@end
