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


typedef NS_ENUM(NSInteger, GestureRecognizerType) {
    TTIGestureRecognizerPinch,
    TTIGestureRecognizerLeftEdge,
    TTIGestureRecognizerRightEdge
};

@interface TTIGestureController : NSObject

@property (nonatomic, strong) UIViewController *targetViewController;
@property (nonatomic, strong) TTITransitionSuper *animator;



-(instancetype) initWithTargeViewController:(UIViewController *)target interactiveAnimator:(TTITransitionSuper *)animator gestureType:(GestureRecognizerType)gestureType;
@end

