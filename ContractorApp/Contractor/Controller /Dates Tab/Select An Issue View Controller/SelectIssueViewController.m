
//  SelectIssueViewController.m
//  Customer
//  Created by Jamshed Ali on 30/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "SelectIssueViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "DateReportSubmitViewController.h"
#import "ServerRequest.h"
#import "AppDelegate.h"
@interface SelectIssueViewController () {
    
    SingletonClass *sharedInstance;
}
@end

@implementation SelectIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    sharedInstance = [SingletonClass sharedInstance];
    
    _userImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    _userImageView.layer.cornerRadius=_userImageView.frame.size.height/2;
    _userImageView.layer.borderWidth=2.0;
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    NSString *setPrimaryImageUrlStr =  [NSString stringWithFormat:@"%@",self.userImagePicUrl];
    
    NSURL *imageUrl = [NSURL URLWithString:setPrimaryImageUrlStr];
    [_userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [statusLabel setText:self.statusValueStr];
    contractorNamelabel.text = [NSString stringWithFormat:@"%@",self.userNameStr];
    priceLabel.text = [NSString stringWithFormat:@"%@",self.priceValueStr];
    
    if (_dateCompletedTimeStr == nil)
    {
        dateLabel.text = [NSString stringWithFormat:@"%@",@""];
    }
    else
    {
        dateLabel.text = [NSString stringWithFormat:@"%@",_dateCompletedTimeStr];
    }

    if (sharedInstance.isFromReportSubmit) {
        sharedInstance.isFromReportSubmit = NO;
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
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
    }
    else {
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

- (IBAction)dateIssueButtonClicked:(id)sender {
    
    DateReportSubmitViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateReportSubmit"];
    dateReportView.self.requestType = @"pastDateDetails";
    dateReportView.self.dateIdStr = self.dateIdStr;
    dateReportView.self.issueIdStr = @"1";
    [self.navigationController pushViewController:dateReportView animated:YES];
    
}

- (IBAction)chargeIssueButtonClicked:(id)sender {
    
    DateReportSubmitViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateReportSubmit"];
    dateReportView.self.requestType = @"pastDateDetails";
    dateReportView.self.dateIdStr = self.dateIdStr;
    dateReportView.self.issueIdStr = @"1";
    [self.navigationController pushViewController:dateReportView animated:YES];
    
}

- (IBAction)diffrentIssueButtonClicked:(id)sender {
    
    DateReportSubmitViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateReportSubmit"];
    dateReportView.self.requestType = @"pastDateDetails";
    dateReportView.self.dateIdStr = self.dateIdStr;
    dateReportView.self.issueIdStr = @"1";
    [self.navigationController pushViewController:dateReportView animated:YES];
    
}
@end
