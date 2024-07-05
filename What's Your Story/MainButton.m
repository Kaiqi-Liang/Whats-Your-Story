#import "MainButton.h"

@implementation MainButton

- (id)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
        configuration.title = title;
        configuration.contentInsets = NSDirectionalEdgeInsetsMake(10, 20, 10, 20);
        self.backgroundColor = UIColor.redColor;
        self.tintColor = UIColor.whiteColor;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self setConfiguration:configuration];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addTarget:self action:@selector(selectAnimation) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)selectAnimation {
    UINotificationFeedbackGenerator *feedbackGenerator = [UINotificationFeedbackGenerator new];
    [feedbackGenerator notificationOccurred:UINotificationFeedbackTypeSuccess];
    CGPoint center = self.center;
    center.y -= 20;
    self.center = center;
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint center = self.center;
        center.y += 20;
        self.center = center;
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
