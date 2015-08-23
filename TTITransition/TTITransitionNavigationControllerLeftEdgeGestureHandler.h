//
//  TTITransitionViewControllerLeftEdgeGestureHandler.h
//  TTITransition
//
//  Created by Andreas Neusüß on 23.08.15.
//  Copyright © 2015 Andreas Neusüß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTITransitionSuper.h"

@interface TTITransitionNavigationControllerLeftEdgeGestureHandler : NSObject

- (instancetype) initWithTargetViewController:(UIViewController *)targetViewController insideOfNavigationController:(UINavigationController *) navigationController animator:(TTITransitionSuper *)animator;

@end
