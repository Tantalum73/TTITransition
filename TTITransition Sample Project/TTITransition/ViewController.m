//
//  ViewController.m
//  TTITransition
//
//  Created by Andreas Neusüß on 10.10.14.
//  Copyright (c) 2014 Andreas Neusüß. All rights reserved.
//

#import "ViewController.h"
#import "TTITransitionController.h"

@interface ViewController () {
    //Important to store this variable as long as the new ViewController is presented.
//    TTITransitioningDelegate *_transitionDelegate;
    TTITransitionController *_transitionController;
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
    
    
    CGPoint fromPoint = CGPointMake(self.view.frame.origin.x+(self.view.frame.size.width/2), self.view.frame.origin.y+(self.view.frame.size.height/2));
    
    
    
    if([segue.identifier isEqualToString:@"ShowFull"]) {
        _transitionController = [[TTITransitionController alloc]
                                 initWithPresentedViewController:destination
                                 transitionType:TTITransitionTypeFull
                                 fromPoint:fromPoint
                                 toPoint:CGPointZero
                                 withSize:CGSizeZero
                                 interactive:YES
                                 gestureType:TTIGestureRecognizerPinch
                                 rectToStartGesture:CGRectZero];
    }
    else if([segue.identifier isEqualToString:@"ShowOverlay"]) {
        _transitionController = [[TTITransitionController alloc]
                                 initWithPresentedViewController:destination
                                 transitionType:TTITransitionTypeOverlay
                                 fromPoint:fromPoint
                                 toPoint:CGPointMake(200, 200)
                                 withSize:CGSizeZero
                                 interactive:YES gestureType:TTIGestureRecognizerPullUpDown
                                 rectToStartGesture:CGRectMake(0, 0, 100, 100)];
        
    }
    else if([segue.identifier isEqualToString:@"ShowSlide"]) {
        _transitionController = [[TTITransitionController alloc]
                                 initWithPresentedViewController:destination
                                 transitionType:TTITransitionTypeSlide
                                 fromPoint:fromPoint
                                 toPoint:CGPointZero
                                 withSize:CGSizeZero
                                 interactive:YES
                                 gestureType:TTIGestureRecognizerLeftEdge
                                 rectToStartGesture:CGRectZero];
        
    }
    else if([segue.identifier isEqualToString:@"ShowFold"]) {
        _transitionController = [[TTITransitionController alloc]
                                 initWithPresentedViewController:destination
                                 transitionType:TTITransitionTypeFold
                                 fromPoint:fromPoint
                                 toPoint:CGPointZero
                                 withSize:CGSizeZero
                                 interactive:YES
                                 gestureType:TTIGestureRecognizerLeftEdge
                                 rectToStartGesture:CGRectZero];
        
    }
    else if([segue.identifier isEqualToString:@"ShowFallIn"]) {
        _transitionController = [[TTITransitionController alloc]
                                 initWithPresentedViewController:destination
                                 transitionType:TTITransitionTypeFallIn
                                 fromPoint:fromPoint
                                 toPoint:CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 0)
                                 withSize:CGSizeZero
                                 interactive:YES
                                 gestureType:TTIGestureRecognizerPanToEdge
                                 rectToStartGesture:CGRectZero];
    }
    else if([segue.identifier isEqualToString:@"ShowSpinn"]) {
        
        _transitionController = [[TTITransitionController alloc]
                                 initWithPresentedViewController:destination
                                 transitionType:TTITransitionTypeSpinn
                                 fromPoint:fromPoint
                                 toPoint:CGPointZero
                                 withSize:CGSizeZero
                                 interactive:YES
                                 gestureType:TTIGestureRecognizerPinch
                                 rectToStartGesture:CGRectZero];
        
    }
    else if([segue.identifier isEqualToString:@"ShowScale"]) {
        
        _transitionController = [[TTITransitionController alloc]
                                 initWithPresentedViewController:destination
                                 transitionType:TTITransitionTypeScale
                                 fromPoint:fromPoint
                                 toPoint:CGPointZero
                                 withSize:CGSizeZero
                                 interactive:YES
                                 gestureType:TTIGestureRecognizerPinch
                                 rectToStartGesture:CGRectZero];
        
    }
    else if([segue.identifier isEqualToString:@"ShowHangIn"]) {
        
        _transitionController = [[TTITransitionController alloc]
                                 initWithPresentedViewController:destination
                                 transitionType:TTITransitionTypeHangIn
                                 fromPoint:fromPoint
                                 toPoint:CGPointZero
                                 withSize:CGSizeZero
                                 interactive:YES
                                 gestureType:TTIGestureRecognizerPullUpDown
                                 rectToStartGesture:CGRectZero];
        
    }
    
}

@end
