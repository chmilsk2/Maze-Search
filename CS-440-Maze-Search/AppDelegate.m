//
//  AppDelegate.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/23/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "AppDelegate.h"
#import "BasicPathfindingViewController.h"
#import "SearchWithDifferentCostFunctionsViewController.h"
#import "SearchWithMultipleDotsViewController.h"
#import "SuboptimalSearchViewController.h"

#define BASIC_PATH_FINDING_TAB_BAR_TITLE @"1.1"
#define SEARCH_WITH_DIFFERENT_COST_FUNCTIONS_TAB_BAR_TITLE @"1.2"
#define SEARCH_WITH_MULTIPLE_DOTS_TAB_BAR_TITLE @"1.3"
#define SUBOPTIMAL_SEARCH_TAB_BAR_TITLE @"1.4"

@implementation AppDelegate {
	UITabBarController *_tabController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	BasicPathfindingViewController *basicPathfindingViewController = [[BasicPathfindingViewController alloc] init];
	SearchWithDifferentCostFunctionsViewController *searchWithDifferentCostFunctionsViewController = [[SearchWithDifferentCostFunctionsViewController alloc] init];
	SearchWithMultipleDotsViewController *searchWithMultipleDotsViewController = [[SearchWithMultipleDotsViewController alloc] init];
	SuboptimalSearchViewController *suboptimalSearchViewController = [[SuboptimalSearchViewController alloc] init];
	
	// view controllers
	NSArray *viewControllers = @[basicPathfindingViewController, searchWithDifferentCostFunctionsViewController,searchWithMultipleDotsViewController, suboptimalSearchViewController];
	
	// tab bar titles
	NSArray *tabBarTitles = @[BASIC_PATH_FINDING_TAB_BAR_TITLE, SEARCH_WITH_DIFFERENT_COST_FUNCTIONS_TAB_BAR_TITLE, SEARCH_WITH_MULTIPLE_DOTS_TAB_BAR_TITLE, SUBOPTIMAL_SEARCH_TAB_BAR_TITLE];

	// navigation controllers
	NSMutableArray *navControllers = [NSMutableArray arrayWithCapacity:viewControllers.count];
	
	for (NSInteger i = 0; i < viewControllers.count; i++) {
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewControllers[i]];
		navController.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabBarTitles[i] image:nil tag:i];
		navControllers[i] = navController;
	}
	
	// tab bar controller
	_tabController = [[UITabBarController alloc] init];
	[_tabController setViewControllers:navControllers animated:YES];
	
	[self.window setRootViewController:_tabController];
	
    self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
