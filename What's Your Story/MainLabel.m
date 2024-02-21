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
        self.font = [UIFont systemFontOfSize:20];
        self.text = text;
        self.textColor = UIColor.whiteColor;
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.textAlignment = NSTextAlignmentCenter;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

@end
