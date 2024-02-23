#import "SceneDelegate.h"
#import "ViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene * windowScene = [[UIWindowScene alloc] initWithSession:session connectionOptions:connectionOptions];
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];
}

@end
