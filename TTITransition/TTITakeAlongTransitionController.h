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

@protocol TTITakeAlongTransitionProtocolForPresented <NSObject>


//-(CGRect)finalFrameForViewWithKey:(NSString *)key forOpening:(BOOL)opening;
-(void)takeAlongDataWithPopulatedFinalFramesForTakeAlongData:(TTITakeAlongData *)takeAlongDataToPopulate;

@end

@protocol TTITakeAlongTransitionProtocolForPresenting <NSObject>

//-(NSDictionary<NSString *, UIView *> *)viewsToBeAnimatedDuringTransitionForOpening:(BOOL)opening;
-(NSArray<TTITakeAlongData*> *)dataForTakeAlongTransition;


@end


@interface TTITakeAlongTransitionController : NSObject

@property (nonatomic, weak) id<TTITakeAlongTransitionProtocolForPresented> delegateForPresented;
@property (nonatomic, weak) id<TTITakeAlongTransitionProtocolForPresenting> delegateForPreseting;
//@property (nonatomic, strong) TTITransitioningDelegate *transitioningDelegate;

//-(instancetype) initWithDelegate:(id<TTITakeAlongTransitionProtocol>) delegate transitioningDelegate:(TTITransitioningDelegate *)transitioningDelegate NS_DESIGNATED_INITIALIZER;
@end
