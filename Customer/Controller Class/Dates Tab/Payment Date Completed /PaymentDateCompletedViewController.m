
//  PaymentDateCompletedViewController.m
//  Customer
//
//  Created by Jamshed Ali on 16/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "PaymentDateCompletedViewController.h"
@interface PaymentDateCompletedViewController ()<TTRangeSliderDelegate> {
    
    NSDictionary *dataDictionary;
    NSDateFormatter *dateFormatter;
    float totalTimeInFloat ;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    float fCostVlue ;
    NSInteger additionalTimeValue;
    NSInteger totalPaymentValue;
    NSInteger totalSubTotalValue;
    float discountAmount;
    NSString *bankDetailsURL;
}

@property (strong, nonatomic) IBOutlet TTRangeSlider *rangeSlider1;

@end

@implementation PaymentDateCompletedViewController
@synthesize dateIdStr,dateTypeStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    additionalTimeValue = [[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",@"0"
                                                                     ]] integerValue];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"dateEndThenPaymentScreen"
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    sharedInstance = [SingletonClass sharedInstance];
    dateFormatter = [[NSDateFormatter alloc]init];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    userIdStr = sharedInstance.userId;
    //  [tipsAmountLabel setText: [NSString stringWithFormat:@"%@",@"0.00"]];
    contractorImageView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    contractorImageView.layer.cornerRadius = contractorImageView.frame.size.height/2;
    contractorImageView.layer.borderWidth = 2.0;
    contractorImageView.layer.masksToBounds = YES;
    contractorImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    codeTextField.layer.cornerRadius = 5.0;
    codeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    codeTextField.layer.borderWidth = 2.0;
    [self dateDetailsApiCall];
    
    if (WIN_WIDTH == 320) {
        [self.rangeSlider1 setFrame:CGRectMake(10, 121, 300, 65)];
    }
    
    sharedInstance.IsDistanceFilter = YES;
    self.rangeSlider1.delegate = self;
    self.rangeSlider1.minValue = 0;
    self.rangeSlider1.maxValue = 50;
    self.rangeSlider1.minDistance = 0;
    self.rangeSlider1.handleBorderWidth = 2;
    self.rangeSlider1.handleColor = [UIColor lightGrayColor];
    self.rangeSlider1.lineHeight = 5;
    self.rangeSlider1.maxLabelColour = [UIColor clearColor];
    self.rangeSlider1.minLabelColour = [UIColor clearColor];
    self.rangeSlider1.rightHandleSelected = NO;
    self.rangeSlider1.selectedMinimum = 15;
    self.rangeSlider1.selectedMaximum =  50;
    [self.rangeSlider1.rightHandle setFrame:CGRectMake(0, 0, 0, 0)];
}

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    
    if (sender == self.rangeSlider1)
    {
        NSLog(@"Standard slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
        float minimumAge=(float)(selectedMinimum);
        NSLog(@" minimumAge sliderValue = %f",minimumAge);
        int minimumAgeIntValue = (int) minimumAge;
        [self calculateTipAmountWithTipValue:minimumAgeIntValue];
    }
}

