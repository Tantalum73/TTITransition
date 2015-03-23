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
#import "TTITransitionSpinn.h"
#import "TTITransitionScale.h"
#import "TTIPercentDrivenInteractionTransitionController.h"
#import "TTIGestureController.h"
#import "TTITransitionSuper.h"

@interface TTITransitioningDelegate () {
    TTITransitionSuper *_activePresentationController;
    UIViewController *_presentedViewController;
    TTIGestureController *_gestureController;
}

@end

@implementation TTITransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    switch (self.transitionType) {
        case TTIOverlayTransition: {
            TTITransitionOverlay *transitionController = [TTITransitionOverlay new];
            transitionController.open = YES;
            transitionController.interactive = NO;
            
            transitionController.fromPoint = self.fromPoint;
            
            transitionController.interactiveAnimator = TTIPercentDrivenInteractionTransitionController.new;
            
            
            _activePresentationController = transitionController;
            _presentedViewController = presented;
            //if canBeInteractive
            _gestureController = [[TTIGestureController alloc] initWithTargeViewController:presented interactiveAnimator:_activePresentationController];

            //wite custom init
//            _gestureController = [[TTIGestureController alloc] initWithTargeViewController:_presentedViewController currentAnimator:_activePresentationController];
            
            return transitionController;
            
        }
        case TTIFullTransition: {
            TTITransitionFull *transitionController = [TTITransitionFull new];
            transitionController.open = YES;
            transitionController.fromPoint = self.fromPoint;
            return transitionController;
        }
        case TTISlideTransition: {
            TTITransitionSlide *transitionController = [TTITransitionSlide new];
            transitionController.open = YES;
            transitionController.fromPoint = self.fromPoint;
            return transitionController;
        }
        case TTIFoldTransition: {
            TTITransitionFold *transitionController = [TTITransitionFold new];
            transitionController.open = YES;
            transitionController.fromPoint = self.fromPoint;
            return transitionController;
        }
        case TTIHangInTransition: {
            TTIHangIn *transitionController = [TTIHangIn new];
            transitionController.open = YES;
            transitionController.fromPoint = self.fromPoint;
            if(CGSizeEqualToSize(self.sizeOfPresentedViewController, CGSizeZero)) {
                
                transitionController.sizeOfToViewController = CGSizeMake(300, 250);
            }
            transitionController.sizeOfToViewController = self.sizeOfPresentedViewController;
            return transitionController;
        }
        case TTISpinnTransition: {
            TTITransitionSpinn *transitionController = [TTITransitionSpinn new];
            transitionController.open = YES;
            transitionController.fromPoint = self.fromPoint;
            return transitionController;
        }
        case TTIScaleTransition: {
            TTITransitionScale *transitionController = [TTITransitionScale new];
            transitionController.open = YES;
            transitionController.fromPoint = self.fromPoint;
            return transitionController;
        }
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    //interactive opening not supported.
    return nil;
    
//    if (self.transitionType != TTIOverlayTransition) {
//        return nil;
//    }
//    else {
//        
////        TTINavigationControllerAnimator *animator;
////        if([animationController isKindOfClass:[TTINavigationControllerAnimator class]]) {
////            animator = (TTINavigationControllerAnimator *)animationController;
////        }
////        
////        if(animator.isInteractive && animator.interactiveAnimator) {
////            return animator.interactiveAnimator;
////        }
//        
//        
////        TTITransitionOverlay *theAnimator;
////        if ([animator isKindOfClass:[TTITransitionOverlay class]]) {
////            theAnimator = (TTITransitionOverlay *)animator;
////        }
////        if (theAnimator.isInteractive && theAnimator.interactiveAnimator) {
////            return theAnimator.interactiveAnimator;
////        }
//        return nil;
//        
//        
//        TTITransitionOverlay *transitionController = [TTITransitionOverlay new];
//        transitionController.open = YES;
//        transitionController.fromPoint = self.fromPoint;
//        
//        //Warning here
//        transitionController.interactiveAnimator = TTIPercentDrivenInteractionTransitionController.new;
//        
//        _activePresentationController = transitionController;
//        return transitionController.interactiveAnimator;
//    }
//    
//    return nil;
}
-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    if ([animator isKindOfClass:[TTITransitionSuper class]]) {
        TTITransitionSuper *transitionController = (TTITransitionSuper *)animator;
//        transitionController.open = false;
        
        if (transitionController.isInteractive && transitionController.interactiveAnimator) {
            return transitionController.interactiveAnimator;
        }
        else {
            return nil;
        }
        
//        return transitionController.interactiveAnimator;
    }
    
    return nil;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    //do non-custom stuff here
    
    switch (self.transitionType) {
        case TTIOverlayTransition: {
            TTITransitionOverlay *transitionController = (TTITransitionOverlay *)_activePresentationController;//[TTITransitionOverlay new];
            transitionController.open = NO;
            transitionController.fromPoint = self.fromPoint;
            return transitionController;
            
        }
        case TTIFullTransition: {
            TTITransitionFull *transitionController = [TTITransitionFull new];
            transitionController.open = NO;
            transitionController.fromPoint = self.fromPoint;
            return transitionController;
            
        }
        case TTISlideTransition: {
            TTITransitionSlide *transitionController = [TTITransitionSlide new];
            transitionController.open = NO;
            transitionController.fromPoint = self.fromPoint;
            return transitionController;
        }
        case TTIFoldTransition: {
            /*Works best under UINavigationBar or above UIToolbar*/
            TTITransitionFold *transitionController = [TTITransitionFold new];
            transitionController.open = NO;
            transitionController.fromPoint = self.fromPoint;
            return transitionController;
        }
        case TTIHangInTransition: {
            TTIHangIn *transitionController = [TTIHangIn new];
            transitionController.open = NO;
            transitionController.fromPoint = self.fromPoint;
            return transitionController;
        }
        case TTISpinnTransition: {
            TTITransitionSpinn *transitionController = [TTITransitionSpinn new];
            transitionController.open = NO;
            transitionController.fromPoint = self.fromPoint;
            return transitionController;
        }
        case TTIScaleTransition: {
            TTITransitionScale *transitionController = [TTITransitionScale new];
            transitionController.open = NO;
            transitionController.fromPoint = self.fromPoint;
            return transitionController;
        }
    }
    return nil;
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [coder encodeCGPoint:self.fromPoint forKey:@"fromPoint"];
    [coder encodeInteger:self.transitionType forKey:@"TransitionType"];
}
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    self.fromPoint = [coder decodeCGPointForKey:@"fromPoint"];
    self.transitionType = (TransitionType)[coder decodeIntegerForKey:@"TransitionType"];
}

@end
