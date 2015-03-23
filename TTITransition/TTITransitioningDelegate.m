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
#import "TTITransitionSuper.h"

@interface TTITransitioningDelegate () {
    TTITransitionSuper *_activePresentationController;
    UIViewController *_presentedViewController;
    TTIGestureController *_gestureController;
}

@end

@implementation TTITransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    TTITransitionSuper *transitionController;
    
    switch (self.transitionType) {
        case TTIOverlayTransition: {
            transitionController = [TTITransitionOverlay new];
        }
            break;
        case TTIFullTransition: {
            transitionController = [TTITransitionFull new];
        }
            break;
        case TTISlideTransition: {
            transitionController = [TTITransitionSlide new];
        }
            break;
        case TTIFoldTransition: {
            transitionController = [TTITransitionFold new];
        }
            break;
        case TTIHangInTransition: {
            CGSize correctSize;
            if(CGSizeEqualToSize(self.sizeOfPresentedViewController, CGSizeZero)) {
                 correctSize = CGSizeMake(300, 250);
            }
            correctSize = self.sizeOfPresentedViewController;
            transitionController = [[TTIHangIn alloc] initWithSizeOfToViewController:correctSize];
        }
            break;
        case TTISpinnTransition: {
            transitionController = [TTITransitionSpinn new];
        }
            break;
        case TTIScaleTransition: {
            transitionController = [TTITransitionScale new];
        }
            break;
    }
    
    transitionController.fromPoint = self.fromPoint;
    transitionController.open = YES;
    transitionController.interactive = NO;
    
    _activePresentationController = transitionController;
    _presentedViewController = presented;
    
    if (self.isInteractive) {
        transitionController.interactiveAnimator = TTIPercentDrivenInteractionTransitionController.new;
        _gestureController = [[TTIGestureController alloc] initWithTargeViewController:presented interactiveAnimator:_activePresentationController gestureType:self.gestureType];
    }

    
    return transitionController;;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    //interactive opening not supported.
    return nil;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    if ([animator isKindOfClass:[TTITransitionSuper class]]) {
        TTITransitionSuper *transitionController = (TTITransitionSuper *)animator;
//        transitionController.open = false;
        
        if (transitionController.interactive && transitionController.interactiveAnimator) {
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
    
    _activePresentationController.open = NO;
    return _activePresentationController;
    
//    switch (self.transitionType) {
//        case TTIOverlayTransition: {
//            TTITransitionOverlay *transitionController = (TTITransitionOverlay *)_activePresentationController;//[TTITransitionOverlay new];
//            transitionController.open = NO;
//            transitionController.fromPoint = self.fromPoint;
//            return transitionController;
//            
//        }
//        case TTIFullTransition: {
//            TTITransitionFull *transitionController = [TTITransitionFull new];
//            transitionController.open = NO;
//            transitionController.fromPoint = self.fromPoint;
//            return transitionController;
//            
//        }
//        case TTISlideTransition: {
//            TTITransitionSlide *transitionController = [TTITransitionSlide new];
//            transitionController.open = NO;
//            transitionController.fromPoint = self.fromPoint;
//            return transitionController;
//        }
//        case TTIFoldTransition: {
//            /*Works best under UINavigationBar or above UIToolbar*/
//            TTITransitionFold *transitionController = [TTITransitionFold new];
//            transitionController.open = NO;
//            transitionController.fromPoint = self.fromPoint;
//            return transitionController;
//        }
//        case TTIHangInTransition: {
//            TTIHangIn *transitionController = [TTIHangIn new];
//            transitionController.open = NO;
//            transitionController.fromPoint = self.fromPoint;
//            return transitionController;
//        }
//        case TTISpinnTransition: {
//            TTITransitionSpinn *transitionController = [TTITransitionSpinn new];
//            transitionController.open = NO;
//            transitionController.fromPoint = self.fromPoint;
//            return transitionController;
//        }
//        case TTIScaleTransition: {
//            TTITransitionScale *transitionController = [TTITransitionScale new];
//            transitionController.open = NO;
//            transitionController.fromPoint = self.fromPoint;
//            return transitionController;
//        }
//    }
//    return nil;
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
