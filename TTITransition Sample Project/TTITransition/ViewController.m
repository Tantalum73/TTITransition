//
//  ViewController.m
//  TTITransition
//
//  Created by Andreas Neusüß on 10.10.14.
//  Copyright (c) 2014 Andreas Neusüß. All rights reserved.
//

#import "ViewController.h"
#import "TTITransitioningDelegate.h"

@interface ViewController () {
    //Important to store this variable as long as the new ViewController is presented.
    TTITransitioningDelegate *_transitionDelegate;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *destination = segue.destinationViewController;
    
    _transitionDelegate = [TTITransitioningDelegate new];
    _transitionDelegate.fromPoint = CGPointMake(self.view.frame.origin.x+(self.view.frame.size.width/2), self.view.frame.origin.y+(self.view.frame.size.height/2));
    
    if([segue.identifier isEqualToString:@"ShowFull"]) {
        _transitionDelegate.transitionType = TTIFullTransition;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerPinch;
    }
    else if([segue.identifier isEqualToString:@"ShowOverlay"]) {
        
        _transitionDelegate.transitionType = TTIOverlayTransition;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerPinch;
    }
    else if([segue.identifier isEqualToString:@"ShowSlide"]) {
        
        _transitionDelegate.transitionType = TTISlideTransition;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerLeftEdge;
    }
    else if([segue.identifier isEqualToString:@"ShowFold"]) {
        /*Works best under UINavigationBar or above UIToolbar*/
        _transitionDelegate.transitionType = TTIFoldTransition;
    }
    else if([segue.identifier isEqualToString:@"ShowHangIn"]) {
        
        _transitionDelegate.transitionType = TTIHangInTransition;
    }
    else if([segue.identifier isEqualToString:@"ShowSpinn"]) {
        
        _transitionDelegate.transitionType = TTISpinnTransition;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerPinch;
    }
    else if([segue.identifier isEqualToString:@"ShowScale"]) {
        
        _transitionDelegate.transitionType = TTIScaleTransition;
    }
    destination.transitioningDelegate = _transitionDelegate;
}

@end
