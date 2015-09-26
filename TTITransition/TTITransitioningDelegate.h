//
//  TTITransitioningDelegate.h
//  TravelTime
//
//  Created by Andreas Neusüß on 31.07.13.
//  Copyright (c) 2013 Andreas Neusüß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTIGestureController.h"
#import "TTITakeAlongTransitionController.h"

/*
    Set type of transition.
*/
typedef NS_ENUM(NSInteger, TTITransitionType) {
    TTITransitionTypeFull,
    TTITransitionTypeOverlay,
    TTITransitionTypeSlide,
    TTITransitionTypeFold,
    TTITransitionTypeHangIn,
    TTITransitionTypeFallIn,
    TTITransitionTypeSpinn,
    TTITransitionTypeScale
};



@interface TTITransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate, UIStateRestoring>


@property (nonatomic, strong) _Nullable Class<UIObjectRestoration> objectRestorationClass;

/**
 A point from where the transition should start. The new ViewController will fly in from that point.
 */
@property (nonatomic) CGPoint fromPoint;


@property (nonatomic, readwrite) CGFloat widthProportionOfSuperView;
@property (nonatomic, readwrite) CGFloat heightProportionOfSuperView;



/**
 The type of transition: overlay or transition that covers entire screen, specified in TTITransitionType
 */
@property (nonatomic, assign) TTITransitionType transitionType;

/**
 Whether the transition can be dismissed by a interactive gesture or rather not.
 */
@property (nonatomic, getter=isInteractive) BOOL interactive;

/**
 The GestureRecognizer, being used to dismiss the presented ViewController.
 */
@property (nonatomic) TTIGestureRecognizerType gestureType;

/**
 CGRect in which the PanGesture can be started. If the user grabs the presented ViewController inside this rect, he can dismiss the ViewController. Every interaction outside of this rect will be ignores when using the TTIGestureRecognizerPullUpDown or TTIGestureRecognizerPullLeftRight gesture type.
 */
@property (nonatomic) CGRect rectForPanGestureToStart;

/**
 The point to which the presented ViewController will animate out.
 This animation may be a slide or a zoom, depending on what you set the gestureType to.
 */
@property (nonatomic) CGPoint toPoint;

@property (nonatomic, strong) TTITakeAlongTransitionController * _Nullable takeAlongController;

@end
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

