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
    CAGradientLayer *_backgroundGradient;
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
    
    
    targetRectView.layer.cornerRadius = 10;
    
    CAGradientLayer *gradientForTargetRect = [[CAGradientLayer alloc] init];
    gradientForTargetRect.frame = targetRectView.frame;
    
    gradientForTargetRect.colors = @[(id)[UIColor colorWithRed:255.0/255.0 green:81.0/255.0 blue:47.0/255.0 alpha:1].CGColor, (id)[UIColor colorWithRed:221.0/255.0 green:36.0/255.0 blue:118.0/255.0 alpha:1].CGColor];
    [targetRectView.layer insertSublayer:gradientForTargetRect atIndex:0];
    
    targetRectView.clipsToBounds = YES;
    [self.view addSubview:targetRectView];

    
    
    _backgroundGradient = [[CAGradientLayer alloc] init];
    _backgroundGradient.frame = self.view.frame;
    _backgroundGradient.colors = @[(id)[UIColor colorWithRed:236.0/255.0 green:111.0/255.0 blue:102.0/255.0 alpha:1].CGColor, (id)[UIColor colorWithRed:243.0/255.0 green:161.0/255.0 blue:131.0/255.0 alpha:1].CGColor];
    
    [self.view.layer insertSublayer:_backgroundGradient atIndex:0];
    self.view.clipsToBounds = YES;
    
    //just a question of taste...
//    self.view.layer.cornerRadius = 10;
}

-(void)viewDidLayoutSubviews {
    _backgroundGradient.frame = self.view.bounds;
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
