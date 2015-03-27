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

#import "TTITransitionSuper.h"

@interface TTIFallIn : TTITransitionSuper

/*
 Defines the size of the ViewController, that should be shown.
 Default size: 200x300.
 */
@property (nonatomic) CGSize sizeOfToViewController;

-(instancetype) initWithSizeOfToViewController:(CGSize)size;
@end