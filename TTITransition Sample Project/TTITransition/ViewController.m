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
        _transitionDelegate.transitionType = TTITransitionTypeFull;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerPinch;
    }
    else if([segue.identifier isEqualToString:@"ShowOverlay"]) {
        _transitionDelegate.transitionType = TTITransitionTypeOverlay;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerPullUpDown;
        //Example for a toPoint
        _transitionDelegate.toPoint = CGPointMake(200, 200);
        
        //Set it here or in the presented UIViewController
        _transitionDelegate.rectForPanGestureToStart = CGRectMake(0, 0, 100, 100);
    }
    else if([segue.identifier isEqualToString:@"ShowSlide"]) {
        _transitionDelegate.transitionType = TTITransitionTypeSlide;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerLeftEdge;
    }
    else if([segue.identifier isEqualToString:@"ShowFold"]) {
        _transitionDelegate.transitionType = TTITransitionTypeFold;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerLeftEdge;
    }
    else if([segue.identifier isEqualToString:@"ShowFallIn"]) {
        _transitionDelegate.transitionType = TTITransitionTypeFallIn;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerPanToEdge;
        _transitionDelegate.toPoint = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 0);
    }
    else if([segue.identifier isEqualToString:@"ShowSpinn"]) {
        _transitionDelegate.transitionType = TTITransitionTypeSpinn;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerPinch;
    }
    else if([segue.identifier isEqualToString:@"ShowScale"]) {
        _transitionDelegate.transitionType = TTITransitionTypeScale;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerPinch;
    }
    else if([segue.identifier isEqualToString:@"ShowHangIn"]) {
        _transitionDelegate.transitionType = TTITransitionTypeHangIn;
        _transitionDelegate.interactive = YES;
        _transitionDelegate.gestureType = TTIGestureRecognizerPullUpDown;
    }
    destination.transitioningDelegate = _transitionDelegate;
}

@end
