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
    UIView *inView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *toView;
    UIView *fromView;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    }
    else {
        toView = [toVC view];
        fromView = [fromVC view];
    }
    
    if(self.open) {
        toView.frame = fromView.frame;
        
        
        // Add the snapshot view and animate its appearance
        //[inView insertSubview:_intermediateView aboveSubview:fromView];
        fromView.layer.anchorPoint = CGPointMake(0, 0);
        fromView.frame = [transitionContext initialFrameForViewController:fromVC];
        
        
        
        UIImageView *blurredTo = [self imageViewWithBlurredImageFromView:toView];
        [inView insertSubview:blurredTo belowSubview:fromView];
        [inView insertSubview:toView belowSubview:blurredTo];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
            fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
            
            fromView.layer.opacity = 1.0f;
            
            blurredTo.layer.opacity = 0.0f;
            
            
            CATransform3D transform = CATransform3DMakeRotation(M_PI/2, 0, 1, 0);
            transform.m34 = 0.2/180.0;
            CATransform3D inverseTransformation = CATransform3DInvert(transform);
            fromView.layer.transform = inverseTransformation;
            
            
            
        }completion:^(BOOL finished) {
            
            
            [blurredTo removeFromSuperview];
            [fromView removeFromSuperview];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
        
    }
    
    else {
        toView.frame = [transitionContext finalFrameForViewController:toVC];
        
        UIImageView *blurredFrom = [self imageViewWithBlurredImageFromView:fromView];
        blurredFrom.layer.opacity = 0.0f;
        [inView addSubview:blurredFrom];
        
        fromView.layer.opacity = 1.0f;
        
        [inView insertSubview:fromView belowSubview:blurredFrom];
        [inView addSubview:fromView];
        
//        [inView insertSubview:toView aboveSubview:toVxiew];
        [inView addSubview:toView];
        
        toView.layer.opacity = 1.0f;
        
        CATransform3D transform = CATransform3DMakeRotation(M_PI/2, 0, 1, 0);
        transform.m34 = 0.2/180.0;
        CATransform3D inverseTransformation = CATransform3DInvert(transform);
        
        if(!CATransform3DEqualToTransform(toView.layer.transform, inverseTransformation)) {
            
            toView.layer.anchorPoint = CGPointMake(0, 0);
            toView.frame = [transitionContext initialFrameForViewController:fromVC];
            
            
            toView.layer.transform = inverseTransformation;
        }
        
       
//        toView.frame = fromView.frame;
//        toView.layer.transform = CATransform3DIdentity;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:0  animations:^{
            
            CATransform3D transform = CATransform3DMakeRotation(0, 0, 1, 0);
            transform.m43 = 0.2/180.0;
            toView.layer.transform = transform;
            
            blurredFrom.layer.opacity = 1.0f;
            
            fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        }completion:^(BOOL finished) {
            
//            toView.frame = fromView.frame;
            toView.layer.transform = CATransform3DIdentity;
            
                [fromView removeFromSuperview];
                [inView addSubview:toView];
                [blurredFrom removeFromSuperview];
                
                [transitionContext completeTransition:YES];
            
                
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
