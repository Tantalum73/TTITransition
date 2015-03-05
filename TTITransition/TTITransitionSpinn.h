//
//  TTITransitionSpinn.h
//  TTITransition
//
//  Created by Andreas Neusüß on 30.11.14.
//  Copyright (c) 2014 Andreas Neusüß. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTITransitionSpinn : UIViewController <UIViewControllerAnimatedTransitioning>
@property (nonatomic) CGPoint fromPoint;
@property (nonatomic) BOOL open;
/*
 The color of the background view that is shown while the transition takes place.
 Default: light gray.
 */
@property (nonatomic, strong) UIColor *colorForBackgroundView;
@end
