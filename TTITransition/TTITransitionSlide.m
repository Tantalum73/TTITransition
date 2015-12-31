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
    if(!self.colorForBackgroundView) {
        self.colorForBackgroundView = [UIColor lightGrayColor];
    }
    backgroundView.backgroundColor = self.colorForBackgroundView;

    [inView insertSubview:backgroundView atIndex:0];
    
    toView = [toVC view];
    fromView = [fromVC view];
    
    
    if(self.scaleDownViewControllers <= 0.7) {
        self.scaleDownViewControllers = 0.8;
    }
    if(self.gapBetweenViewControllers == 0) {
        self.gapBetweenViewControllers = 20;
    }
    
    [inView insertSubview:toView atIndex:0];
//    [inView insertSubview:fromView atIndex:1];
    
    if (self.takeAlongController) {
        [self insertTakeAlongViewIntoContainerViewForContext:transitionContext];
    }
//    [fromView removeFromSuperview];
    [toView removeFromSuperview];
    
    toView.alpha = 1;
    UIView  *fromShot = [fromView snapshotViewAfterScreenUpdates:YES];
    UIView *toShot = [toView snapshotViewAfterScreenUpdates:YES];

    
    [inView insertSubview:fromShot aboveSubview:fromView];
//    [fromView removeFromSuperview];//when removed, the Gesture stops!
    fromView.alpha = 0;
    
    CGFloat slideToRight = -[UIScreen mainScreen].bounds.size.width+self.gapBetweenViewControllers;
    [inView addSubview:toShot];
//    [toView removeFromSuperview];

    CGAffineTransform scale = CGAffineTransformMakeScale(0.7, 0.7);
    CGAffineTransform slideLeft = CGAffineTransformMakeTranslation(slideToRight, 0);
    CGAffineTransform slideRight = CGAffineTransformMakeTranslation(-slideToRight, 0);
    
    toShot.transform = CGAffineTransformConcat(scale, self.open? slideRight : slideLeft);

    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:[self transitionDuration:transitionContext] animations:^{
            [self changeTakeAlongViews];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.1 animations:^{
            
            //marking the fromView small
            fromShot.transform = scale;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.7 animations:^{
            //sliding the views
            
            if(self.open) {
                fromShot.transform = CGAffineTransformConcat(fromShot.transform, slideLeft);
                toShot.transform = CGAffineTransformConcat(toShot.transform, slideLeft);
                
            }
            else {
                fromShot.transform = CGAffineTransformConcat(fromShot.transform, slideRight);
                toShot.transform = CGAffineTransformConcat(toShot.transform, slideRight);
            }
            
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            
            //making  the toView big
            toShot.transform = CGAffineTransformIdentity;
        }];
        
    } completion:^(BOOL finished) {
        
        if ([transitionContext transitionWasCancelled]) {
            [self takeAlongTransitionCancelled];
            fromView.alpha = 1;
            [inView addSubview:fromView];
            [fromShot removeFromSuperview];
            [toShot removeFromSuperview];
            
            [backgroundView removeFromSuperview];
            [transitionContext completeTransition:NO];
            
            
            self.interactive = NO;
        }
        else {
            [self removeAndCleanUptakeAlongViews];
            [inView addSubview:toView];
            [fromView removeFromSuperview];
            
            [fromShot removeFromSuperview];
            [toShot removeFromSuperview];
            
            [backgroundView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }

    }];
    
    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext]/3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
//        //making the fromView small
//        
//        fromShot.frame = CGRectInset(fromShot.frame, (1-self.scaleDownViewControllers) * fromShot.frame.size.width, (1-self.scaleDownViewControllers) * fromShot.frame.size.height);
//        
//    } completion:^(BOOL finished) {
//        
//        toShot.frame = [self rectWithOriginOffsetFromRect:fromShot.frame xOffset:self.open? (fromShot.frame.size.width + self.gapBetweenViewControllers) : (-fromShot.frame.size.width - self.gapBetweenViewControllers) yOffset:0];
//        
//        [inView addSubview:toShot];
//        
//        [UIView animateWithDuration:[self transitionDuration:transitionContext]/3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
//            //sliding the views
//            
//            if(self.open) {
//                fromShot.frame = [self rectWithOriginOffsetFromRect:fromShot.frame xOffset:slideToRight yOffset:0];
//                toShot.frame = [self rectWithOriginOffsetFromRect:fromShot.frame xOffset:[UIScreen mainScreen].bounds.size.width-self.gapBetweenViewControllers yOffset:0];
//            }
//            else {
//                fromShot.frame = [self rectWithOriginOffsetFromRect:fromShot.frame xOffset:-slideToRight yOffset:0];
//                toShot.frame = [self rectWithOriginOffsetFromRect:fromShot.frame xOffset:-[UIScreen mainScreen].bounds.size.width+self.gapBetweenViewControllers yOffset:0];
//            }
//            
//        } completion:^(BOOL finished) {
//            [fromShot removeFromSuperview];
//            
//            [UIView animateWithDuration:[self transitionDuration:transitionContext]/3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
//                //making  the toView big
//                toShot.frame = [UIScreen mainScreen].bounds;
//                
//            } completion:^(BOOL finished) {
//                if ([transitionContext transitionWasCancelled]) {
//                    fromView.alpha = 1;
//                    
////                    [inView addSubview:toView];
////                    [fromView removeFromSuperview];
//                    
//                    [fromShot removeFromSuperview];
//                    [toShot removeFromSuperview];
//                    
//                    [backgroundView removeFromSuperview];
//                    [transitionContext completeTransition:NO];
//                    
//                    
//                    self.interactive = NO;
//                }
//                else {
//                    [inView addSubview:toView];
//                    [fromView removeFromSuperview];
//                    
//                    [fromShot removeFromSuperview];
//                    [toShot removeFromSuperview];
//                    
//                    [backgroundView removeFromSuperview];
//                    [transitionContext completeTransition:YES];
//                }
//                
//                
//            }];
//            
//        }];
//    }];
  
    
    
}

-(void)animationEnded:(BOOL)transitionCompleted {
    
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

//-(CGRect)rectWithOriginOffsetFromRect:(CGRect)rect xOffset:(CGFloat)xOffset yOffset:(CGFloat)yOffset {
//    return CGRectMake(rect.origin.x + xOffset, rect.origin.y + yOffset, rect.size.width, rect.size.height);
//}
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
