
//  ReserveViewController.m
//  Customer
//  Created by Jamshed Ali on 09/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "ReserveViewController.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface ReserveViewController ()<MDTimePickerDialogDelegate,MDDatePickerDialogDelegate,kDropDownListViewDelegate,LocationDelegtae,CLLocationManagerDelegate,UITextViewDelegate> {
    
    NSDateFormatter *dateFormatter;
    NSString *bookTimeSlot;
    NSDate *bookTimeSlotDate;
    NSString *dateStr;
    NSString *timeStr;
    NSString *dateTimeStr;
    NSString *contractorUserId;
    NSString *streetStr;
    NSString *cityStr;
    NSString *stateStr;
    UIScrollView *timeSlotScrollView;
    NSString *addressVerify;
    NSArray *timeSlotArray;
    DropDownListView * Dropobj;
    NSMutableArray *rewardDataArray;
    NSString *rewardIDStr;
    NSString *avreageServiceTime;
    NSString *selectedTimeSlot;
    NSInteger selectedTimeSlotTagValue;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    NSDateFormatter *dateFormatter1;
    UIView *prmoCodePopupView;
    UILabel *invalidPromoCodeLabel;
    UITextField *promoCodeTextField;
}

@property(nonatomic) MDDatePickerDialog *datePicker;
@end

@implementation ReserveViewController
@synthesize checkControllerStr,imageUrlStr,contractorId,checkRequestNowControllerStr,rewardOnOff;
@synthesize autoCompleter = _autoCompleter;

#pragma mark:- UIView Controller Life Cycle Method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    rewardButton.hidden = NO;
    dropDownImage.hidden = YES;
    promoCodeLabel.hidden = NO;
    addressVerify = @"";
    rewardIDStr = @"";
    avreageServiceTime = @"";
    selectedTimeSlot = @"";
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"addressVerify"];
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyAW4AldQrkEsG5PJX8nDZL6_-ecYX9Z4-0"];
    [self.tabBarController.tabBar setHidden:YES];
    dateFormatter = [[NSDateFormatter alloc] init];
    dateTimeStr = @"";
    profileImageView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2;
    profileImageView.layer.borderWidth = 4.0;
    profileImageView.layer.masksToBounds = YES;
    profileImageView.layer.borderColor= [[UIColor whiteColor] CGColor];
    dayTimeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    dayTimeTextField.layer.borderWidth = 0.5;
    dateFormatter1 = [[NSDateFormatter alloc] init];
    UIView *dayPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    dayPaddingView.backgroundColor = [UIColor clearColor];
    
    UIImageView *calenderIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_Gray"]];
    calenderIcon.frame = CGRectMake(8, 5, 19.f, 19.f);
    calenderIcon.backgroundColor = [UIColor clearColor];
    [dayPaddingView addSubview:calenderIcon];
    
    dayTimeTextField.leftView = dayPaddingView;
    dayTimeTextField.leftViewMode = UITextFieldViewModeAlways;
    meetingTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    meetingTextField.layer.borderWidth = 0.5;
    //meetingTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //meetingTextView.layer.borderWidth = 0.5;
    meetingTextView.placeholder = @"Choose a location";
    UIView *meetingPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    meetingPaddingView.backgroundColor = [UIColor clearColor];
    
    UIImageView *meetingIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
    meetingIcon.frame = CGRectMake(8, 8, 15.f, 22.f);
    meetingIcon.backgroundColor = [UIColor clearColor];
    [meetingPaddingView addSubview:meetingIcon];
    
    //meetingTextField.leftView = meetingPaddingView;
   // meetingTextField.leftViewMode = UITextFieldViewModeAlways;
    
    notesTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    notesTextField.layer.borderWidth = 0.5;
    
    UIView *notesPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    notesTextField.leftView = notesPaddingView;
    notesTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *notesIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file_Gray"]];
    notesIcon.frame = CGRectMake(8, 10, 21.f, 18.f);
    notesIcon.backgroundColor = [UIColor clearColor];
    [notesPaddingView addSubview:notesIcon];
    
    // rewardButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // rewardButton.layer.borderWidth = 0.5;
    [self setDetailValues];
    //  [self rewardApiCall];
    NSDate *date = [NSDate date];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    dateStr = [dateFormatter stringFromDate:date];
    dayTimeTextField.text = [NSString stringWithFormat:@"%@",dateStr];
    [self availableTimeApiCall];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
//    [meetingTextField setFrame:CGRectMake(meetingTextField.frame.origin.x
//                                          , meetingTextField.frame.origin.y
//                                          , meetingTextField.frame.size.width, 50)];
//    [meetingTextView setFrame:CGRectMake(meetingTextView.frame.origin.x
//                                         , meetingTextView.frame.origin.y
//                                         , meetingTextView.frame.size.width, meetingTextView.frame.size.height)];
}

