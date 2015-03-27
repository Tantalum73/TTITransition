//
//  DetailViewController.m
//  TTITransition
//
//  Created by Andreas Neusüß on 10.10.14.
//  Copyright (c) 2014 Andreas Neusüß. All rights reserved.
//

#import "DetailViewController.h"
#import "TTITransitioningDelegate.h"

@interface DetailViewController () {
    CGRect _rectForDismissGesture;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //touches inside of this rect will be able to start a TTIGestureRecognizerPullUpDown or TTIGestureRecognizerPullLeftRight gesture to dismiss the ViewController.
    //just a color to mark the spot.
    _rectForDismissGesture = CGRectMake(0, 0, 100, 100);
    UIView *targetRectView = [[UIView alloc] initWithFrame:_rectForDismissGesture];
    [targetRectView setBackgroundColor:UIColor.redColor];
    
    [self.view addSubview:targetRectView];
}

- (void)viewDidAppear:(BOOL)animated {

    //setting the rectForPanGestureToStart when everything is layed out
    if ([self.transitioningDelegate isKindOfClass:[TTITransitioningDelegate class]]) {
        TTITransitioningDelegate *delegate = (TTITransitioningDelegate *)self.transitioningDelegate;
        delegate.rectForPanGestureToStart = _rectForDismissGesture;
//        delegate.toPoint = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0, 0);
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
