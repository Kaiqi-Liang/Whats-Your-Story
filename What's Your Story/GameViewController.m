#import "GameViewController.h"
#import "StoryDataSource.h"
#import "MainButton.h"
#import "MainLabel.h"
#import "Colour.h"

@interface GameViewController ()

@property (nonatomic, copy) NSArray<NSNumber *> *categories;
@property (nonatomic, strong) NSMutableArray<NSString *> *stories;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) UILabel *story;
@property (nonatomic, strong) MainButton *button;

@end

@implementation GameViewController

+ (id)gameViewControllerWithCategories:(NSArray<NSNumber *> *)categories {
    GameViewController *gameViewController = [self new];
    gameViewController.categories = categories;
    gameViewController.stories = [NSMutableArray new];
    gameViewController.index = 0;
    return gameViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    for (uint8_t i = 0; i < self.categories.count; ++i) {
        if ([self.categories[i] boolValue]) {
            [self.stories addObjectsFromArray:STORIES[i]];
        }
    }
    for (uint8_t i = self.stories.count; i > 1; --i) {
        [self.stories exchangeObjectAtIndex:i - 1 withObjectAtIndex:arc4random_uniform(i)];
    }

    self.button = [[MainButton alloc] initWithTitle:@"Next"];
    [self.button addTarget:self action:@selector(nextStory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.button];

    MainLabel *label = [[MainLabel alloc] initWithText:@"TELL A STORY ABOUT"];
    [self.view addSubview:label];

    UIView *storyContainer = [UIView new];
    storyContainer.backgroundColor = Color.yellowColor;
    storyContainer.layer.cornerRadius = 10;
    storyContainer.layer.masksToBounds = YES;
    storyContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:storyContainer];

    self.story = [UILabel new];
    self.story.text = self.stories[self.index++];
    self.story.textColor = UIColor.blackColor;
    self.story.numberOfLines = 0;
    self.story.lineBreakMode = NSLineBreakByWordWrapping;
    self.story.textAlignment = NSTextAlignmentCenter;
    self.story.translatesAutoresizingMaskIntoConstraints = NO;
    [storyContainer addSubview:self.story];

    CGFloat padding = 20;
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-75],
        [storyContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [storyContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:25],
        [storyContainer.widthAnchor constraintEqualToConstant:300],
        [self.story.topAnchor constraintEqualToAnchor:storyContainer.topAnchor constant:padding],
        [self.story.bottomAnchor constraintEqualToAnchor:storyContainer.bottomAnchor constant:-padding],
        [self.story.leadingAnchor constraintEqualToAnchor:storyContainer.leadingAnchor constant:padding],
        [self.story.trailingAnchor constraintEqualToAnchor:storyContainer.trailingAnchor constant:-padding],
        [self.button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.button.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-(self.view.bounds.size.height * 0.05)],
    ]];
}

- (void)nextStory {
    if (self.index < self.stories.count) {
        self.story.text = self.stories[self.index++];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No more stories in the selected categories" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIPopoverPresentationController *presentationController = [alert popoverPresentationController];
        presentationController.sourceView = self.button;
        [alert addAction:[UIAlertAction actionWithTitle:@"Go Back" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
