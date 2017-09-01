
//  PaymentDateCompletedViewController.m
//  Customer
//
//  Created by Jamshed Ali on 16/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "PaymentDateCompletedViewController.h"
#import "DateReportSubmitViewController.h"
#import "RatingViewController.h"

#import "DatesViewController.h"
#import "AppDelegate.h"
#import "ServerRequest.h"
@interface PaymentDateCompletedViewController () {
    
    NSDictionary *dataDictionary;
    NSString *isPaymentReceivedYesOrNo;
    SingletonClass *sharedInstance;
    
}

@end

@implementation PaymentDateCompletedViewController
@synthesize dateIdStr,dateTypeStr;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    isPaymentReceivedYesOrNo = @"1";
    sharedInstance = [SingletonClass sharedInstance];
    contractorImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    contractorImageView.layer.cornerRadius=contractorImageView.frame.size.height/2;
    contractorImageView.layer.borderWidth=2.0;
    contractorImageView.layer.masksToBounds = YES;
    contractorImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
    codeTextField.layer.cornerRadius = 5.0;
    codeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    codeTextField.layer.borderWidth = 2.0;
    [self dateDetailsApiCall];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
}


#pragma mark Get Date Details API Call
- (void)dateDetailsApiCall {
    
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userType=%@&DateID=%@",APIGetPaymentCopnfirmationCode,@"2",self.dateIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                dataDictionary = [responseObject mutableCopy];
                contractorNameLabel.text =  [[dataDictionary objectForKey:@"result"]objectForKey:@"userName"];
                dateHeaderLabel.text = [[dataDictionary objectForKey:@"result"]objectForKey:@"EndTime"];
                if ([[[dataDictionary objectForKey:@"result"]objectForKey:@"TimeDuration"] isKindOfClass:[NSString class]]) {
                    NSString *totalTimeStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"result"] objectForKey:@"TimeDuration"]];
                    totalTimeLabel.text =  [NSString stringWithFormat:@"Total Time: %@",totalTimeStr];
                }
                else {
                    totalTimeLabel.text = @"";
                }
                
                if ([[[dataDictionary objectForKey:@"result"]objectForKey:@"RewardInfo"] isKindOfClass:[NSString class]]) {
                    NSString *rewardValue =  [NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"result"]objectForKey:@"RewardInfo"] floatValue]];
                    
                    if ([rewardValue isEqualToString:@"0.00"]) {
                        rewardAmountLabel.text = @"";
                    }
                    else
                    {
                        rewardAmountLabel.text = [NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"result"]objectForKey:@"RewardInfo"] floatValue]];
                    }
                }
                else {
                    rewardAmountLabel.text  = @"";
                }
                
                fourDigitCodeLabel.text = [NSString stringWithFormat:@"Give 4 Digit Payment Confirmation Code to %@",[[dataDictionary objectForKey:@"result"]objectForKey:@"userName"]];
                fourDigitCodeLabel.numberOfLines = 0;
                fourDigitCodeLabel.lineBreakMode =NSLineBreakByWordWrapping;
                [fourDigitCodeLabel sizeToFit];
                codeTextField.text = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"result"] objectForKey:@"PaymentConfirmationCode"]];
                if ([[[dataDictionary objectForKey:@"result"]objectForKey:@"amount"] isKindOfClass:[NSString class]]) {
                    
                    totalPayAmountLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"$%.2f", [[[dataDictionary objectForKey:@"result"]objectForKey:@"amount"]floatValue]]];
                }
                else
                {
                    totalPayAmountLabel.text = @"";
                }
                NSString *setPrimaryImageUrlStr =  [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"result"]objectForKey:@"userPic"]];
                
                NSURL *imageUrl = [NSURL URLWithString:setPrimaryImageUrlStr];
                [contractorImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

- (void)viewDidLayoutSubviews {
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 800);
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark textField Scroll Up
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //Keyboard becomes visible
    scrollView.frame = CGRectMake(scrollView.frame.origin.x,
                                  scrollView.frame.origin.y,
                                  scrollView.frame.size.width,
                                  scrollView.frame.size.height - 350 + 50);   //resize
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    //keyboard will hide
    scrollView.frame = CGRectMake(scrollView.frame.origin.x,
                                  scrollView.frame.origin.y,
                                  scrollView.frame.size.width,
                                  scrollView.frame.size.height + 350 - 50); //resize
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Not Received the Payment Method Call
- (IBAction)notReceivedPaymentMethodCall:(id)sender {
    isPaymentReceivedYesOrNo = @"0";
    [self paymentReceivedYesOrNo];
}


#pragma mark Submit Payment Method Call
- (IBAction)submitPaymentMethodCall:(id)sender {
    isPaymentReceivedYesOrNo = @"1";
    [self paymentReceivedYesOrNo];
    
}


- (void)paymentReceivedYesOrNo {
    
    NSString *userIdStr = sharedInstance.userId;
    NSString *urlstr=[NSString stringWithFormat:@"%@?ContractorID=%@&DateID=%@&isPaymentReceive=%@",APISubmitPaymentReceivedYesOrNo,userIdStr,self.dateIdStr,isPaymentReceivedYesOrNo];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                if ([isPaymentReceivedYesOrNo isEqualToString:@"0"]) {
                    DatesViewController *dateView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                    dateView.isFromDateDetails = NO;
                    
                    [self.navigationController pushViewController:dateView animated:YES];
                }
                else {
                    
                    RatingViewController *rateViewCall = [self.storyboard instantiateViewControllerWithIdentifier:@"rating"];
                    rateViewCall.isFromDateDetails = NO;
                    rateViewCall.self.dateIdStr = self.dateIdStr;
                    rateViewCall.self.nameStr = [dataDictionary objectForKey:@"UserName"];
                    rateViewCall.self.imageUrlStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"result"]objectForKey:@"userPic"]];
                    rateViewCall.self.dateCompletedTimeStr = [[dataDictionary objectForKey:@"result"]objectForKey:@"EndTime"];
                    [self.navigationController pushViewController:rateViewCall animated:YES];
                }
            }
            else {
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

#pragma mark Do Not Received the Code Method Call
- (IBAction)dontGetCodeMethodCall:(id)sender {
}

- (IBAction)backMethodCall:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
