#import "ModalViewController.h"

@interface ModalViewController ()

@end

@implementation ModalViewController

- (id)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [backgroundView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissModalView:)]];
        [self.view addSubview:backgroundView];

        CGSize popupSize = CGSizeMake(300, 200);
        UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, popupSize.width, popupSize.height)];
        popupView.backgroundColor = UIColor.blackColor;
        popupView.layer.cornerRadius = 10;
        popupView.center = self.view.center;
        popupView.clipsToBounds = YES;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(popupView.bounds, 20, 20)];
        label.text = text;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:24];
        label.numberOfLines = 0;
        [popupView addSubview:label];
        [self.view addSubview:popupView];
    }
    return self;
}

- (void)dismissModalView:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.view.subviews.firstObject.frame = UIScreen.mainScreen.bounds; // This is the backgroundView which should cover the whole screen.
        UIView *popupView = self.view.subviews.lastObject; // Assuming popupView was added last.
        popupView.center = CGPointMake(size.width / 2, size.height / 2);
    } completion:nil];
}

@end
