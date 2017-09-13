//
//  UploadVideoViewController.m
//  Contractor
//
//  Created by Kirti Rai on 19/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "UploadVideoViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "ServerRequest.h"
#import "GetVerifiedViewController.h"
#import "AlertView.h"
#import "AppDelegate.h"
#import "AccountViewController.h"

@interface UploadVideoViewController () {
    
    SingletonClass *sharedInstance;
}

@end

@implementation UploadVideoViewController
@synthesize imageViewTumbnail,videoPathUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    imageView.image = imageViewTumbnail.image;
    sharedInstance = [SingletonClass sharedInstance];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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



- (IBAction)submitVideoBtnClicked:(id)sender {
    
    [self videoUploadApiCall];
}

- (IBAction)ReRecordBtnClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBtnClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)videoUploadApiCall {
    
    if (videoPathUrl) {
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        NSString *userIdStr = sharedInstance.userId;
        NSString *mimeType;
        NSString *fileName;
        NSData *fileData;
        
        fileName =[NSString stringWithFormat:@"%@.mov",@"image"];
        fileData = [NSData dataWithContentsOfURL:videoPathUrl];
        mimeType =@"video/quicktime";
        
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@",@"http://www.doumees.com/api/ImgaeUploader/Post",userIdStr,@"UserVideo"];
        NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        
        [manager POST:encodedUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            if(fileData){
                
                [formData appendPartWithFileData:fileData
                                            name:@"image"
                                        fileName:fileName
                                        mimeType:mimeType];
                
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [ProgressHUD dismiss];
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                             andButtonsWithTitle:@[@"Ok"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle)
                 {
                     if ([buttonTitle isEqualToString:@"Ok"]) {
                         
                        // NSArray *viewControlles = self.navigationController.viewControllers;
                         AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                         accountView.isFromOrderProcess = YES;
                         accountView.isFromUpdateMobileNumber = NO;
                         accountView.isFromCreditCardProcess = NO;
                         accountView.isEmailVerifiedOrNotPage = NO;
                         [self.navigationController pushViewController:accountView animated:NO];
                     }}];
                
            } else {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [ProgressHUD dismiss];
            
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
