//
//  TTITransitionViewControllerLeftEdgeGestureHandler.m
//  TTITransition
//
//  Created by Andreas Neusüß on 23.08.15.
//  Copyright © 2015 Andreas Neusüß. All rights reserved.
//

#import "TTITransitionNavigationControllerLeftEdgeGestureHandler.h"

@interface TTITransitionNavigationControllerLeftEdgeGestureHandler () {
    
}

@property (nonatomic, strong) UINavigationController* navigationController;
@property (nonatomic, strong) UIViewController* targetViewController;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer * gestureRecognizer;
@property (nonatomic, strong) TTITransitionSuper *animator;
@end

@implementation TTITransitionNavigationControllerLeftEdgeGestureHandler


- (instancetype) initWithTargetViewController:(UIViewController *)targetViewController insideOfNavigationController:(UINavigationController *) navigationController animator:(TTITransitionSuper *)animator {
    
    if (self = [super init]) {
        
        self.navigationController = navigationController;
        self.targetViewController = targetViewController;
        self.animator = animator;
        
        self.gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
        
        self.gestureRecognizer.edges = UIRectEdgeLeft;
        
        [self.targetViewController.view addGestureRecognizer:self.gestureRecognizer];

        
        return self;
    }
    return nil;
}

-(void) handlePopRecognizer:(UIScreenEdgePanGestureRecognizer *)recognizer {
    // Calculate how far the user has dragged across the view
    CGFloat progress = [recognizer translationInView:self.targetViewController.view].x / (self.targetViewController.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    static const float threshold = 0.35;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // Create a interactive transition and pop the view controller
        self.animator.interactive = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [self.animator.interactiveAnimator updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        self.animator.interactive = NO;
        if (progress > threshold) {
            [self.animator.interactiveAnimator finishInteractiveTransition];
        }
        else {
            [self.animator.interactiveAnimator cancelInteractiveTransition];
        }
        
    }

}
@end
