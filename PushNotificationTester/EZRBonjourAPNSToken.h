//
//  EZRBonjourAPNSToken.h
//  BandWagon
//
//  Created by Isaac Paul on 12/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRVApplicationDelegateService.h"

/*! Mainly used in combination with APNS Pusher for testing */

@interface EZRBonjourAPNSToken : SRVApplicationDelegateService

@property (nonatomic, strong) NSData *token;

@end
