//
//  ViewController.m
//  PushNotificationTester
//
//  Created by Isaac Paul on 3/18/15.
//  Copyright (c) 2015 Isaac Paul. All rights reserved.
//

#import "ViewController.h"
#import "VCLogs.h"
#import "EZRAPNSTokenUpdater.h"
#import "NotificationCache.h"
#import "UIActivityViewController+PNT.h"
#import <UIAlertView+Shortcuts.h>

@interface ViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *txtPushNotifications;
@property (strong, nonatomic) IBOutlet UITextView *txtToken;
@property (strong, nonatomic) IBOutlet UILabel *lblTokenTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) IBOutletCollection(UITextView) NSArray *textFields;

@property (strong, nonatomic) VCLogs* vcLogs;
@property (strong, nonatomic) NotificationCache* noteCache;
@property (strong, nonatomic) UIPopoverController* lastPopover;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"Push Notification Tester";
  self.vcLogs = [self.storyboard instantiateViewControllerWithIdentifier:@"VCLogs"];
  self.noteCache = [NotificationCache new];
  [self reloadNotifications];
  
#if (TARGET_IPHONE_SIMULATOR)
  [self.txtToken setText:@"Push notifications are not supported in the simulator."];
#endif
  
#if DEBUG
  [self.lblTokenTitle setText:@"Push notification token (SANDBOX):"];
#else
  [self.lblTokenTitle setText:@"Push notification token (PRODUCTION):"];
#endif
  
  __weak ViewController* weakSelf = self;
  [[EZRAPNSTokenUpdater shared] setUserTappedPushNotificationCallBack:^(NSDictionary* pushResult) {
    ViewController* strongSelf = weakSelf;
    [strongSelf.noteCache addNotification:pushResult];
    [strongSelf reloadNotifications];
  }];
  [[EZRAPNSTokenUpdater shared] fireAnyPendingNotifications];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushTokenUpdate:) name:@"registerForRemote" object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadNotifications {
  NSArray* notifications = [self.noteCache arrayOfAllNotifications];
  
  if (notifications.count == 0)
  {
    [self.txtPushNotifications setText:@"No Push Notifications"];
    return;
  }
  
  NSEnumerator *reversedNotifications = [notifications reverseObjectEnumerator];
  
  NSString* noteString = @"";
  for (NSDictionary* eachNote in reversedNotifications)
  {
    noteString = [noteString stringByAppendingFormat:@"%@\n\n", [eachNote description]];
  }
  [self.txtPushNotifications setText:noteString];
  [self.vcLogs.txtPushNotifications setText:noteString];
}

- (void)pushTokenUpdate:(NSNotification*)notification {
  [self.txtToken setText:notification.object];
}

- (IBAction)tapClear {
  UIAlertView* alertview = [UIAlertView showQuestion:@"Are you sure?"];
  alertview.delegate = self;
}

- (IBAction)tapShare {
  
  NSString* shareText = [NSString stringWithFormat:@"%@\n%@\n\nNotification Log:\n%@", _lblTokenTitle.text, _txtToken.text, _txtPushNotifications.text];
  UIActivityViewController* shareActivity = [UIActivityViewController buildDefaultShareActivity:shareText];
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    [self.navigationController presentViewController:shareActivity animated:YES completion:nil];
  }
  else
  {
    self.lastPopover = [[UIPopoverController alloc] initWithContentViewController:shareActivity];
    [_lastPopover presentPopoverFromRect:_btnShare.frame inView:_btnShare.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
  }
}

- (IBAction)tapCopyToken {
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  pasteboard.string = self.txtToken.text;
  [UIAlertView showMessage:@"Copied token to clipboard"];
}

- (IBAction)tapLogs {
  [self.navigationController pushViewController:_vcLogs animated:true];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex == alertView.cancelButtonIndex)
    return;
  [self clearLoggedNotifications];
}

- (void)clearLoggedNotifications {
  [self.noteCache clear];
  [self reloadNotifications];
}

@end
