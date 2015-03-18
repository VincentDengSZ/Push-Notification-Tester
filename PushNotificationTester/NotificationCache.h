//
//  NotificationCache.h
//  PushNotificationTester
//
//  Created by Isaac Paul on 3/18/15.
//  Copyright (c) 2015 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationCache : NSObject

- (void)addNotification:(NSDictionary*)note;

- (NSArray*)arrayOfAllNotifications;

@end