-(void)locationStringValue :(NSString*)str{
//        [meetingTextField setFrame:CGRectMake(meetingTextField.frame.origin.x
//                                              , meetingTextField.frame.origin.y
//                                              , meetingTextField.frame.size.width, 50)];
//        [meetingTextView setFrame:CGRectMake(meetingTextView.frame.origin.x
//                                             , meetingTextField.frame.origin.y+7
//                                             , meetingTextView.frame.size.width, 39)];

    
    
    if ([str isEqualToString:@""] || [str isEqual:nil]) {
        //
        meetingTextView.text = str;

        [meetingTextField setFrame:CGRectMake(meetingTextField.frame.origin.x
                                              , meetingTextField.frame.origin.y
                                              , meetingTextField.frame.size.width, 50)];
        [meetingTextView setFrame:CGRectMake(meetingTextView.frame.origin.x
                                              , meetingTextField.frame.origin.y+7
                                              , meetingTextView.frame.size.width, 39)];
        
        [self setheightOfTheView:meetingTextView];
    }
    else{
        meetingTextView.scrollEnabled = NO;
      
        meetingTextView.text = str;
      //  [meetingTextView sizeToFit];
        CGRect textViewSize = [str boundingRectWithSize:CGSizeMake(meetingTextView.frame.size.width, FLT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                                 context:nil];
//        CGSize textViewSize = [str sizeWithFont:[UIFont systemFontOfSize:14.0]
//                               constrainedToSize:CGSizeMake(meetingTextView.frame.size.width, FLT_MAX)
//                                   lineBreakMode:UILineBreakModeTailTruncation];
        NSLog(@"Height Value %f",[self heightFromStringWithFont:[UIFont systemFontOfSize:14.0] constraintToWidth:meetingTextView.frame.size.width withStr:str]);
        [meetingTextView setFrame:CGRectMake(meetingTextView.frame.origin.x, meetingTextView.frame.origin.y-0, meetingTextView.frame.size.width, [self heightFromStringWithFont:[UIFont systemFontOfSize:14.0] constraintToWidth:meetingTextView.frame.size.width withStr:str] + 25)];
        CGFloat heightOfView = meetingTextView.frame.size.height;
        [meetingTextField setFrame:CGRectMake(meetingTextField.frame.origin.x
                                              , meetingTextField.frame.origin.y
                                              , meetingTextField.frame.size.width, heightOfView+7)];
        [self setheightOfTheView:meetingTextView];

    }
   // [meetingTextField setText:str];
    //meetingTextField.hidden = YES;
}

- (CGFloat)heightFromStringWithFont:(UIFont*)font constraintToWidth:(CGFloat)width withStr:(NSString *)stringVAlue
{
    CGRect rect;
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        rect = [stringVAlue boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [stringVAlue sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        rect = CGRectMake(0, 0, size.width, size.height);
#pragma GCC diagnostic pop
    }
    return ceil(rect.size.height);
}

-(void)setheightOfTheView:(UITextView *)textView{
    
     [notesTextField setFrame:CGRectMake(notesTextField.frame.origin.x
                                       , meetingTextField.frame.origin.y+ meetingTextField.frame.size.height+13
                                       , notesTextField.frame.size.width, notesTextField.frame.size.height)];
    
     [estimatedRateView setFrame:CGRectMake(estimatedRateView.frame.origin.x
                                         , notesTextField.frame.origin.y+ notesTextField.frame.size.height+25
                                         , estimatedRateView.frame.size.width, estimatedRateView.frame.size.height)];
    
     [rewardButton setFrame:CGRectMake(rewardButton.frame.origin.x
                                           , estimatedRateView.frame.origin.y+ estimatedRateView.frame.size.height+11
                                            , rewardButton.frame.size.width, rewardButton.frame.size.height)];
     [promoCodeLabel setFrame:CGRectMake(promoCodeLabel.frame.origin.x
                                              , rewardButton.frame.origin.y+ rewardButton.frame.size.height+1
                                              , promoCodeLabel.frame.size.width, promoCodeLabel.frame.size.height)];
     [sendReserveRequestButton setFrame:CGRectMake(sendReserveRequestButton.frame.origin.x
                                        , promoCodeLabel.frame.origin.y+ promoCodeLabel.frame.size.height+8
                                        , sendReserveRequestButton.frame.size.width, sendReserveRequestButton.frame.size.height)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"Touch begin method call");
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [meetingTextField resignFirstResponder];
    }
}

-(void)setDetailValues {
    
    if ([self.checkControllerStr isEqualToString:@"search"]) {
        
        NSDictionary *dataDic = [[self.reserveDataDictionary valueForKey:@"ContractorProfile"] mutableCopy];
        userNameLbl.text =[dataDic valueForKey:@"FirstName"];
        NSURL *imageUrl = [NSURL URLWithString:self.imageUrlStr];
        
        [profileImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"user_default"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //        [profileImageView sd_setImageWithURL:imageUrl
        //                            placeholderImage:[UIImage imageNamed:@"user_default"]];
        NSString *strForPerHourRate = [dataDic valueForKey:@"HourlyRate"];
        perhourPriceLbl.text = [NSString stringWithFormat:@"%@/hr",[CommonUtils getFormateedNumberWithValue:strForPerHourRate]];
        NSString *strForMinimumHourRate = [dataDic valueForKey:@"MinimumHours"];
        minimumHourPriceLbl.text = [NSString stringWithFormat:@"Minimum %d hours",[strForMinimumHourRate intValue]];
        NSString *strForMinuteAftrRate = [dataDic valueForKey:@"RateAfterMinimumHour"];
        minuteAfterPriceLbl.text = [NSString stringWithFormat:@"%@ per minute after",[CommonUtils getFormateedNumberWithValue:strForMinuteAftrRate]];
        
    } else {
        
        NSDictionary *dataDic;
        
        if ([[self.reserveDataDictionary valueForKey:@"ContractorProfile"] isKindOfClass:[NSDictionary class]]) {
            NSLog(@"key Found");
            dataDic = [[self.reserveDataDictionary valueForKey:@"ContractorProfile"] mutableCopy];
            
        } else {
            
            NSLog(@"key NOT Found");
            dataDic = [self.reserveDataDictionary mutableCopy];
            self.contractorId = [NSString stringWithFormat:@"%@",[self.reserveDataDictionary valueForKey:@"UserID"]];
        }
        
        userNameLbl.text = [dataDic objectForKey:@"FirstName"];
        NSURL *imageUrl = [NSURL URLWithString:[dataDic objectForKey:@"PrimaryPicURL"]];
        [profileImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"user_default"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //        [profileImageView sd_setImageWithURL:imageUrl
        //                            placeholderImage:[UIImage imageNamed:@"user_default"]];
        NSString *strForPerHourRate = [dataDic objectForKey:@"HourlyRate"];
        perhourPriceLbl.text = [NSString stringWithFormat:@"%@/hr",[CommonUtils getFormateedNumberWithValue:strForPerHourRate]];
        NSString *strForMinimumHourRate = [dataDic objectForKey:@"MinimumHours"];
        minimumHourPriceLbl.text = [NSString stringWithFormat:@"Minimum %d hours",[strForMinimumHourRate intValue]];
        NSString *strForMinuteAftrRate = [dataDic objectForKey:@"RateAfterMinimumHour"];
        minuteAfterPriceLbl.text = [NSString stringWithFormat:@"%@ per minute after",[CommonUtils getFormateedNumberWithValue:strForMinuteAftrRate]];
    }
}

# pragma mark Start Date Method Call
- (void)startDateButtonPushed {
    
    // dateSelectValue = 1;
    
    if (!_datePicker) {
        NSDate *date = [NSDate date];
        MDDatePickerDialog *datePicker = [[MDDatePickerDialog alloc] init];
        _datePicker = datePicker;
        _datePicker.minimumDate = date;
        NSDate *sevenDays = [date dateByAddingTimeInterval:60*60*24*7];
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//        NSDate *currentDate = [NSDate date];
//        NSDateComponents *comps = [[NSDateComponents alloc] init];
//        [comps setYear:0];
//        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
//        [comps setWeekday:7];

//        [datePicker setMaximumDate:maxDate];
//        [datePicker setMinimumDate:minDate];
          _datePicker.maximumDate = sevenDays ;
        _datePicker.selectedDate = date;
        _datePicker.delegate = self;
    }
    [_datePicker show];
}


#pragma mark Date Popop on Ok Button

- (void)datePickerDialogDidSelectDate:(NSDate *)date {
    
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    dateStr = [dateFormatter stringFromDate:date];
    dayTimeTextField.text = [NSString stringWithFormat:@"%@",dateStr];
    [self availableTimeApiCall];
    
}

- (void)datePickerDialogCancelDate {
    NSLog(@"Date Cancel");
}


#pragma mark Start Time Method Call
- (void)startTimeButtonPushed {
    
    MDTimePickerDialog *timePicker = [[MDTimePickerDialog alloc] init];
    timePicker.theme = MDTimePickerThemeLight;
    timePicker.delegate = self;
    [timePicker show];
    
}

- (void)timePickerDialog:(MDTimePickerDialog *)timePickerDialog
           didSelectHour:(NSInteger)hour
               andMinute:(NSInteger)minute {
    
    timeStr = [NSString stringWithFormat:@"%.2li:%.2li", (long)hour, (long)minute];
    dayTimeTextField.text = [NSString stringWithFormat:@"%@ %@",dateStr,timeStr];
    dateTimeStr = [NSString stringWithFormat:@"%@ %@",dateStr,timeStr];
    [self availableTimeApiCall];
    
}

- (void)timePickerCancelDialog {
    NSLog(@"Time Cancel");
    dateTimeStr = @"";
}

#pragma mark Meetup Address Method Call
- (IBAction)meetUpAddressButtonClicked:(id)sender {
    
    ChooseLocationViewController *objLoc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseLocationViewController"];
    objLoc.delegate = self;
    [self.navigationController pushViewController:objLoc animated:YES];
    
}

#pragma mark Send Dating Request Method Call
- (IBAction)sentRequestBtnClicked:(id)sender {
    
    if ([sharedInstance.isPastDuePayment isEqualToString:@"1"]) {
        [[AlertView sharedManager] presentAlertWithTitle:@"Cannot Send Request" message:@"You cannot send request because your account is On Hold status."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                               //   [self performSelector:@selector(obj) withObject:self afterDelay:3];
                                           }];
    }
    else
    {

    addressVerify = [[NSUserDefaults standardUserDefaults]objectForKey:@"addressVerify"];
    
    if ([meetingTextView.text isEqualToString:@""] || [meetingTextView.text isEqualToString: @"Choose a location"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                        message:@"Please enter the address."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        
    } else if([dayTimeTextField.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                        message:@"Please select the date."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([selectedTimeSlot isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                        message:@"Please select the time slot."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }else {
        
        BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
        
        if (locationAllowed) {
            
            if ([sharedInstance.latiValueStr length] && [sharedInstance.longiValueStr length]) {
                [self sendReserveRequestApiData];
                
            }
            else{
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LATITUDEDATA"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LONGITUDEDATA"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Sorry!" message:@"We did not fetch your location.Do you want again to find the location?"
                                             andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                       if ([buttonTitle isEqualToString:@"Yes"]) {
                                                           if ([APPDELEGATE locationManager] != nil) {
                                                               [[APPDELEGATE locationManager] startUpdatingLocation];
                                                               
                                                           }
                                                           else {
                                                               APPDELEGATE.locationManager= [[CLLocationManager alloc] init];
                                                               APPDELEGATE.locationManager.delegate = self;
                                                               APPDELEGATE.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                                                               [APPDELEGATE.locationManager requestWhenInUseAuthorization];
                                                               [APPDELEGATE.locationManager startUpdatingLocation];
                                                           }
                                                       }
                                                   }];
            }
        }
        else
        {
            sharedInstance.latiValueStr = NULL;
            sharedInstance.longiValueStr = NULL;
            [[AlertView sharedManager] presentAlertWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                         andButtonsWithTitle:@[@"OK"] onController:self
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                   //  [self performSelector:@selector(obj) withObject:self afterDelay:5];
                                               }];
        }
    }
}
}

- (void)viewDidLayoutSubviews {
    bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 800);
}


#pragma mark: UitextView Delgate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return NO;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backBtnClicked:(id)sender {
    
    if([self.checkRequestNowControllerStr isEqualToString:@"RequestNow"]) {
        
        SearchViewController *searchView = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
        [self.navigationController pushViewController:searchView animated:YES];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)dateTimeMethodCall:(id)sender {
    [self startDateButtonPushed];
}

#pragma mark Promo Code Reward Method Call

- (IBAction)rewardButtonClicked:(id)sender {
    [self promoCodePopup];
}

- (void)rewardApiCall {
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",nil];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APIGetRewardApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                rewardDataArray = [[NSMutableArray alloc]init];
                if ([[responseObject objectForKey:@"Reward"] isKindOfClass:[NSArray class]]) {
                    rewardButton.hidden= NO;
                    dropDownImage.hidden = NO;
                    rewardDataArray = [[responseObject objectForKey:@"Reward"] mutableCopy];
                }
                else {
                    rewardButton.hidden= YES;
                    dropDownImage.hidden = YES;
                    sendReserveRequestButton.frame = CGRectMake(15, 650, bgScrollView.frame.size.width-30, 42);
                }
            }
            else {
                rewardButton.hidden= YES;
                dropDownImage.hidden = YES;
                sendReserveRequestButton.frame = CGRectMake(15, 650, bgScrollView.frame.size.width-30, 42);
            }
        }
    }];
}


