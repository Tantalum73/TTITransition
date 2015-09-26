//
//  NavigationTakeAlongViewController.m
//  TTITransition
//
//  Created by Andreas Neusüß on 26.09.15.
//  Copyright © 2015 Andreas Neusüß. All rights reserved.
//

#import "NavigationTakeAlongViewController.h"

@interface NavigationTakeAlongViewController ()  {
    TTITransitionController *_ttitransitionController;
    UIView *_aView;
}
@property (weak, nonatomic) IBOutlet UIImageView *viewToTakeAlong;

@end

@implementation NavigationTakeAlongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if (![segue.destinationViewController respondsToSelector:@selector(takeAlongDataWithPopulatedFinalFramesForTakeAlongData:)]) {
        return;
    }
    
    if([segue.identifier isEqualToString:@"ShowFold"]) {
        _ttitransitionController = [[TTITransitionController alloc] initNavigationControllerTransitionWithTakeAlongElementsInNavigationController:self.navigationController presentedViewController:segue.destinationViewController presentingViewController:self transitionType:TTINavigationControllerTransitionTypeFold];
        
        //[[TTITransitionController alloc] initTakeAlongTransitionWithPresentedViewController:segue.destinationViewController presentingViewController:self transitionType:TTITransitionTypeFold fromPoint:CGPointZero toPoint:CGPointZero widthProportionOfSuperView:1 heightProportionOfSuperView:1 interactive:YES gestureType:TTIGestureRecognizerLeftEdge rectToStartGesture:CGRectZero];
        
        //

        
    }

}
-(NSArray<TTITakeAlongData *> *)dataForTakeAlongTransition {
    TTITakeAlongData *data = [[TTITakeAlongData alloc] initWithInitialView:self.viewToTakeAlong key:@"viewToTakeAlong"];
    
    return @[data];
}

@end
