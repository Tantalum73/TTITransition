//
//  TTITransitionSlide.h
//  TTITransition
//
//  Created by Andreas Neusüß on 25.10.14.
//  Copyright (c) 2014 Andreas Neusüß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTITransitioningDelegate.h"

@interface TTITransitionSlide : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) CGPoint fromPoint;
@property (nonatomic) BOOL open;
@property (nonatomic) CGFloat scaleDownViewControllers;
@property (nonatomic) CGFloat gapBetweenViewControllers;
/*
 The color of the background view that is shown while the transition takes place.
 Default: light gray.
 */
@property (nonatomic, strong) UIColor *colorForBackgroundView;
@end
