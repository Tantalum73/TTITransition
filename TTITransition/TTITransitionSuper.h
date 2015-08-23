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


@interface TTITransitionSuper : NSObject <UIViewControllerAnimatedTransitioning, UIStateRestoring>


@property (nonatomic, strong) _Nullable Class<UIObjectRestoration> objectRestorationClass;

@property (nonatomic) CGPoint fromPoint;
@property (nonatomic) BOOL open;

@property (nonatomic) BOOL interactive;//set, when gesture begins, before calling dismissVC...()
@property (nonatomic, strong) TTIPercentDrivenInteractionTransitionController* _Nullable  interactiveAnimator;

//@property (nonatomic) CGRect targetRect;
@property (nonatomic) CGPoint offscreenPoint;
@property (nonatomic, strong) _Nullable id<UIViewControllerContextTransitioning> context;
-(CGPoint)centerOfRect:(CGRect)rect;
@property (nonatomic) CGPoint toPoint;


@property (nonatomic, readwrite) CGFloat widthProportionOfSuperView;
@property (nonatomic, readwrite) CGFloat heightProportionOfSuperView;

-(void)applyBorderToView:(UIView *_Nonnull)view;
-(void)applyShadowEffectToView:(UIView *_Nonnull)view;

-(NSArray *_Nonnull)constraintsForBackgroundView:(UIView *_Nonnull)view;
-(NSArray *_Nonnull)constraintsForPresentedView:(UIView *_Nonnull)presented inView:(UIView *_Nonnull)inView widthProportion:(CGFloat) widthRatio heightProportion:(CGFloat) heightRatio;
@end