# pragma  mark Reward Amount Popup Show

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:self.view animated:YES];
    
    /*----------------Set DropDown backGroundColor-----------------*/
    [Dropobj SetBackGroundDropDown_R:0.0 G:108.0 B:194.0 alpha:0.70];
    
}


- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex {
    
    /*----------------Get Selected Value[Single selection]-----------------*/
    
    [rewardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString *rewardStr =[NSString stringWithFormat:@"%.2f",[[[rewardDataArray objectAtIndex:anIndex]objectForKey:@"Amount"] floatValue]];
    [rewardButton setTitle:[CommonUtils getFormateedNumberWithValue:rewardStr] forState:UIControlStateNormal];
    rewardIDStr = [NSString stringWithFormat:@"%@",[[rewardDataArray objectAtIndex:anIndex]objectForKey:@"ID"]];
}


- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
    
    /*----------------Get Selected Value[Multiple selection]-----------------*/
    if (ArryData.count>0) {
    }
    else{
        
    }
}
-(NSString *)getCurrentTime {
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatterValue = [[NSDateFormatter alloc] init];
    [dateFormatterValue setDateFormat:@"HH:mm:ss"];
    NSString *resultString = [dateFormatterValue  stringFromDate: currentTime];
    return resultString;
}

#pragma mark Check Time Slot Api Call

