//
//  TTINavigationControllerTransitioningDelegate.h
//  TTITransition
//
//  Created by Andreas Neusüß on 23.08.15.
//  Copyright © 2015 Andreas Neusüß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTIGestureController.h"


/*
 Set type of transition.
 */
typedef NS_ENUM(NSInteger, TTINavigationControllerTransitionType) {
    TTINavigationControllerTransitionTypeFull,
    TTINavigationControllerTransitionTypeSlide,
    TTINavigationControllerTransitionTypeFold,
    TTINavigationControllerTransitionTypeSpinn,
    TTINavigationControllerTransitionTypeScale
};



@interface TTINavigationControllerTransitioningDelegate : NSObject <UINavigationControllerDelegate>

@property (nonatomic, strong) _Nullable Class<UIObjectRestoration> objectRestorationClass;


/*
 The type of transition: overlay or transition that covers entire screen
 */
@property (nonatomic, assign) TTINavigationControllerTransitionType transitionType;

@property (nonatomic, strong) TTITakeAlongTransitionController * _Nullable takeAlongController;

@end
