//
//  TTINavigationControllerTransitioningDelegate.m
//  TTITransition
//
//  Created by Andreas Neusüß on 23.08.15.
//  Copyright © 2015 Andreas Neusüß. All rights reserved.
//

#import "TTINavigationControllerTransitioningDelegate.h"
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
#import "TTITransitionNavigationControllerLeftEdgeGestureHandler.h"

@interface TTINavigationControllerTransitioningDelegate () {
    TTITransitionSuper *_activePresentationController;
    TTITransitionNavigationControllerLeftEdgeGestureHandler *_gestureController;
}

@end
@implementation TTINavigationControllerTransitioningDelegate 

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    
    TTITransitionSuper *animator;
    
    
    if(operation == UINavigationControllerOperationPush) {
        //opening
        
        //creating animator when pushing new VC
        switch (self.transitionType) {
                
            case TTINavigationControllerTransitionTypeFull: {
                animator = [TTITransitionFull new];
            }
                break;
            case TTINavigationControllerTransitionTypeSlide: {
                animator = [TTITransitionSlide new];
            }
                break;
            case TTINavigationControllerTransitionTypeFold: {
                animator = [TTITransitionFold new];
            }
                break;
            case TTINavigationControllerTransitionTypeSpinn: {
                animator = [TTITransitionSpinn new];
            }
                break;
            case TTINavigationControllerTransitionTypeScale: {
                animator = [TTITransitionScale new];
            }
                break;
        }

        animator.takeAlongController = self.takeAlongController;
        
        animator.takeAlongDataArray = [self.takeAlongController.delegateForPreseting dataForTakeAlongTransition].mutableCopy;
        
        
        animator.open = YES;
        
        
        animator.interactiveAnimator = TTIPercentDrivenInteractionTransitionController.new;
        
        
        _gestureController = [[TTITransitionNavigationControllerLeftEdgeGestureHandler alloc] initWithTargetViewController:toVC insideOfNavigationController:navigationController animator:animator];
        //[[TTIGestureController alloc] initWithTargeViewController:toVC interactiveAnimator:_activePresentationController gestureType:self.gestureType rectForPullDownToStart:self.rectForPanGestureToStart];
        
        _activePresentationController = animator;
        
    }
    else if(operation == UINavigationControllerOperationPop) {
        //closing
        _activePresentationController.open = NO;
    }
    
    return _activePresentationController;

    
    
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    
    if ([animator isKindOfClass:[TTITransitionSuper class]]) {
        TTITransitionSuper *transitionController = (TTITransitionSuper *)animator;
        
        if (transitionController.interactive && transitionController.interactiveAnimator) {
  
            return transitionController.interactiveAnimator;
        }
        else {
            return nil;
        }
        
    }
    
    return nil;
}
//
//+(id<UIStateRestoring>)objectWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
//    for (NSString *key in identifierComponents) {
//        if([key isEqualToString:@"animator"]) {
//            TTITransitionSuper *tmp = [TTITransitionSuper new];
////            TTINavigationControllerAnimator *tmp = [TTINavigationControllerAnimator new];
//            
//            tmp.objectRestorationClass = [self class];
//            [UIApplication registerObjectForStateRestoration:tmp restorationIdentifier:@"animator"];
//            return tmp;
//        }
//       
//    }
//    
//    return nil;
//}
//
//-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
//    if(_activePresentationController) {
//        
//        [coder encodeObject:_activePresentationController forKey:@"animator"];
//    }
//    if(_presentedViewController) {
//        [coder encodeObject:_presentedViewController forKey:@"presentedViewController"];
//    }
//    if(_gestureController) {
//        [coder encodeObject:_gestureController forKey:@"gestureController"];
//    }
//    [coder encodeInteger:self.transitionType forKey:@"transitionType"];
//}
//
//-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
//    
//    _activePresentationController = [coder decodeObjectForKey:@"animator"];
//    _presentedViewController = [coder decodeObjectForKey:@"presentedViewController"];
//    _gestureController = [coder decodeObjectForKey:@"gestureController"];
//    self.transitionType = [coder decodeIntegerForKey:@"transitionType"];
//}
//

@end
