#import "ViewController.h"
#import "GameViewController.h"
#import "TableViewController.h"
#import "MainButton.h"
#import "MainLabel.h"
#import "CollectionViewController.h"
#import "StoryDataSource.h"

@interface ViewController () <MainViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray<NSNumber *> *categories;
@property (nonatomic, strong) MainButton *button;
@property (nonatomic, strong) MainLabel *label;
@property (nonatomic, strong) UIButton *help;
@property (nonatomic, strong) NSMutableArray<UIButton *> *checkboxes;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *constraints;
@property (nonatomic, strong) CollectionViewController *collectionViewController;

@end

@implementation ViewController

- (CGFloat)collectionHeightThatWillFit:(NSInteger)cells {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewController.collectionView.collectionViewLayout;
    return cells * layout.itemSize.height + (cells - 1) * layout.minimumInteritemSpacing;
}

- (void)setupConstraintsWithSize:(CGSize)size {
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [self.constraints removeAllObjects];
    CGFloat verticalMargin = size.height * 0.05;
    CGFloat horizontalMargin = size.width * 0.15;
    CGFloat height = [self collectionHeightThatWillFit:size.height < 700 ? 4 : 6];
    CGFloat width = 200;
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        height = [self collectionHeightThatWillFit:size.height > 450 ? 3 : 2];
        width = 500;
    }
    [self.constraints addObjectsFromArray:@[
        [self.label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.label.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:(size.height * 0.01)],
        [self.label.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:horizontalMargin],
        [self.label.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.view.trailingAnchor constant:-horizontalMargin],
        [self.button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.button.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-verticalMargin],
        [self.help.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-verticalMargin],
        [self.help.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-horizontalMargin],
        [self.help.widthAnchor constraintEqualToAnchor:self.button.heightAnchor],
        [self.help.heightAnchor constraintEqualToAnchor:self.button.heightAnchor],
        [self.collectionViewController.view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.collectionViewController.view.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.collectionViewController.view.widthAnchor constraintEqualToConstant:width],
        [self.collectionViewController.view.heightAnchor constraintEqualToConstant:height],
    ]];

    [NSLayoutConstraint activateConstraints:self.constraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    self.constraints = [NSMutableArray new];
    self.categories = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"categories"] mutableCopy];
    if (self.categories == nil) {
        self.categories = [NSMutableArray arrayWithCapacity:STORIES.count];
    }
    for (uint8_t i = 0; i < STORIES.count; ++i) {
        [self.categories addObject:@NO];
    }

    self.label = [[MainLabel alloc] initWithText:@"Pick one or more categories of stories to tell"];
    [self.view addSubview:self.label];

    self.button = [[MainButton alloc] initWithTitle:@"Start"];
    [self.button addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];

    self.collectionViewController = [CollectionViewController new];
    self.collectionViewController.delegate = self;
    [self addChildViewController:self.collectionViewController];
    [self.view addSubview:self.collectionViewController.view];
    [self.collectionViewController didMoveToParentViewController:self];
    self.collectionViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

    self.help = [UIButton new];
    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    [configuration setAttributedTitle: [[NSMutableAttributedString alloc] initWithString:@"?"
                                                                              attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:20],
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

- (void)didSelectItemAtIndex:(NSInteger)index {
    self.categories[index] = @YES;
    [[NSUserDefaults standardUserDefaults] setObject:self.categories forKey:@"categories"];
}

- (void)didDeselectItemAtIndex:(NSInteger)index {
    self.categories[index] = @NO;
    [[NSUserDefaults standardUserDefaults] setObject:self.categories forKey:@"categories"];
}

- (void)startGame {
    if ([self.categories containsObject:@YES]) {
        [self.navigationController pushViewController:[GameViewController gameViewControllerWithCategories:self.categories] animated:YES];
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
