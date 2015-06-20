//
//  TTIFallIn.m
//  TTITransition
//
//  Created by Andreas Neusüß on 27.03.15.
//  Copyright (c) 2015 Andreas Neusüß. All rights reserved.
//

#import "TTITransitionController.h"
@interface TTITransitionController () <UIDynamicAnimatorDelegate>

@property (nonatomic, readwrite, strong) TTITransitioningDelegate *ttiTransitioningDelegate;

@property (nonatomic, readwrite) CGPoint fromPoint;

@property (nonatomic, assign, readwrite) CGSize sizeOfPresentedViewController;

@property (nonatomic, assign, readwrite) TTITransitionType transitionType;

@property (nonatomic, getter=isInteractive, readwrite) BOOL interactive;

@property (nonatomic, readwrite) TTIGestureRecognizerType gestureType;

@property (nonatomic, readwrite) CGRect rectForPanGestureToStart;

@property (nonatomic, readwrite) CGPoint toPoint;

@property (nonatomic, strong, readwrite) UIViewController *presentedViewController;

@end


@implementation TTITransitionController {
}


-(instancetype)initWithPresentedViewController:(UIViewController *) presentedViewController

                                transitionType:(TTITransitionType) transitionType
                                     fromPoint:(CGPoint) fromPoint toPoint:(CGPoint) toPoint withSize:(CGSize) sizeOfPresentedViewController
                                   interactive:(BOOL)interactive
                                   gestureType:(TTIGestureRecognizerType) gestureType
                            rectToStartGesture:(CGRect) rectForPanGestureToStart {
    
    if (self = [super init]) {
        
        //setting up the internal TTITransitioningDdelegate
        self.ttiTransitioningDelegate = [[TTITransitioningDelegate alloc] init];
        self.ttiTransitioningDelegate.fromPoint = fromPoint;
        self.ttiTransitioningDelegate.sizeOfPresentedViewController = sizeOfPresentedViewController;
        self.ttiTransitioningDelegate.transitionType = transitionType;
        self.ttiTransitioningDelegate.interactive = interactive;
        self.ttiTransitioningDelegate.gestureType = gestureType;
        self.ttiTransitioningDelegate.rectForPanGestureToStart = rectForPanGestureToStart;
        self.ttiTransitioningDelegate.toPoint = toPoint;
        
        //setting the internal TTITransitioningDelagte as transitioningDelegate of the presented ViewController
        presentedViewController.transitioningDelegate = self.ttiTransitioningDelegate;
        
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
        
        if (transitionType == TTITransitionTypeFold || transitionType == TTITransitionTypeSlide || transitionType == TTITransitionTypeScale || transitionType == TTITransitionTypeOverlay) {
            
            presentedViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        }
        
        //storing the attributes
        self.presentedViewController = presentedViewController;
        self.transitionType = transitionType;
        self.fromPoint = fromPoint;
        self.toPoint = toPoint;
        self.sizeOfPresentedViewController = sizeOfPresentedViewController;
        self.interactive = interactive;
        self.gestureType = gestureType;
        self.rectForPanGestureToStart = rectForPanGestureToStart;
        
        
    
        return self;
    }
    
    return nil;
}


@end
