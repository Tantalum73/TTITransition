//
//  TTIGestureController.h
//  TTITransition
//
//  Created by Andreas Neusüß on 23.03.15.
//  Copyright (c) 2015 Andreas Neusüß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTITransitionSuper.h"


typedef NS_ENUM(NSInteger, TTIGestureRecognizerType) {
    TTIGestureRecognizerPinch,
    TTIGestureRecognizerLeftEdge,
    TTIGestureRecognizerRightEdge,
    TTIGestureRecognizerPullDown,
    TTIGestureRecognizerPullUp
};

@interface TTIGestureController : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIViewController *targetViewController;
@property (nonatomic, strong) TTITransitionSuper *animator;

@property (nonatomic) CGRect rectForPullDownToStart;

-(instancetype) initWithTargeViewController:(UIViewController *)target interactiveAnimator:(TTITransitionSuper *)animator gestureType:(TTIGestureRecognizerType)gestureType rectForPullDownToStart:(CGRect)rectToStart;
@end

