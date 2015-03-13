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


@interface TTITransitioningDelegate () {
}

@end

@implementation TTITransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    switch (self.transitionType) {
        case TTIOverlayTransition: {
            TTITransitionOverlay *transitionController = [TTITransitionOverlay new];
            transitionController.open = YES;
            transitionController.fromPoint = self.fromPoint;
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
            if (self.sizeOfPresentedViewController.height == CGSizeZero.height && self.sizeOfPresentedViewController.width == CGSizeZero.width) {
                
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
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    
    switch (self.transitionType) {
        case TTIOverlayTransition: {
            TTITransitionOverlay *transitionController = [TTITransitionOverlay new];
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
