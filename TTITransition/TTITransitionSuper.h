//
//  TTITransitionSuper.h
//  TTITransition
//
//  Created by Andreas Neusüß on 23.03.15.
//  Copyright (c) 2015 Andreas Neusüß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTIPercentDrivenInteractionTransitionController.h"

@interface TTITransitionSuper : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) CGPoint fromPoint;
@property (nonatomic) BOOL open;

@property (nonatomic, getter=isInteractive) BOOL interactive;//set, when gesture begins, before calling dismissVC...()
@property (nonatomic, strong) TTIPercentDrivenInteractionTransitionController *interactiveAnimator;

//@property (nonatomic, strong) TTIGestureController *gestureController;
@end
