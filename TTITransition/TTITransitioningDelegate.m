    //
//  TTITransitioningDelegate.m
//  TravelTime
//
//  Created by Andreas Neusüß on 31.07.13.
//  Copyright (c) 2013 Andreas Neusüß. All rights reserved.
//

#import "TTITransitioningDelegate.h"
#import "TTITransitionOverlay.h"
#import "TTITransitionFull.h"
#import "TTITransitionSlide.h"
#import "TTITransitionFold.h"
#import "TTIHangIn.h"
#import "TTIFallIn.h"
#import "TTITransitionSpinn.h"
#import "TTITransitionScale.h"
#import "TTIPercentDrivenInteractionTransitionController.h"
#import "TTITransitionSuper.h"

@interface TTITransitioningDelegate () {
    TTITransitionSuper *_activePresentationController;
    UIViewController *_presentedViewController;
    TTIGestureController *_gestureController;
}

@end

@implementation TTITransitioningDelegate

-(void)setFromPoint:(CGPoint)fromPoint {
    _fromPoint = fromPoint;
    if (_activePresentationController) {
        _activePresentationController.fromPoint = fromPoint;
    }
}
-(void)setToPoint:(CGPoint)toPoint {
    _toPoint = toPoint;
    if (_activePresentationController) {
        _activePresentationController.toPoint = toPoint;
    }
}

- (void)setRectForPanGestureToStart:(CGRect)newRect {
    CGRect convertedRect = [_presentedViewController.view.window convertRect:newRect fromView:_presentedViewController.view];
    _rectForPanGestureToStart = convertedRect;
    if (_gestureController) {
        _gestureController.rectForPullPanGestureToStart = convertedRect;
    }
}

-(void)setGestureType:(TTIGestureRecognizerType)gestureType {
    _gestureType = gestureType;
    
    if (self.isInteractive) {
        _gestureController.targetViewController = _presentedViewController;
        _gestureController.interactiveAnimator = _activePresentationController;
        
        _gestureController.rectForPullPanGestureToStart = self.rectForPanGestureToStart;
    }
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    TTITransitionSuper *transitionAnimator;
    
    switch (self.transitionType) {
        case TTITransitionTypeOverlay: {
            transitionAnimator = [TTITransitionOverlay new];
        }
            break;
        case TTITransitionTypeFull: {
            transitionAnimator = [TTITransitionFull new];
        }
            break;
        case TTITransitionTypeSlide: {
            transitionAnimator = [TTITransitionSlide new];
        }
            break;
        case TTITransitionTypeFold: {
            transitionAnimator = [TTITransitionFold new];
        }
            break;
        case TTITransitionTypeHangIn: {
            transitionAnimator = [[TTIHangIn alloc] init];
        }
            break;
        case TTITransitionTypeFallIn: {
            transitionAnimator = [[TTIFallIn alloc] init];
        }
            break;
        case TTITransitionTypeSpinn: {
            transitionAnimator = [TTITransitionSpinn new];
        }
            break;
        case TTITransitionTypeScale: {
            transitionAnimator = [TTITransitionScale new];
        }
            break;
    }
    
    if (self.widthProportionOfSuperView == 0) {
        self.widthProportionOfSuperView = 1;
    }
    if (self.heightProportionOfSuperView == 0) {
        self.heightProportionOfSuperView = 1;
    }
    transitionAnimator.widthProportionOfSuperView = self.widthProportionOfSuperView;
    transitionAnimator.heightProportionOfSuperView = self.heightProportionOfSuperView;
    
    
    transitionAnimator.takeAlongController = self.takeAlongController;
    transitionAnimator.takeAlongDataArray = [self.takeAlongController.delegateForPreseting dataForTakeAlongTransition].mutableCopy;
    
    transitionAnimator.fromPoint = self.fromPoint;
    transitionAnimator.open = YES;
    transitionAnimator.interactive = NO;
    
    if (CGPointEqualToPoint(self.toPoint, CGPointZero)) {
        self.toPoint = self.fromPoint;
    }
    transitionAnimator.toPoint = self.toPoint;
    
    _activePresentationController = transitionAnimator;
    _presentedViewController = presented;
    
    if (self.isInteractive) {
        transitionAnimator.interactiveAnimator = TTIPercentDrivenInteractionTransitionController.new;
        _gestureController = [[TTIGestureController alloc] initWithTargeViewController:presented interactiveAnimator:_activePresentationController gestureType:self.gestureType rectForPullDownToStart:self.rectForPanGestureToStart];
    }
    
    return transitionAnimator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    //interactive opening not supported.
    return nil;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    if ([animator isKindOfClass:[TTITransitionSuper class]]) {
        TTITransitionSuper *transitionController = (TTITransitionSuper *)animator;
        transitionController.open = NO;
        
        if (transitionController.interactive && transitionController.interactiveAnimator) {
            
            if (self.gestureType == TTIGestureRecognizerPanToEdge) {
                //Work is done by the gestureRecognizer, not by the animator.
                //return nil, when gesture does all the work.
                return nil;
            }
            
            return transitionController.interactiveAnimator;
        }
        else {
            return nil;
        }
        
    }
    
    return nil;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
        
    _activePresentationController.open = NO;
    return _activePresentationController;
    }

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [coder encodeCGPoint:self.fromPoint forKey:@"fromPoint"];
    [coder encodeInteger:self.transitionType forKey:@"TransitionType"];
}
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    self.fromPoint = [coder decodeCGPointForKey:@"fromPoint"];
    self.transitionType = (TTITransitionType)[coder decodeIntegerForKey:@"TransitionType"];
}

@end
