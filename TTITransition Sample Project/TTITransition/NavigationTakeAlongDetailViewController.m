//
//  NavigationTakeAlongDetailViewController.m
//  TTITransition
//
//  Created by Andreas Neusüß on 26.09.15.
//  Copyright © 2015 Andreas Neusüß. All rights reserved.
//

#import "NavigationTakeAlongDetailViewController.h"

@interface NavigationTakeAlongDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *viewToTakeAlong;

@end

@implementation NavigationTakeAlongDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)takeAlongDataWithPopulatedFinalFramesForTakeAlongData:(TTITakeAlongData *)takeAlongDataToPopulate {
    takeAlongDataToPopulate.finalView = self.viewToTakeAlong;
}
@end
