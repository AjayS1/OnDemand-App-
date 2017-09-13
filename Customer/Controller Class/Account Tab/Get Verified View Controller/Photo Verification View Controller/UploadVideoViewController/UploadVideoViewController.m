
//  UploadVideoViewController.m
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "UploadVideoViewController.h"
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

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
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
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                             andButtonsWithTitle:@[@"OK"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                       if ([buttonTitle isEqualToString:@"OK"]) {
                                                           AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                                                           accountView.isFromOrderProcess = YES;
                                                           accountView.isFromUpdateMobileNumber = NO;
                                                           accountView.isFromCreditCardProcess = NO;
                                                           accountView.isEmailVerifiedOrNotPage = NO;
                                                           [self.navigationController pushViewController:accountView animated:NO];
                                                       }
                                                       // [self.navigationController popViewControllerAnimated:YES];
                                                   }];
            }
            
            else {
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
            
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  [ProgressHUD dismiss];
              }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
