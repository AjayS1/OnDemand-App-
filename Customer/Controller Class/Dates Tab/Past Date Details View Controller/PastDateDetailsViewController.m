
//  PastDateDetailsViewController.m
//  Customer
//  Created by Jamshed Ali on 10/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "PastDateDetailsViewController.h"

#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@interface PastDateDetailsViewController ()
{
    NSDictionary *dataDictionary;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    NSDateFormatter *dateFormatter;
    NSString *userName;
    NSString *userNameBy;
    NSString *totalPaidAmount;
}

@end

@implementation PastDateDetailsViewController
@synthesize dateIdStr,dateTypeStr;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [seperatorDownView setHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    needHelpButton.layer.cornerRadius = 2;
    needHelpButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    needHelpButton.layer.borderWidth = 1;
    [needHelpButton setUserInteractionEnabled:YES];
    [completeFeeView setUserInteractionEnabled:YES];
    
    [self.view setUserInteractionEnabled:YES];
    [self.view addSubview:bgScrollView];
    [bgScrollView addSubview:mainHistoryDetailsView];
    [mainHistoryDetailsView addSubview:completeFeeView];
    [bgScrollView addSubview:needHelpThirdButton];
    
    needHelpSecondButton.layer.cornerRadius = 2;
    needHelpSecondButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    needHelpSecondButton.layer.borderWidth = 1;
    [needHelpSecondButton setUserInteractionEnabled:YES];
    bgScrollView.delaysContentTouches = NO;
    
    [ mainHistoryDetailsView setUserInteractionEnabled:YES];
    [needHelpSecondButton setHidden:YES];
    [needHelpButton setHidden:YES];
    [completeFeeView setUserInteractionEnabled:YES];
    
    needHelpThirdButton.layer.cornerRadius = 2;
    needHelpThirdButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    needHelpThirdButton.layer.borderWidth = 1;
    [bgScrollView addSubview:needHelpThirdButton];
    [bgScrollView addSubview:needHelpSecondButton];
    
    //NSInteger heightCompleteValue = completeFeeView.frame.origin.y;
    NSInteger heightValue = bgScrollView.frame.size.height;
    NSLog(@"Main Height Value %ld",(long)heightValue);
    if (WIN_WIDTH == 320) {
        needHelpSecondButton.frame = CGRectMake(self.view.frame.size.width/2-72, (completeFeeView.frame.origin.y+completeFeeView.frame.size.height)+170, 144, 35);
        needHelpThirdButton.frame = CGRectMake(self.view.frame.size.width/2-72, (completeFeeView.frame.origin.y+completeFeeView.frame.size.height)+170, 144, 35);
    }
    else
    {
        needHelpSecondButton.frame = CGRectMake(self.view.frame.size.width/2-72, (completeFeeView.frame.origin.y+completeFeeView.frame.size.height)+190, 144, 35);
        needHelpThirdButton.frame = CGRectMake(self.view.frame.size.width/2-72, (completeFeeView.frame.origin.y+completeFeeView.frame.size.height)+190, 144, 35);
    }
    
    //  [needHelpThirdButton setBackgroundColor:[UIColor redColor]];
    [needHelpSecondButton addTarget:self action:@selector(needHelpSecondButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [needHelpButton addTarget:self action:@selector(needHelpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [needHelpThirdButton addTarget:self action:@selector(needHelpThirdButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rateYourDateButton setFrame:CGRectMake(statusLabel.frame.origin.x, statusLabel.frame.origin.y+statusLabel.frame.size.height+15, rateYourDateButton.frame.size.width, rateYourDateButton.frame.size.height)];
    dateFormatter = [[NSDateFormatter alloc] init];
    sharedInstance = [SingletonClass sharedInstance];
    [sepeartorLabel setHidden:YES];
    [greenStartImage setHidden:YES];
    [redEndImage setHidden:YES];
    [completeFeeView setHidden:YES];
    chargeBreakDownView.hidden = YES;
    userIdStr = sharedInstance.userId;
    
    if ([self.dateTypeStr isEqualToString:@"2"])
    {
        chargeBreakDownView.hidden = YES;
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    else if ([self.dateTypeStr isEqualToString:@"4"])
    {
        chargeBreakDownView.hidden = YES;
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
        
    }
    else if ([self.dateTypeStr isEqualToString:@"5"])
    {
    }
    else if ([self.dateTypeStr isEqualToString:@"6"])
    {
        [cancellationFeeView setHidden:YES];
        [sepeartorLabel setHidden:NO];
        [completeFeeViewWithCancellationCharges setHidden:YES];
        [completeFeeView setHidden:YES];
        chargeBreakDownView.hidden = YES;
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    else if ([self.dateTypeStr isEqualToString:@"9"])
    {
        [completeFeeView setHidden:NO];
        [completeFeeViewWithCancellationCharges setHidden:YES];
        [cancellationFeeView setHidden:YES];
        chargeBreakDownView.hidden = YES;
        [seperatorDownView setHidden:YES];
        [sepeartorLabel setHidden:YES];
    }
    
    else if ([self.dateTypeStr isEqualToString:@"19"])
    {
        chargeBreakDownView.hidden = YES;
        [completeFeeView setHidden:YES];
        [cancellationFeeView setHidden:YES];
        [completeFeeViewWithCancellationCharges setHidden:YES];
        [sepeartorLabel setHidden:YES];
        [seperatorDownView setFrame:CGRectMake(0, 403, self.view.frame.size.width, 1)];
    }
    else if ([self.dateTypeStr isEqualToString:@"10"])
    {
        chargeBreakDownView.hidden = YES;
        [sepeartorLabel setHidden:NO];
        [completeFeeView setHidden:YES];
        [completeFeeViewWithCancellationCharges setHidden:YES];
        [cancellationFeeView setHidden:YES];
    }
    else if ([self.dateTypeStr isEqualToString:@"12"])
    {
        [completeFeeView setHidden:NO];
        [completeFeeViewWithCancellationCharges setHidden:YES];
        [cancellationFeeView setHidden:YES];
        chargeBreakDownView.hidden = YES;
        [seperatorDownView setHidden:YES];
        [sepeartorLabel setHidden:YES];
    }
    
    else if ([self.dateTypeStr isEqualToString:@"15"])
    {
        chargeBreakDownView.hidden = YES;
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    
    else if ([self.dateTypeStr isEqualToString:@"13"])
    {
    }
    else if ([self.dateTypeStr isEqualToString:@"11"])
    {
    }
    else
    {
        chargeBreakDownView.hidden = YES;
    }
    [self dateDetailsApiCall];
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    NSLog(@"touchesShouldCancelInContentView");
    if ([view isKindOfClass:[UIButton class]])
        return NO;
    else
        return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.hidden=YES;
    userNameLabel.text =  self.userNameStr;
    NSString *setPrimaryImageUrlStr =  [NSString stringWithFormat:@"%@",self.picUrlStr];
    NSURL *imageUrl = [NSURL URLWithString:setPrimaryImageUrlStr];
    [userImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.tabBarController.tabBar setHidden:YES];
    
    if (APPDELEGATE.hubConnection)
    {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    NSString *dateType =   self.dateTypeStr;
    if ([dateType isEqualToString:@"6"]  || [dateType isEqualToString:@"10"] || [dateType isEqualToString:@"19"] || [dateType isEqualToString:@"20"]) {
        if ([_dateRequestType isEqualToString:@"1"]) {
            [reservationTimeImage setImage:[UIImage imageNamed:@"lightning"]];
        }
        else
        {
            [reservationTimeImage setImage:[UIImage imageNamed:@"calendar_Other"]];
        }
    }
    else
    {
        [reservationTimeImage setImage:[UIImage imageNamed:@"clock"]];
    }
}

- (void)viewDidLayoutSubviews {
    
    if ([self.dateTypeStr isEqualToString:@"6"] ||[self.dateTypeStr isEqualToString:@"10"]) {
        bgScrollView.contentSize = CGSizeMake(320, self.view.frame.size.height);
    }
    else{
        bgScrollView.contentSize = CGSizeMake(320, 800);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Need Help Method Call
- (IBAction)needHelpButtonClicked:(UIButton *)sender {
    
    SelectIssueViewController *selectIssueView = [self.storyboard instantiateViewControllerWithIdentifier:@"selectIssue"];
    selectIssueView.self.dataDictionary = [dataDictionary objectForKey:@"DateDetails"];
    selectIssueView.self.dateIdStr = self.dateIdStr;
    selectIssueView.self.userNameStr = self.userNameStr;
    selectIssueView.self.userImagePicUrl = self.picUrlStr;
    NSString *requestTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"StartTime"]];
    NSString *requestDate = [CommonUtils convertUTCTimeToLocalTime:requestTimeStr WithFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    selectIssueView.self.dateCompletedTimeStr = [CommonUtils changeDateInParticularFormateWithString:requestDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
    selectIssueView.self.priceValueStr = totalPaidAmount;
    if ([self.dateTypeStr isEqualToString:@"6"] || [self.dateTypeStr isEqualToString:@"10"] || [self.dateTypeStr isEqualToString:@"19"] ||[self.dateTypeStr isEqualToString:@"20"]) {
        selectIssueView.statusValueStr = @"Cancelled";
    }
    else
    {
        selectIssueView.statusValueStr = @"Complete";
    }
    [self.navigationController pushViewController:selectIssueView animated:YES];
    
}
- (IBAction)needHelpSecondButtonClicked:(UIButton *)sender {
    
    SelectIssueViewController *selectIssueView = [self.storyboard instantiateViewControllerWithIdentifier:@"selectIssue"];
    selectIssueView.self.dataDictionary = [dataDictionary objectForKey:@"DateDetails"];
    selectIssueView.self.dateIdStr = self.dateIdStr;
    selectIssueView.self.userNameStr = self.userNameStr;
    selectIssueView.self.userImagePicUrl = self.picUrlStr;
    NSString *requestTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"StartTime"]];
    NSString *requestDate = [CommonUtils convertUTCTimeToLocalTime:requestTimeStr WithFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    selectIssueView.self.dateCompletedTimeStr = [CommonUtils changeDateInParticularFormateWithString:requestDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
    selectIssueView.self.priceValueStr = [CommonUtils getFormateedNumberWithValue:[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"]];
    if ([self.dateTypeStr isEqualToString:@"6"] || [self.dateTypeStr isEqualToString:@"10"] || [self.dateTypeStr isEqualToString:@"19"] ||[self.dateTypeStr isEqualToString:@"20"]) {
        selectIssueView.statusValueStr = @"Cancelled";
    }
    else
    {
        selectIssueView.statusValueStr = @"Complete";
    }
    [self.navigationController pushViewController:selectIssueView animated:YES];
    
}
- (IBAction)needHelpThirdButtonClicked:(id)sender {
    
    SelectIssueViewController *selectIssueView = [self.storyboard instantiateViewControllerWithIdentifier:@"selectIssue"];
    selectIssueView.self.dataDictionary = [dataDictionary objectForKey:@"DateDetails"];
    selectIssueView.self.dateIdStr = self.dateIdStr;
    selectIssueView.self.userNameStr = self.userNameStr;
    selectIssueView.self.userImagePicUrl = self.picUrlStr;
    NSString *requestTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"StartTime"]];
    NSString *requestDate = [CommonUtils convertUTCTimeToLocalTime:requestTimeStr WithFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    selectIssueView.self.dateCompletedTimeStr = [CommonUtils changeDateInParticularFormateWithString:requestDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
    selectIssueView.self.priceValueStr = [CommonUtils getFormateedNumberWithValue:[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"]];
    if ([self.dateTypeStr isEqualToString:@"6"] || [self.dateTypeStr isEqualToString:@"10"] || [self.dateTypeStr isEqualToString:@"19"] ||[self.dateTypeStr isEqualToString:@"20"]) {
        selectIssueView.statusValueStr = @"Cancelled";
    }
    else{
        selectIssueView.statusValueStr = @"Complete";
    }
    
    [self.navigationController pushViewController:selectIssueView animated:YES];
    
}

- (IBAction)rateYourDateButtonClicked:(id)sender {
    
    RatingViewController *rateViewCall = [self.storyboard instantiateViewControllerWithIdentifier:@"rating"];
    //rateViewCall.isFromDateDetailsFromPastDate = YES;
    rateViewCall.isFromDateDetails = YES;
    rateViewCall.self.dateIdStr = self.dateIdStr;
    rateViewCall.self.nameStr = [[dataDictionary objectForKey:@"EndDateCustomer"] objectForKey:@"UserName"];
    rateViewCall.self.imageUrlStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Url"]];
    NSString *requestTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"EndTime"]];
    NSString *requestDate = [CommonUtils convertUTCTimeToLocalTime:requestTimeStr WithFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    // [endTimeLabel setText:[NSString stringWithFormat:@"%@",requestDate]];
    rateViewCall.self.dateCompletedTimeStr = [CommonUtils changeDateInParticularFormateWithString:requestDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
    [self.navigationController pushViewController:rateViewCall animated:YES];
    
}

#pragma mark Get Date Details API Call
- (void)dateDetailsApiCall
{
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userType=%@&DateID=%@&DateType=%@",APIDateDetailsPast,@"1",self.dateIdStr,self.dateTypeStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            [reservationTimeImage setHidden:YES];
            [greenStartImage setHidden:YES];
            [redEndImage setHidden:YES];
            [statusImage setHidden:YES];
            [locationImage setHidden:YES];
            [ratingImage setHidden:YES];
            [cancellationFeeView setHidden:YES];
            [chargeBreakDownView setHidden:YES];
            [completeFeeView setHidden:YES];
        }
        else
        {
            if(!error)
            {
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    dataDictionary = [responseObject mutableCopy];
                    [reservationTimeImage setHidden:NO];
                    [locationImage setHidden:NO];
                    [statusImage setHidden:NO];
                    [ratingImage setHidden:NO];
                    
                    if(WIN_WIDTH == 320)
                    {
                     [locationLabel setFrame:CGRectMake(locationLabel.frame.origin.x, locationLabel.frame.origin.y, locationLabel.frame.size.width-25, locationLabel.frame.size.height)];
                    }
                    
                    NSArray *imageDataArray = [dataDictionary objectForKey:@"UserPicture"];
                    NSLog(@"imageDataArray %lu",(unsigned long)imageDataArray.count);
                    userName =[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"UserName"];
                    userNameBy =[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"UserNameby"];
                    sharedInstance.CancelReasonID = [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"CancelReasonID"];
                    locationLabel.text =  [[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Location"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    locationLabel.numberOfLines = 0;
                    locationLabel.lineBreakMode =NSLineBreakByWordWrapping;
                    [locationLabel sizeToFit];
                    
                    if([self.dateTypeStr isEqualToString:@"6"] ||[self.dateTypeStr isEqualToString:@"10"] || [self.dateTypeStr isEqualToString:@"19"])
                    {
                        if ( [sharedInstance.CancelReasonID isEqualToString:@"56"]) {
                            [needHelpThirdButton setHidden:NO];
                            [completeFeeView setHidden:YES];
                            [completeFeeView removeFromSuperview];
                            [cancellationFeeView setHidden:NO];
                            [chargeBreakDownView removeFromSuperview];
                        }
                        else{
                        [needHelpThirdButton setHidden:YES];
                        [completeFeeView setHidden:YES];
                        [completeFeeView removeFromSuperview];
                        [cancellationFeeView removeFromSuperview];
                        [chargeBreakDownView removeFromSuperview];
                        }
                    }
                    else if ([self.dateTypeStr isEqualToString:@"20"]){
                  
                        [needHelpThirdButton setHidden:NO];
                        [completeFeeView setHidden:YES];
                        [completeFeeView removeFromSuperview];
                        [cancellationFeeView setHidden:NO];
                        [chargeBreakDownView removeFromSuperview];
                    }
                    NSString *paymentStatus = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]];
                    if ([paymentStatus isEqualToString:@"UNPAID"] ||[paymentStatus isEqualToString:@"CHARGEBACK"] ) {
                        [breakdownChargeBackLabel setTextColor:[UIColor redColor]];
                        [breakDownLabelWithStatus setTextColor:[UIColor redColor]];
                        [breakDownCompleteLabelWithStatus setTextColor:[UIColor redColor]];
                    }
                    else{
                        [breakdownChargeBackLabel setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                        [breakDownLabelWithStatus setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                        [breakDownCompleteLabelWithStatus setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                    }
                    [breakdownChargeBackLabel setText:paymentStatus];
                    [breakDownLabelWithStatus setText:paymentStatus];
                    [breakDownCompleteLabelWithStatus setText:paymentStatus];
                    
                    [chargeBreakDownView setFrame:CGRectMake(chargeBreakDownView.frame.origin.x, durationTimeValueLabel.frame.origin.y+durationTimeValueLabel.frame.size.height+35, chargeBreakDownView.frame.size.width, chargeBreakDownView.frame.size.height)];
                    
                    [completeFeeView setFrame:CGRectMake(completeFeeView.frame.origin.x, durationTimeValueLabel.frame.origin.y+durationTimeValueLabel.frame.size.height+25, completeFeeView.frame.size.width, completeFeeView.frame.size.height)];
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"BaseFee"] isKindOfClass:[NSString class]]) {
                        minimumAmountLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%d", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"BaseFee"] intValue]]];
                    }
                    else{
                        minimumAmountLabel.text  = @"$0.00";
                    }
                    if ([self.dateTypeStr isEqualToString:@"9"]) {
                        NSString *additionalTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"AdditionalDuration"] ];
                        
                        if ([additionalTimeStr integerValue]>0) {
                            [completeFeeView setHidden:YES];
                            [chargeBreakDownView setHidden:NO];
                            [cancellationFeeView setHidden:YES];
                        }
                        else
                        {
                            [completeFeeView setHidden:NO];
                            [chargeBreakDownView setHidden:YES];
                        }
                    }
                    else if ([self.dateTypeStr isEqualToString:@"12"])
                    {
                        [completeFeeView setHidden:YES];
                        [chargeBreakDownView setHidden:NO];
                        [cancellationFeeView setHidden:YES];
                    }
                    else if ([self.dateTypeStr isEqualToString:@"17"] || [self.dateTypeStr isEqualToString:@"18"])
                    {
                        
                        NSString *paymentStatus = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]];
                        
                        if ([paymentStatus isEqualToString:@"UNPAID"] ||[paymentStatus isEqualToString:@"CHARGEBACK"] ) {
                            [breakdownChargeBackLabel setTextColor:[UIColor redColor]];
                            [breakDownLabelWithStatus setTextColor:[UIColor redColor]];
                            [breakDownCompleteLabelWithStatus setTextColor:[UIColor redColor]];
                        }
                        else{
                            [breakdownChargeBackLabel setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                            [breakDownLabelWithStatus setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                            [breakDownCompleteLabelWithStatus setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                        }

                        [breakdownChargeBackLabel setText:paymentStatus];
                        [paymentMethodLabel setHidden:YES];
                        [breakDownCompleteLabelWithStatus setTextColor:[UIColor colorWithRed:191.0/255.0 green:41.0/255.0 blue:50.0/255.0 alpha:1.0]];
                        [breakDownLabelWithStatus setTextColor:[UIColor colorWithRed:191.0/255.0 green:41.0/255.0 blue:50.0/255.0 alpha:1.0]];
                        [breakdownChargeBackLabel setTextColor:[UIColor colorWithRed:191.0/255.0 green:41.0/255.0 blue:50.0/255.0 alpha:1.0]];
                        [breakDownLabelWithStatus setText:paymentStatus];
                        [breakDownCompleteLabelWithStatus setText:paymentStatus];
                        [breakdownChargeBackLabel setText:paymentStatus];
                        [completeFeeView setHidden:YES];
                        [chargeBreakDownView setHidden:NO];
                        [cancellationFeeView setHidden:YES];
                        [chargeBackTitleLabel setHidden:NO];
                        [chargeBackFeesLabel setHidden:NO];
                    }
                    else if ([self.dateTypeStr isEqualToString:@"25"])
                    {
                        [completeFeeView setHidden:YES];
                        [chargeBreakDownView setHidden:NO];
                        [cancellationFeeView setHidden:YES];
                    }
                    
                    else  if ([self.dateTypeStr isEqualToString:@"20"]) {
                        [completeFeeView setHidden:YES];
                        [chargeBreakDownView setHidden:YES];
                        [cancellationFeeView setHidden:NO];
                    }
                    else
                    {
                            NSString *additionalTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"AdditionalDuration"] ];
                        
                        if ([additionalTimeStr integerValue]>0) {
                            [mainHistoryDetailsView bringSubviewToFront:completeFeeView];
                            
                            [completeFeeView setHidden:YES];
                            [chargeBreakDownView setHidden:NO];
                        }
                        else
                        {
                            [mainHistoryDetailsView bringSubviewToFront:completeFeeView];
                            [completeFeeView setHidden:NO];
                            [chargeBreakDownView setHidden:YES];
                            if (  [self.dateTypeStr isEqualToString:@"20"]) {
                                [cancellationFeeView setHidden:NO];
                            }
                            else{
                             [cancellationFeeView setHidden:YES];
                            }
                        }
                    }
                    
                    if ([self.dateTypeStr isEqualToString:@"12"]) {
                        [completeFeeView setHidden:YES];
                        [chargeBreakDownView setHidden:NO];
                        [cancellationFeeView setHidden:YES];
                        
                        [chargeBackTitleLabel setHidden:YES];
                        [chargeBackFeesLabel setHidden:YES];
                        [totalTitleLabel setFrame:CGRectMake(totalTitleLabel.frame.origin.x, creditCardTitleLabel.frame.origin.y+creditCardTitleLabel.frame.size.height+15, 120, 21)];
                           [totalTitleSeperatorLabel setFrame:CGRectMake(totalTitleLabel.frame.origin.x, totalTitleLabel.frame.origin.y - 5, totalTitleSeperatorLabel.frame.size.width, 1)];
                        [totalAmountLabel setFrame:CGRectMake(totalAmountLabel.frame.origin.x, totalTitleLabel.frame.origin.y, totalAmountLabel.frame.size.width, totalAmountLabel.frame.size.height)];
                        [paymentMethodLabel setFrame:CGRectMake(paymentMethodLabel.frame.origin.x, totalTitleLabel.frame.origin.y+totalTitleLabel.frame.size.height+10, paymentMethodLabel.frame.size.width, paymentMethodLabel.frame.size.height)];
                        [needHelpButton setFrame:CGRectMake(needHelpButton.frame.origin.x, paymentMethodLabel.frame.origin.y+paymentMethodLabel.frame.size.height+25, needHelpButton.frame.size.width, needHelpButton.frame.size.height)];
                        NSString *paymentStatus = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]];
                        if ([paymentStatus isEqualToString:@"UNPAID"] ||[paymentStatus isEqualToString:@"CHARGEBACK"] ) {
                            [breakdownChargeBackLabel setTextColor:[UIColor redColor]];
                            [breakDownLabelWithStatus setTextColor:[UIColor redColor]];
                            [breakDownCompleteLabelWithStatus setTextColor:[UIColor redColor]];
                        }
                        else{
                            [breakdownChargeBackLabel setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                            [breakDownLabelWithStatus setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                            [breakDownCompleteLabelWithStatus setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                        }

                        [breakdownChargeBackLabel setText:paymentStatus];
                        [paymentMethodLabel setHidden:YES];
                        [breakDownCompleteLabelWithStatus setTextColor:[UIColor colorWithRed:191.0/255.0 green:41.0/255.0 blue:50.0/255.0 alpha:1.0]];
                        [breakDownLabelWithStatus setTextColor:[UIColor colorWithRed:191.0/255.0 green:41.0/255.0 blue:50.0/255.0 alpha:1.0]];
                        [breakdownChargeBackLabel setTextColor:[UIColor colorWithRed:191.0/255.0 green:41.0/255.0 blue:50.0/255.0 alpha:1.0]];
                        [breakDownLabelWithStatus setText:paymentStatus];
                        [breakDownCompleteLabelWithStatus setText:paymentStatus];
                        [breakdownChargeBackLabel setText:paymentStatus];
                    }
                    NSString *reserveTimeStr ;
                    if ([self.dateTypeStr isEqualToString:@"6"] || [self.dateTypeStr isEqualToString:@"10"]||[self.dateTypeStr isEqualToString:@"19"] ||[self.dateTypeStr isEqualToString:@"20"]) {
                          reserveTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ReservationTime"]];
                    }
                    else{
                          reserveTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"StartTime"]];
                    }
                  
                    NSArray *nameStr = [reserveTimeStr componentsSeparatedByString:@"."];
                    NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                    NSLog(@"%@",fileKey);
                    NSString *reserveDate = [self convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                    datelabel.text = [NSString stringWithFormat:@"%@",[self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"]];
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"StartTime"] isKindOfClass:[NSString class]]) {
                        NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"StartTime"]];
                        NSArray *nameStr = [reserveTimeStr componentsSeparatedByString:@"."];
                        NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                        NSLog(@"%@",fileKey);
                        NSString *reserveDate = [self convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                        dateStartTimeLabel.text = [NSString stringWithFormat:@"%@",[self changeDateInParticularFormateWithStringForDate:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"]];
                    }
                    
                    else
                    {
                        dateStartTimeLabel.text = @"";
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"EndTime"] isKindOfClass:[NSString class]]) {
                        NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"EndTime"]];
                        NSArray *nameStr = [reserveTimeStr componentsSeparatedByString:@"."];
                        NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                        NSLog(@"%@",fileKey);
                        NSString *reserveDate = [self convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                        dateEndTimeLabel.text = [NSString stringWithFormat:@"%@",[self changeDateInParticularFormateWithStringForDate:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"]];
                    }
                    else
                    {
                        dateEndTimeLabel.text = @"";
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"BaseFee"] isKindOfClass:[NSString class]]) {
                        minimumAmountLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"BaseFee"] floatValue]]];
                    }
                    else{
                        minimumAmountLabel.text  = @"$0.00";
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"AdditionalDuration"] isKindOfClass:[NSString class]]) {
                        NSString *extraTime = [NSString stringWithFormat:@"%d",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"AdditionalDuration"] intValue]];
                        if ([extraTime isEqualToString:@"0"]) {
                            additionalTitleTimeLabel.text = [NSString stringWithFormat:@"Additional Time"];
                        }
                        else {
                            additionalTitleTimeLabel.text = [NSString stringWithFormat:@"Additional Time (%@)",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"AdditionalDuration"]];
                        }
                        additonalTimeLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ExtraAmount"]]];
                    }
                    else {
                        additonalTimeLabel.text = @"";
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"BaseFee"] isKindOfClass:[NSString class]]) {
                        completeBaseFeeLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"BaseFee"] floatValue]]];
                    }
                    else{
                        completeBaseFeeLabel.text  = @"$0.00";
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] isKindOfClass:[NSString class]]) {
                        
                        subTotalLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] floatValue]]];
                        subTotalCompleteLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] floatValue]]];
                        subtotalLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] floatValue]]];
                    }
                    else {
                        subTotalLabel.text = @"$0.00";
                        subTotalCompleteLabel.text =@"$0.00";
                        subtotalLabel.text = @"$0.00";
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TipAmount"] isKindOfClass:[NSString class]]) {
                        tipsCompleteLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TipAmount"] floatValue]]];
                         creditCardFeesLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TipAmount"] floatValue]]];
                        if ([self.dateTypeStr isEqualToString:@"11"]||[self.dateTypeStr isEqualToString:@"9"] || [self.dateTypeStr isEqualToString:@"17"]) {
                             creditCardFeesLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TipAmount"] floatValue]]];
                        }
                    }
                    else
                    {
                        tipsCompleteLabel.text = @"$0.00";
                        //creditCardFeesLabel.text = @"$0.00";
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DiscountAmount"] isKindOfClass:[NSString class]]) {
                        discountCompleteLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DiscountAmount"] floatValue]]];
                    }
                    else {
                        discountCompleteLabel.text = @"$0.00";
                    }
                    
                    if ([self.dateTypeStr isEqualToString:@"19"] || [self.dateTypeStr isEqualToString:@"20"]) {
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] isKindOfClass:[NSString class]]) {
                            
                            subTotalLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] floatValue]]];
                        }
                        else {
                            subTotalLabel.text = @"$0.00";
                        }
                    }
                    
                    else if([self.dateTypeStr isEqualToString:@"9"])
                    {
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] isKindOfClass:[NSString class]]) {
                            subTotalCompleteLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] floatValue]]];
                        }
                        else {
                            subTotalCompleteLabel.text = @"$0.00";
                        }
                    }
                    if ([self.dateTypeStr isEqualToString:@"9"] ||[self.dateTypeStr isEqualToString:@"11"]) {
                        
                    }
                    else
                    {
                        if ([self.dateTypeStr isEqualToString:@"25"]) {
                            
                              creditCardFeesLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TipAmount"] floatValue]]];
                        }
                        
                        else  if (![self.dateTypeStr isEqualToString:@"17"]){
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TransactionFee"] isKindOfClass:[NSString class]]) {
                            creditCardFeesLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TransactionFee"] floatValue]]];
                        }
                        else {
                            creditCardFeesLabel.text = @"$0.00";
                        }
                      }
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"] isKindOfClass:[NSString class]]) {
                        
                        [cardStatusTypeLabel setText:[NSString stringWithFormat:@"Payment Method: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                        [cardStatusCompleteTypeLabel setText:[NSString stringWithFormat:@"Payment Method: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                        [paymentMethodLabel setText:[NSString stringWithFormat:@"Payment Method: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                    }
                    else {
                        cardStatusTypeLabel.text = @"";
                        cardStatusCompleteTypeLabel.text = @"";
                        [paymentMethodLabel setText:@""];
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"] isKindOfClass:[NSString class]]) {
                        totalAmountLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"]floatValue]]];
                      
                        [paymentMethodLabel setFrame:CGRectMake(paymentMethodLabel.frame.origin.x, totalTitleLabel.frame.origin.y+totalTitleLabel.frame.size.height+10, paymentMethodLabel.frame.size.width, paymentMethodLabel.frame.size.height)];
                        totalEarningsLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"]floatValue]]];
                        totalEarningsCompleteLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"]floatValue]]];
                           totalPaidAmount = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"]floatValue]]];
                        
                    }
                    else {
                        totalAmountLabel.text = @"$0.00";
                        totalEarningsCompleteLabel.text = @"$0.00";
                        totalEarningsLabel.text = @"$0.00";
                        totalPaidAmount =@"$0.00";
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayedNumber"] isKindOfClass:[NSString class]]) {
                        cardNumberLabel.frame = CGRectMake(cardNumberLabel.frame.origin.x
                                                           , totalAmountLabel.frame.origin.y+additonalTimeLabel.frame.size.height+1, 180, 30);
                        cardNumberLabel.text = [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayedNumber"];
                    }
                    else {
                        cardNumberLabel.text = @"";
                    }
                    
                    NSString *checkPrimaryImage= @"";
                    NSLog(@"checkPrimaryImage %@",checkPrimaryImage);
                    
                    if ([self.dateTypeStr isEqualToString:@"2"]|| [self.dateTypeStr isEqualToString:@"4"]||[self.dateTypeStr isEqualToString:@"6"]||[self.dateTypeStr isEqualToString:@"10"]||[self.dateTypeStr isEqualToString:@"19"]||[self.dateTypeStr isEqualToString:@"20"]) {
                        
                        greenStartImage.hidden = YES;
                        redEndImage.hidden = YES;
                        dateStartTimeLabel.hidden = YES;
                        dateEndTimeLabel.hidden = YES;
                        float originValueOfLocation = locationLabel.frame.origin.x;
                        float originValueOfImageLocation = reservationTimeImage.frame.origin.x;
                        if(WIN_WIDTH == 320){
                            [locationLabel setFrame:CGRectMake(originValueOfLocation, datelabel.frame.origin.y+datelabel.frame.origin.y+25, locationLabel.frame.size.width-10, locationLabel.frame.size.height)];
                        }
                        else{
                            [locationLabel setFrame:CGRectMake(originValueOfLocation, datelabel.frame.origin.y+datelabel.frame.origin.y+25, locationLabel.frame.size.width, locationLabel.frame.size.height)];
                        }
                        
                        NSLog(@"Origin Value %f",originValueOfLocation);
                        // locationTitleLabel.frame = CGRectMake(11,45,70,25);
                        [locationImage setFrame:CGRectMake(originValueOfImageLocation+10, locationLabel.frame.origin.y+3, 15, 15)];
                        locationLabel.numberOfLines = 0;
                        locationLabel.lineBreakMode =NSLineBreakByWordWrapping;
                        locationLabel.textAlignment = NSTextAlignmentLeft;
                        [locationLabel sizeToFit];
                        
                        if ([self.dateTypeStr isEqualToString:@"6"] || [self.dateTypeStr isEqualToString:@"10"]||[self.dateTypeStr isEqualToString:@"19"]||[self.dateTypeStr isEqualToString:@"20"]) {
                            [durationTimeValueLabel setHidden:YES];
                            [ratingImage setHidden:YES];
                            [seperatorDownView setHidden:YES];
                        }
                        else
                        {
                            [durationTimeValueLabel setHidden:NO];
                            [ratingImage setHidden:NO];
                            [seperatorDownView setHidden:NO];
                        }
                        durationTitleLabel.frame = CGRectMake(11,locationLabel.frame.origin.y+locationLabel.frame.size.height+8, 70, 25);
                        durationTimeValueLabel.frame = CGRectMake(originValueOfLocation, locationLabel.frame.origin.y+locationLabel.frame.size.height+8, 100, 25);
                        statusLabel.frame = CGRectMake(originValueOfLocation, durationTitleLabel.frame.origin.y+durationTitleLabel.frame.size.height+8, 70, 25);
                        statusLabel.frame = CGRectMake(originValueOfLocation, locationLabel.frame.origin.y+locationLabel.frame.size.height+8, self.view.frame.size.width-originValueOfLocation, 25);
                        [statusImage setFrame:CGRectMake(originValueOfImageLocation+10, statusLabel.frame.origin.y+5, 15, 15)];
                        [self setStatusLabel];
                        
                        
                    }
                    else {
                        
                        float originValueOfLocation = locationLabel.frame.origin.x;
                        float originValueOfImageLocation = reservationTimeImage.frame.origin.x;
                        if (WIN_WIDTH == 320) {
                            [greenStartImage setFrame:CGRectMake(datelabel.frame.origin.x, datelabel.frame.origin.y+datelabel.frame.size.height+8, 10, 10)];
                            [dateStartTimeLabel setFrame:CGRectMake(greenStartImage.frame.origin.x+greenStartImage.frame.size.width+4, datelabel.frame.origin.y+datelabel.frame.size.height+2, dateStartTimeLabel.frame.size.width-10, dateStartTimeLabel.frame.size.height)];
                            dateStartTimeLabel.font = [UIFont systemFontOfSize:10];
                            dateEndTimeLabel.font = [UIFont systemFontOfSize:10];
                            //dateStartTimeLabel.backgroundColor = [UIColor redColor];
                            [redEndImage setFrame:CGRectMake(dateStartTimeLabel.frame.origin.x+dateStartTimeLabel.frame.size.width+8, datelabel.frame.origin.y+datelabel.frame.size.height+8, 10, 10)];
                            [dateEndTimeLabel setFrame:CGRectMake(redEndImage.frame.origin.x+redEndImage.frame.size.width+4, datelabel.frame.origin.y+datelabel.frame.size.height+2, dateEndTimeLabel.frame.size.width+20, dateEndTimeLabel.frame.size.height)];
                            //                        locationLabel.frame = CGRectMake(originValueOfLocation, dateStartTimeLabel.frame.origin.y+dateStartTimeLabel.frame.size.height+5, self.view.frame.size.width-originValueOfLocation-10, 25);
                            
                        }
                        else
                        {
                            //locationLabel.frame = CGRectMake(originValueOfLocation, 48, self.view.frame.size.width-originValueOfLocation, 25);
                        }
                        
                        locationLabel.numberOfLines = 0;
                        locationLabel.lineBreakMode =NSLineBreakByWordWrapping;
                        [locationLabel sizeToFit];
                        [locationImage setFrame:CGRectMake(originValueOfImageLocation+10, locationLabel.frame.origin.y+3, 15, 15)];
                        
                        statusLabel.frame = CGRectMake(originValueOfLocation, durationTitleLabel.frame.origin.y+durationTitleLabel.frame.size.height+8, 70, 25);
                        statusLabel.frame = CGRectMake(originValueOfLocation, locationLabel.frame.origin.y+locationLabel.frame.size.height+8, self.view.frame.size.width-originValueOfLocation, 25);
                        [statusImage setFrame:CGRectMake(originValueOfImageLocation+10, statusLabel.frame.origin.y+5, 15, 15)];
                        [ratingImage setFrame:CGRectMake(originValueOfImageLocation+10, statusLabel.frame.origin.y+5, 15, 15)];
                        durationTimeValueLabel.frame = CGRectMake(originValueOfLocation, statusLabel.frame.origin.y+statusLabel.frame.size.height+8, 100, 25);
                        [ratingImage setFrame:CGRectMake(originValueOfImageLocation+10, durationTimeValueLabel.frame.origin.y+5, 15, 15)];
                        greenStartImage.hidden = NO;
                        redEndImage.hidden = NO;
                        dateStartTimeLabel.hidden = NO;
                        dateEndTimeLabel.hidden = NO;
                        [greenStartImage setFrame:CGRectMake(datelabel.frame.origin.x, datelabel.frame.origin.y+datelabel.frame.size.height+8, 10, 10)];
                        [dateStartTimeLabel setFrame:CGRectMake(greenStartImage.frame.origin.x+greenStartImage.frame.size.width+4, datelabel.frame.origin.y+datelabel.frame.size.height+2, dateStartTimeLabel.frame.size.width+20, dateStartTimeLabel.frame.size.height)];
                        //dateStartTimeLabel.backgroundColor = [UIColor redColor];
                        [redEndImage setFrame:CGRectMake(dateStartTimeLabel.frame.origin.x+dateStartTimeLabel.frame.size.width+5, datelabel.frame.origin.y+datelabel.frame.size.height+8, 10, 10)];
                       // dateStartTimeLabel.font = [UIFont systemFontOfSize:12];
                       // dateEndTimeLabel.font = [UIFont systemFontOfSize:12];

                        [dateEndTimeLabel setFrame:CGRectMake(redEndImage.frame.origin.x+redEndImage.frame.size.width+4, datelabel.frame.origin.y+datelabel.frame.size.height+2, dateEndTimeLabel.frame.size.width+28, dateEndTimeLabel.frame.size.height)];
                        [completeFeeView setFrame:CGRectMake(completeFeeView.frame.origin.x, durationTimeValueLabel.frame.origin.y+durationTimeValueLabel.frame.size.height+25, completeFeeView.frame.size.width, completeFeeView.frame.size.height)];
                        
                        [self setStatusLabel];
                    }
                    
                    if ([self.dateTypeStr isEqualToString:@"9"] || [self.dateTypeStr isEqualToString:@"11"]) {
                        NSString *paymentStatus =[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]];
                        if ([paymentStatus isEqualToString:@"UNPAID"] ||[paymentStatus isEqualToString:@"CHARGEBACK"] ) {
                            [breakdownChargeBackLabel setTextColor:[UIColor redColor]];
                            [breakDownLabelWithStatus setTextColor:[UIColor redColor]];
                            [breakDownCompleteLabelWithStatus setTextColor:[UIColor redColor]];
                        }
                        else{
                            [breakdownChargeBackLabel setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                            [breakDownLabelWithStatus setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                            [breakDownCompleteLabelWithStatus setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                        }

                        if ([paymentStatus isEqualToString:@"<null>"]) {
                            [breakDownLabelWithStatus setText:@"N/A"];
                            [breakDownCompleteLabelWithStatus setText:@"N/A"];
                        }
                        else if([paymentStatus isEqualToString:@"PAID"])
                        {
                            [breakdownChargeBackLabel setTextColor:[UIColor colorWithRed:48.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                            [breakDownCompleteLabelWithStatus setTextColor:[UIColor colorWithRed:48.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                            [breakDownLabelWithStatus setTextColor:[UIColor colorWithRed:48.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                            [breakDownLabelWithStatus setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                            [breakDownCompleteLabelWithStatus setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                            [breakdownChargeBackLabel setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                            [breakDownCompleteLabelWithStatus setTextColor:[UIColor colorWithRed:48.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                            [totalEarningsCompleteSeperatorLabel setFrame:CGRectMake(totalEarningsCompleteLabelTitle.frame.origin.x, totalEarningsCompleteLabelTitle.frame.origin.y - 5, totalEarningsCompleteSeperatorLabel.frame.size.width, 1)];
                            [cardStatusCompleteTypeLabel setFrame:CGRectMake(totalEarningsCompleteLabelTitle.frame.origin.x, totalEarningsCompleteLabelTitle.frame.origin.y+totalEarningsCompleteLabelTitle.frame.size.height+10, cardStatusCompleteTypeLabel.frame.size.width, cardStatusCompleteTypeLabel.frame.size.height)];
                            [breakDownLabelWithStatus setTextColor:[UIColor colorWithRed:48.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                               [totalEarningsSeperatorLabel setFrame:CGRectMake(totalEarningsLabelTitle.frame.origin.x, totalEarningsLabelTitle.frame.origin.y - 5, totalEarningsSeperatorLabel.frame.size.width, 1)];
                            [cardStatusTypeLabel setFrame:CGRectMake(totalEarningsLabelTitle.frame.origin.x, totalEarningsLabelTitle.frame.origin.y+totalEarningsLabelTitle.frame.size.height+10, cardStatusTypeLabel.frame.size.width, cardStatusTypeLabel.frame.size.height)];
                            
                            [paymentMethodLabel setHidden:NO];
                            [needHelpThirdButton setUserInteractionEnabled:YES];
                            //[needHelpThirdButton setFrame:CGRectMake(needHelpThirdButton.frame.origin.x, totalTitleLabel.frame.origin.y+totalTitleLabel.frame.size.height+10, needHelpThirdButton.frame.size.width, needHelpThirdButton.frame.size.height)];
                            
                            if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ChageBackFee"] isKindOfClass:[NSString class]]) {
                                NSString *chargeBackFee =[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ChageBackFee"];
                                if ([chargeBackFee isEqualToString:@"0.0000"])
                                {
                                    [chargeBackTitleLabel setHidden:YES];
                                    [chargeBackFeesLabel setHidden:YES];
                                    [totalTitleLabel setFrame:CGRectMake(totalTitleLabel.frame.origin.x, creditCardTitleLabel.frame.origin.y+creditCardTitleLabel.frame.size.height+15, 120, 21)];
                                    
                                    [totalTitleSeperatorLabel setFrame:CGRectMake(totalTitleLabel.frame.origin.x, totalTitleLabel.frame.origin.y - 5, totalTitleSeperatorLabel.frame.size.width, 1)];
                                    
                                    [totalAmountLabel setFrame:CGRectMake(totalAmountLabel.frame.origin.x, totalTitleLabel.frame.origin.y, totalAmountLabel.frame.size.width, totalAmountLabel.frame.size.height)];
                                    [paymentMethodLabel setFrame:CGRectMake(paymentMethodLabel.frame.origin.x, totalTitleLabel.frame.origin.y+totalTitleLabel.frame.size.height+10, paymentMethodLabel.frame.size.width, paymentMethodLabel.frame.size.height)];
                                    [needHelpButton setFrame:CGRectMake(needHelpButton.frame.origin.x, paymentMethodLabel.frame.origin.y+paymentMethodLabel.frame.size.height+25, needHelpButton.frame.size.width, needHelpButton.frame.size.height)];
                                }
                                else
                                {
                                    [chargeBackTitleLabel setHidden:NO];
                                    [chargeBackFeesLabel setHidden:NO];
                                    [paymentMethodLabel setText:@"Payment Method"];
                                    NSString *paymentMethode =[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]];
                                    [paidDirectlyToUser setHidden:NO];
                                    [paidDirectlyToUser setText:paymentMethode];
                                    chargeBackFeesLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ChageBackFee"]floatValue]]];
                                    discountCompleteLabel.text  = @"";
                                }
                            }
                            else {
                                chargeBackFeesLabel.text = @"$0.00";
                                discountCompleteLabel.text  = @"";
                            }
                        }
                    }
                    
                    if ([self.dateTypeStr isEqualToString:@"19"]) {
                      //  [cancellationFeeView setHidden:NO];
                        [totalEarningsLabelTitle setText:@"Total"];
                        [cardStatusTypeLabel setText:[NSString stringWithFormat:@"Deposit To: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                        [breakDownLabel setText:@"Charge Breakdown"];
                        if ([[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]] isEqualToString:@"<null>"]) {
                            [breakDownLabelWithStatus setText:@"N/A"];
                        }
                        else
                        {
                            [breakDownLabelWithStatus setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                        }
                    }
                    
                    else if ([self.dateTypeStr isEqualToString:@"20"]) {
                        [cancellationFeeView setHidden:NO];
                        
                        [totalEarningsLabelTitle setText:@"Total"];
                        [cardStatusTypeLabel setText:[NSString stringWithFormat:@"Payment Method: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                        [breakDownLabel setText:@"Charge Breakdown"];
                        if ([[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]] isEqualToString:@"<null>"]) {
                            [breakDownLabelWithStatus setText:@"N/A"];
                        }
                        else{
                            [breakDownLabelWithStatus setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                        }
                    }
                  
                    else if ([self.dateTypeStr isEqualToString:@"9"] || [self.dateTypeStr isEqualToString:@"11"])
                    {
                        [cancellationFeeView setHidden:YES];
                        
                        [totalEarningsLabelTitle setText:@"Total"];
                           [totalEarningsSeperatorLabel setFrame:CGRectMake(totalEarningsLabelTitle.frame.origin.x, totalEarningsLabelTitle.frame.origin.y - 5, totalEarningsSeperatorLabel.frame.size.width, 1)];
                        [breakDownCompleteLabelWithStatus setTextColor:[UIColor colorWithRed:48.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                           [totalEarningsCompleteSeperatorLabel setFrame:CGRectMake(totalEarningsCompleteLabelTitle.frame.origin.x, totalEarningsCompleteLabelTitle.frame.origin.y - 5, totalEarningsCompleteSeperatorLabel.frame.size.width, 1)];
                        [cardStatusCompleteTypeLabel setFrame:CGRectMake(totalEarningsCompleteLabelTitle.frame.origin.x, totalEarningsCompleteLabelTitle.frame.origin.y+totalEarningsCompleteLabelTitle.frame.size.height+10, cardStatusCompleteTypeLabel.frame.size.width, cardStatusCompleteTypeLabel.frame.size.height)];
                        [breakDownLabelWithStatus setTextColor:[UIColor colorWithRed:48.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                        [cardStatusTypeLabel setFrame:CGRectMake(cardStatusTypeLabel.frame.origin.x, paymentMethodLabel.frame.origin.y, cardStatusTypeLabel.frame.size.width, cardStatusTypeLabel.frame.size.height)];
                         [cardStatusCompleteTypeLabel setFrame:CGRectMake(cardStatusCompleteTypeLabel.frame.origin.x, paymentMethodLabel.frame.origin.y, cardStatusTypeLabel.frame.size.width, cardStatusTypeLabel.frame.size.height)];
                           [paidDirectlyToUser setFrame:CGRectMake(paidDirectlyToUser.frame.origin.x, paymentMethodLabel.frame.origin.y, paidDirectlyToUser.frame.size.width, paidDirectlyToUser.frame.size.height)];
                      //  cardStatusTypeLabel.backgroundColor = [UIColor redColor];
                       // paymentMethodLabel.backgroundColor = [UIColor redColor];
                       // cardStatusCompleteTypeLabel.backgroundColor = [UIColor redColor];
                        //paidDirectlyToUser.backgroundColor = [UIColor redColor];

                        [cardStatusCompleteTypeLabel setText:[NSString stringWithFormat:@"Payment Method: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                        [couponCodeCompleteLabel setText:[NSString stringWithFormat:@"Coupon Code: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"CouponCode"]]];
                        [breakDownCompleteLabel setText:@"Charge Breakdown"];
                        if ([[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]] isEqualToString:@"<null>"]) {
                            [breakDownLabelWithStatus setText:@"N/A"];
                        }
                        else{
                            [breakDownLabelWithStatus setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                        }
                    }
                    
                    else
                    {
                        //[cancellationFeeView setHidden:YES];
                        [totalEarningsLabelTitle setText:@"Total"];
                        [cardStatusTypeLabel setText:[NSString stringWithFormat:@"Payment Method: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                        [breakDownLabel setText:@"Charge Breakdown"];
                        [breakDownCompleteLabel setText:@"Charge Breakdown"];
                        [breakdownChargeBackTitleLabel setText:@"Charge Breakdown"];
                        if ([[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]] isEqualToString:@"<null>"]) {
                            [breakDownLabelWithStatus setText:@"N/A"];
                        }
                        else{
                            [breakDownLabelWithStatus setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                        }
                    }
                    
                    if ([self.dateTypeStr isEqualToString:@"19"]||[self.dateTypeStr isEqualToString:@"20"]) {
                        if ([self.dateTypeStr isEqualToString:@"19"]) {
                            if ([sharedInstance.CancelReasonID isEqualToString:@"56"]) {
                                [cancellationFeeView setHidden:NO];

                            }
                            else{
                            [cancellationFeeView setHidden:YES];
                            }

                        }else{
                            [cancellationFeeView setHidden:NO];

                        }
                        
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"CancellationFee"] isKindOfClass:[NSString class]]) {
                            [cancellationFeeLabel setText:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"CancellationFee"] floatValue]]]];
                            
                        }
                        
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] isKindOfClass:[NSString class]]) {
                            [subTotalLabel setText:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] floatValue]]]];
                        }
                        
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"] isKindOfClass:[NSString class]]) {
                            [totalEarningsLabel setText:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"] floatValue]]]];
                        }
                    }
                    else {
                        [cancellationFeeView setHidden:YES];
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DiscountAmount"] isKindOfClass:[NSString class]]) {
                        if (([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DiscountAmount"] isEqualToString:@"0.0000"]) || (![[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DiscountAmount"]length])) {
                            [discountCompleteLabel setHidden:YES];
                            [couponCodeCompleteLabel setHidden:YES];
                            [ discountCompleteLabelTitle setHidden:YES];
                            [totalEarningsCompleteLabelTitle setFrame:CGRectMake(totalEarningsCompleteLabelTitle.frame.origin.x, tipsCompleteLabel.frame.origin.y+tipsCompleteLabel.frame.size.height+15, 120, 21)];
                               [totalEarningsCompleteSeperatorLabel setFrame:CGRectMake(totalEarningsCompleteLabelTitle.frame.origin.x, totalEarningsCompleteLabelTitle.frame.origin.y - 5, totalEarningsCompleteSeperatorLabel.frame.size.width, 1)];
                            [totalEarningsCompleteLabel setFrame:CGRectMake(totalEarningsCompleteLabel.frame.origin.x, totalEarningsCompleteLabelTitle.frame.origin.y, totalEarningsCompleteLabel.frame.size.width, totalEarningsCompleteLabel.frame.size.height)];
                            [cardStatusCompleteTypeLabel setFrame:CGRectMake(totalEarningsCompleteLabelTitle.frame.origin.x, totalEarningsCompleteLabelTitle.frame.origin.y+totalEarningsCompleteLabelTitle.frame.size.height+10, cardStatusCompleteTypeLabel.frame.size.width, cardStatusCompleteTypeLabel.frame.size.height)];
                            [needHelpThirdButton setUserInteractionEnabled:YES];
                            //  [needHelpThirdButton setFrame:CGRectMake(needHelpThirdButton.frame.origin.x, cardStatusCompleteTypeLabel.frame.origin.y+cardStatusCompleteTypeLabel.frame.size.height+25, needHelpThirdButton.frame.size.width, needHelpThirdButton.frame.size.height)];
                        }
                        else
                        {
                            [discountCompleteLabel setHidden:NO];
                            [couponCodeCompleteLabel setHidden:NO];
                            [ discountCompleteLabelTitle setHidden:NO];
                            discountCompleteLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%d", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DiscountAmount"] intValue]]];
                        }
                    }
                    else
                    {
                        discountCompleteLabel.text  = @"";
                        [totalEarningsCompleteLabelTitle setFrame:CGRectMake(tipsCompleteLabel.frame.origin.x, tipsCompleteLabel.frame.origin.x+tipsCompleteLabel.frame.size.height+30, 120, 21)];
                           [totalEarningsCompleteSeperatorLabel setFrame:CGRectMake(totalEarningsCompleteLabelTitle.frame.origin.x, totalEarningsCompleteLabelTitle.frame.origin.y -10, totalEarningsCompleteSeperatorLabel.frame.size.width, 1)];
                        [totalEarningsCompleteLabel setFrame:CGRectMake(totalEarningsCompleteLabel.frame.origin.x, totalEarningsCompleteLabelTitle.frame.origin.y, totalEarningsCompleteLabel.frame.size.width, totalEarningsCompleteLabel.frame.size.height)];
                        [cardStatusCompleteTypeLabel setFrame:CGRectMake(totalEarningsCompleteLabelTitle.frame.origin.x, totalEarningsCompleteLabelTitle.frame.origin.y+totalEarningsCompleteLabelTitle.frame.size.height+10, cardStatusCompleteTypeLabel.frame.size.width, cardStatusCompleteTypeLabel.frame.size.height)];
                        [needHelpThirdButton setUserInteractionEnabled:YES];
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Rating"] isKindOfClass:[NSString class]])
                    {
                        if (([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Rating"] isEqualToString:@"<null>"]) || (![[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Rating"]length])) {
                            [rateYourDateButton setHidden:NO];
                            [rateYourDateButton setFrame:CGRectMake(durationTimeValueLabel.frame.origin.x, durationTimeValueLabel.frame.origin.y, durationTimeValueLabel.frame.size.width, durationTimeValueLabel.frame.size.height)];
                            [durationTimeValueLabel setText:@""];
                        }
                        else
                        {
                            [rateYourDateButton setHidden:YES];
                            [durationTimeValueLabel setText:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Rating"] floatValue]]];
                        }
                    }
                    else
                    {
                        [durationTimeValueLabel setText:@""];
                    }
                    
                    if ([self.dateTypeStr isEqualToString:@"17"] || [self.dateTypeStr isEqualToString:@"18"])
                    {
                        NSString *paymentStatus = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]];
                        [completeFeeView setHidden:YES];
                        [chargeBreakDownView setHidden:NO];
                        [cancellationFeeView setHidden:YES];
                        if ([paymentStatus isEqualToString:@"UNPAID"] ||[paymentStatus isEqualToString:@"CHARGEBACK"] ) {
                            [breakdownChargeBackLabel setTextColor:[UIColor redColor]];
                            [breakDownLabelWithStatus setTextColor:[UIColor redColor]];
                            [breakDownCompleteLabelWithStatus setTextColor:[UIColor redColor]];
                        }
                        else{
                            [breakdownChargeBackLabel setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                            [breakDownLabelWithStatus setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                            [breakDownCompleteLabelWithStatus setTextColor:[UIColor colorWithRed:45.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                        }

                        if([paymentStatus isEqualToString:@"CHARGEBACK"])
                        {
                            [breakdownChargeBackLabel setTextColor:[UIColor colorWithRed:191.0/255.0 green:41.0/255.0 blue:50.0/255.0 alpha:1.0]];
                            [paymentMethodLabel setHidden:NO];
                            [paymentMethodLabel setText:@"Payment Method"];
                            NSString *paymentMethode =[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]];
                            [paidDirectlyToUser setHidden:NO];
                            float totalAmountOfLabelOrigin =totalAmountLabel.frame.origin.x;
                            NSLog(@"Lable Orign Value %f", totalAmountOfLabelOrigin);
                            paidDirectlyToUser.numberOfLines = 0;
                            paidDirectlyToUser.lineBreakMode =NSLineBreakByWordWrapping;
                            [paidDirectlyToUser sizeToFit];
                            if (WIN_WIDTH == 320) {
                                [paidDirectlyToUser setFrame:CGRectMake(paidDirectlyToUser.frame.origin.x-15, paymentMethodLabel.frame.origin.y-15, paidDirectlyToUser.frame.size.width+43, paidDirectlyToUser.frame.size.height+20)];
                            }
                            else{
                                [paidDirectlyToUser setFrame:CGRectMake(paidDirectlyToUser.frame.origin.x-15, paymentMethodLabel.frame.origin.y, paidDirectlyToUser.frame.size.width+23, paidDirectlyToUser.frame.size.height+20)];
                            }

                            [paymentMethodLabel setFrame:CGRectMake(paymentMethodLabel.frame.origin.x, paymentMethodLabel.frame.origin.y, paymentMethodLabel.frame.size.width, paymentMethodLabel.frame.size.height)];
                            if ([paymentMethode isEqualToString:@"<null>"]) {
                                [paidDirectlyToUser setText:@""];
                            }
                            else{
                                [paidDirectlyToUser setText:paymentMethode];
                            }
                            [needHelpThirdButton setUserInteractionEnabled:YES];
                            if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ChageBackFee"] isKindOfClass:[NSString class]])
                            {
                                NSString *chargeBackFee =[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ChageBackFee"];
                                [chargeBackTitleLabel setHidden:NO];
                                [chargeBackFeesLabel setHidden:NO];
                                chargeBackFeesLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ChageBackFee"]floatValue]]];
                                discountCompleteLabel.text  = @"";
                            }
                            else
                            {
                                chargeBackFeesLabel.text = @"$0.00";
                                discountCompleteLabel.text  = @"";
                            }
                        }
                    }
                    
                    if ([self.dateTypeStr isEqualToString:@"25"])
                    {
                        NSString *paymentStatus = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]];
                        NSLog(@"Fee Payment %@",paymentStatus);
                        [completeFeeView setHidden:YES];
                        [chargeBreakDownView setHidden:NO];
                        [cancellationFeeView setHidden:YES];
//                        [breakdownChargeBackLabel setTextColor:[UIColor colorWithRed:48.0/255.0 green:180.0/255.0 blue:117.0/255.0 alpha:1.0]];
                        [paymentMethodLabel setHidden:NO];
                        [paymentMethodLabel setText:@"Payment Method"];
                        NSString *paymentMethode =[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]];
                        [paidDirectlyToUser setHidden:NO];
                        float totalAmountOfLabelOrigin =totalAmountLabel.frame.origin.x;
                        NSLog(@"Payment %f",totalAmountOfLabelOrigin);
                        paidDirectlyToUser.numberOfLines = 0;
                        paidDirectlyToUser.lineBreakMode = NSLineBreakByWordWrapping;
                        [paidDirectlyToUser sizeToFit];
                        if (WIN_WIDTH == 320) {
                             [paidDirectlyToUser setFrame:CGRectMake(paidDirectlyToUser.frame.origin.x-15, paymentMethodLabel.frame.origin.y-15, paidDirectlyToUser.frame.size.width+43, paidDirectlyToUser.frame.size.height+20)];
                        }
                        else{
                             [paidDirectlyToUser setFrame:CGRectMake(paidDirectlyToUser.frame.origin.x-15, paymentMethodLabel.frame.origin.y, paidDirectlyToUser.frame.size.width+23, paidDirectlyToUser.frame.size.height+20)];
                        }
                      
                        [paymentMethodLabel setFrame:CGRectMake(paymentMethodLabel.frame.origin.x, paymentMethodLabel.frame.origin.y, paymentMethodLabel.frame.size.width, paymentMethodLabel.frame.size.height)];
                        if ([paymentMethode isEqualToString:@"<null>"]) {
                            [paidDirectlyToUser setText:@""];
                        }
                        else{
                            [paidDirectlyToUser setText:paymentMethode];
                        }
                        [needHelpThirdButton setUserInteractionEnabled:YES];
                        
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ChageBackFee"] isKindOfClass:[NSString class]]) {
                            NSString *chargeBackFee =[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ChageBackFee"];
                            NSLog(@"Fee %@",chargeBackFee);
                            [chargeBackTitleLabel setHidden:NO];
                            [chargeBackFeesLabel setHidden:NO];
                            chargeBackFeesLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ChageBackFee"]floatValue]]];
                            discountCompleteLabel.text  = @"";
                        }
                        else {
                            chargeBackFeesLabel.text = @"$0.00";
                            discountCompleteLabel.text  = @"";
                        }
                    }
                    if([self.dateTypeStr isEqualToString:@"6"] ||[self.dateTypeStr isEqualToString:@"10"] || [self.dateTypeStr isEqualToString:@"19"])
                    {
                        [sepeartorLabel setFrame:CGRectMake(sepeartorLabel.frame.origin.x, durationTimeValueLabel.frame.origin.y+durationTimeValueLabel.frame.size.height+5, self.view.frame.size.width, 1)];
                    }
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}

-(void)setStatusLabel
{
    if ([self.dateTypeStr isEqualToString:@"2"]) {
        
        // statusLabel.text = @"Decline By Contractor";
        statusLabel.text = [NSString stringWithFormat:@"Declined By %@",userNameBy];
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    else if ([self.dateTypeStr isEqualToString:@"4"]) {
        
        //  statusLabel.text = @"Decline By Customer";
        statusLabel.text = [NSString stringWithFormat:@"Declined By %@",userNameBy];
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    else if ([self.dateTypeStr isEqualToString:@"5"])
    {
        statusLabel.text = @"Completed";
    }
    else if ([self.dateTypeStr isEqualToString:@"6"] || [self.dateTypeStr isEqualToString:@"19"]) {
        statusLabel.text = [NSString stringWithFormat:@"Canceled By %@",userNameBy];
        // statusLabel.text = @"Cancel By Customer";
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    else if ([self.dateTypeStr isEqualToString:@"9"]) {
        statusLabel.text = @"Completed";
        // chargeBreakDownView.hidden = YES;
    }
    else if ([self.dateTypeStr isEqualToString:@"10"]|| [self.dateTypeStr isEqualToString:@"20"]) {
        
        statusLabel.text = [NSString stringWithFormat:@"Canceled By %@",userNameBy];
        //  statusLabel.text = @"Cancel By Contractor";
        chargeBreakDownView.hidden = YES;
    }
    else if ([self.dateTypeStr isEqualToString:@"12"]) {
        
        statusLabel.text = @"Completed";
        // chargeBreakDownView.hidden = YES;
    }
    else if ([self.dateTypeStr isEqualToString:@"15"]) {
        
        statusLabel.text = @"Auto Decline Date";
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    else if ([self.dateTypeStr isEqualToString:@"17"] || ([self.dateTypeStr isEqualToString:@"18"]) ||([self.dateTypeStr isEqualToString:@"25"])) {
        statusLabel.text = @"Completed";
        
    }
    else if ([self.dateTypeStr isEqualToString:@"11"]) {
        statusLabel.text = @"Completed";
        // statusLabel.text = @"Auto Decline Date";
        // chargeBreakDownView.hidden = YES;
        // needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    else
    {
        statusLabel.text = @"";
    }
}


#pragma mark: Change Date in Particular Formate
-(NSString *)changeDateInParticularFormateWithString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MMMM d, YYYY @ hh:mm aaa"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
    
}

#pragma mark: Change Date in Particular Formate
-(NSString *)changeDateInParticularFormateWithStringForDate :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM/dd/yyyy hh:mm aaa"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
}


#pragma mark:- Change UTC time Current Local Time

- (NSString *) convertUTCTimeToLocalTime:(NSString *)dateString WithFormate:(NSString *)formate{
    
    //formate = @"yyyy-MM-dd'T'HH:mm:ss"
    [dateFormatter setDateFormat:formate];
    NSTimeZone *gmtTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //Log: gmtTimeZone - GMT (GMT) offset 0
    
    [dateFormatter setTimeZone:gmtTimeZone];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    //Log: dateFromString - 2016-03-08 06:00:00 +0000
    
    [NSTimeZone setDefaultTimeZone:[NSTimeZone systemTimeZone]];
    NSTimeZone * sourceTimeZone = [NSTimeZone defaultTimeZone];
    //Log: sourceTimeZone - America/New_York (EDT) offset -14400 (Daylight)
    // Add daylight time
    BOOL isDayLightSavingTime = [sourceTimeZone isDaylightSavingTimeForDate:dateFromString];
    if (isDayLightSavingTime) {
    
    }
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:sourceTimeZone];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:dateFromString];
    //Log: dateRepresentation - 2016-03-08 01:00:00
    return dateRepresentation;
}

@end
