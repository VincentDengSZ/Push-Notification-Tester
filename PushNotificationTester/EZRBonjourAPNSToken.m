//
//  EZRBonjourAPNSToken.m
//  BandWagon
//
//  Created by Isaac Paul on 12/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRBonjourAPNSToken.h"

@interface EZRBonjourAPNSToken () <NSNetServiceDelegate>
@property (nonatomic, strong) NSNetService *netService;
@property (nonatomic, strong) dispatch_queue_t queue;
@end


@implementation EZRBonjourAPNSToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    dispatch_async(self.queue, ^{
        [self setToken:deviceToken];
        [self _republish];
    });
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    dispatch_async(self.queue, ^{
        if (self.token)
            [self _republish];
    });
}


- (NSNetService *)netService {
    if (!_netService) {
        _netService = [[NSNetService alloc] initWithDomain:@"" type:@"_apnspusher._tcp" name:[UIDevice currentDevice].name port:1337];
        [_netService setDelegate:self];
    }
    return _netService;
}

- (dispatch_queue_t)queue {
    if (!_queue) {
        _queue = dispatch_queue_create("se.simonb.SBAPNSPusherQueue", NULL);
        dispatch_set_target_queue(_queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
    }
    return _queue;
}

- (void)_republish {
    [self.netService stop];
    [self.netService setTXTRecordData:[NSNetService dataFromTXTRecordDictionary:@{@"token":self.token}]];
    [self.netService publish];
}

@end
