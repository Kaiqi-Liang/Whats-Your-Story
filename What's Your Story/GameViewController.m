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

    self.story = [UILabel new];
    self.story.text = self.stories[self.index++];
    self.story.backgroundColor = Color.yellowColor;
    self.story.textColor = UIColor.blackColor;
    self.story.numberOfLines = 0;
    self.story.lineBreakMode = NSLineBreakByWordWrapping;
    self.story.textAlignment = NSTextAlignmentCenter;
    self.story.layer.cornerRadius = 10;
    self.story.layer.masksToBounds = YES;
    [self.view addSubview:self.story];
    self.story.translatesAutoresizingMaskIntoConstraints = NO;

    MainLabel *label = [[MainLabel alloc] initWithText:@"TELL A STORY ABOUT"];
    [self.view addSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-75],
        [self.story.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.story.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:25],
        [self.story.widthAnchor constraintEqualToConstant:300],
        [self.story.heightAnchor constraintEqualToConstant:100],
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
