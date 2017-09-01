
//  PastDateDetailsViewController.m
//  Customer
//  Created by Jamshed Ali on 10/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "PastDateDetailsViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "SelectIssueViewController.h"
#import "ServerRequest.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AppDelegate.h"
#import "RatingViewController.h"
#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width
@interface PastDateDetailsViewController (){
    NSDictionary *dataDictionary;
    SingletonClass *sharedInstance;
    NSDateFormatter *dateFormatter;
    NSString *userName;
    NSString *userNameBy;
    NSString *baseFee;
    NSString *additionalFee;
    NSString *doumeeFee;
    NSString *TransactionFee;
    NSString *tipAmountFee;
    NSString *totalPaidAmount;
}

@end

@implementation PastDateDetailsViewController
@synthesize dateIdStr,dateTypeStr;

#pragma mark View Controller Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)showProperList:(PastDateDetailsList)mode
{
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    //Call SetUp Laod methode
    [self setUpLoadMethod];
}

-(void)setUpLoadMethod
{
    needHelpButton.layer.cornerRadius = 2;
    needHelpButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    needHelpButton.layer.borderWidth = 1;
    
    needHelpSecondButton.layer.cornerRadius = 2;
    needHelpSecondButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    needHelpSecondButton.layer.borderWidth = 1;
    [sepeartorLabel setHidden:YES];
    [rateYourDateButton setHidden:YES];
    dateFormatter = [[NSDateFormatter alloc]init];
    sharedInstance = [SingletonClass sharedInstance];
    chargeBreakDownView.hidden = YES;
    cancellationFeeView.hidden = YES;
    [rateYourDateButton setFrame:CGRectMake(statusLabel.frame.origin.x, statusLabel.frame.origin.y+statusLabel.frame.size.height+15, rateYourDateButton.frame.size.width, rateYourDateButton.frame.size.height)];
    
    [bgScrollView addSubview:needHelpSecondButton];
    if (WIN_WIDTH == 320) {
        needHelpSecondButton.frame = CGRectMake(self.view.frame.size.width/2-72, (chargeBreakDownView.frame.origin.y+chargeBreakDownView.frame.size.height)+200, 144, 35);
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, (chargeBreakDownView.frame.origin.y+chargeBreakDownView.frame.size.height)+145, 144, 35);
        
    }
    else{
        needHelpSecondButton.frame = CGRectMake(self.view.frame.size.width/2-72, (chargeBreakDownView.frame.origin.y+chargeBreakDownView.frame.size.height)+165, 144, 35);
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, (chargeBreakDownView.frame.origin.y+chargeBreakDownView.frame.size.height)+165, 144, 35);
        
    }
    
    [needHelpButton setHidden:YES];
    if ([self.dateTypeStr isEqualToString:@"2"]) {
        chargeBreakDownView.hidden = YES;
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    else if ([self.dateTypeStr isEqualToString:@"4"]) {
        chargeBreakDownView.hidden = YES;
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
        
    }
    else if ([self.dateTypeStr isEqualToString:@"5"]) {
    }
    else if ([self.dateTypeStr isEqualToString:@"6"]) {
        [sepeartorLabel setHidden:YES];
        [seperatorDownView setHidden:NO ];
        chargeBreakDownView.hidden = YES;
        [cancellationFeeView setHidden:YES];
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    else if ([self.dateTypeStr isEqualToString:@"9"]) {
        [seperatorDownView setHidden:YES ];
        
    }
    else if ([self.dateTypeStr isEqualToString:@"19"] || [self.dateTypeStr isEqualToString:@"20"]) {
        chargeBreakDownView.hidden = YES;
        [cancellationFeeView setHidden:NO];
        [cancellationFeeView setFrame:CGRectMake(cancellationFeeView.frame.origin.x, 408, cancellationFeeView.frame.size.width, cancellationFeeView.frame.size.height)];
        [seperatorDownView setHidden:YES];
        [seperatorDownView setFrame:CGRectMake(seperatorDownView.frame.origin.x, 407, self.view.frame.size.width, 1)];
    }
    else if ([self.dateTypeStr isEqualToString:@"11"]) {
        [seperatorDownView setFrame:CGRectMake(seperatorDownView.frame.origin.x, 407, self.view.frame.size.width, 1)];
    }
    else if ([self.dateTypeStr isEqualToString:@"10"]) {
        [sepeartorLabel setHidden:NO];
        [cancellationFeeView setHidden:YES];
        chargeBreakDownView.hidden = YES;
        
    }
    else if ([self.dateTypeStr isEqualToString:@"12"])
        
    {
        [seperatorDownView setHidden:YES ];
        
    }
    
    else if ([self.dateTypeStr isEqualToString:@"15"])
    {
        chargeBreakDownView.hidden = YES;
        needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
        
    }
    else if ([self.dateTypeStr isEqualToString:@"13"]) {
        
        // statusLabel.text = @"Auto Decline Date";
        // chargeBreakDownView.hidden = YES;
        // needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
        
    }
    else if ([self.dateTypeStr isEqualToString:@"11"]) {
        // statusLabel.text = @"Auto Decline Date";
        // chargeBreakDownView.hidden = YES;
        // needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    else  {
        chargeBreakDownView.hidden = YES;
    }
    userNameLabel.text =  self.userNameStr;
    NSString *setPrimaryImageUrlStr =  [NSString stringWithFormat:@"%@",self.picUrlStr];
    NSURL *imageUrl = [NSURL URLWithString:setPrimaryImageUrlStr];
    [userImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    NSString *dateType =   self.dateTypeStr;
    if ([dateType isEqualToString:@"6"]  || [dateType isEqualToString:@"10"] || [dateType isEqualToString:@"19"] || [dateType isEqualToString:@"20"]) {
        if ([_dateRequestedType isEqualToString:@"1"]) {
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
    
    [self dateDetailsApiCall];
}

- (void)checkSignalRReqest:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    if ([requestTypeStr isEqualToString:@"1"]) {
        NSString *dateIdString = [responseObject objectForKey:@"dateId"];
        NSDictionary *dataDictionaryy = @{@"DateID":dateIdString,@"Type":requestTypeStr};
        if (sharedInstance.onDemandPushNotificationArray.count) {
            [sharedInstance.onDemandPushNotificationArray removeAllObjects];
        }
        [sharedInstance.onDemandPushNotificationArray addObject:dataDictionaryy];
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

- (void)viewDidLayoutSubviews {
    bgScrollView.contentSize = CGSizeMake(320, 800);
}

#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark UIBUtton Action Methode
- (IBAction)needHelpButtonClicked:(id)sender {
    
    SelectIssueViewController *selectIssueView = [self.storyboard instantiateViewControllerWithIdentifier:@"selectIssue"];
    selectIssueView.self.dataDictionary = [dataDictionary objectForKey:@"DateDetails"];
    selectIssueView.self.dateIdStr = self.dateIdStr;
    
    selectIssueView.self.userNameStr = self.userNameStr;
    selectIssueView.self.userImagePicUrl = self.picUrlStr;
    NSString *requestTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"StartTime"]];
    NSString *requestDate = [self convertUTCTimeToLocalTime:requestTimeStr WithFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    selectIssueView.self.dateCompletedTimeStr = [self changeDateInParticularFormateWithString:requestDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
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

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rateYourDateButtonClicked:(id)sender {
    
    RatingViewController *rateViewCall = [self.storyboard instantiateViewControllerWithIdentifier:@"rating"];
    rateViewCall.isFromDateDetails = YES;
    rateViewCall.self.dateIdStr = self.dateIdStr;
    rateViewCall.self.nameStr = [[dataDictionary objectForKey:@"EndDateCustomer"] objectForKey:@"UserName"];
    rateViewCall.self.imageUrlStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Url"]];
    NSString *requestTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"EndTime"]];
    NSString *requestDate = [self convertUTCTimeToLocalTime:requestTimeStr WithFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    rateViewCall.self.dateCompletedTimeStr = [self changeDateInParticularFormateWithString:requestDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
    [self.navigationController pushViewController:rateViewCall animated:YES];
    
}
#pragma mark Get Date Details API Call
- (void)dateDetailsApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSLog(@"%@",userIdStr);
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userType=%@&DateID=%@&DateType=%@",APIDateDetailsPast,@"2",self.dateIdStr,self.dateTypeStr];
    
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]]))
        {
            //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            [reservationTimeImage setHidden:YES];
            [greenStartImage setHidden:YES];
            [redEndImage setHidden:YES];
            [statusImage setHidden:YES];
            [locationImage setHidden:YES];
            [ratingImage setHidden:YES];
            [cancellationFeeView setHidden:YES];
            [chargeBreakDownView setHidden:YES];
        }
        else
        {
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    dataDictionary = [responseObject mutableCopy];
                    [reservationTimeImage setHidden:NO];
                    [greenStartImage setHidden:NO];
                    [redEndImage setHidden:NO];
                    [statusImage setHidden:NO];
                    [locationImage setHidden:NO];
                    [ratingImage setHidden:NO];
                    
                    //NSArray *imageDataArray = [dataDictionary objectForKey:@"UserPicture"];
                    //    userNameLabel.text =  [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"UserName"];
                    userName =[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"UserName"];
                    userNameBy =[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"UserNameby"];
                    sharedInstance.cancelReasonIdValue = [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"CancelReasonID"];
                    NSLog(@"Reason ID Value %@", sharedInstance.cancelReasonIdValue);
                    if(WIN_WIDTH == 320){
                        [locationLabel setFrame:CGRectMake(locationLabel.frame.origin.x, locationLabel.frame.origin.y, locationLabel.frame.size.width-25, locationLabel.frame.size.height)];
                    }
                    
                    locationLabel.text =  [[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Location"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    locationLabel.numberOfLines = 0;
                    locationLabel.lineBreakMode =NSLineBreakByWordWrapping;
                    [locationLabel sizeToFit];
                    
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
                    
                    if ([self.dateTypeStr isEqualToString:@"6"] || [self.dateTypeStr isEqualToString:@"10"]) {
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] isKindOfClass:[NSString class]]) {
                            
                            subtotalLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] floatValue]]];
                            [subTotalLabel setText:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] floatValue]]]];
                        }
                        else {
                            subtotalLabel.text = @"";
                        }
                        
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"] isKindOfClass:[NSString class]]) {
                            
                            [totalEarningsLabel setText:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"] floatValue]]]];
                            totalAmountLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"]floatValue]]];
                            totalPaidAmount = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Total"]floatValue]]];
                        }
                        else {
                            totalEarningsLabel.text =@"$0.00";
                            totalAmountLabel.text = @"$0.00";
                            totalPaidAmount =@"$0.00";
                        }
                    }
                    else
                    {
                        if ((![[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"BaseFee"] isKindOfClass:[NSNull class]])) {
                            baseFee = [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"BaseFee"];
                        }
                        else
                        {
                            if ((![[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] isKindOfClass:[NSNull class]])) {
                                baseFee = [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"];
                            }
                            else{
                                baseFee = @"0.00";
                            }
                        }
                        if ( (![[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ExtraAmount"]  isKindOfClass:[NSNull class]])) {
                            additionalFee = [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ExtraAmount"];
                        }
                        else{
                            additionalFee = @"0.00";
                        }
                        if ( (![[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DoumeesFee"]  isKindOfClass:[NSNull class]])) {
                            doumeeFee = [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DoumeesFee"];
                        }
                        else{
                            doumeeFee = @"0.00";
                        }
                        if ( (![[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TransactionFee"]  isKindOfClass:[NSNull class]])) {
                            TransactionFee = [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TransactionFee"];
                        }
                        else{
                            TransactionFee = @"0.00";
                        }
                        if ( (![[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TipAmount"]  isKindOfClass:[NSNull class]])) {
                            tipAmountFee = [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TipAmount"];
                        }
                        else{
                            tipAmountFee = @"0.00";
                        }
                        NSString *subTotalAmount =  [self calculateTheAmountBaseFee:[NSString stringWithFormat:@"%.2f", [baseFee floatValue]] withFee:[NSString stringWithFormat:@"%.2f",[additionalFee floatValue]] DoumeesFees:[NSString stringWithFormat:@"%.2f",[doumeeFee floatValue]] with:[NSString stringWithFormat:@"-%.2f", [TransactionFee floatValue]]];
//                        NSString *totalAmount = [self calculateTotalAmountWithSubtotalValue:subTotalAmount with:[NSString stringWithFormat:@"%.2f", [tipAmountFee floatValue]]];
                        NSString *totalAmount = [self calculateTotalAmountWithSubtotalValue:subTotalAmount with:[NSString stringWithFormat:@"%.2f", [tipAmountFee floatValue]] DoumeesFees:[NSString stringWithFormat:@"%.2f",[doumeeFee floatValue]] withtarns:[NSString stringWithFormat:@"%.2f", [TransactionFee floatValue]]];
                        
                        
                        NSLog(@"Total Amount Label %@",totalAmount);
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"BaseFee"] isKindOfClass:[NSString class]]) {
                        
                        minimumAmountLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"BaseFee"] floatValue]]];
                    }
                    else {
                        minimumAmountLabel.text  =@"$0.00";
                    }
                    
                    if ([self.dateTypeStr isEqualToString:@"6"]|| [self.dateTypeStr isEqualToString:@"10"]) {
                        [chargeBreakDownView setHidden:YES];
                        [needHelpSecondButton setHidden:YES];
                        [cancellationFeeView setHidden:YES];
                    }
                    else{
                        NSString *additionalTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"AdditionalDuration"] ];
                        
                        if ([additionalTimeStr integerValue]>0) {
                            [chargeBreakDownView setHidden:NO];
                            [cancellationFeeView setHidden:YES];
                        }
                        else
                        {
                            [chargeBreakDownView setHidden:NO];
                            [cancellationFeeView setHidden:YES];
                        }
                    }
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"AdditionalDuration"] isKindOfClass:[NSString class]]) {
                        
                        
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"AdditionalDuration"] isKindOfClass:[NSString class]]) {
                            NSString *extraTime = [NSString stringWithFormat:@"%d",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"AdditionalDuration"] intValue]];
                            if ([extraTime isEqualToString:@"0"]) {
                                additionalTitleTimeLabel.text = [NSString stringWithFormat:@"Additional Time"];
                            }
                            else {
                                additionalTitleTimeLabel.text = [NSString stringWithFormat:@"Additional Time (%@)",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"AdditionalDuration"]];
                            }
                            additonalTimeLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ExtraAmount"] floatValue]]] ;
                        }
                        else
                        {
                            additonalTimeLabel.text = @"";
                        }
                    }
                    
                    else {
                        additonalTimeLabel.text = @"";
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TipAmount"] isKindOfClass:[NSString class]]) {
                        tipsCompleteLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TipAmount"] floatValue]]];
                    }
                    else
                    {
                        tipsCompleteLabel.text = @"$0.00";
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"] isKindOfClass:[NSString class]]) {
                        [cardPaymentStatusTypeLabel setText:[NSString stringWithFormat:@"Deposit To: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                    }
                    else
                    {
                        cardPaymentStatusTypeLabel.text = @"";
                    }
                    
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DoumeesFee"] isKindOfClass:[NSString class]]) {
                        
                        creditCardFeesLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"-%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DoumeesFee"] floatValue]]];
                    }
                    else {
                        creditCardFeesLabel.text = @"";
                    }
                    
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ChageBackFee"] isKindOfClass:[NSString class]]) {
                        
                        chargeBackFeesLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"ChageBackFee"]floatValue]]];
                    } else {
                        chargeBackFeesLabel.text = @"";
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TransactionFee"] isKindOfClass:[NSString class]]) {
                        cardNumberLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"-%.2f", [[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TransactionFee"]floatValue]]];
                        
                    }
                    else
                    {
                        cardNumberLabel.text = @"";
                    }
                    
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentType"] isKindOfClass:[NSString class]])
                    {
                        paidDirectlyToUser.text = [NSString stringWithFormat:@"%@ to %@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentType"],[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"UserName"]];
                    }
                    else
                    {
                        paidDirectlyToUser.text = @"";
                    }
                    
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
                    
                    if ([[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]] isEqualToString:@"<null>"]) {
                        [breakDownLabelWithStatus setText:@"N/A"];
                        [breakDownCompleteLabel setText:@"N/A"];
                        [breakDownLabelWithStatusComplete setText:@"N/A"];
                    }
                    else
                    {
                        if ([self.dateTypeStr isEqualToString:@"19"] || [self.dateTypeStr isEqualToString:@"20"] || [self.dateTypeStr isEqualToString:@"17"]) {
                            if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"] isEqualToString:@"CHARGEBACK"]) {
                                breakDownLabelWithStatus.textColor = [UIColor redColor];
                                breakDownCompleteLabel.textColor = [UIColor redColor];
                                breakDownLabelWithStatusComplete.textColor = [UIColor redColor];
                            }
                            [breakDownLabelWithStatus setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                            [breakDownCompleteLabel setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                            [breakDownLabelWithStatusComplete setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                        }
                        else{
                            [breakDownLabelWithStatus setText:@"PROCESSED"];
                            [breakDownCompleteLabel setText:@"PROCESSED"];
                            [breakDownLabelWithStatusComplete setText:@"PROCESSED"];
                        }
                        
                    }
                    
                    if ([self.dateTypeStr isEqualToString:@"2"]|| [self.dateTypeStr isEqualToString:@"4"]||[self.dateTypeStr isEqualToString:@"6"]||[self.dateTypeStr isEqualToString:@"10"]||[self.dateTypeStr isEqualToString:@"19"]||[self.dateTypeStr isEqualToString:@"20"]) {
                        
                        greenStartImage.hidden = YES;
                        redEndImage.hidden = YES;
                        dateStartTimeLabel.hidden = YES;
                        dateEndTimeLabel.hidden = YES;
                        float originValueOfLocation = locationLabel.frame.origin.x;
                        float originValueOfImageLocation = reservationTimeImage.frame.origin.x;
                        NSLog(@"Origin Value %f",originValueOfLocation);
                        locationTitleLabel.frame = CGRectMake(11,45,70,25);
                        if(WIN_WIDTH == 320){
                            [locationLabel setFrame:CGRectMake(originValueOfLocation, datelabel.frame.origin.y+datelabel.frame.origin.y+25, locationLabel.frame.size.width-10, locationLabel.frame.size.height)];
                        }
                        else{
                            [locationLabel setFrame:CGRectMake(originValueOfLocation, datelabel.frame.origin.y+datelabel.frame.origin.y+25, locationLabel.frame.size.width, locationLabel.frame.size.height)];
                        }
                        [locationImage setFrame:CGRectMake(originValueOfImageLocation+10, 52, 15, 15)];
                        locationLabel.numberOfLines = 0;
                        locationLabel.lineBreakMode =NSLineBreakByWordWrapping;
                        locationLabel.textAlignment = NSTextAlignmentLeft;
                        [locationLabel sizeToFit];
                        
                        if ([self.dateTypeStr isEqualToString:@"6"] || [self.dateTypeStr isEqualToString:@"10"])
                        {
                            [durationTimeValueLabel setHidden:YES];
                            [ratingImage setHidden:YES];
                            [seperatorDownView setHidden:NO];
                            [seperatorDownView setFrame:CGRectMake(seperatorDownView.frame.origin.x, statusLabel.frame.origin.y+statusLabel.frame.size.height+10, self.view.frame.size.width, 1)];
                        }
                        else
                        {
                            [durationTimeValueLabel setHidden:NO];
                            [ratingImage setHidden:NO];
                            [sepeartorLabel setHidden:NO];
                            [seperatorDownView setHidden:NO];
                        }
                        if ([self.dateTypeStr isEqualToString:@"19"]||[self.dateTypeStr isEqualToString:@"20"]) {
                            if ([sharedInstance.cancelReasonIdValue isEqualToString:@"56"]) {
                                
                            }
                            [durationTimeValueLabel setHidden:YES];
                            [ratingImage setHidden:YES];
                            [seperatorDownView setHidden:YES];
                            [sepeartorLabel setHidden:YES];
                            
                        }
                        else if ([self.dateTypeStr isEqualToString:@"17"]){
                            [sepeartorLabel setHidden:YES];
                            
                        }
                        else
                        {
                            if ([self.dateTypeStr isEqualToString:@"6"] || [self.dateTypeStr isEqualToString:@"10"]){
                                
                                [ratingImage setHidden:YES];
                                [durationTimeValueLabel setHidden:YES];
                                [sepeartorLabel setHidden:YES];
                                [seperatorDownView setHidden:NO];
                            }
                            else
                            {
                                [ratingImage setHidden:NO];
                                [durationTimeValueLabel setHidden:NO];
                                [sepeartorLabel setHidden:NO];
                                [seperatorDownView setHidden:NO];
                                
                            }
                        }
                        durationTitleLabel.frame = CGRectMake(11,locationLabel.frame.origin.y+locationLabel.frame.size.height+8, 70, 25);
                        durationTimeValueLabel.frame = CGRectMake(originValueOfLocation, locationLabel.frame.origin.y+locationLabel.frame.size.height+8, 100, 25);
                        // durationTimeValueLabel.text = @"0 mins";
                        statusTitleLabel.frame = CGRectMake(originValueOfLocation, durationTitleLabel.frame.origin.y+durationTitleLabel.frame.size.height+8, 70, 25);
                        statusLabel.frame = CGRectMake(originValueOfLocation, locationLabel.frame.origin.y+locationLabel.frame.size.height+8, self.view.frame.size.width-originValueOfLocation, 25);
                        [statusImage setFrame:CGRectMake(originValueOfImageLocation+10, statusLabel.frame.origin.y+5, 15, 15)];
                        [self setStatusLabel];
                        
                    }
                    else {
                        [sepeartorLabel setHidden:NO];
                        float originValueOfImageLocation = reservationTimeImage.frame.origin.x;
                        locationLabel.numberOfLines = 0;
                        locationLabel.lineBreakMode =NSLineBreakByWordWrapping;
                        [locationLabel sizeToFit];
                        durationTitleLabel.frame = CGRectMake(11,locationLabel.frame.origin.y+locationLabel.frame.size.height+8, 70, 25);
                        // durationTimeValueLabel.text = @"0 mins";
                        statusTitleLabel.frame = CGRectMake(11, durationTimeValueLabel.frame.origin.y+durationTimeValueLabel.frame.size.height+2, 70, 25);
                        statusLabel.frame = CGRectMake(statusLabel.frame.origin.x, locationLabel.frame.origin.y+locationLabel.frame.size.height+5, statusLabel.frame.size.width, statusLabel.frame.size.height);
                        if (WIN_WIDTH == 320) {
                            [statusImage setFrame:CGRectMake(originValueOfImageLocation+13, statusLabel.frame.origin.y+12, 15, 15)];
                            [greenStartImage setFrame:CGRectMake(datelabel.frame.origin.x, datelabel.frame.origin.y+datelabel.frame.size.height+8, 10, 10)];
                            [dateStartTimeLabel setFrame:CGRectMake(greenStartImage.frame.origin.x+greenStartImage.frame.size.width+4, datelabel.frame.origin.y+datelabel.frame.size.height+2, dateStartTimeLabel.frame.size.width+10, dateStartTimeLabel.frame.size.height)];
                            dateStartTimeLabel.font = [UIFont systemFontOfSize:10];
                            dateEndTimeLabel.font = [UIFont systemFontOfSize:10];
                            //dateStartTimeLabel.backgroundColor = [UIColor redColor];
                            [redEndImage setFrame:CGRectMake(dateStartTimeLabel.frame.origin.x+dateStartTimeLabel.frame.size.width+8, datelabel.frame.origin.y+datelabel.frame.size.height+8, 10, 10)];
                            [dateEndTimeLabel setFrame:CGRectMake(redEndImage.frame.origin.x+redEndImage.frame.size.width+4, datelabel.frame.origin.y+datelabel.frame.size.height+2, dateEndTimeLabel.frame.size.width+40, dateEndTimeLabel.frame.size.height)];
                            statusLabel.frame = CGRectMake(statusLabel.frame.origin.x, locationLabel.frame.origin.y+locationLabel.frame.size.height+10, statusLabel.frame.size.width, statusLabel.frame.size.height);
                            //                             locationLabel.frame = CGRectMake(locationLabel.frame.origin.x, dateStartTimeLabel.frame.origin.y+dateStartTimeLabel.frame.size.height+5, self.view.frame.size.width-locationLabel.frame.origin.x-10, 25);
                        }
                        else
                        {
                            // locationLabel.frame = CGRectMake(locationLabel.frame.origin.x, 48, self.view.frame.size.width-locationLabel.frame.origin.x, 25);
                            [statusImage setFrame:CGRectMake(originValueOfImageLocation+10, statusLabel.frame.origin.y+5, 15, 15)];
                            statusLabel.frame = CGRectMake(statusLabel.frame.origin.x, locationLabel.frame.origin.y+locationLabel.frame.size.height+5, statusLabel.frame.size.width, statusLabel.frame.size.height);
                            dateStartTimeLabel.font = [UIFont systemFontOfSize:12];
                            dateEndTimeLabel.font = [UIFont systemFontOfSize:12];
                            
                            [greenStartImage setFrame:CGRectMake(datelabel.frame.origin.x, datelabel.frame.origin.y+datelabel.frame.size.height+8, 10, 10)];
                            [dateStartTimeLabel setFrame:CGRectMake(greenStartImage.frame.origin.x+greenStartImage.frame.size.width+4, datelabel.frame.origin.y+datelabel.frame.size.height+2, dateStartTimeLabel.frame.size.width+20, dateStartTimeLabel.frame.size.height)];
                            //dateStartTimeLabel.backgroundColor = [UIColor redColor];
                            [redEndImage setFrame:CGRectMake(dateStartTimeLabel.frame.origin.x+dateStartTimeLabel.frame.size.width+5, datelabel.frame.origin.y+datelabel.frame.size.height+8, 10, 10)];
                            [dateEndTimeLabel setFrame:CGRectMake(redEndImage.frame.origin.x+redEndImage.frame.size.width+4, datelabel.frame.origin.y+datelabel.frame.size.height+2, dateEndTimeLabel.frame.size.width+28, dateEndTimeLabel.frame.size.height)];
                        }
                        [locationImage setFrame:CGRectMake(originValueOfImageLocation+10, locationLabel.frame.origin.y+3, 15, 15)];
                        
                        durationTimeValueLabel.frame = CGRectMake(statusLabel.frame.origin.x, statusLabel.frame.origin.y+statusLabel.frame.size.height+5, durationTimeValueLabel.frame.size.width, durationTimeValueLabel.frame.size.height);
                        [ratingImage setFrame:CGRectMake(originValueOfImageLocation+14, durationTimeValueLabel.frame.origin.y+5, 15, 15)];
                        rateYourDateButton.frame = CGRectMake(statusLabel.frame.origin.x, statusLabel.frame.origin.y+statusLabel.frame.size.height+5, rateYourDateButton.frame.size.width, rateYourDateButton.frame.size.height);
                        [self setStatusLabel];
                        NSString *additionalTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"AdditionalDuration"] ];
                        
                        if ([additionalTimeStr integerValue]>0) {
                            [chargeBreakDownView setHidden:NO];
                            [cancellationFeeView setHidden:YES];
                        }
                        else
                        {
                            NSString *additionalTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DoumeesFee"] ];
                            if ([additionalTimeStr integerValue]>0) {
                                [chargeBreakDownView setHidden:NO];
                                [cancellationFeeView setHidden:YES];
                                
                            }
                            else
                            {
                                [chargeBreakDownView setHidden:NO];
                                [cancellationFeeView setHidden:YES];
                                [self setChargeBackView ];
                            }
                        }
                    }
                    if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Rating"] isKindOfClass:[NSString class]]) {
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
                    else{
                        [durationTimeValueLabel setText:@""];
                        
                    }
                    
                    if ([self.dateTypeStr isEqualToString:@"19"])
                    {
                        if ([sharedInstance.cancelReasonIdValue isEqualToString:@"56"]) {
                            
                            [totalEarningsLabelTitle setText:@"Total Earnings"];
                            [cardStatusTypeLabel setText:[NSString stringWithFormat:@"Deposit To: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                            [cardPaymentStatusTypeLabel setText:[NSString stringWithFormat:@"Deposit To: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                            [breakDownLabel setText:@"Earnings Breakdown"];
                            [breakDownlabelWithCharging setText:@"Earnings Breakdown"];
                            
                            if ([[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]] isEqualToString:@"<null>"]) {
                                [breakDownLabelWithStatus setText:@"N/A"];
                            }
                            else
                            {
                                if ([self.dateTypeStr isEqualToString:@"19"] || [self.dateTypeStr isEqualToString:@"20"]) {
                                    [breakDownLabelWithStatus setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                                    [breakDownCompleteLabel setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                                }
                                else{
                                    [breakDownLabelWithStatus setText:@"PROCESSED"];
                                    [breakDownCompleteLabel setText:@"PROCESSED"];
                                }
                            }
                        }
                        else{
                        [totalEarningsLabelTitle setText:@"Total"];
                        [cardStatusTypeLabel setText:[NSString stringWithFormat:@"Payment Method: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                        [breakDownLabel setText:@"Charge Breakdown"];
                        [breakDownlabelWithCharging setText:@"Charge Breakdown"];
                        if ([[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]] isEqualToString:@"<null>"]) {
                            [breakDownLabelWithStatus setText:@"N/A"];
                            [breakDownCompleteLabel setText:@"N/A"];
                            
                        }
                        else
                        {
                            if ([self.dateTypeStr isEqualToString:@"19"] || [self.dateTypeStr isEqualToString:@"20"]) {
                                [breakDownLabelWithStatus setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                                [breakDownCompleteLabel setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                            }
                            else{
                                [breakDownLabelWithStatus setText:@"PROCESSED"];
                                [breakDownCompleteLabel setText:@"PROCESSED"];
                            }
                        }
                        }
                    }
                    else  if ([self.dateTypeStr isEqualToString:@"20"] )
                    {
                        [totalEarningsLabelTitle setText:@"Total Earnings"];
                        [cardStatusTypeLabel setText:[NSString stringWithFormat:@"Deposit To: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                        [cardPaymentStatusTypeLabel setText:[NSString stringWithFormat:@"Deposit To: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                        [breakDownLabel setText:@"Earnings Breakdown"];
                        [breakDownlabelWithCharging setText:@"Earnings Breakdown"];
                        
                        if ([[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]] isEqualToString:@"<null>"]) {
                            [breakDownLabelWithStatus setText:@"N/A"];
                        }
                        else
                        {
                            if ([self.dateTypeStr isEqualToString:@"19"] || [self.dateTypeStr isEqualToString:@"20"]) {
                                [breakDownLabelWithStatus setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                                [breakDownCompleteLabel setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                            }
                            else{
                                [breakDownLabelWithStatus setText:@"PROCESSED"];
                                [breakDownCompleteLabel setText:@"PROCESSED"];
                            }
                        }
                    }
                    else if ([self.dateTypeStr isEqualToString:@"9"] ||[self.dateTypeStr isEqualToString:@"11"] || [self.dateTypeStr isEqualToString:@"17"]){
                        [totalEarningsLabelTitle setText:@"Total Earnings"];
                        [cardStatusTypeLabel setText:[NSString stringWithFormat:@"Deposit To: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                        [cardPaymentStatusTypeLabel setText:[NSString stringWithFormat:@"Deposit To: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                        [breakDownLabel setText:@"Earnings Breakdown"];
                        [breakDownlabelWithCharging setText:@"Earnings Breakdown"];
                        
                    }
                    else
                    {
                        [totalEarningsLabelTitle setText:@"Total"];
                        [cardStatusTypeLabel setText:[NSString stringWithFormat:@"Payment Method: %@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PayeeNumber"]]];
                        [breakDownLabel setText:@"Charge Breakdown"];
                        [breakDownlabelWithCharging setText:@"Charge Breakdown"];
                        if ([[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]] isEqualToString:@"<null>"]) {
                            [breakDownLabelWithStatus setText:@"N/A"];
                        }
                        else
                        {
                            if ([self.dateTypeStr isEqualToString:@"19"] || [self.dateTypeStr isEqualToString:@"20"]) {
                                [breakDownLabelWithStatus setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                                [breakDownCompleteLabel setText:[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"PaymentStatus"]]];
                            }
                            else
                            {
                                [breakDownLabelWithStatus setText:@"PROCESSED"];
                                [breakDownCompleteLabel setText:@"PROCESSED"];
                            }
                            
                        }
                    }
                    
                    if ([self.dateTypeStr isEqualToString:@"19"]||[self.dateTypeStr isEqualToString:@"20"]) {
                        
                        [cancellationFeeView setHidden:NO];
                        [cancellationFeeView setFrame:CGRectMake(cancellationFeeView.frame.origin.x, cancellationFeeView.frame.origin.y-20, cancellationFeeView.frame.size.width, cancellationFeeView.frame.size.height)];
                        [sepeartorLabel setHidden:YES];
                        [seperatorDownView setHidden:YES];
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"CancellationFee"] isKindOfClass:[NSString class]]) {
                            [cancellationFeeLabel setText:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"CancellationFee"] floatValue]]]];
                            
                        }
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DoumeesFee"] isKindOfClass:[NSString class]]) {
//                            [doumeesFeeLabel setText:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DoumeesFee"] floatValue]]]];
                             [doumeesFeeLabel setText:[NSString stringWithFormat:@"-%@",[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"DoumeesFee"] floatValue]]]]];
                        }
                        else{
                               [doumeesFeeLabel setText:[NSString stringWithFormat:@"-%@",[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[@"0" floatValue]]]]];
                        }
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TransactionFee"] isKindOfClass:[NSString class]]) {
                            [transactionFeeLabel setText:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TransactionFee"] floatValue]]]];
                               [transactionFeeLabel setText:[NSString stringWithFormat:@"-%@",[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"TransactionFee"] floatValue]]]]];
                            
                        }
                        else{
                              [transactionFeeLabel setText:[NSString stringWithFormat:@"-%@",[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[@"0" floatValue]]]]];
                        }
                        
           
                        if ([[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] isKindOfClass:[NSString class]]) {
                            [subTotalLabel setText:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"SubTotal"] floatValue]]]];
                        }
                        
                        
                        //
                    }
                    else {
                        [cancellationFeeView setHidden:YES];
                        
                    }
                    
                    if([self.dateTypeStr isEqualToString:@"6"] ||[self.dateTypeStr isEqualToString:@"10"])
                    {
                        [sepeartorLabel setFrame:CGRectMake(sepeartorLabel.frame.origin.x, durationTimeValueLabel.frame.origin.y+durationTimeValueLabel.frame.size.height+5, self.view.frame.size.width, 1)];
                    }
                    
                    float originValueOfLocation = locationLabel.frame.origin.x;
                    NSLog(@"Origin Value %f",originValueOfLocation);
                    if (WIN_WIDTH == 320) {
                        locationLabel.frame = CGRectMake(originValueOfLocation, locationLabel.frame.origin.y, locationLabel.frame.size.width-5, locationLabel.frame.size.height);
                    }
                    
                    // NSString *checkPrimaryImage= @"";
                    NSString *setPrimaryImageUrlStr =  [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"DateDetails"]objectForKey:@"Url"]];
                    
                    NSURL *imageUrl = [NSURL URLWithString:setPrimaryImageUrlStr];
                    //                [userImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    //                [userImage sd_setImageWithURL:imageUrl
                    //                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    NSLog(@"Image Value %@",imageUrl);
                    
                }
                else {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
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
    else if ([self.dateTypeStr isEqualToString:@"5"]) {
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
    else if ([self.dateTypeStr isEqualToString:@"13"]) {
        // statusLabel.text = @"Auto Decline Date";
        // chargeBreakDownView.hidden = YES;
        // needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
        
    }
    else if ([self.dateTypeStr isEqualToString:@"11"]) {
        statusLabel.text = @"Completed";
        // statusLabel.text = @"Auto Decline Date";
        // chargeBreakDownView.hidden = YES;
        // needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    else if ([self.dateTypeStr isEqualToString:@"17"]) {
        statusLabel.text = @"Completed";
        seperatorDownView.hidden = YES;
        // statusLabel.text = @"Auto Decline Date";
        // chargeBreakDownView.hidden = YES;
        // needHelpButton.frame = CGRectMake(self.view.frame.size.width/2-72, 450, 144, 35);
    }
    else
    {
        statusLabel.text = @"";
    }
}


-(void)setChargeBackView{
    
    [additionalTitleTimeLabel setHidden:YES];
    [creditCardFeesLabel setHidden:YES];
    [additonalTimeLabel setHidden:YES];
    [chargeBackFeesLabel setHidden:YES];
    [chargeBackFeesTitleLabel setHidden:YES];
    [seperatorDownSecondTitleView setHidden:YES];
    [cardNumberTitleLabel setFrame:additionalTitleTimeLabel.frame];
    [cardNumberLabel setFrame:additonalTimeLabel.frame];
    [seperatorDownTitleView setFrame:CGRectMake(seperatorDownTitleView.frame.origin.x, additionalTitleTimeLabel.frame.origin.y+additionalTitleTimeLabel.frame.size.height+10, self.view.frame.size.width-30, 1)];
    [subtotalLabel setFrame:CGRectMake(subtotalLabel.frame.origin.x, seperatorDownTitleView.frame.origin.y-2+seperatorDownTitleView.frame.size.height+10, subtotalLabel.frame.size.width, subtotalLabel.frame.size.height)];
    
    [subtotaTitlelLabel setFrame:CGRectMake(subtotaTitlelLabel.frame.origin.x, seperatorDownTitleView.frame.origin.y+seperatorDownTitleView.frame.size.height+10, subtotaTitlelLabel.frame.size.width, subtotaTitlelLabel.frame.size.height)];
    
    [tipAmountTitlelLabel setFrame:CGRectMake(tipAmountTitlelLabel.frame.origin.x, subtotaTitlelLabel.frame.origin.y+subtotaTitlelLabel.frame.size.height-2, tipAmountTitlelLabel.frame.size.width, tipAmountTitlelLabel.frame.size.height)];
    [tipsCompleteLabel setFrame:CGRectMake(tipsCompleteLabel.frame.origin.x, subtotaTitlelLabel.frame.origin.y-2+subtotaTitlelLabel.frame.size.height-2, tipsCompleteLabel.frame.size.width, tipsCompleteLabel.frame.size.height)];
    
    [totalAmountLabel setFrame:CGRectMake(totalAmountLabel.frame.origin.x, tipsCompleteLabel.frame.origin.y+tipsCompleteLabel.frame.size.height+10, totalAmountLabel.frame.size.width, totalAmountLabel.frame.size.height)];
    [totalAmountTitleLabel setFrame:CGRectMake(totalAmountTitleLabel.frame.origin.x, tipsCompleteLabel.frame.origin.y+tipsCompleteLabel.frame.size.height+10, totalAmountTitleLabel.frame.size.width, totalAmountTitleLabel.frame.size.height)];
    [cardStatusTypeLabel setFrame:CGRectMake(cardStatusTypeLabel.frame.origin.x, totalAmountTitleLabel.frame.origin.y+totalAmountTitleLabel.frame.size.height+10, cardStatusTypeLabel.frame.size.width, cardStatusTypeLabel.frame.size.height)];
    [cardPaymentStatusTypeLabel setFrame:CGRectMake(cardPaymentStatusTypeLabel.frame.origin.x, totalAmountTitleLabel.frame.origin.y+totalAmountTitleLabel.frame.size.height+10, cardPaymentStatusTypeLabel.frame.size.width, cardPaymentStatusTypeLabel.frame.size.height)];
    
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
        //        NSTimeInterval timeInterval = [sourceTimeZone  daylightSavingTimeOffsetForDate:dateFromString];
        //        dateFromString = [dateFromString dateByAddingTimeInterval:timeInterval];
    }
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:sourceTimeZone];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:dateFromString];
    //Log: dateRepresentation - 2016-03-08 01:00:00
    return dateRepresentation;
}



