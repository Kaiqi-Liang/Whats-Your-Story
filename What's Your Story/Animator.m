#import "Animator.h"

@interface Animator ()

@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation Animator

+ (id)animator:(NSTimeInterval)duration {
    Animator *animator = [self new];
    animator.duration = duration;
    return animator;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext { 
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview: toView];
    toView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithSpringDuration:self.duration bounce:0.3 initialSpringVelocity:0.2 delay:0 options:0 animations:^{
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext { 
    return self.duration;
}

@end
