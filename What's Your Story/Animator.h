#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Animator : NSObject<UIViewControllerAnimatedTransitioning>

+ (id)animatorWithDuration:(NSTimeInterval)duration;

@end

