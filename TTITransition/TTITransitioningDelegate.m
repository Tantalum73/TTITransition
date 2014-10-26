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
