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
@end
