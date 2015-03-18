//
//  AppDelegate.m
//  PushNotificationTester
//
//  Created by Isaac Paul on 3/18/15.
//  Copyright (c) 2015 Isaac Paul. All rights reserved.
//

#import "AppDelegate.h"
#import "EZRAPNSTokenUpdater.h"
#import "EZRBonjourAPNSToken.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self registerService:[EZRAPNSTokenUpdater shared]];
  [self registerService:[EZRBonjourAPNSToken shared]];
  return YES;
}

@end