- (void)availableTimeApiCall {
    
    [timeSlotScrollView removeFromSuperview];
    NSDateFormatter *dateFormatterStyle=[[NSDateFormatter alloc] init];
    [dateFormatterStyle setDateFormat:@"MM/dd/YYYY HH:mm:ss"];
    NSDateFormatter *dateFormatterStyleForCurrenTDate=[[NSDateFormatter alloc] init];
    [dateFormatterStyleForCurrenTDate setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-yy"];
    NSDate *formateedString = [formatter dateFromString:dateStr];
    NSString *dateStringValue = [NSString stringWithFormat:@"%@",[formatter stringFromDate:formateedString]];
    NSLog(@"Current Time %@",dateStringValue);
    NSString *currentDateTime = [NSString stringWithFormat:@"%@",[dateFormatterStyle stringFromDate:[NSDate date]]];
    NSString *currentDateTimeInUTC = [NSString stringWithFormat:@"%@",[dateFormatterStyleForCurrenTDate stringFromDate:[NSDate date]]];
    NSString *UtcDateString = [self getUTCFormateDateWithString:currentDateTime];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    //http://ondemandapiqa.flexsin.in/API/Contractor/GetAvailableTime?userID=Cr00a827c&dateTime=4-18-2017&todayTime=2017-04-18T10%3A36%3A27&LoginID=Cu0055c6f1&CurrentDateTimeByZone=2017-04-18 03%3A35%3A27
    NSString *urlstr =[NSString stringWithFormat:@"%@?userID=%@&dateTime=%@&todayTime=%@&LoginID=%@&CurrentDateTimeByZone=%@",APIGetContractorAvailableTimeSlot,self.contractorId,dateStringValue,UtcDateString,userIdStr,currentDateTimeInUTC];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ServerRequest requestWithUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                timeSlotArray  = [responseObject objectForKey:@"ContractorAvailableTimeList"];
                if([timeSlotArray count] == 0) {
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
                else {
                    
                    avreageServiceTime = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"AverageReservationTime"]];
                    dateFormatter.dateFormat = @"MM/dd/yyyy";
                    
                    NSDate *selectedDate = [dateFormatter dateFromString:dateStr];
                    dayTimeTextField.text = [NSString stringWithFormat:@"%@",dateStr];
                    BOOL currentDate = NO;
                    NSCalendar* calendar = [NSCalendar currentCalendar];
                    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
                    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:[NSDate date]];
                    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:selectedDate];
                    
                    if( [comp1 day]   == [comp2 day] &&
                       [comp1 month] == [comp2 month] &&
                       [comp1 year]  == [comp2 year]) {
                        currentDate = YES;
                    }
                    
                    timeSlotScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 218, bgScrollView.frame.size.width-40, 40)];
                    int x = 10;
                    for (int i = 0; i < [timeSlotArray count]; i++) {
                        
                        NSString *timeSlot = [CommonUtils checkStringForNULL:[NSString stringWithFormat:@"%@",[[timeSlotArray objectAtIndex:i] objectForKey:@"Time"]]];
                        NSArray *nameStr = [timeSlot componentsSeparatedByString:@"."];
                        NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                        NSLog(@"%@",fileKey);
                        
                        NSString *reserveDate = [CommonUtils convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                        UIButton *timeSlotButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0.0f, 85, 35.0f)];
                        timeSlotButton.contentMode = UIViewContentModeScaleAspectFit;
                        
                        timeSlotButton.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:170.0/255.0 blue:206.0/255.0 alpha:1.0];
                        timeSlotButton.tintColor = [UIColor whiteColor];
                        [timeSlotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        NSString *sepreatedArrayString;
                        if ([CommonUtils checkTheFormateType]) {
                            
                            NSArray *timSlotArray = [[self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"] componentsSeparatedByString:@" "];
                            NSArray *timSlotMinuteArray = [[self changeDateInParticularFormateForMinuteValue:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"] componentsSeparatedByString:@":"];
                            long minuteValue = [[timSlotMinuteArray lastObject] integerValue];
                            if (minuteValue>30) {
                                long minValue = [[timSlotMinuteArray firstObject] integerValue];
                             //   minValue = minValue+1;
                                sepreatedArrayString   = [NSString stringWithFormat:@"%ld:00",minValue];
                            }
                            else {
                                sepreatedArrayString = [NSString stringWithFormat:@"%@:00",[timSlotMinuteArray firstObject]];
                            }
                        }
                        else {
                            NSArray *timSlotArray = [[self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"] componentsSeparatedByString:@" "];
                            NSArray *timSlotMinuteArray = [[self changeDateInParticularFormateForMinuteValue:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"] componentsSeparatedByString:@":"];
                            long minuteValue = [[timSlotMinuteArray lastObject] integerValue];
                            ;
                            
                            if (minuteValue>30) {
                                long minuteValue = [[timSlotArray firstObject] integerValue];
                               // minuteValue = minuteValue+1;
                                sepreatedArrayString   = [NSString stringWithFormat:@"%ld:00 %@",minuteValue,[timSlotArray lastObject]];
                            }
                            
                            else {
                                sepreatedArrayString = [NSString stringWithFormat:@"%@:00 %@",[timSlotArray firstObject],[timSlotArray lastObject]];
                            }
                        }
                        
                        NSLog(@"Availabel Time %@",sepreatedArrayString);
                        [timeSlotButton setTitle:sepreatedArrayString forState:UIControlStateNormal];
                        [timeSlotButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
                        timeSlotButton.layer.cornerRadius = 3.0;
                        timeSlotButton.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:170.0/255.0 blue:206.0/255.0 alpha:1.0];
                        timeSlotButton.tag = i;
                        // NSString *checkTimeSlot
                        [timeSlotButton addTarget:self action:@selector(selectedTimeSlotClicked:) forControlEvents:UIControlEventTouchUpInside];
                        [timeSlotScrollView addSubview:timeSlotButton];
                        x += timeSlotButton.frame.size.width+5;
                    }
                    
                    timeSlotScrollView.contentSize = CGSizeMake(x, timeSlotScrollView.frame.size.height);
                    timeSlotScrollView.backgroundColor = [UIColor clearColor];
                    [bgScrollView addSubview:timeSlotScrollView];
                }
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

-(NSString *)changeDateInParticularFormateWithString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    if ([CommonUtils checkTheFormateType]) {
        [dateFormatter2 setDateFormat:@"hh:mm a"];
    }
    else{
        [dateFormatter2 setDateFormat:@"hh aaa"];
    }
    NSString *dateRepresentation = [dateFormatter2 stringFromDate:formatedDate];
    return dateRepresentation;
}

-(NSString *)changeDateInParticularFormateForMinuteValue :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"hh:mm"];
    NSString *dateRepresentation = [dateFormatter2 stringFromDate:formatedDate];
    return dateRepresentation;
}

-(NSString *)changeDateInParticularFormateForMinuteValueIN24Formate :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString *dateRepresentation = [dateFormatter2 stringFromDate:formatedDate];
    return dateRepresentation;
}

-(NSString *)changeformate_string24hr:(NSString *)date
{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"hh:mm a"];
    NSDate* wakeTime = [df dateFromString:date];
    [df setDateFormat:@"HH:mm"];
    return [df stringFromDate:wakeTime];
    
}

- (void)selectedTimeSlotClicked:(UIButton *)sender {
    
    selectedTimeSlotTagValue = sender.tag;
    
    for( id vw in timeSlotScrollView.subviews){
        
        if([vw isKindOfClass:[UIButton class]]){
            
            UIButton *btn =(UIButton *)vw;
            btn.layer.cornerRadius = 3.0;
            btn.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:170.0/255.0 blue:206.0/255.0 alpha:1.0];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            for( id vw1 in btn.subviews){
                if (btn.tag  == selectedTimeSlotTagValue) {
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn setBackgroundColor:[UIColor colorWithRed:81.0/255.0 green:47.0/255.0 blue:106.0/255.0 alpha:1.0]];
                    //                    selectedTimeSlot = [CommonUtils checkStringForNULL:[NSString stringWithFormat:@"%@",[[timeSlotArray objectAtIndex:selectedTimeSlotTagValue] objectForKey:@"Time"]]];
                    
                    NSString *timeSlot = [CommonUtils checkStringForNULL:[NSString stringWithFormat:@"%@",[[timeSlotArray objectAtIndex:selectedTimeSlotTagValue] objectForKey:@"Time"]]];
                    NSArray *nameStr = [timeSlot componentsSeparatedByString:@"."];
                    NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                    NSLog(@"%@",fileKey);
                    
                    NSString *reserveDate = [CommonUtils convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                    NSArray *timSlotArray = [[self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"] componentsSeparatedByString:@" "];
                    NSArray *timSlotMinuteArray = [[self changeDateInParticularFormateForMinuteValueIN24Formate:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"] componentsSeparatedByString:@":"];
                    long minuteValue = [[timSlotMinuteArray lastObject] integerValue];
                    NSString *sepreatedArrayString;
                    
                    if (minuteValue>30) {
                        long minute = [[timSlotArray firstObject] integerValue];
                        minute = minute+1;
                        sepreatedArrayString   = [NSString stringWithFormat:@"%ld:00 %@",minute,[timSlotArray lastObject]];
                    }
                    
                    else {
                        sepreatedArrayString = [NSString stringWithFormat:@"%@:00 %@",[timSlotArray firstObject],[timSlotArray lastObject]];
                    }
                    
                    NSLog(@"Availabel Time %@",sepreatedArrayString);
                    selectedTimeSlot =  sepreatedArrayString;
                }
                
                if ([vw1 isKindOfClass:[UILabel class]]){
                    UILabel *datweLabel =(UILabel *)vw1;
                    NSLog(@"label is --%@", datweLabel);
                }
            }
        }
    }
}


-(void)obj {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loactionUpdate" object:nil userInfo:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSString *)getUTCFormateDateWithString:(NSString *)localDate withSelectedSlotValue:(NSString *)selctedValue
{
    
    NSDateFormatter *dateFormateForTime = [[NSDateFormatter alloc] init];
    [dateFormateForTime setDateFormat:@"HH:mm"];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    NSDate *dateValue = [dateFormatter dateFromString:localDate];
    NSLog( @"date Formate value %@",dateValue);
    NSDateFormatter *dateFormatterString=[[NSDateFormatter alloc] init];
    [dateFormatterString setDateFormat:@"yyyy-MM-dd"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSString *dateString = [dateFormatterString stringFromDate:dateValue];
    NSArray *timeFragment = [selctedValue componentsSeparatedByString:@" "];
    NSDate *timeForDate = [dateFormateForTime dateFromString:[timeFragment firstObject]];
    NSLog( @"Time Formate value %@",timeForDate);
    NSString *timeForString = [self  changeformate_string24hr:selctedValue];
    NSLog( @"Time Formate value in String %@",timeForString);
    
    NSString *utcFromate = [NSString stringWithFormat:@"%@T%@:00",dateString,timeForString];
    NSDateFormatter *dateUTCString=[[NSDateFormatter alloc] init];
    [dateUTCString setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *convertedUTCDate = [[NSDate alloc] init];
    convertedUTCDate = [dateUTCString dateFromString:utcFromate];
    NSLog(@"UTC Date %@",convertedUTCDate);
    
    NSDateFormatter *UTCDateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [UTCDateFormatter setTimeZone:timeZone];
    [UTCDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *dateStringVlaue = [UTCDateFormatter stringFromDate:convertedUTCDate];
    return dateStringVlaue;
}

#pragma mark-- Reserve Dating Request Sent API Call

- (void)sendReserveRequestApiData {
    
    NSArray *timeFragment = [selectedTimeSlot componentsSeparatedByString:@" "];
    NSString *checkTime = [NSString stringWithFormat:@"%@",[timeFragment lastObject]];
    //   NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
    if ([checkTime isEqualToString:@"AM"] || [checkTime isEqualToString:@"Noon"]) {
        selectedTimeSlot = [NSString stringWithFormat:@"%@ AM",[timeFragment objectAtIndex:0]];
        
    } else {
        
        if ([checkTime isEqualToString:@"PM"] || [checkTime isEqualToString:@"Mid"]) {
            selectedTimeSlot = [NSString stringWithFormat:@"%@ PM",[timeFragment objectAtIndex:0]];
        }
        else {
            selectedTimeSlot = [NSString stringWithFormat:@"%@ PM",[timeFragment objectAtIndex:0]];
        }
    }
    
    // bookTimeSlot = [NSString stringWithFormat:@"%@ %@",dayTimeTextField.text,selectedTimeSlot];
    bookTimeSlot = [self getUTCFormateDateWithString:dayTimeTextField.text withSelectedSlotValue:selectedTimeSlot];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    if (![sharedInstance.promoCodeValue length]) {
        sharedInstance.promoCodeValue = @"";
    }
    //http://ondemandapinew.flexsin.in/api/Customer/ReserveRequest?CustomerId=Cu0020c42&ContractorID=Cr007e28b&Location=noida sector  22 &PromoCode&Notes=test  new api &reserveTime=2016-07-12 17:58:37.197
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)meetingTextView.text,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
        NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerId=%@&ContractorID=%@&PromoCode=%@&Notes=%@&reserveTime=%@&Latitude=%@&Longitude=%@&City=%@&County=%@&Country=%@&State=%@",APIReserveRequest,userIdStr,self.contractorId,sharedInstance.promoCodeValue,notesTextField.text,bookTimeSlot,
                      sharedInstance.meetUpLocationLattitude,
                      sharedInstance.meetUpLocationLongtitude,sharedInstance.cityValueStr,sharedInstance.districtValueStr,sharedInstance.countryValueStr,sharedInstance.stateValueStr];
    
    NSString *encodedUrl =  [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   NSString *  encodedAddressUrl = [NSString stringWithFormat:@"%@&Location=%@",encodedUrl,encodedString];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encodedAddressUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                RequestSentViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"requestSent"];
                notiView.self.averageTimeStr = avreageServiceTime;
                [self.navigationController pushViewController:notiView animated:YES];
            }
            
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==2) {
                [[AlertView sharedManager] presentAlertWithTitle:@"Account Inactive" message:@"Your account is inactive.Contact to Doumee support team."
                                             andButtonsWithTitle:@[@"Ok"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                   }];
                
            }
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==3) {
                [[AlertView sharedManager] presentAlertWithTitle:@"No Payment Method" message:@"You need to add a payment method to your account before you can send a request. Do you want to add a credit card now?."
                                             andButtonsWithTitle:@[@"Ok"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                       if(index == 1) {
//                                                           CreditCardViewController *creditCardView = [self.storyboard instantiateViewControllerWithIdentifier:@"creditCard"];
//                                                           [self.navigationController pushViewController:creditCardView animated:YES];
                                                       }
                                                   }];
            }
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==4) {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Credit Card Verification" message:@"You need to verify your credit card before you can send a request. Do you want to verify now?"
                                             andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                       if(index == 1) {
                                                           PaymentMethodsViewController *paymentInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentMethod"];
                                                           [self.navigationController pushViewController:paymentInfoView animated:YES];
                                                       }
                                                   }];
            }
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==5) {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Your credit card has expired.Do you want to add a credit card now?"
                                             andButtonsWithTitle:@[@"Ok"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                       if(index == 1) {
//                                                           CreditCardViewController *creditCardView = [self.storyboard instantiateViewControllerWithIdentifier:@"creditCard"];
//                                                           [self.navigationController pushViewController:creditCardView animated:YES];
                                                       }
                                                   }];
                
            }
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==0) {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                
            }else {
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

- (NSString*)toStringFromDateTime:(NSDate*)datetime
{
    // Purpose: Return a string of the specified date-time in UTC (Zulu) time zone in ISO 8601 format.
    // Example: 2013-10-25T06:59:43.431Z
    NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString* dateTimeInIsoFormatForZuluTimeZone = [dateFormatter2 stringFromDate:datetime];
    return dateTimeInIsoFormatForZuluTimeZone;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        
    } else if(buttonIndex == 1) {
        
        PaymentMethodsViewController *paymentInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentMethod"];
        [self.navigationController pushViewController:paymentInfoView animated:YES];
    }
}

