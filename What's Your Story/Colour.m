#import "Colour.h"

@implementation Color

+ (UIColor *)orangeColor {
    static UIColor *ORANGE = nil;
    if (ORANGE == nil) {
        ORANGE = [[UIColor alloc] initWithRed:235 / 255.0 green:155 / 255.0 blue:65 / 255.0 alpha:1];
    }
    return ORANGE;
}

+ (UIColor *)yellowColor {
    static UIColor *YELLOW = nil;
    if (YELLOW == nil) {
        YELLOW = [[UIColor alloc] initWithRed:250 / 255.0 green:235 / 255.0 blue:85 / 255.0 alpha:1];
    }
    return YELLOW;
}

+ (UIColor *)blueColor {
    static UIColor *BLUE = nil;
    if (BLUE == nil) {
        BLUE = [[UIColor alloc] initWithRed:86 / 255.0 green:167 / 255.0 blue:223 / 255.0 alpha:1];
    }
    return BLUE;
}

@end
