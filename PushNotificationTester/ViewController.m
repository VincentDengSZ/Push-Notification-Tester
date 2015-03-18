//
//  ViewController.m
//  PushNotificationTester
//
//  Created by Isaac Paul on 3/18/15.
//  Copyright (c) 2015 Isaac Paul. All rights reserved.
//

#import "ViewController.h"
#import "EZRAPNSTokenUpdater.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextView *txtPushNotifications;
@property (strong, nonatomic) IBOutlet UITextView *txtToken;
@property (strong, nonatomic) IBOutletCollection(UITextView) NSArray *textFields;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"Push Notification Tester";
  
  [[EZRAPNSTokenUpdater shared] setUserTappedPushNotificationCallBack:^(NSDictionary* pushResult) {
    
  }];
  [[EZRAPNSTokenUpdater shared] fireAnyPendingNotifications];
}

- (IBAction)tapClear {
}

- (IBAction)tapShare {
}

@end
