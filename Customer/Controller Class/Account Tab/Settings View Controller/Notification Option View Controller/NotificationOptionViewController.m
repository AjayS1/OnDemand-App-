
//  NotificationOptionViewController.m
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "NotificationOptionViewController.h"

@interface NotificationOptionViewController ()

@end

@implementation NotificationOptionViewController

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
