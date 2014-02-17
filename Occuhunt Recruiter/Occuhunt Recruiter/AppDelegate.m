//
//  AppDelegate.m
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/12/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
//        splitViewController.delegate = (id)navigationController.topViewController;
//    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        NSDictionary *shortcut1 = @{@"phrase":@"Passionate", @"shortcut":@"This student is passionate about "};
        NSDictionary *shortcut2 = @{@"phrase":@"Used Product", @"shortcut":@"This student has been approved by the engineer.\n"};
        NSDictionary *shortcut3 = @{@"phrase":@"Eng. Approval", @"shortcut":@"This student has used our product before.\n"};
        NSDictionary *shortcut4 = @{@"phrase":@"Referral", @"shortcut":@"This student has been referred by "};
        [[NSUserDefaults standardUserDefaults] setObject:@[shortcut1, shortcut2, shortcut3, shortcut4]  forKey:@"shortcuts"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
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
