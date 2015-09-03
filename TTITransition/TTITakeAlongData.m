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
    
    self.finalFrame = newValue.frame;
    self.finalViewCopy = [newValue snapshotViewAfterScreenUpdates:YES];
    self.finalViewCopy.frame = newValue.frame;
    
    _finalView = newValue;
    _finalView.frame = self.finalFrame;
}
-(void)setInitialView:(UIView *)newValue {
    self.initialFrame = newValue.frame;
    self.initialViewCopy = [newValue snapshotViewAfterScreenUpdates:YES];
    self.initialViewCopy.frame = newValue.frame;
    
    _initialView = newValue;
    _initialView.frame = self.initialFrame;
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
