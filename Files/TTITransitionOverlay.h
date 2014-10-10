//
//  TTITransition.h
//  TravelTime
//
//  Created by Andreas Neusüß on 31.07.13.
//  Copyright (c) 2013 Andreas Neusüß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTITransitioningDelegate.h"

@interface TTITransitionOverlay : NSObject <UIViewControllerAnimatedTransitioning, UIDynamicAnimatorDelegate>
@property (nonatomic) CGPoint fromPoint;
@property (nonatomic) BOOL open;
@end
