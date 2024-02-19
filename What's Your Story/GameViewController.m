//
//  GameViewController.m
//  What's Your Story
//
//  Created by ByteDance on 2/19/24.
//

#import "GameViewController.h"
static NSArray *STORIES = @[
    @[// makes you look bad
        @"something unfair that happened to you",
        @"an unpleasant chore that has been your responsibility",
        @"being sick",
        @"a time you broke something",
        @"a time you acted out of character",
        @"forgetting something important",
        @"someone you didn't get along with as a kid",
        @"having something taken or stolen from you",
        @"a time you felt like nothing was going your way",
        @"a time you felt lucky",
        @"a time you were wrong",
    ],
    @[ // boring
        @"a word or phrase you use all the time",
        @"a trend you once tried",
        @"a historical event you've lived through",
        @"a favourite thing in your home",
        @"a favourite piece of clothing",
        @"a time you got a really good deal",
        @"the last thing you purchased",
        @"an expensive purchase you made",
        @"an encounter with a ghost or other mysterious",
        @"seeing one of your favourite musical acts",
        @"how you're similar to your family members",
        @"how you're different to your family members",
        @"where you live",
        @"the oldest thing you own",
        @"what your ate for lunch at school",
        @"severe weather you've experienced",
        @"a work of art you love",
    ],
    @[// too corporate
        @"winning",
        @"losing",
        @"being in charge",
        @"a favourite teacher",
        @"a project helped complete",
        @"a first day of a new job",
        @"playing sports",
        @"one of your first work experiences",
        @"one of your heroes and how they've inspired you",
        @"some bad advice you've received",
        @"some great advice you've received",
        @"a favourite class in school",
        @"a time you felt immense gratitude",
        @"a time you fixed something",
        @"a cause you believe in",
        @"an achievement",
        @"learning something from a disappointment",
    ],
    @[// friend
        @"trying something new",
        @"learning something new",
        @"a secret",
        @"a routine or ritual you enjoy",
        @"your first crush",
        @"falling in love",
    ],
    @[// relationship
        @"getting lost",
        @"one of your biggest pet peeves",
        @"a favourite scent or smell",
        @"a scary dream",
        @"a dream you've had more than once",
        @"a hiding place",
        @"a risk you've taken",
        @"a mishap in the kitchen",
        @"a family holiday tradition",
        @"a interesting encounter with a stranger",
        @"a time you had to go to the hospital",
        @"a time you surprised someone",
        @"a time you were surprised",
        @"a time you were misunderstood",
        @"a time you broke the rules",
        @"a time you felt nervous",
        @"a time you felt scared",
        @"a time you felt awkward",
        @"a time you felt sad",
        @"a time you felt extremely excited",
        @"a character from a book or movie you identify with",
        @"an embarrassing moment",
        @"something you miss",
        @"something you're bad at",
        @"something that makes you cry",
        @"what your childhood bedroom looked like",
        @"your best friend from childhood",
        @"how you spent summers as a child",
        @"how you met someone you're close to",
        @"getting into trouble",
        @"where you grew up",
        @"something you won't eat",
        @"changing your mind",
    ],
    @[// first date
        @"an adventure you've been on",
        @"an unusual food you've tried",
        @"a famous place you've been to",
        @"a now-closed place you wish still existed",
        @"a favourite place to visit",
        @"a favourite city",
        @"a favourite hobby",
        @"a favourite toy or stuffed animal from childhood",
        @"a favourite spot in your childhood home",
        @"a favourite comfort food",
        @"a memorable dish or meal you've cooked",
        @"a memorable meal",
        @"a memorable trip you took as a child",
        @"a memorable vacation",
        @"a memorable costume you wore",
        @"a memorable encounter with an animal",
        @"a memento you wish you'd saved",
        @"a time you laughed so hard you cried",
        @"a time you felt really happy",
        @"a time you stayed up all night or really late",
        @"a perfect day you had",
        @"a favourite snack",
        @"a movie you've seen more than once",
        @"a nickname you got from your friends or family",
        @"a trip you took by yourself",
        @"a road trip you've taken",
        @"a great gift you've given",
        @"a great gift you've received",
        @"a song or album that holds great meaning for you",
        @"a sporting event you've attended",
        @"a game or activity you enjoyed as a child",
        @"a song you loved as a child",
        @"what you were afraid of as a child",
        @"what job you thought you would have",
        @"what you wanted to be when you grew up",
        @"doing something yourself for the first time",
        @"something that makes you laugh",
        @"something you wish you could do over",
        @"the longest trip you've taken",
        @"one of your birthday parties",
        @"one of your earliest memories",
        @"one of your favourite childhood outfits",
        @"travelling far from home",
        @"something most people don't know about you",
        @"something that always makes you laugh",
        @"how you got your name",
        @"something you're good at",
        @"something beautiful you've experienced",
        @"being in nature",
        @"being part of a club or a team",
        @"seeing a celebrity",
        @"one of your first pets",
        @"first day of school",
        @"reading a favourite book for the first time",
        @"mustering up the courage to do something hard",
    ],
];

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
