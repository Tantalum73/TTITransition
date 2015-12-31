//
//  TTITransitionFold.m
//  TTITransition
//
//  Created by Andreas Neusüß on 21.11.14.
//  Copyright (c) 2014 Andreas Neusüß. All rights reserved.
//

#import "TTITransitionFold.h"
#import "UIImage+ImageEffects.h"

/*Works best under UINavigationBar or above UIToolbar*/

@implementation TTITransitionFold

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    [self prepareAnimationWithTransitionContext:transitionContext];
    
    if(self.open) {
        self.toView.frame = self.fromView.frame;
        
        
        // Add the snapshot view and animate its appearance
        //[inView insertSubview:_intermediateView aboveSubview:fromView];
        self.fromView.layer.anchorPoint = CGPointMake(0, 0);
        self.fromView.frame = [transitionContext initialFrameForViewController:self.fromVC];
        
        [self.inView insertSubview:self.toView belowSubview:self.fromView];
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
        }
        
        UIImageView *blurredTo = [self imageViewWithBlurredImageFromView:self.toView];
        [self.inView insertSubview:blurredTo aboveSubview:self.toView];
//        [inView insertSubview:toView belowSubview:blurredTo];
        
        
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
            self.fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            self.toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
            
            self.fromView.layer.opacity = 1.0f;
            
            blurredTo.layer.opacity = 0.0f;
            
            
            CATransform3D transform = CATransform3DMakeRotation(M_PI/2, 0, 1, 0);
            transform.m34 = 0.2/180.0;
            CATransform3D inverseTransformation = CATransform3DInvert(transform);
            self.fromView.layer.transform = inverseTransformation;
            
            [self changeTakeAlongViews];
            
            
        }completion:^(BOOL finished) {
            self.interactiveAnimator = [TTIPercentDrivenInteractionTransitionController new];
            
            [blurredTo removeFromSuperview];
            [self.fromView removeFromSuperview];
            [self removeAndCleanUptakeAlongViews];
            
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
        
    }
    
    else {
        self.toView.frame = [transitionContext finalFrameForViewController:self.toVC];
        
        
        
        if (self.takeAlongController) {
            [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
        }
        
        UIImageView *blurredFrom = [self imageViewWithBlurredImageFromView:self.fromView];
        blurredFrom.layer.opacity = 0.0f;
        [self.inView addSubview:blurredFrom];
        
        self.fromView.layer.opacity = 1.0f;
        
        [self.inView insertSubview:self.fromView belowSubview:blurredFrom];
//        [inView addSubview:fromView];
        
//        [inView insertSubview:toView aboveSubview:toVxiew];
        [self.inView addSubview:self.toView];
        
        self.toView.layer.opacity = 1.0f;
        
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:0  animations:^{
            [self changeTakeAlongViews];
            self.toView.layer.transform = CATransform3DIdentity;//transform;
            
            
            blurredFrom.layer.opacity = 1.0f;
            
//            fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            self.toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        }completion:^(BOOL finished) {
            
            
            
            if ([transitionContext transitionWasCancelled]) {
                [self takeAlongTransitionCancelled];
                [self.toView removeFromSuperview];
                //[fromView removeFromSuperview];
                [blurredFrom removeFromSuperview];
                self.fromView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
                self.fromView.transform = CGAffineTransformIdentity;
                [transitionContext completeTransition:NO];
                
                
                self.interactive = NO;

            }
            else {
                
                [self removeAndCleanUptakeAlongViews];
                
                self.toView.layer.transform = CATransform3DIdentity;
                [self.fromView removeFromSuperview];
                [self.inView addSubview:self.toView];
                [blurredFrom removeFromSuperview];
                
                [transitionContext completeTransition:YES];
                
                self.interactiveAnimator = nil;
            }

            
                
        }];
    }
    
    
}


-(void)animationEnded:(BOOL)transitionCompleted {
    
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8f;
}

-(UIImageView *)imageViewWithBlurredImageFromView:(UIView *)view {
    // Create a new context the size of the frame
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0);
    
    // Render the view
    //[view.layer drawInContext:context];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Get the image from the context
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Cleanup the context you created
    UIGraphicsEndImageContext();
    
    UIImage *blurredImage = [renderedImage applyStandardBlurForTourTime];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:blurredImage];
    imageView.frame = CGRectMake(0, 64, imageView.frame.size.width, imageView.frame.size.height);
    
    
    return imageView;
}
@end
