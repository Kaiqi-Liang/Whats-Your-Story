//
//  GameViewController.m
//  What's Your Story
//
//  Created by ByteDance on 2/19/24.
//

#import "GameViewController.h"

@interface GameViewController ()
@property NSArray<NSNumber *> *categories;
@property NSMutableArray<NSString *> *stories;
@property NSUInteger index;
@property UILabel *story;
@end

@implementation GameViewController

+ (id) gameViewController:(NSArray<NSNumber *> *)categories {
    GameViewController *gameViewController = [self new];
    gameViewController.categories = categories;
    gameViewController.stories = [NSMutableArray new];
    gameViewController.index = 0;
    return gameViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    for (uint8_t i = 0; i < self.categories.count; ++i) {
        if ([self.categories[i] boolValue]) {
            [self.stories addObjectsFromArray:STORIES[i]];
        }
    }
    for (uint8_t i = self.stories.count; i > 1; --i) {
        [self.stories exchangeObjectAtIndex:i - 1 withObjectAtIndex:arc4random_uniform(i)];
    }

    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    configuration.title = @"Next";
    configuration.contentInsets = NSDirectionalEdgeInsetsMake(10, 20, 10, 20);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor redColor];
    [button setConfiguration:configuration];
    [button addTarget:self action:@selector(nextStory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [button.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:self.view.bounds.size.height * 0.35],
    ]];

    self.story = [UILabel new];
    self.story.text = self.stories[self.index++];
    self.story.numberOfLines = 0;
    self.story.lineBreakMode = NSLineBreakByWordWrapping;
    self.story.textColor = UIColor.whiteColor;
    self.story.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.story];
    self.story.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat sideMargin = self.view.bounds.size.width * 0.15;
    [NSLayoutConstraint activateConstraints:@[
        [self.story.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.story.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.story.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:sideMargin],
        [self.story.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.view.trailingAnchor constant:-sideMargin],
    ]];
}

- (void)nextStory {
    if (self.index < self.stories.count) {
        self.story.text = self.stories[self.index++];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
