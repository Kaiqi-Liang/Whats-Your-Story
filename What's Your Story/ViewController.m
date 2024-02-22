//
//  ViewController.m
//  What's Your Story
//
//  Created by ByteDance on 2/14/24.
//

#import "ViewController.h"
#import "GameViewController.h"
#import "MainButton.h"
#import "MainLabel.h"
#define NUM_OF_STORIES 6

@interface ViewController ()

@property NSMutableArray<NSNumber *> *categories;
@property MainButton *button;
@property MainLabel *label;
@property NSMutableArray<UIButton *> *checkboxes;
@property NSMutableArray<NSLayoutConstraint *> *constraints;

@end

@implementation ViewController
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void)setupConstraintsWithSize:(CGSize)size {
    // TODO: this does not work
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [self.constraints removeAllObjects];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.label
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0
                                                                         constant:size.height * 0.1];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.button
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:-(size.height * 0.1)];
    CGFloat sideMargin = size.width * 0.15;
    [self.constraints addObjectsFromArray:@[
        [self.label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        topConstraint,
        [self.label.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:sideMargin],
        [self.label.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.view.trailingAnchor constant:-sideMargin],
        [self.button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        bottomConstraint,
    ]];

    for (uint8_t i = 0; i < NUM_OF_STORIES; ++i) {
        [self.constraints addObjectsFromArray:@[
            [self.checkboxes[i].centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
            [self.checkboxes[i].centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:size.height * (i - 2.5) / 10],
        ]];
    }
    [NSLayoutConstraint activateConstraints:self.constraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.constraints = [NSMutableArray new];
    self.categories = [NSMutableArray arrayWithCapacity:NUM_OF_STORIES];
    for (uint8_t i = 0; i < NUM_OF_STORIES; ++i) {
        [self.categories addObject:@NO];
    }

    self.label = [[MainLabel alloc] initWithText:@"Pick one or more categories of stories to tell"];
    [self.view addSubview:self.label];

    self.button = [[MainButton alloc] initWithTitle:@"Start"];
    [self.button addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];

    self.checkboxes = [NSMutableArray arrayWithCapacity:NUM_OF_STORIES];
    for (uint8_t i = 0; i < NUM_OF_STORIES; ++i) {
        UIButton *checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkboxButton setTitle:[NSString stringWithFormat:@"Category %d", i + 1] forState:UIControlStateNormal];
        [checkboxButton setBackgroundImage:[self imageWithColor:UIColor.tintColor] forState:UIControlStateSelected];
        [checkboxButton addTarget:self action:@selector(checkboxButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [checkboxButton setTag:i];
        [self.view addSubview:checkboxButton];
        checkboxButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.checkboxes[i] = checkboxButton;
    }
    [self setupConstraintsWithSize:self.view.bounds.size];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self setupConstraintsWithSize:size];
}

- (void)checkboxButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.categories[sender.tag] = sender.selected ? @YES : @NO;
}

- (void)startGame {
    if ([self.categories containsObject:@YES]) {
        [self.navigationController pushViewController:[GameViewController gameViewController:self.categories] animated:YES];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You need to select at least one categories" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
        UIPopoverPresentationController *presentationController = [alert popoverPresentationController];
        presentationController.sourceView = self.button;
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
