//
//  TTIFallIn.h
//  TTITransition
//
//  Created by Andreas Neusüß on 27.03.15.
//  Copyright (c) 2015 Andreas Neusüß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTITransitioningDelegate.h"
#import "TTINavigationControllerTransitioningDelegate.h"

@interface TTITransitionController : NSObject 
NS_ASSUME_NONNULL_BEGIN
-(instancetype _Nullable)initWithPresentedViewController:(UIViewController*) presentedViewController

                                transitionType:(TTITransitionType) transitionType
                                     fromPoint:(CGPoint) fromPoint
                                       toPoint:(CGPoint) toPoint
                    widthProportionOfSuperView: (CGFloat) widthProportionOfSuperView
                   heightProportionOfSuperView: (CGFloat) heightProportionOfSuperView
                                   interactive:(BOOL)interactive
                                   gestureType:(TTIGestureRecognizerType) gestureType
                                      rectToStartGesture:(CGRect) rectForPanGestureToStart
NS_DESIGNATED_INITIALIZER;

-(instancetype _Nullable)initNavigationControllerTransitionWithNavigationController:(UINavigationController*) navigationController transitionType:(TTINavigationControllerTransitionType) transitionType
NS_DESIGNATED_INITIALIZER;



@property (nonatomic, readonly, strong) TTITransitioningDelegate* _Nullable ttiTransitioningDelegate;
@property (nonatomic, readonly, strong) TTINavigationControllerTransitioningDelegate *_Nullable ttiNavigationControllerTransitioningDelegate;

@property (nonatomic, strong) _Nullable Class<UIObjectRestoration> objectRestorationClass;

/**
 A point from where the transition should start. The new ViewController will fly in from that point.
 */
@property (nonatomic, readonly) CGPoint fromPoint;


@property (nonatomic, readonly) CGFloat widthProportionOfSuperView;
@property (nonatomic, readonly) CGFloat heightProportionOfSuperView;

/**
 The type of transition: overlay or transition that covers entire screen
 */
@property (nonatomic, assign, readonly) TTITransitionType transitionType;


/**
 Whether the transition can be dismissed by a interactive gesture or rather not.
 */
@property (nonatomic, getter=isInteractive, readonly) BOOL interactive;

/**
 The GestureRecognizer, being used to dismiss the presented ViewController.
 */
@property (nonatomic, readonly) TTIGestureRecognizerType gestureType;

/**
 CGRect in which the PanGesture can be started. If the user grabs the presented ViewController inside this rect, he can dismiss the ViewController. Every interaction outside of this rect will be ignores when using the TTIGestureRecognizerPullUpDown or TTIGestureRecognizerPullLeftRight gesture type.
 */
@property (nonatomic, readonly) CGRect rectForPanGestureToStart;

/**
 The point to which the presented ViewController will animate out.
 This animation may be a slide or a zoom, depending on what you set the gestureType to.
 */
@property (nonatomic, readonly) CGPoint toPoint;

@property (nonatomic, strong, readonly) UIViewController* _Nonnull presentedViewController;
NS_ASSUME_NONNULL_END
@end