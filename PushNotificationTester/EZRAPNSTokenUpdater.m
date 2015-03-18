//
//  EZRAPNSTokenUpdater.m
//  BandWagon
//
//  Created by Isaac Paul on 12/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRAPNSTokenUpdater.h"

#include "TargetConditionals.h"
#import <NSData+Cryptography.h>
#import <UIAlertView+Shortcuts.h>

@interface EZRAPNSTokenUpdater ()

@property (strong, nonatomic) ReceivedObject userTappedPushNotificationCallBack;
@property (strong, nonatomic) NSDictionary* pendingNotification;
@property (strong, nonatomic) NSDictionary* initialPushNotification;

@end

@implementation EZRAPNSTokenUpdater

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerForPush];
    
    NSDictionary* userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
    {
        self.initialPushNotification = userInfo;
    }
    
    return true;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *hexToken = [deviceToken hexString];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:@"registerForRemote" object:hexToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:@"registerForRemote" object:[error localizedDescription]];
    [UIAlertView showError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState appState = [application applicationState];
    bool userDidNotTapNotification = (appState == UIApplicationStateActive);
    if (userDidNotTapNotification)
    {
        [self handlePush:userInfo userDidTap:false];
        return;
    }
    
    //At this point we don't know if the user did or did not tap the notification.
    //We will HAVE to hold the notification hostage for x seconds to determine this.
    //If the app becomes active within that time, we can determine that the user tapped it.
    //NOTE: There is no other way (I've spent over 6 hours trying to figure it out),
    //also an ex-coworker ran into the same problem, spent more time than I did on
    //it, and came to the same conclusion
    
    [self performSelector:@selector(clearPendingNotification) withObject:nil afterDelay:1];
    self.pendingNotification = userInfo;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self registerForPush];
    
    if (!_pendingNotification)
        return;
    
    [self handlePush:_pendingNotification userDidTap:true];
    self.pendingNotification = nil;
}

#pragma mark -
- (void)registerForPush {
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

- (void)clearPendingNotification {
    if (_pendingNotification == nil)
        return;
    NSDictionary* userInfo = _pendingNotification;
    self.pendingNotification = nil;
    
    [self handlePush:userInfo userDidTap:false];
}

- (void)handlePush:(NSDictionary*)userInfo userDidTap:(bool)didTap {
    
    if (self.userTappedPushNotificationCallBack == nil)
    {
        self.initialPushNotification = userInfo;
        return;
    }
    
    NSMutableDictionary* mutUserInfo = [userInfo mutableCopy];
    [mutUserInfo setObject:@(didTap) forKey:@"didTap"];
    [mutUserInfo setObject:[NSDate date] forKey:@"receivedDate"];
  
    NSDictionary* final = [NSDictionary dictionaryWithDictionary:mutUserInfo];
    self.userTappedPushNotificationCallBack(final);
}

- (bool)fireAnyPendingNotifications {
    if (self.initialPushNotification == nil)
        return false;
    [self handlePush:self.initialPushNotification userDidTap:true];
    return true;
}

- (void)simulatePushNotification {
    NSDictionary* aps = @{@"alert": @"This is a simulated push"};
    NSDictionary* push = @{@"aps": aps, @"feed_item_id": @(583325)};
    [self handlePush:push userDidTap:true];
}

@end
