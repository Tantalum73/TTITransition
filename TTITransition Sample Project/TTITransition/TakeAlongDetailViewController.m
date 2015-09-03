//
//  TakeAlongDetailViewController.m
//  TTITransition
//
//  Created by Andreas Neusüß on 03.09.15.
//  Copyright © 2015 Andreas Neusüß. All rights reserved.
//

#import "TakeAlongDetailViewController.h"

@interface TakeAlongDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewToTakeAlong;

@end

@implementation TakeAlongDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)takeAlongDataWithPopulatedFinalFramesForTakeAlongData:(TTITakeAlongData *)takeAlongDataToPopulate {
    
    takeAlongDataToPopulate.finalView = self.viewToTakeAlong;
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
