
//  Created by ___FULLUSERNAME___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window=_window;

#pragma mark - UIApplicationDelegate

// 1st called on start
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self.window makeKeyAndVisible];
    return YES;
}

// 2nd called on START
// 2nd called when pressing HOME
- (void)applicationDidBecomeActive:     (UIApplication *)application {}

// 1st called when pressing HOME
- (void)applicationWillResignActive:    (UIApplication *)application {}

// 2nd called when pressing HOME
- (void)applicationDidEnterBackground:  (UIApplication *)application {}

// 1st called when coming back from HOME
- (void)applicationWillEnterForeground: (UIApplication *)application {}

// called before application EXIT due to a call or being killed by iOS
- (void)applicationWillTerminate:       (UIApplication *)application {}

#pragma mark - Instance lifecycle

- (void)dealloc {
    [_window release];
    [super dealloc];
}

@end