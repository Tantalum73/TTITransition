//
//  TTITransitioningDelegate.h
//  TravelTime
//
//  Created by Andreas Neusüß on 31.07.13.
//  Copyright (c) 2013 Andreas Neusüß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
    Set type of transition: overlay or transition that covers entire screen
*/
typedef enum TransitionType : NSInteger {
    TTIFullTransition,
    TTIOverlayTransition,
    TTISlideTransition,
    TTIFoldTransition,
    TTIHangInTransition,
    TTISpinnTransition,
    TTIScaleTransition
} TransitionType;

@interface TTITransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate, UIStateRestoring>

@property (nonatomic, strong) Class<UIObjectRestoration> objectRestorationClass;

/*
 A point from where the transition should start. The new ViewController will fly in from that point.
 */
@property (nonatomic) CGPoint fromPoint;

/*
 The size, that the new ViewController should have.
 Only works in TTIHangInTransition!
 */
@property (nonatomic, assign) CGSize sizeOfPresentedViewController;

/*
 The type of transition: overlay or transition that covers entire screen
 */
@property (nonatomic, assign) TransitionType transitionType;


@end
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