#pragma mark Enter Promo Code Popup

- (void)promoCodePopup {
    
    prmoCodePopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    prmoCodePopupView.backgroundColor = [UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:0.9];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2-77, self.view.frame.size.width-40, 155)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0;
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 5, contentView.frame.size.width-2, 118)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    UILabel *titleTextLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 10, whiteView.frame.size.width, 18) andTitle:@"Enter Promo Code" andTextColor:[UIColor darkGrayColor]];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [contentView addSubview:titleTextLabel];
    UIButton *closeButton = [CommonUtils createButtonWithRect:CGRectMake(whiteView.frame.size.width-50, 0, 50, 40) andText:@"X" andTextColor:[UIColor lightGrayColor] andFontSize:@"" andImgName:@""];
    [closeButton addTarget:self action:@selector(cancelPromoCodeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //    [closeButton setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:1.0]];
    [closeButton setBackgroundColor:[UIColor clearColor]];
    closeButton.layer.cornerRadius = 3.0;
    [contentView addSubview:closeButton];
    promoCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+15, whiteView.frame.size.width-40, 30)];
    promoCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    promoCodeTextField.font = [UIFont systemFontOfSize:15];
    promoCodeTextField.placeholder = @"12345";
    promoCodeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    promoCodeTextField.keyboardType = UIKeyboardTypeDefault;
    promoCodeTextField.returnKeyType = UIReturnKeyDone;
    promoCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    promoCodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    promoCodeTextField.delegate = self;
    [contentView addSubview:promoCodeTextField];
    invalidPromoCodeLabel = [CommonUtils createLabelWithRect:CGRectMake(0, promoCodeTextField.frame.origin.y+promoCodeTextField.frame.size.height+5, whiteView.frame.size.width, 16) andTitle:@"Invalid Promo Code" andTextColor:[UIColor redColor]];
    invalidPromoCodeLabel.textAlignment = NSTextAlignmentCenter;
    invalidPromoCodeLabel.hidden = YES;
    invalidPromoCodeLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    [contentView addSubview:invalidPromoCodeLabel];
    UIButton *submitButton = [CommonUtils createButtonWithRect:CGRectMake(contentView.frame.size.width/2-70, promoCodeTextField.frame.origin.y+promoCodeTextField.frame.size.height+26, 140, 40) andText:@"SUBMIT" andTextColor:[UIColor whiteColor] andFontSize:@"" andImgName:@""];
    [submitButton addTarget:self action:@selector(checkPromoCodeValidOrNotMethodCall) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:0.2]];
    [submitButton setTag:200];
    submitButton.layer.cornerRadius = 3.0;
    [contentView addSubview:submitButton];
    [prmoCodePopupView addSubview:contentView];
    [self.view addSubview:prmoCodePopupView];
    contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:0.3/1.5 animations:^{
        contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                contentView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

- (void)cancelPromoCodeButtonClicked {
    [prmoCodePopupView removeFromSuperview];
}

#pragma mark:- Promo Code validity check
- (void)checkPromoCodeValidOrNotMethodCall {
    
    if ([promoCodeTextField.text length]) {
        [self enterPromoCodeWithCode:promoCodeTextField.text];
    }
}

#pragma mark Google Place Api Call

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == meetingTextField) {
        
        NSLog(@"Text is --%@",[NSString stringWithFormat:@"%@%@",textField.text,string]);
        [self handleSearchForSearchString:[NSString stringWithFormat:@"%@%@",textField.text,string]];
    }
    else if (textField == promoCodeTextField) {
        
        invalidPromoCodeLabel.hidden = YES;
        UIButton *button = (UIButton *)[self.view viewWithTag:200];
        if (promoCodeTextField.text.length > 1 || (string.length > 0 && ![string isEqualToString:@""]))
        {
            button.enabled = YES;
            [button setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:1.0]];
        }
        else
        {
            button.enabled = NO;
            [button setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:0.2]];
        }
    }
    return YES;
}

