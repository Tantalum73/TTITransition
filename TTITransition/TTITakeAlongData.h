//
//  TTITakeAlongData.h
//  TTITransition
//
//  Created by Andreas Neusüß on 03.09.15.
//  Copyright © 2015 Andreas Neusüß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///The class that stores properties for the take along transition. Create a new instance of this for every single view you want to animate.
@interface TTITakeAlongData : NSObject
///Initial view that is part of the presenting ViewController. Animating this view. Set in the initializer.

@property (nonatomic, strong, readonly) UIView *initialView;

///A copy of the initialView that was made using snapShotAfterViewUpdate:. It is used to animate the transition.
@property (nonatomic, strong, readonly) UIView *initialViewCopy;

///Final view that is part of the presented ViewController. Animating to this view.  Set this value, using the takeAlongDataWithPopulatedFinalFramesForTakeAlongData: method of the TTITakeAlongTransitionProtocolForPresented protocol.
@property (nonatomic, strong) UIView *finalView;

///A copy of the finalView that was made using snapShotAfterViewUpdate:. It is used to animate the transition.
@property (nonatomic, strong, readonly) UIView *finalViewCopy;

///A key to identify the views.
@property (nonatomic, strong, readonly) NSString *key;

///Initial frame of the view that is animated. Set when you specify the initialView.
@property (nonatomic, readonly) CGRect initialFrame;

///Final frame of the view that is animated. Set when you specify the finalView.
@property (nonatomic, readonly) CGRect finalFrame;

///Init with a view that you want to animate and give it a key to find this view.
-(instancetype) initWithInitialView:(UIView *)view key:(NSString *)key NS_DESIGNATED_INITIALIZER;

///Init whith a initial and a final view. inly use this if you know about both the final and initial view.
-(instancetype) initWithInitialView:(UIView *)view key:(NSString *)key finalView:(UIView *)finalView;


@end
