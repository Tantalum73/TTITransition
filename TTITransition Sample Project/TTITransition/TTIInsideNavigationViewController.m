//
//  InsideNavigationViewController.m
//  TTITransition
//
//  Created by Andreas Neusüß on 23.08.15.
//  Copyright © 2015 Andreas Neusüß. All rights reserved.
//

#import "TTIInsideNavigationViewController.h"
#import "TTITransitionController.h"

@interface TTIInsideNavigationViewController () {
    TTITransitionController *_transitionController;
}

@end

@implementation TTIInsideNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ShowFold"]) {
        _transitionController = [[TTITransitionController alloc] initNavigationControllerTransitionWithNavigationController:self.navigationController transitionType:TTINavigationControllerTransitionTypeFold];
    }
    else if ([segue.identifier isEqualToString:@"ShowScale"]) {
        _transitionController = [[TTITransitionController alloc] initNavigationControllerTransitionWithNavigationController:self.navigationController transitionType:TTINavigationControllerTransitionTypeScale];
    }
    else if ([segue.identifier isEqualToString:@"ShowFull"]) {
        _transitionController = [[TTITransitionController alloc] initNavigationControllerTransitionWithNavigationController:self.navigationController transitionType:TTINavigationControllerTransitionTypeFull];
    }
    
}
- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