- (void)handleSearchForSearchString:(NSString *)searchString {
    
    //  searchQuery.location = currentLocation.coordinate;
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not fetch Places"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            
            _autoCompleter.suggestionsDictionary =  places;
            [self.autoCompleter textFieldValueChanged:meetingTextField];
        }
    }];
}


- (AutocompletionTableView *)autoCompleter {
    
    if (!_autoCompleter){
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:meetingTextField inViewController:self withOptions:options];
        _autoCompleter.backgroundColor =[UIColor lightGrayColor];
        _autoCompleter.autoCompleteDelegate = self;
    }
    return _autoCompleter;
}

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    NSLog(@"suggestions---%@",_autoCompleter.suggestionsDictionary);
    return _autoCompleter.suggestionsDictionary;
    
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index withString:(NSString *)str{
    
    // Fire Station Laxmi Nagar, New Delhi, Delhi, India
    meetingTextField.text=str;
    [meetingTextField resignFirstResponder];
    NSString *selectedData =[NSString stringWithFormat:@"%@",[_autoCompleter.suggestionsDictionary objectAtIndex:index]];
    NSArray *getData = [str componentsSeparatedByString:@","];
    streetStr = [getData objectAtIndex:0];
    cityStr = [getData objectAtIndex:1];
    stateStr = [getData objectAtIndex:2];
    NSArray *items = [selectedData componentsSeparatedByString:@","];
    NSString *placeIdStr =[items objectAtIndex:[items count]-2];
    NSArray *placeIdArray = [placeIdStr componentsSeparatedByString:@" "];
    NSString *placeId =[placeIdArray objectAtIndex:[placeIdArray count]-1];
    NSLog(@"Selected Data is --%@",placeId);
    //[self addressValidateApiData];
}

