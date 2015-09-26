//
//  TTIFallIn.m
//  TTITransition
//
//  Created by Andreas Neusüß on 27.03.15.
//  Copyright (c) 2015 Andreas Neusüß. All rights reserved.
//

#import "TTITransitionController.h"


@interface TTITransitionController () <UIDynamicAnimatorDelegate>
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, readwrite, strong) TTITransitioningDelegate *_Nullable ttiTransitioningDelegate;

@property (nonatomic, readwrite, strong) TTINavigationControllerTransitioningDelegate *_Nullable ttiNavigationControllerTransitioningDelegate;

@property (nonatomic, readwrite) CGPoint fromPoint;

@property (nonatomic, assign, readwrite) CGSize sizeOfPresentedViewController;

@property (nonatomic, assign, readwrite) TTITransitionType transitionType;

@property (nonatomic, getter=isInteractive, readwrite) BOOL interactive;

@property (nonatomic, readwrite) TTIGestureRecognizerType gestureType;

@property (nonatomic, readwrite) CGRect rectForPanGestureToStart;

@property (nonatomic, readwrite) CGPoint toPoint;

@property (nonatomic, weak, readwrite) UIViewController* _Nullable presentedViewController;

@property (nonatomic, readwrite) CGFloat widthProportionOfSuperView;
@property (nonatomic, readwrite) CGFloat heightProportionOfSuperView;

@property (nonatomic, readwrite) TTITakeAlongTransitionController * _Nullable takeAlongTransitionController;

@end


@implementation TTITransitionController {
}


-(instancetype _Nullable)initModalTransitionWithPresentedViewController:(UIViewController* ) presentedViewController

                                          transitionType:(TTITransitionType) transitionType
                                               fromPoint:(CGPoint) fromPoint
                                                 toPoint:(CGPoint) toPoint
                              widthProportionOfSuperView: (CGFloat) widthProportionOfSuperView
                             heightProportionOfSuperView: (CGFloat) heightProportionOfSuperView
                                             interactive:(BOOL)interactive
                                             gestureType:(TTIGestureRecognizerType) gestureType
                                      rectToStartGesture:(CGRect) rectForPanGestureToStart {
    
    if (self = [super init]) {
        
        if (!presentedViewController) {
            return nil;
        }
        
        //setting up the internal TTITransitioningDdelegate
        self.ttiTransitioningDelegate = [[TTITransitioningDelegate alloc] init];
        self.ttiTransitioningDelegate.fromPoint = fromPoint;

        self.ttiTransitioningDelegate.transitionType = transitionType;
        self.ttiTransitioningDelegate.interactive = interactive;
        self.ttiTransitioningDelegate.gestureType = gestureType;
        self.ttiTransitioningDelegate.rectForPanGestureToStart = rectForPanGestureToStart;
        self.ttiTransitioningDelegate.toPoint = toPoint;
        self.ttiTransitioningDelegate.widthProportionOfSuperView = widthProportionOfSuperView;
        self.ttiTransitioningDelegate.heightProportionOfSuperView = heightProportionOfSuperView;
        
        //setting the internal TTITransitioningDelagte as transitioningDelegate of the presented ViewController
        presentedViewController.transitioningDelegate = self.ttiTransitioningDelegate;
        
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
        
        
        if (transitionType == TTITransitionTypeFold || transitionType == TTITransitionTypeSlide || transitionType == TTITransitionTypeScale || transitionType == TTITransitionTypeOverlay) {
            
            presentedViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        
//        NSLog(@"Width Ratio: %f, HeightRatio: %f", widthProportionOfSuperView, heightProportionOfSuperView);
        
        //storing the attributes
        self.presentedViewController = presentedViewController;
        self.transitionType = transitionType;
        self.fromPoint = fromPoint;
        self.toPoint = toPoint;
        self.interactive = interactive;
        self.gestureType = gestureType;
        self.rectForPanGestureToStart = rectForPanGestureToStart;
        self.widthProportionOfSuperView = widthProportionOfSuperView;
        self.heightProportionOfSuperView = heightProportionOfSuperView;
        
    
        return self;
    }
    
    return nil;
}

-(instancetype _Nullable) initNavigationControllerTransitionWithNavigationController:(UINavigationController *)navigationController transitionType:(TTINavigationControllerTransitionType)transitionType {
    
    if (self = [super init]) {
        
        self.ttiNavigationControllerTransitioningDelegate = [[TTINavigationControllerTransitioningDelegate alloc] init];
        
        self.ttiNavigationControllerTransitioningDelegate.transitionType = transitionType;
        
        navigationController.delegate = self.ttiNavigationControllerTransitioningDelegate;

        return self;
    }
    return nil;
}

- (instancetype _Nullable)initNavigationControllerTransitionWithTakeAlongElementsInNavigationController:(UINavigationController *)navigationController presentedViewController:(UIViewController<TTITakeAlongTransitionProtocolForPresented> *)presentedViewController presentingViewController:(UIViewController<TTITakeAlongTransitionProtocolForPresenting> *)presentingViewController transitionType:(TTINavigationControllerTransitionType)transitionType {
    
    self = [self initNavigationControllerTransitionWithNavigationController:navigationController transitionType:transitionType];
    if (!self) {
        return nil;
    }
    
    self.takeAlongTransitionController = [[TTITakeAlongTransitionController alloc] init];
    self.takeAlongTransitionController.delegateForPresented = presentedViewController;
    self.takeAlongTransitionController.delegateForPreseting = presentingViewController;

    self.ttiNavigationControllerTransitioningDelegate.takeAlongController = self.takeAlongTransitionController;
    
    return self;
}

-(instancetype _Nullable)initModalTakeAlongTransitionWithPresentedViewController:(UIViewController<TTITakeAlongTransitionProtocolForPresented> *)presentedViewController presentingViewController:(UIViewController<TTITakeAlongTransitionProtocolForPresenting> *)presentingViewController transitionType:(TTITransitionType)transitionType fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint widthProportionOfSuperView:(CGFloat)widthProportionOfSuperView heightProportionOfSuperView:(CGFloat)heightProportionOfSuperView interactive:(BOOL)interactive gestureType:(TTIGestureRecognizerType)gestureType rectToStartGesture:(CGRect)rectForPanGestureToStart {
    
    self = [self initModalTransitionWithPresentedViewController:presentedViewController transitionType:transitionType fromPoint:fromPoint toPoint:toPoint widthProportionOfSuperView:widthProportionOfSuperView heightProportionOfSuperView:heightProportionOfSuperView interactive:interactive gestureType:gestureType rectToStartGesture:rectForPanGestureToStart];
    if (!self) {
        return nil;
    }
    
    
    self.takeAlongTransitionController = [[TTITakeAlongTransitionController alloc] init];
    self.takeAlongTransitionController.delegateForPresented = presentedViewController;
    self.takeAlongTransitionController.delegateForPreseting = presentingViewController;
    
    self.ttiTransitioningDelegate.takeAlongController = self.takeAlongTransitionController;
    
    
    
    return self;
}
NS_ASSUME_NONNULL_END
@end
