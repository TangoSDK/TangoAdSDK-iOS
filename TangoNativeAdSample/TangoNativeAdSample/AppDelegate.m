//
//  AppDelegate.m
//  TangoNativeAdSample
//
//  Created by idogadaev on 28/02/17.
//  Copyright © 2017 Tango.me. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import <TangoAdSDK/TangoAdSDK.h>

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
  UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
  navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
  splitViewController.delegate = self;
  self.cacheAds = YES;
  [[TGNativeAdSDK sharedInstance] initializeSDK];//first call to the SDK, must be called on main thread
  [TGNativeAdSDK sharedInstance].userAge = 21;//optinal
  [TGNativeAdSDK sharedInstance].userGender = TGNativeAdSDKUserGenderFemale;//optional, defaults to TGNativeAdSDKUserGenderUnknown
  return YES;
}

- (BOOL)checkIfAdCacheUrl:(NSURL *)url {
  if ([url.scheme isEqualToString:@"tangoadsdk"] && [url.host isEqualToString:@"adcache"]) {
    if ([url.query isEqualToString:@"enabled=no"]) {
      self.cacheAds = NO;
    }
    else if ([url.query isEqualToString:@"enabled=yes"]) {
      self.cacheAds = YES;
    }
    return YES;
  }
  return NO;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  if ([self checkIfAdCacheUrl:url]) {
    return YES;
  }
  BOOL rc = [[TGNativeAdSDK sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
  if (rc) {
    return rc;
  }
  //continue...
  return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
  if ([self checkIfAdCacheUrl:url]) {
    return YES;
  }
  BOOL rc = [[TGNativeAdSDK sharedInstance] application:app openURL:url sourceApplication:nil annotation:[NSNull null]];
  if (rc) {
    return rc;
  }
  //continue...
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
