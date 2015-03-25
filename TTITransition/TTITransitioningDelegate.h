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

/*
    Set type of transition: overlay or transition that covers entire screen
*/
typedef NS_ENUM(NSInteger, TTITransitionType) {
    TTITransitionTypeFull,
    TTITransitionTypeOverlay,
    TTITransitionTypeSlide,
    TTITransitionTypeFold,
    TTITransitionTypeHangIn,
    TTITransitionTypeSpinn,
    TTITransitionTypeScale
};



@interface TTITransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate, UIStateRestoring>

@property (nonatomic, strong) Class<UIObjectRestoration> objectRestorationClass;

/*
 A point from where the transition should start. The new ViewController will fly in from that point.
 */
@property (nonatomic) CGPoint fromPoint;

/*
 The size, that the new ViewController should have.
 Only works in TTIHangInTransition!
 */
@property (nonatomic, assign) CGSize sizeOfPresentedViewController;

/*
 The type of transition: overlay or transition that covers entire screen
 */
@property (nonatomic, assign) TTITransitionType transitionType;

/*
 Whether the transition can be dismissed by a interactive gesture or rather not.
 */
@property (nonatomic, getter=isInteractive) BOOL interactive;

/*
 The GestureRecognizer, being used to dismiss the presented ViewController.
 */
@property (nonatomic) TTIGestureRecognizerType gestureType;

/*
 CGRect in which the PanGesture can be started. If the user grabs the presented ViewController inside this rect, he can dismiss the ViewController. Every interaction outside of this rect will be ignores when using the TTIGestureRecognizerPullUpDown or TTIGestureRecognizerPullLeftRight gesture type.
 */
@property (nonatomic) CGRect rectForPanGestureToStart;

@end
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

