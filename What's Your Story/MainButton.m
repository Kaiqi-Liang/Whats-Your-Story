//
//  MainButton.m
//  What's Your Story
//
//  Created by ByteDance on 2/20/24.
//

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
        [self setConfiguration:configuration];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}
    
@end
