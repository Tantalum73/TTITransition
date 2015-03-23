//
//  TTIHangIn.h
//  TTITransition
//
//  Created by Andreas Neusüß on 21.11.14.
//  Copyright (c) 2014 Andreas Neusüß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTITransitioningDelegate.h"

#import "TTITransitionSuper.h"

@interface TTIHangIn : TTITransitionSuper

/*
 Defines the size of the ViewController, that should be shown.
 Default size: 200x300.
 */
@property (nonatomic) CGSize sizeOfToViewController;

-(instancetype) initWithSizeOfToViewController:(CGSize)size;
@end