#pragma mark textField Scroll Up

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //Keyboard becomes visible
    bgScrollView.frame = CGRectMake(bgScrollView.frame.origin.x,
                                    bgScrollView.frame.origin.y,
                                    bgScrollView.frame.size.width,
                                    bgScrollView.frame.size.height - 360 + 50);   //resize
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    //keyboard will hide
    bgScrollView.frame = CGRectMake(bgScrollView.frame.origin.x,
                                    bgScrollView.frame.origin.y,
                                    bgScrollView.frame.size.width,
                                    bgScrollView.frame.size.height + 400 - 50); //resize
}


#pragma mark Address Validate Api Call ( Check Address Commercial or Residential)

- (void)addressValidateApiData {
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.smartystreets.com/street-address?auth-id=a7344e85-7340-5fb1-373e-26e4140fe2e7&auth-token=i6zc2hTNJH0NvYnxcLHT&street=%@&city=%@&state=%@&candidates=10",streetStr,cityStr,stateStr];
    NSString *encodedUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:encodedUrl parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSLog(@"JSON: %@", responseObject);
         NSArray *dataArray = responseObject;
         if (dataArray>0) {
             NSDictionary *dataDictionary = [dataArray objectAtIndex:0];
             NSString *dataStr = [[dataDictionary objectForKey:@"metadata"] objectForKey:@"rdi"];
             if ([dataStr isEqualToString:@"Commercial"]) {
                 addressVerify = @"yes";
             }
             else {
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                                 message:@"Please select diffrent address. It is not a Commercial address."
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
         }
         
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
    
    [ProgressHUD dismiss];
}

#pragma mark Enter Promo Code Api Call

- (void)enterPromoCodeWithCode:(NSString *)code{
    
    NSString *userIDStr = sharedInstance.userId;
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&promoCode=%@",APIAddPromoCodeCall,userIDStr,code];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlForGetCustomLocation:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        [ProgressHUD dismiss];
        
        if(!error) {
            
            NSLog(@"Response is --%@",responseObject);
            invalidPromoCodeLabel.hidden = YES;
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [rewardButton setTitle:@"Change Promo Code" forState:UIControlStateNormal];
                promoCodeLabel.hidden = NO;
                promoCodeLabel.text = promoCodeTextField.text;
                sharedInstance.promoCodeValue = promoCodeLabel.text;
                [prmoCodePopupView removeFromSuperview];
            }
            else {
                invalidPromoCodeLabel.hidden = NO;
                //[CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark: Get Utc Time
-(NSString *)getUTCFormateDateWithString:(NSString *)localDate
{
    
//    NSDateFormatter *dateFormatterString=[[NSDateFormatter alloc] init];
//    [dateFormatterString setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
//    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
//  //NSString *dateString = [dateFormatterString stringFromDate:[NSDate date]];
    NSArray *todayDateArray = [localDate componentsSeparatedByString:@" "];
    NSString *utcFromate = [NSString stringWithFormat:@"%@T%@",[todayDateArray firstObject],[todayDateArray lastObject]];
    NSDateFormatter *dateUTCString=[[NSDateFormatter alloc] init];
    [dateUTCString setDateFormat:@"MM/dd/yyyy'T'HH:mm:ss"];
    NSDate *convertedUTCDate = [[NSDate alloc] init];
    convertedUTCDate = [dateUTCString dateFromString:utcFromate];
    NSLog(@"UTC Date %@",convertedUTCDate);
    NSDateFormatter *UTCDateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [UTCDateFormatter setTimeZone:timeZone];
    [UTCDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *dateStringVlaue = [UTCDateFormatter stringFromDate:convertedUTCDate];
    
    return dateStringVlaue;
}


@end
