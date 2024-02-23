#import "ViewController.h"
#import "GameViewController.h"
#import "TableViewController.h"
#import "MainButton.h"
#import "MainLabel.h"
#define NUM_OF_STORIES 6

@interface ViewController ()

@property NSMutableArray<NSNumber *> *categories;
@property MainButton *button;
@property MainLabel *label;
@property UIButton *help;
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
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [self.constraints removeAllObjects];
    CGFloat sideMargin = size.width * 0.15;
    [self.constraints addObjectsFromArray:@[
        [self.label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.label.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:(size.height * 0.01)],
        [self.label.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:sideMargin],
        [self.label.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.view.trailingAnchor constant:-sideMargin],
        [self.button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.button.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-(size.height * 0.05)],
        [self.help.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-(size.height * 0.05)],
        [self.help.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-sideMargin],
        [self.help.widthAnchor constraintEqualToAnchor:self.button.heightAnchor],
        [self.help.heightAnchor constraintEqualToAnchor:self.button.heightAnchor],
    ]];

    for (uint8_t i = 0; i < NUM_OF_STORIES; ++i) {
        [self.constraints addObjectsFromArray:@[
            [self.checkboxes[i].centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
            [self.checkboxes[i].centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:size.height * (i - 2.5) / 15],
        ]];
    }
    [NSLayoutConstraint activateConstraints:self.constraints];
}

- (void)viewDidLoad {
    // TODO: add animation
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
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

    // TODO: put them in a collection view
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

    self.help = [UIButton new];
    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    [configuration setAttributedTitle: [[NSMutableAttributedString alloc] initWithString:@"?"
                                                                              attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:18],
        NSForegroundColorAttributeName: UIColor.whiteColor,
    }]];
    [self.help setConfiguration:configuration];
    self.help.backgroundColor = UIColor.redColor;
    [self.help addTarget:self action:@selector(goToHelpPage) forControlEvents:UIControlEventTouchUpInside];
    self.help.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.help];

    [self setupConstraintsWithSize:self.view.bounds.size];
}

- (void )viewDidLayoutSubviews {
    self.help.layer.cornerRadius = self.help.frame.size.width / 2;
    self.help.clipsToBounds = YES;
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

- (void)goToHelpPage {
    [self.navigationController pushViewController:[[TableViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
}

@end
