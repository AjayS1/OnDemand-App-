//
//  NotificationOptionViewController.m
//  Customer
//
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "NotificationOptionViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "PushNotificationTypeSelectViewController.h"
#import "EmailNotificationTypeSelectViewController.h"
#import "SingletonClass.h"
#import "AppDelegate.h"

@interface NotificationOptionViewController () {
    
    SingletonClass *sharedInstance;
}

@end

@implementation NotificationOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedInstance = [SingletonClass sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    
}


- (void)checkSignalRReqest:(NSNotification*) noti {
    
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    
    if ([requestTypeStr isEqualToString:@"1"]) {
        
        NSString *dateIdStr = [responseObject objectForKey:@"dateId"];
        
        NSDictionary *dataDictionary = @{@"DateID":dateIdStr,@"Type":requestTypeStr};
        if (sharedInstance.onDemandPushNotificationArray.count) {
            [sharedInstance.onDemandPushNotificationArray removeAllObjects];
        }
        [sharedInstance.onDemandPushNotificationArray addObject:dataDictionary];
        
        NSLog(@"sharedInstance.onDemandPushNotificationArray ==  %@",sharedInstance.onDemandPushNotificationArray);
        
        OnDemandDatePushNotificationViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"onDamndDatePushNotification"];
        
        [self.navigationController pushViewController:dateDetailsView animated:YES];
        
    } else {
        
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushNotificationButtonClicked:(id)sender {
    
    
    PushNotificationTypeSelectViewController *pushNotificationView = [self.storyboard instantiateViewControllerWithIdentifier:@"pushNotification"];
    [self.navigationController pushViewController:pushNotificationView animated:YES];
}

- (IBAction)emailNotificationButtonClicked:(id)sender {
    
    EmailNotificationTypeSelectViewController *emailNotificationView = [self.storyboard instantiateViewControllerWithIdentifier:@"emailNotification"];
    [self.navigationController pushViewController:emailNotificationView animated:YES];
}
@end
