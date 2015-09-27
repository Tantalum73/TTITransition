//
//  TTITakeAlongData.m
//  TTITransition
//
//  Created by Andreas Neusüß on 03.09.15.
//  Copyright © 2015 Andreas Neusüß. All rights reserved.
//

#import "TTITakeAlongData.h"

@interface TTITakeAlongData() {
    
}
@property (nonatomic, strong, readwrite) UIView *initialView;
@property (nonatomic, strong, readwrite) UIView *initialViewCopy;
@property (nonatomic, strong, readwrite) UIView *finalViewCopy;

@property (nonatomic, strong, readwrite) NSString *key;
@property (nonatomic, readwrite) CGRect finalFrame;
@property (nonatomic, readwrite) CGRect initialFrame;
@end

@implementation TTITakeAlongData

-(void)setFinalView:(UIView *)newValue {
    self.finalFrame = [newValue.superview convertRect:newValue.frame toView:nil];
    
#warning The next line will cause an log statement to occur. It will say that snappshotting an view before it is rendered is pointless. You can ignore the warning because it will work and the mentioned concerns are invalid. Just relax and continue working on your app.
    self.finalViewCopy = [newValue snapshotViewAfterScreenUpdates:NO];
    self.finalViewCopy.frame = self.finalFrame;
    
    _finalView = newValue;
//    _finalView.frame = self.finalFrame;
}
-(void)setInitialView:(UIView *)newValue {
    self.initialFrame = [newValue.superview convertRect:newValue.frame toView:nil];
    self.initialViewCopy = [newValue snapshotViewAfterScreenUpdates:NO];
    self.initialViewCopy.frame = self.initialFrame;
    
    _initialView = newValue;
//    _initialView.frame = self.initialFrame;
}

-(instancetype)initWithInitialView:(UIView *)view key:(NSString *)key {
    if (self = [super init]) {
        self.initialView = view;
        self.key = key;
    }
    return self;
}
-(instancetype)initWithInitialView:(UIView *)view key:(NSString *)key finalView:(UIView *)finalView {
    if (self = [self initWithInitialView:view key:key]) {
        self.finalView = finalView;
    }
    return self;
}


@end
