//
//  TakeAlongMasterViewController.m
//  TTITransition
//
//  Created by Andreas Neusüß on 03.09.15.
//  Copyright © 2015 Andreas Neusüß. All rights reserved.
//

#import "TakeAlongMasterViewController.h"

@interface TakeAlongMasterViewController () {
    TTITransitionController *_ttitransitionController;
}
@property (weak, nonatomic) IBOutlet UIView *viewToTakeAlong;

@end

@implementation TakeAlongMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    CGPoint fromPoint = CGPointMake(self.view.frame.origin.x+(self.view.frame.size.width/2), self.view.frame.origin.y+(self.view.frame.size.height/2));
    
    if([segue.identifier isEqualToString:@"ShowSlide"] && [segue.destinationViewController respondsToSelector:@selector(takeAlongDataWithPopulatedFinalFramesForTakeAlongData:)]) {
        
        _ttitransitionController = [[TTITransitionController alloc] initTakeAlongTransitionWithPresentedViewController:segue.destinationViewController presentingViewController:self transitionType:TTITransitionTypeSlide fromPoint:fromPoint toPoint:fromPoint widthProportionOfSuperView:1 heightProportionOfSuperView:1 interactive:YES gestureType:TTIGestureRecognizerLeftEdge rectToStartGesture:CGRectZero];
    }
    else if([segue.identifier isEqualToString:@"ShowOverlay"] && [segue.destinationViewController respondsToSelector:@selector(takeAlongDataWithPopulatedFinalFramesForTakeAlongData:)]) {
        
        _ttitransitionController = [[TTITransitionController alloc] initTakeAlongTransitionWithPresentedViewController:segue.destinationViewController presentingViewController:self transitionType:TTITransitionTypeOverlay fromPoint:fromPoint toPoint:fromPoint widthProportionOfSuperView:0.8 heightProportionOfSuperView:0.5 interactive:YES gestureType:TTIGestureRecognizerLeftEdge rectToStartGesture:CGRectZero];
    }
    else if([segue.identifier isEqualToString:@"ShowFull"] && [segue.destinationViewController respondsToSelector:@selector(takeAlongDataWithPopulatedFinalFramesForTakeAlongData:)]) {
        
        _ttitransitionController = [[TTITransitionController alloc] initTakeAlongTransitionWithPresentedViewController:segue.destinationViewController presentingViewController:self transitionType:TTITransitionTypeFull fromPoint:fromPoint toPoint:fromPoint widthProportionOfSuperView:1 heightProportionOfSuperView:1 interactive:YES gestureType:TTIGestureRecognizerLeftEdge rectToStartGesture:CGRectZero];
    }
    else if([segue.identifier isEqualToString:@"ShowFold"] && [segue.destinationViewController respondsToSelector:@selector(takeAlongDataWithPopulatedFinalFramesForTakeAlongData:)]) {
        
        _ttitransitionController = [[TTITransitionController alloc] initTakeAlongTransitionWithPresentedViewController:segue.destinationViewController presentingViewController:self transitionType:TTITransitionTypeFold fromPoint:fromPoint toPoint:fromPoint widthProportionOfSuperView:1 heightProportionOfSuperView:1 interactive:YES gestureType:TTIGestureRecognizerLeftEdge rectToStartGesture:CGRectZero];
    }
    else if([segue.identifier isEqualToString:@"ShowFallInto"] && [segue.destinationViewController respondsToSelector:@selector(takeAlongDataWithPopulatedFinalFramesForTakeAlongData:)]) {
        
        _ttitransitionController = [[TTITransitionController alloc] initTakeAlongTransitionWithPresentedViewController:segue.destinationViewController presentingViewController:self transitionType:TTITransitionTypeFallIn fromPoint:fromPoint toPoint:fromPoint widthProportionOfSuperView:0.8 heightProportionOfSuperView:0.5 interactive:YES gestureType:TTIGestureRecognizerLeftEdge rectToStartGesture:CGRectZero];
    }
    else if([segue.identifier isEqualToString:@"ShowHangInto"] && [segue.destinationViewController respondsToSelector:@selector(takeAlongDataWithPopulatedFinalFramesForTakeAlongData:)]) {
        
        _ttitransitionController = [[TTITransitionController alloc] initTakeAlongTransitionWithPresentedViewController:segue.destinationViewController presentingViewController:self transitionType:TTITransitionTypeHangIn fromPoint:fromPoint toPoint:fromPoint widthProportionOfSuperView:0.8 heightProportionOfSuperView:0.5 interactive:YES gestureType:TTIGestureRecognizerLeftEdge rectToStartGesture:CGRectZero];
    }
    else if([segue.identifier isEqualToString:@"ShowSpinn"] && [segue.destinationViewController respondsToSelector:@selector(takeAlongDataWithPopulatedFinalFramesForTakeAlongData:)]) {
        
        _ttitransitionController = [[TTITransitionController alloc] initTakeAlongTransitionWithPresentedViewController:segue.destinationViewController presentingViewController:self transitionType:TTITransitionTypeSpinn fromPoint:fromPoint toPoint:fromPoint widthProportionOfSuperView:1 heightProportionOfSuperView:1 interactive:YES gestureType:TTIGestureRecognizerLeftEdge rectToStartGesture:CGRectZero];
    }
    else if([segue.identifier isEqualToString:@"ShowScale"] && [segue.destinationViewController respondsToSelector:@selector(takeAlongDataWithPopulatedFinalFramesForTakeAlongData:)]) {
        
        _ttitransitionController = [[TTITransitionController alloc] initTakeAlongTransitionWithPresentedViewController:segue.destinationViewController presentingViewController:self transitionType:TTITransitionTypeScale fromPoint:fromPoint toPoint:fromPoint widthProportionOfSuperView:1 heightProportionOfSuperView:1 interactive:YES gestureType:TTIGestureRecognizerLeftEdge rectToStartGesture:CGRectZero];
    }
    }

-(NSArray<TTITakeAlongData *> *)dataForTakeAlongTransition {
    TTITakeAlongData *data = [[TTITakeAlongData alloc] initWithInitialView:self.viewToTakeAlong key:@"viewToTakeAlong"];
    
    return @[data];
}

@end
