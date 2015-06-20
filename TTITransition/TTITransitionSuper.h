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

@property (nonatomic) BOOL interactive;//set, when gesture begins, before calling dismissVC...()
@property (nonatomic, strong) TTIPercentDrivenInteractionTransitionController *interactiveAnimator;

//@property (nonatomic) CGRect targetRect;
@property (nonatomic) CGPoint offscreenPoint;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> context;
-(CGPoint)centerOfRect:(CGRect)rect;
@property (nonatomic) CGPoint toPoint;

-(void)applyBorderToView:(UIView *)view;
-(void)applyShadowEffectToView:(UIView *)view;

-(NSArray *)constraintsForBackgroundView:(UIView *)view;
-(NSArray *)constraintsForPresentedView:(UIView *)presented inView:(UIView *)inView withSize:(CGSize) size;
@end
