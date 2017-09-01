
//  ProfileDateCommnetsViewController.m
//  Customer
//  Created by Deepak on 7/13/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "ProfileDateCommnetsViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "ServerRequest.h"
#import "AlertView.h"
#import "AppDelegate.h"
@interface ProfileDateCommnetsViewController () {
    
    SingletonClass *sharedInstance;
}

@end

@implementation ProfileDateCommnetsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    sharedInstance = [SingletonClass sharedInstance];
    // Do any additional setup after loading the view.
    titleLabel.text = self.titleStr;
    commentTextView.layer.cornerRadius = 0;
    commentTextView.layer.borderWidth = 1;
    commentTextView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    commentTextView.backgroundColor = [UIColor whiteColor];

    
    if([self.titleStr isEqualToString:@"Comment"]) {
        titleLabel.text = @"ABOUT ME";
        commentTextView.text = self.dateLikeMessageStr;
    }
    else if([self.titleStr isEqualToString:@"Date Comment"]) {
        titleLabel.text = @"MY INTERESTS";
        commentTextView.text = self.dateLikeMessageStr;
    }
    else {
        titleLabel.text = self.titleStr;
    }
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

#pragma mark--  Change profileData API

- (void)changeCommentProfileDataApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSString *dataTypestr;
    NSString *titleValueStr;

    if([self.titleStr isEqualToString:@"Comment"]) {
        dataTypestr= @"Description";
        titleValueStr = @"About Me";

    }
    else if ([self.titleStr isEqualToString:@"Date Comment"]) {
        dataTypestr= @"MyDatePreferences";
        titleValueStr = @"My Interests";

    }
//    NSString *commentAlue = [commentTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    commentAlue = [commentAlue stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *urlstr =[NSString stringWithFormat:@"%@?userID=%@&attributeType=%@&attributeValue=%@",APIChangeProfileData,userIdStr,dataTypestr,commentTextView.text];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
          //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
                {
                    [[AlertView sharedManager] presentAlertWithTitle:titleValueStr message:@"Updated successfully."
                                                 andButtonsWithTitle:@[@"Ok"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle)
                     {
                         if ([buttonTitle isEqualToString:@"Ok"]) {
                             [self.navigationController popViewControllerAnimated:YES];
                         }}];
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}

- (IBAction)doneButtonClicked:(id)sender{
    [self changeCommentProfileDataApiCall];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
