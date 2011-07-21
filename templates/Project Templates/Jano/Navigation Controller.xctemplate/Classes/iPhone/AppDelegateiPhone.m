
//  Created by ___FULLUSERNAME___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.

#import "AppDelegateiPhone.h"

@implementation AppDelegateiPhone

@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = self.navigationController;
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)dealloc {
    [_navigationController release];
	[super dealloc];
}

@end