-(NSString *)calculateTheAmountBaseFee:(NSString *)BaseFee withFee:(NSString *)AdditinoalTime DoumeesFees:(NSString *)transactionFee with:(NSString *)subTotalVale
{
    
    NSString *subtotalValue;
    double subtotalAdditionaValue = [BaseFee floatValue] + [AdditinoalTime floatValue] ;
    double transactionAmount =[subTotalVale floatValue] - [transactionFee floatValue];
    double transactionTotalAmount = subtotalAdditionaValue + transactionAmount;
    subtotalValue = [NSString stringWithFormat:@"%f",subtotalAdditionaValue];
    subtotalLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [subtotalValue floatValue]]];
    [subTotalLabel setText:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[subtotalValue floatValue]]]];
    
    NSLog(@"Total Amount %@",subtotalValue);
    return subtotalValue;
}

-(NSString *)calculateTotalAmountWithSubtotalValue:(NSString *)subtotalValue with:(NSString *)TipAmountValue DoumeesFees:(NSString *)doumeesFees withtarns:(NSString *)transactionFee
{
    NSString *subtotalValueAmount;
    double tipAmountValue = [subtotalValue floatValue] + [TipAmountValue floatValue];
    tipAmountValue = tipAmountValue - [transactionFee floatValue] - [doumeesFees floatValue];
    subtotalValueAmount = [NSString stringWithFormat:@"%f",tipAmountValue];
    totalAmountLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [subtotalValueAmount floatValue]]];
    [totalEarningsLabel setText:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[subtotalValueAmount floatValue]]]];
    totalPaidAmount = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[subtotalValueAmount floatValue]]];
    return subtotalValueAmount;
}
@end
