//
//  TTITakeAlongTransitionController.h
//  TTITransition
//
//  Created by Andreas Neusüß on 03.09.15.
//  Copyright © 2015 Andreas Neusüß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTITakeAlongData.h"

///Protocol that should be implemented by the presented ViewController that is part of a TakeAlong transition.
@protocol TTITakeAlongTransitionProtocolForPresented <NSObject>

///Setting up every missing information about the transition. Most important one: the final view.
-(void)takeAlongDataWithPopulatedFinalFramesForTakeAlongData:(TTITakeAlongData *)takeAlongDataToPopulate;

@end

///Protocol that should be implemented by the presenting ViewController that is part of a TakeAlong transition.
@protocol TTITakeAlongTransitionProtocolForPresenting <NSObject>

///An array of TTITakeAlongData objects that each holds information about one view that participates in the transitioning process.
-(NSArray<TTITakeAlongData*> *)dataForTakeAlongTransition;


@end


@interface TTITakeAlongTransitionController : NSObject

@property (nonatomic, weak) id<TTITakeAlongTransitionProtocolForPresented> delegateForPresented;
@property (nonatomic, weak) id<TTITakeAlongTransitionProtocolForPresenting> delegateForPreseting;


@end
