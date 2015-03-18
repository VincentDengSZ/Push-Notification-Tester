//
//  NotificationCache.m
//  PushNotificationTester
//
//  Created by Isaac Paul on 3/18/15.
//  Copyright (c) 2015 Isaac Paul. All rights reserved.
//

#import "NotificationCache.h"

NSString* const kPNTNotifications = @"kPNTNotifications";

@interface NotificationCache ()

@property (strong, nonatomic) NSArray* pushNotifications;

@end

@implementation NotificationCache

- (instancetype)init {
  if ((self = [super init]) == nil)
    return self;
  
  _pushNotifications = [[NSUserDefaults standardUserDefaults] objectForKey:kPNTNotifications];
  if (_pushNotifications == nil)
    _pushNotifications = @[];
  return self;
}

- (void)addNotification:(NSDictionary*)note {
  self.pushNotifications = [_pushNotifications arrayByAddingObject:note];
  
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:_pushNotifications forKey:kPNTNotifications];
  [defaults synchronize];
}

- (NSArray*)arrayOfAllNotifications {
  return self.pushNotifications;
}

- (void)clear {
  self.pushNotifications = @[];
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:nil forKey:kPNTNotifications];
  [defaults synchronize];
}

@end
