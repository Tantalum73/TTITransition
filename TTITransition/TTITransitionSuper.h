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
#import "TTITakeAlongTransitionController.h"
#import "TTITakeAlongData.h"

@interface TTITransitionSuper : NSObject <UIViewControllerAnimatedTransitioning, UIStateRestoring>


@property (nonatomic, strong) _Nullable Class<UIObjectRestoration> objectRestorationClass;

@property (nonatomic) CGPoint fromPoint;
@property (nonatomic) BOOL open;

@property (nonatomic) BOOL interactive;//set, when gesture begins, before calling dismissVC...()
@property (nonatomic, strong) TTIPercentDrivenInteractionTransitionController* _Nullable  interactiveAnimator;

//@property (nonatomic) CGRect targetRect;
@property (nonatomic) CGPoint offscreenPoint;
-(CGPoint)centerOfRect:(CGRect)rect;
@property (nonatomic) CGPoint toPoint;


@property (nonatomic, readwrite) CGFloat widthProportionOfSuperView;
@property (nonatomic, readwrite) CGFloat heightProportionOfSuperView;

@property (nonatomic, weak)_Nullable id<UIViewControllerContextTransitioning>transitioningContext;
@property (nonatomic, strong, readonly) UIView  * _Nullable inView;
@property (nonatomic, strong, readonly) UIViewController  * _Nullable toVC;
@property (nonatomic, strong, readonly) UIViewController  * _Nullable fromVC;
@property (nonatomic, strong, readonly) UIView  * _Nullable toView;
@property (nonatomic, strong, readonly) UIView  * _Nullable fromView;

-(void)prepareAnimationWithTransitionContext:(id<UIViewControllerContextTransitioning> _Nonnull)transitioningContext;

-(void)applyBorderToView:(UIView *_Nonnull)view;
-(void)applyShadowEffectToView:(UIView *_Nonnull)view;

-(NSArray *_Nonnull)constraintsForBackgroundView:(UIView *_Nonnull)view;
-(NSArray *_Nonnull)constraintsForPresentedView:(UIView *_Nonnull)presented inView:(UIView *_Nonnull)inView widthProportion:(CGFloat) widthRatio heightProportion:(CGFloat) heightRatio;

#pragma mark - Take Along Transition
///The Take Along Transition Controller. Used to store the delegate handling.
@property (nonatomic, strong) TTITakeAlongTransitionController * _Nullable takeAlongController;
///Values, that have come from the TTITakeAlongTransitionController.
@property (nonatomic, strong) NSMutableArray<TTITakeAlongData*> *_Nullable takeAlongDataArray;

///Setting up the take along views for transitioning.
-(void)insertTakeAlongViewIntoContainerViewForContext:(_Nonnull id<UIViewControllerContextTransitioning>)context;

///Performing the update of the take along views.
-(void)changeTakeAlongViews;
///Finishing the transition of the take along views ans doing some cleanup.
-(void)removeAndCleanUptakeAlongViews;

-(void)takeAlongTransitionCancelled;

-(void)animateTakeAlongViews;

@end
