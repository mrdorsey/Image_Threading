//
//  MRDAppDelegate.m
//  HomeworkOne
//
//  Created by Michael Dorsey on 4/27/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "MRDAppDelegate.h"
#import "MRDTableViewController.h"

@implementation MRDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [MRDTableViewController new];
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	return YES;
}

@end
