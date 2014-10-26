//
//  TTITransitionSlide.m
//  TTITransition
//
//  Created by Andreas Neusüß on 25.10.14.
//  Copyright (c) 2014 Andreas Neusüß. All rights reserved.
//

#import "TTITransitionSlide.h"
#import "UIImage+ImageEffects.h"

@implementation TTITransitionSlide

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *inView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *toView;
    UIView *fromView;
    UIView *backgroundView = [[UIView alloc] initWithFrame:inView.frame];
    backgroundView.backgroundColor = [UIColor lightGrayColor];
    
    [inView insertSubview:backgroundView atIndex:0];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    }
    else {
        toView = [toVC view];
        fromView = [fromVC view];
    }
    
    if(self.scaleDownViewControllers <= 0.7) {
        self.scaleDownViewControllers = 0.8;
    }
    if(self.gapBetweenViewControllers == 0) {
        self.gapBetweenViewControllers = 20;
    }
    UIView  *fromShot = [fromView snapshotViewAfterScreenUpdates:YES];
    UIView *toShot = [toView snapshotViewAfterScreenUpdates:YES];
    
//
//    UIImageView *fromShot = [[UIImageView alloc] initWithImage:[self imageFromView:fromView]];
//    [inView addSubview:fromShot];
//    UIImageView *toShot = [[UIImageView alloc] initWithImage:[self imageFromView:toView]];
//
    
    [inView insertSubview:fromShot aboveSubview:fromView];
    [fromView removeFromSuperview];
    
    CGFloat slideToRight = -[UIScreen mainScreen].bounds.size.width+self.gapBetweenViewControllers;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]/3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        //making the fromView small
        
        fromShot.frame = CGRectInset(fromShot.frame, (1-self.scaleDownViewControllers) * fromShot.frame.size.width, (1-self.scaleDownViewControllers) * fromShot.frame.size.height);
        
    } completion:^(BOOL finished) {
        [inView addSubview:toShot];
        
        toShot.frame = [self rectWithOriginOffsetFromRect:fromShot.frame xOffset:self.open? (fromShot.frame.size.width + self.gapBetweenViewControllers) : (-fromShot.frame.size.width - self.gapBetweenViewControllers) yOffset:0];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]/3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            //sliding the views
            
            if(self.open) {
                fromShot.frame = [self rectWithOriginOffsetFromRect:fromShot.frame xOffset:slideToRight yOffset:0];
                toShot.frame = [self rectWithOriginOffsetFromRect:fromShot.frame xOffset:[UIScreen mainScreen].bounds.size.width-self.gapBetweenViewControllers yOffset:0];
            }
            else {
                fromShot.frame = [self rectWithOriginOffsetFromRect:fromShot.frame xOffset:-slideToRight yOffset:0];
                toShot.frame = [self rectWithOriginOffsetFromRect:fromShot.frame xOffset:-[UIScreen mainScreen].bounds.size.width+self.gapBetweenViewControllers yOffset:0];
            }
            
        } completion:^(BOOL finished) {
            [fromShot removeFromSuperview];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext]/3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                //making  the toView big
                toShot.frame = [UIScreen mainScreen].bounds;
                
            } completion:^(BOOL finished) {
                [inView addSubview:toView];
                [fromView removeFromSuperview];
                
                [fromShot removeFromSuperview];
                [toShot removeFromSuperview];
                
                [backgroundView removeFromSuperview];
                [transitionContext completeTransition:YES];
            }];
            
        }];
    }];
  
    
    
}

-(void)animationEnded:(BOOL)transitionCompleted {
    
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 2;
}

-(CGRect)rectWithOriginOffsetFromRect:(CGRect)rect xOffset:(CGFloat)xOffset yOffset:(CGFloat)yOffset {
    return CGRectMake(rect.origin.x + xOffset, rect.origin.y + yOffset, rect.size.width, rect.size.height);
}
-(void)applyShinyEffectsToView:(UIView *)view {
    view.layer.borderWidth = 4.0f;
    view.layer.borderColor = [UIColor lightTextColor].CGColor;
    
    view.layer.shadowRadius = 4.0f;
    view.layer.shadowOpacity = 0.6f;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(3, 3);
}
-(UIImage *)imageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
@end
