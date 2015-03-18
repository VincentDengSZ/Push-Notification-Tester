//
//  UIActivityViewController+PNT.m
//  PushNotificationTester
//
//  Created by Isaac Paul on 3/18/15.
//  Copyright (c) 2015 Isaac Paul. All rights reserved.
//

#import "UIActivityViewController+PNT.h"
#import <UIDevice+SystemVersion.h>

@implementation UIActivityViewController (PNT)

+ (UIActivityViewController*)buildDefaultShareActivity:(NSString*)text {
    NSString *shareText = text;
    
    NSArray *items = @[shareText];
  
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [activityViewController setValue:@"Push Notification Tester" forKey:@"subject"];
    
    if ([[UIDevice currentDevice] isIOS6OrLower])
    {
      activityViewController.excludedActivityTypes =   @[UIActivityTypePostToWeibo,
                                                         UIActivityTypeSaveToCameraRoll,
                                                         UIActivityTypeAssignToContact,
                                                         UIActivityTypePrint];
    }
    else
    {
      activityViewController.excludedActivityTypes =   @[UIActivityTypePostToWeibo,
                                                         UIActivityTypeSaveToCameraRoll,
                                                         UIActivityTypeAssignToContact,
                                                         UIActivityTypePrint,
                                                         UIActivityTypeAddToReadingList,
                                                         UIActivityTypeAirDrop];
    }
    return activityViewController;
}

@end
