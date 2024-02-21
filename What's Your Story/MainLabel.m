//
//  MainLabel.m
//  What's Your Story
//
//  Created by ByteDance on 2/21/24.
//

#import "MainLabel.h"

@implementation MainLabel

- (nonnull id)initWithText:(nonnull NSString *)text {
    self = [super init];
    if (self) {
        self.text = text;
        self.font = [UIFont systemFontOfSize:20];
        self.textColor = UIColor.whiteColor;
        self.textAlignment = NSTextAlignmentCenter;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

@end