-(void)calculateTipAmountWithTipValue:(int)tip{
    
    long tipAmount = (fCostVlue *tip)/100;
    [tipsAmountLabel setText: [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%ld%@",tipAmount,@".00"]]];
    long totalAmount  = totalPaymentValue;
    long totalPayAmount = totalAmount + tipAmount;
    [totalPayAmountLabel setText:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%ld%@",totalPayAmount,@".00"]]];
    sharedInstance.tipAmountWithTotalAmount = [NSString stringWithFormat:@"%ld",totalPayAmount];
    sharedInstance.tipAmountValue =[NSString stringWithFormat:@"%ld",tipAmount];
    tipsAmountPercentageLabel.text = [NSString stringWithFormat:@"%d%@",tip,@"%"];
    sharedInstance.tipAmountPercentage =  [NSString stringWithFormat:@"%d",tip];
    tipsAmountPercentageDataValue .text =[NSString stringWithFormat:@"Tip (%d%@)",tip,@"%"];
}

#pragma mark Get Date Details API Call

- (void)dateDetailsApiCall {
    
    // http://ondemandapinew.flexsin.in/API/Account/GetDateDetail?userType=1&DateID=Date10439&DateType=9
    
    //   NSString *urlstr=[NSString stringWithFormat:@"%@?userType=%@&DateID=%@&DateType=%@",APIGetDateDetails,@"1",self.dateIdStr,dateTypeStr];
    NSString *urlstr=[NSString stringWithFormat:@"%@?userType=%@&DateID=%@&DateType=%@",APIGetDateDetails,@"1",self.dateIdStr,@"9"];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                dataDictionary = [responseObject mutableCopy];
                contractorNameLabel.text =  [[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"UserName"];
                //dateHeaderLabel.text = [[dataDictionary objectForKey:@"result"]objectForKey:@"EndTime"];
                
                if ([[[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"TotalTime"] isKindOfClass:[NSString class]]) {
                    NSString *totalTimeStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"EndDateCustomer"] objectForKey:@"TotalTime"]];
                    
                    totalTimeLabel.text =  [NSString stringWithFormat:@"%@",totalTimeStr];
                }
                else {
                    totalTimeLabel.text = @"";
                }
                
                NSArray *arrayOfString;
                if ([[[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"AdditionalDuration"] isKindOfClass:[NSString class]]) {
                    NSString *additionalTimeStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"EndDateCustomer"] objectForKey:@"AdditionalDuration"]];
                    arrayOfString = [additionalTimeStr componentsSeparatedByString:@" "];
                    
                    AdditionalTimeLabel.text =[NSString stringWithFormat:@"Additional Time (%@)",additionalTimeStr];
                    AdditionalTimeLabelWithAmount.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",[arrayOfString firstObject]]];
                   // additionalTimeValue = [[arrayOfString firstObject] integerValue];
                }
                else
                {
                    AdditionalTimeLabel.text = [NSString stringWithFormat:@"Additional Time (%@)",@"0 mins"];
                    AdditionalTimeLabelWithAmount.text
                    =[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",@"0"]];
                   // additionalTimeValue = 0;
                }
                
                if ([[[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"ExtraAmount"] isKindOfClass:[NSString class]]) {
                    NSString *additionalTimeStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"EndDateCustomer"] objectForKey:@"ExtraAmount"]];
                    AdditionalTimeLabelWithAmount.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",additionalTimeStr]];
                    NSString *bseVlue =  [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"EndDateCustomer"] objectForKey:@"ExtraAmount"]];
                    float baseAdditionaCost = [bseVlue floatValue];
                    additionalTimeValue = baseAdditionaCost;
                }
                else
                {
                    AdditionalTimeLabelWithAmount.text
                    =[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",@"0"]];
                }
                
                if ([[[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"DiscountAmount"] isKindOfClass:[NSString class]]) {
                    NSString *additionalTimeStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"EndDateCustomer"] objectForKey:@"DiscountAmount"]];
                    discountLabelWithAmount.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",additionalTimeStr]];
                  
                }
                else
                {
                    discountLabelWithAmount.text
                    =[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",@"0"]];
                }
                
                NSString *discountValue =  [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"DiscountAmount"]];
                discountAmount = [discountValue floatValue];
                NSString *bseVlue =  [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"BaseFee"]];
                fCostVlue = [bseVlue floatValue];
                baseAmountValue.text =  [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",fCostVlue]];
                totalPaymentValue = ((additionalTimeValue + fCostVlue) - discountAmount);
                totalSubTotalValue = (additionalTimeValue + fCostVlue);
                subTotalLabel.text =  [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%ld",totalSubTotalValue]];
                NSLog(@"Value Of Total %ld",totalPaymentValue);
                NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"StartTime"]];
                NSArray *nameStr = [reserveTimeStr componentsSeparatedByString:@"."];
                NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                NSLog(@"%@",fileKey);
                NSString *reserveDate = [CommonUtils convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                startTimeLabel.text = [CommonUtils changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                
                // [startTimeLabel setText:[NSString stringWithFormat:@"%@",reserveDate]];
                NSString *requestTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"EndTime"]];
                
                NSArray *seperatiedData = [requestTimeStr componentsSeparatedByString:@"."];
                if (seperatiedData.count == 2){
                    requestTimeStr = [NSString stringWithFormat:@"%@",requestTimeStr];

                }
                else{
                    requestTimeStr = [NSString stringWithFormat:@"%@.636",requestTimeStr];

                }
                NSString *requestDate = [CommonUtils convertUTCTimeToLocalTime:requestTimeStr WithFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                // [endTimeLabel setText:[NSString stringWithFormat:@"%@",requestDate]];
                endTimeLabel.text = [CommonUtils changeDateInParticularFormateWithString:requestDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                
                if ([[[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"SubTotal"] isKindOfClass:[NSString class]]) {
                    NSString *totalTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"SubTotal"]];
                    float    totalTime = [totalTimeStr floatValue];
                    NSLog(@"time Value %f",totalTime);
                    subTotalLabel.text =  [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%ld",totalPaymentValue]];
                }
                else
                {
                    subTotalLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",@"0"]];
                }
                
                if ([[[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"Total"] isKindOfClass:[NSString class]]) {
                    NSString *totalTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"Total"]];
                    totalTimeInFloat = [totalTimeStr floatValue];
                    totalPayAmountLabel.text =  [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",totalTimeInFloat]];
                }
                else
                {
                    totalPayAmountLabel.text = @"";
                }
                NSString *setPrimaryImageUrlStr =  [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"PicUrl"]];
                NSURL *imageUrl = [NSURL URLWithString:setPrimaryImageUrlStr];
                [contractorImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [self calculateTipAmountWithTipValue:15];
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
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


#pragma mark Submit Payment Method Call
- (IBAction)submitPaymentMethodCall:(id)sender {
    
    if ([codeTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                        message:@"Please enter the code."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@&tipAmount=%@&tipPercentage=%@&total=%@",APISubmitPaymentAfterDateCompleted,userIdStr,self.dateIdStr,sharedInstance.tipAmountValue,sharedInstance.tipAmountPercentage,sharedInstance.tipAmountWithTotalAmount];
 
      //  #warning just for credit card declined checked
//        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@&tipAmount=%@&tipPercentage=%@&total=%@",APISubmitPaymentAfterDateCompleted,@"Cu00afaf8",self.dateIdStr,sharedInstance.tipAmountValue,sharedInstance.tipAmountPercentage,sharedInstance.tipAmountWithTotalAmount];
        NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        bankDetailsURL = encoded;
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                sharedInstance.requestEndDateButton = @"0";
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    NSString *otherDateType = [responseObject objectForKey:@"OtherEndDateType"];
                    NSString *otherDateTypeID = [responseObject objectForKey:@"OtherEndDateID"];
                    sharedInstance.otherDateType = otherDateType;
                    sharedInstance.otherDateTypeID = otherDateTypeID;
                    RatingViewController *rateViewCall = [self.storyboard instantiateViewControllerWithIdentifier:@"rating"];
                    if (self.isFromLoginView) {
                        rateViewCall.isFromLoginViewController = YES;
                    }
                    else{
                        rateViewCall.isFromLoginViewController = NO;
                    }
                    rateViewCall.self.dateIdStr = self.dateIdStr;
                    rateViewCall.isFromDateDetails = NO;
                    rateViewCall.self.nameStr = [[dataDictionary objectForKey:@"EndDateCustomer"] objectForKey:@"UserName"];
                    rateViewCall.self.imageUrlStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"PicUrl"]];
                    NSString *requestTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"EndTime"]];
                    NSString *requestDate = [CommonUtils convertUTCTimeToLocalTime:requestTimeStr WithFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                    // [endTimeLabel setText:[NSString stringWithFormat:@"%@",requestDate]];
                    rateViewCall.self.dateCompletedTimeStr = [CommonUtils changeDateInParticularFormateWithString:requestDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                    [self.navigationController pushViewController:rateViewCall animated:YES];
                    
                }
                else if ([[responseObject objectForKey:@"StatusCode"] intValue] == 2){
                    CreditCardDeclinedVC *declinedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardDeclinedVC"];
                    declinedVC.creditCradDeclinedMsg = [responseObject objectForKey:@"Message"];
                    declinedVC.dateDetailsDictionary = dataDictionary;
                    declinedVC.bankDetailsWithUrl = bankDetailsURL;
                    declinedVC.dateIDStr = self.dateIdStr;
                    declinedVC.totalAmountToBePaid = sharedInstance.tipAmountWithTotalAmount;
                    sharedInstance.isFromCaneclDateByCustomer = NO;
                    declinedVC.isFromCaneclDateByCustomer = NO;
                    if (self.isFromLoginView) {
                        declinedVC.isFromLoginCreditView = YES;
                    }
                    else{
                        declinedVC.isFromLoginCreditView = NO;
                    }
                    [self.navigationController pushViewController:declinedVC animated:YES];
                }
                else {
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
    }
}

#pragma mark Do Not Received the Code Method Call
- (IBAction)dontGetCodeMethodCall:(id)sender {
    
    DateReportSubmitViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateReportSubmit"];
    dateReportView.self.requestType = @"do not get the code";
    dateReportView.self.dateIdStr = self.dateIdStr;
    [self.navigationController pushViewController:dateReportView animated:YES];
}

- (IBAction)backMethodCall:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
