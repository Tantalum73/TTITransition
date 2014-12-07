//
//  TTITransitionScale.h
//  TTITransition
//
//  Created by Andreas Neusüß on 06.12.14.
//  Copyright (c) 2014 Andreas Neusüß. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTITransitioningDelegate.h"

@interface TTITransitionScale :NSObject  <UIViewControllerAnimatedTransitioning>

@property (nonatomic) CGPoint fromPoint;
@property (nonatomic) BOOL open;
/*
 The color of the background view that is shown while the transition takes place.
 Default: a light gray.
 */
@property (nonatomic, strong) UIColor *colorForBackgroundView;
@end