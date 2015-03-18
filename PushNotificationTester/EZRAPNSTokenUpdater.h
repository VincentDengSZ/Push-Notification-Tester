//
//  EZRAPNSTokenUpdater.h
//  BandWagon
//
//  Created by Isaac Paul on 12/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "SRVApplicationDelegateService.h"

typedef void (^ReceivedObject)(id result);

@interface EZRAPNSTokenUpdater : SRVApplicationDelegateService

- (void)setUserTappedPushNotificationCallBack:(ReceivedObject)receivedObjectCallback;
- (bool)fireAnyPendingNotifications;

@end
