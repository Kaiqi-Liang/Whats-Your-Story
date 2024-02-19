//
//  ViewController.m
//  What's Your Story
//
//  Created by ByteDance on 2/14/24.
//

#import "ViewController.h"
#import "GameViewController.h"
#define NUM_OF_STORIES 6

@interface ViewController ()
@property NSMutableArray<NSNumber *> *categories;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categories = [NSMutableArray arrayWithCapacity:NUM_OF_STORIES];
    for (uint8_t i = 0; i < NUM_OF_STORIES; ++i) {
        [self.categories addObject:@NO];
    }

    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    configuration.title = @"Start";
    configuration.contentInsets = NSDirectionalEdgeInsetsMake(10, 20, 10, 20);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor redColor];
    [button setConfiguration:configuration];
    [button addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [button.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:self.view.bounds.size.height * 0.35],
    ]];

    for (uint8_t i = 0; i < NUM_OF_STORIES; ++i) {
        // TODO: add labels on top of the checkboxes
        UIButton *checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkboxButton setTitle:@"\u2B1C" forState:UIControlStateNormal]; // Empty box unicode
        [checkboxButton setTitle:@"\u2705" forState:UIControlStateSelected]; // Checkmark unicode
        [checkboxButton addTarget:self action:@selector(checkboxButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [checkboxButton setTag:i];
        [self.view addSubview:checkboxButton];
        checkboxButton.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [checkboxButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
            [checkboxButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:self.view.bounds.size.height * (i - 3) / 10],
        ]];
    }
}

- (void)checkboxButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.categories[sender.tag] = sender.selected ? @YES : @NO;
}

- (void)startGame {
    if ([self.categories containsObject:@YES]) {
        [self.navigationController pushViewController:[GameViewController gameViewController:self.categories] animated:YES];
    } else {
        // TODO: tell the user they need to select at least one category
    }
}

@end
