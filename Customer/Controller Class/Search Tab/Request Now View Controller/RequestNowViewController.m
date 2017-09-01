
//  RequestNowViewController.m
//  Customer
//  Created by Jamshed Ali on 09/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "RequestNowViewController.h"

@interface RequestNowViewController ()<kDropDownListViewDelegate,LocationDelegtae,CLLocationManagerDelegate,UINavigationControllerDelegate> {
    
    NSString *streetStr;
    NSString *cityStr;
    NSString *stateStr;
    NSString *addressVerify;
    NSString *dateIdStr;
    UITextField *distanceTextField;
    DropDownListView * Dropobj;
    NSMutableArray *rewardDataArray;
    NSString *rewardIDStr;
    NSTimer* myTimer;
    NSString *estimatedTimeArrivalStr;
    NSString *estimatedDateIDStr;
    BOOL checkTab;
    BOOL checkTabSecond;
    UIView *requestSendPopUpView;
    UIView *unavailableContractorPopupView;
    UIView *estimatedTimeOfArrivalByContractorPopupView;
    UIView *requestDeclinedByContractorPopupView;
    UIView *prmoCodePopupView;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    UILabel *invalidPromoCodeLabel;
    UITextField *promoCodeTextField;
    NSTimer *myLoadingTimer;
    NSInteger dotsToShow;
    NSString *timerValue;
    NSInteger counter;

}

@end

@implementation RequestNowViewController
@synthesize checkControllerStr,imageUrlStr,contractorId;

- (void)viewDidLoad {
    [super viewDidLoad];
    checkTab = NO;
    checkTabSecond = NO;
    rewardButton.hidden= YES;
    dropDownImage.hidden = YES;
    promoCodeLabel.hidden = YES;
    profileImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2;
    profileImageView.layer.borderWidth = 2.0;
    profileImageView.layer.masksToBounds = YES;
    profileImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    meetingTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    meetingTextField.layer.borderWidth = 0.5;
    UIView *meetingPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    meetingPaddingView.backgroundColor = [UIColor clearColor];
    //meetingTextField.leftView = meetingPaddingView;
    meetingTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *meetingIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
    meetingIcon.frame = CGRectMake(8, 8, 15.f, 22.f);
    meetingIcon.backgroundColor = [UIColor clearColor];
 //   [meetingPaddingView addSubview:meetingIcon];
    
    meetingTextField.backgroundColor = [UIColor clearColor];
   // meetingTextField.leftView = meetingPaddingView;
   // meetingTextField.leftViewMode = UITextFieldViewModeAlways;
    meetingTextView.placeholder = @"Choose a location";
    notesTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    notesTextField.layer.borderWidth = 0.5;
    UIView *notesPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    notesTextField.leftView = notesPaddingView;
    notesTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *notesIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file_Gray"]];
    notesIcon.frame = CGRectMake(8, 10, 21.f, 18.f);
    notesIcon.backgroundColor = [UIColor clearColor];
    [notesPaddingView addSubview:notesIcon];
    notesTextField.leftView = notesPaddingView;
    notesTextField.leftViewMode = UITextFieldViewModeAlways;
    rewardButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    rewardButton.layer.borderWidth = 0.5;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    NSLog(@"Request Now viewDidLoad method Call");
    
    addressVerify = @"";
    dateIdStr = @"";
    rewardIDStr= @"";
    notesTextField.text = @"";
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"addressVerify"];
    self.contractorId = [NSString stringWithFormat:@"%@",[self.requestNowDataDictionary valueForKey:@"UserID"]];
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyAW4AldQrkEsG5PJX8nDZL6_-ecYX9Z4-0"];
    [self.tabBarController.tabBar setHidden:YES];
    [self setDetailValues];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    NSLog(@"Request Now viewWillAppear method Call");
    if (checkTab) {
        SearchViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
        [self.navigationController pushViewController:notiView animated:YES];
        
    }
    
    if (checkTabSecond) {
        for ( UINavigationController *controller in self.tabBarController.viewControllers ) {
            if ( [[controller.childViewControllers objectAtIndex:0] isKindOfClass:[DatesViewController class]]) {
                self.tabBarController.selectedIndex = 1;
                checkTab = YES;
                [self.tabBarController setSelectedViewController:controller];
                //  [self tabBarControllerClass];
                break;
            }
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkDateReqestBySignalR:)
                                                 name:@"checkDateReqestBySignalR"
                                               object:nil];
    addressVerify = [[NSUserDefaults standardUserDefaults]objectForKey:@"addressVerify"];
}

-(void)locationStringValue :(NSString*)str{
    [locationButton setTitle:@"" forState:UIControlStateNormal];
    
    meetingTextView.text = str;
    if ([str isEqualToString:@""] || [str isEqual:nil]) {
        //[meetingTextView sizeToFit];
        [meetingTextField setFrame:CGRectMake(meetingTextField.frame.origin.x
                                              , meetingTextField.frame.origin.y
                                              , meetingTextField.frame.size.width, 50)];
        [meetingTextView setFrame:CGRectMake(meetingTextView.frame.origin.x
                                             , meetingTextView.frame.origin.y
                                             , meetingTextView.frame.size.width, meetingTextView.frame.size.height)];
        
        [self setheightOfTheView:meetingTextView];
    }
    else
    {
        CGSize textViewSize = [str sizeWithFont:[UIFont systemFontOfSize:14.0]
                              constrainedToSize:CGSizeMake(meetingTextView.frame.size.width, FLT_MAX)
                                  lineBreakMode:UILineBreakModeTailTruncation];
        NSLog(@"Height Value %f",textViewSize.height);
        [meetingTextView setFrame:CGRectMake(meetingTextView.frame.origin.x, meetingTextView.frame.origin.y, meetingTextView.frame.size.width, textViewSize.height+25)];
        CGFloat heightOfView = meetingTextView.frame.size.height;
        [meetingTextField setFrame:CGRectMake(meetingTextField.frame.origin.x
                                              , meetingTextField.frame.origin.y
                                              , meetingTextField.frame.size.width, heightOfView+5)];
        [self setheightOfTheView:meetingTextView];
        
    }

}

-(void)setheightOfTheView:(UITextView *)textView{
    
    [notesTextField setFrame:CGRectMake(notesTextField.frame.origin.x
                                        , meetingTextField.frame.origin.y+ meetingTextField.frame.size.height+13
                                        , notesTextField.frame.size.width, notesTextField.frame.size.height)];
    
    [estimatedRateView setFrame:CGRectMake(estimatedRateView.frame.origin.x
                                           , notesTextField.frame.origin.y+ notesTextField.frame.size.height+25
                                           , estimatedRateView.frame.size.width, estimatedRateView.frame.size.height)];
    
    [enterPromoCodeButton setFrame:CGRectMake(enterPromoCodeButton.frame.origin.x
                                      , estimatedRateView.frame.origin.y+ estimatedRateView.frame.size.height+11
                                      , enterPromoCodeButton.frame.size.width, enterPromoCodeButton.frame.size.height)];
    [promoCodeLabel setFrame:CGRectMake(promoCodeLabel.frame.origin.x
                                        , enterPromoCodeButton.frame.origin.y+ enterPromoCodeButton.frame.size.height+1
                                        , promoCodeLabel.frame.size.width, promoCodeLabel.frame.size.height)];
    [sendRequestNowButton setFrame:CGRectMake(sendRequestNowButton.frame.origin.x
                                                  , promoCodeLabel.frame.origin.y+ promoCodeLabel.frame.size.height+8
                                                  , sendRequestNowButton.frame.size.width, sendRequestNowButton.frame.size.height)];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"checkDateReqestBySignalR"
                                                  object:nil];
    
    [myTimer invalidate];
    myTimer=nil;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [myTimer invalidate];
    myTimer=nil;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Request Now viewDidAppear method Call");
    [super viewDidAppear:YES];
    if (checkTab) {
    }
}

- (void)checkDateReqestBySignalR:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    
    if ([requestTypeStr isEqualToString:@"4"]) {
        
        [myTimer invalidate];
        myTimer=nil;
        [myLoadingTimer invalidate];
        myLoadingTimer = nil;

        [self checkDateRequestacceptOrNotApiCall];
    }
    else if ([requestTypeStr isEqualToString:@"3"]) {
        
        [myTimer invalidate];
        myTimer=nil;
        [myLoadingTimer invalidate];
        myLoadingTimer = nil;
        [self requestDeclinedByContractorPopup];
        
    }
    else if ([requestTypeStr isEqualToString:@"16"]) {
        [myTimer invalidate];
        myTimer=nil;
        [myLoadingTimer invalidate];
        myLoadingTimer = nil;
        [self checkDateRequestacceptOrNotApiCall];
    }
    else
    {
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:YES];
    [myTimer invalidate];
    myTimer=nil;
    [myLoadingTimer invalidate];
    myLoadingTimer = nil;
}

- (void)setDetailValues {
    
    if ([checkControllerStr isEqualToString:@"search"]) {
        
        NSDictionary *dataDic = [[self.requestNowDataDictionary valueForKey:@"ContractorProfile"] mutableCopy];
        userNameLbl.text =[dataDic valueForKey:@"FirstName"];
        NSURL *imageUrl = [NSURL URLWithString:self.imageUrlStr];
        [profileImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"user_default"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        NSString *strForPerHourRate = [dataDic valueForKey:@"HourlyRate"];
        perhourPriceLbl.text = [NSString stringWithFormat:@"%@/hr",[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",strForPerHourRate]] ];
        NSString *strForMinimumHourRate = [dataDic valueForKey:@"MinimumHours"];
        minimumHourPriceLbl.text = [NSString stringWithFormat:@"Minimum %d hours",[strForMinimumHourRate intValue]];
        NSString *strForMinuteAftrRate = [dataDic valueForKey:@"RateAfterMinimumHour"];
        minuteAfterPriceLbl.text = [NSString stringWithFormat:@"%@ per minute after",[CommonUtils getFormateedNumberWithValue:strForMinuteAftrRate]];
    }
    else {
        NSDictionary *dataDic;
        if ([[self.requestNowDataDictionary valueForKey:@"ContractorProfile"] isKindOfClass:[NSDictionary class]]) {
            NSLog(@"key Found");
            dataDic = [[self.requestNowDataDictionary valueForKey:@"ContractorProfile"] mutableCopy];
        }
        else {
            NSLog(@"key NOT Found");
            dataDic = [self.requestNowDataDictionary mutableCopy];
            self.contractorId = [NSString stringWithFormat:@"%@",[self.requestNowDataDictionary valueForKey:@"UserID"]];
        }
        userNameLbl.text = [dataDic objectForKey:@"FirstName"];
        NSURL *imageUrl = [NSURL URLWithString:self.imageUrlStr];
        [profileImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"user_default"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        NSString *strForPerHourRate = [dataDic objectForKey:@"HourlyRate"];
        perhourPriceLbl.text = [NSString stringWithFormat:@"%@/hr",[CommonUtils getFormateedNumberWithValue:strForPerHourRate]];
        NSString *strForMinimumHourRate = [dataDic objectForKey:@"MinimumHours"];
        minimumHourPriceLbl.text = [NSString stringWithFormat:@"Minimum %d hours",[strForMinimumHourRate intValue]];
        NSString *strForMinuteAftrRate = [dataDic objectForKey:@"RateAfterMinimumHour"];
        minuteAfterPriceLbl.text = [NSString stringWithFormat:@"%@ per minute after",[CommonUtils getFormateedNumberWithValue:strForMinuteAftrRate]];
    }
}

- (void)viewDidLayoutSubviews {
    bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 700);
}

#pragma mark Google Place Api Call

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField ==meetingTextField){
        
        NSLog(@"Text is --%@",[NSString stringWithFormat:@"%@%@",textField.text,string]);
        [self handleSearchForSearchString:[NSString stringWithFormat:@"%@%@",textField.text,string]];
    }
    else if (textField == promoCodeTextField){
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
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not fetch Places"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            
            _autoCompleter.suggestionsDictionary =  places;
            [self.autoCompleter textFieldValueChanged:meetingTextField];
        }
    }];
}

- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
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
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

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

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClicked:(id)sender {
    [myTimer invalidate];
    myTimer=nil;
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark Request Now Method Call
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
    if ([meetingTextView.text isEqualToString:@""] || [meetingTextView.text isEqualToString: @"Choose a location"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                        message:@"Please enter the address."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
        if (locationAllowed) {
            if ([sharedInstance.latiValueStr length] && [sharedInstance.longiValueStr length]) {
                [self sendDateRequestApiData];
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
                                                   // [self performSelector:@selector(obj) withObject:self afterDelay:5];
                                               }];
        }
    }
    }
}

-(void)obj {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loactionUpdate" object:nil userInfo:nil];
    
}


#pragma mark Reward Method Call
- (IBAction)rewardButtonClicked:(id)sender {
    [Dropobj fadeOut];
    [self showPopUpWithTitle:@"Select Reward" withOption:rewardDataArray xy:CGPointMake(20, 70) size:CGSizeMake(self.view.frame.size.width-40, self.view.frame.size.height-80) isMultiple:NO];
    
}


#pragma mark Reward Api Call
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
                    sendRequestNowButton.frame = CGRectMake(15, 480, bgScrollView.frame.size.width-30, 42);
                }
            }
            else {
                
                rewardButton.hidden= YES;
                dropDownImage.hidden = YES;
                sendRequestNowButton.frame = CGRectMake(15, 480, bgScrollView.frame.size.width-30, 42);
                
            }
        }
    }];
}

#pragma mark Meetup Address Method Call
- (IBAction)meetUpAddressButtonClicked:(id)sender {
    
    ChooseLocationViewController *objLoc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseLocationViewController"];
    objLoc.delegate = self;
    [self.navigationController pushViewController:objLoc animated:YES];
    
}

#pragma mark Promo Code Method Clicked
- (IBAction)enterPromoCodeMethodClicked:(id)sender {
    [self promoCodePopup];
}

# pragma  mark Reward Amount Popup Show

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple {
    
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:self.view animated:YES];
    
    /*----------------Set DropDown backGroundColor-----------------*/
    [Dropobj SetBackGroundDropDown_R:0.0 G:108.0 B:194.0 alpha:0.70];
    
}


- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex {
    
    /*----------------Get Selected Value[Single selection]-----------------*/
    
    [rewardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rewardButton setTitle:[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[[rewardDataArray objectAtIndex:anIndex]objectForKey:@"Amount"] floatValue]]] forState:UIControlStateNormal];
    rewardIDStr = [NSString stringWithFormat:@"%@",[[rewardDataArray objectAtIndex:anIndex]objectForKey:@"ID"]];
    
}


- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
    
    /*----------------Get Selected Value[Multiple selection]-----------------*/
    if (ArryData.count>0) {
    }
    else{
        
    }
}


#pragma mark-- Send Dating Request API
- (void)sendDateRequestApiData {
    
    sharedInstance.checkBaseUrl = YES;
    if (!sharedInstance.promoCodeValue) {
        sharedInstance.promoCodeValue = @"";
    }
    NSString *encodedAddressUrl;
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)meetingTextView.text,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));

    NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerId=%@&ContractorID=%@&PromoCode=%@&Notes=%@&Latitude=%@&Longitude=%@&City=%@&County=%@&Country=%@&State=%@",APIRequestNow,userIdStr,self.contractorId,sharedInstance.promoCodeValue,notesTextField.text,
                      sharedInstance.meetUpLocationLattitude,
                      sharedInstance.meetUpLocationLongtitude,sharedInstance.cityValueStr,sharedInstance.cityValueStr,sharedInstance.countryValueStr,sharedInstance.stateValueStr];
    NSString *encodedUrl =  [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    encodedAddressUrl = [NSString stringWithFormat:@"%@&Location=%@",encodedUrl,encodedString];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encodedAddressUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if (([responseObject isKindOfClass:[NSNull class]]))
        {
            //  [requestSendPopUpView removeFromSuperview];
        }
        else
        {
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([responseObject isKindOfClass:[NSString class]]) {
                    [self  checkDateRequestAutoDeclineOrNot];
                }
                else
                {
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                        timerValue = [responseObject objectForKey:@"ReqTimeOut"];
                        dateIdStr = [responseObject objectForKey:@"DateID"];
                        if ([dateIdStr length]) {
                            [self requestSentPopup:timerValue];
                        }
                        else{
                        }
                    }
                    else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==2) {
                        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Your account is inactive.Contact to Doumee support team."
                                                     andButtonsWithTitle:@[@"Ok"] onController:self
                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           }];
                    }
                    else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==3) {
                        [[AlertView sharedManager] presentAlertWithTitle:@"No Payment Method" message:@"You need to add a payment method to your account before you can send a request. Do you want to add a credit card now?"
                                                     andButtonsWithTitle:@[@"Ok"] onController:self
                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                               if(index == 1) {
//                                                                   CreditCardViewController *creditCardView = [self.storyboard instantiateViewControllerWithIdentifier:@"creditCard"];
//                                                                   [self.navigationController pushViewController:creditCardView animated:YES];
                                                               }
                                                           }];
                        
                    } else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==4)
                    {
                        [[AlertView sharedManager] presentAlertWithTitle:@"Credit Card Verification" message:@"You need to verify your credit card before you can send a request. Do you want to verify now?"
                                                     andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                               if(index == 1) {
                                                                   PaymentMethodsViewController *paymentInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentMethod"];
                                                                   [self.navigationController pushViewController:paymentInfoView animated:YES];
                                                               }
                                                           }];
                        
                    }
                    else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==5)
                    {
                        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Your credit card has expired.Do you want to add a credit card now?"
                                                     andButtonsWithTitle:@[@"Ok"] onController:self
                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                               if(index == 1) {
//                                                                   CreditCardViewController *creditCardView = [self.storyboard instantiateViewControllerWithIdentifier:@"creditCard"];
//                                                                   [self.navigationController pushViewController:creditCardView animated:YES];
                                                               }
                                                           }];
                    }
                    else
                    {
                        [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                }
            }
            else {
                [ProgressHUD dismiss];
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:@"Request Time Out" inController:self];
            }
        }
    }
     ];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else if(buttonIndex == 1) {
        PaymentMethodsViewController *paymentInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentMethod"];
        [self.navigationController pushViewController:paymentInfoView animated:YES];
    }
}

- (void)checkDateRequestacceptOrNotTimerCall:(NSTimer*)t  {
    [self checkDateRequestacceptOrNotApiCall];
    [myTimer invalidate];
    myTimer=nil;
    [t  invalidate];
    t = nil;
}

- (void)checkDateRequestacceptOrNotApiCall {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APICheckDateRequestAcceptOrNot,userIdStr,dateIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        [myLoadingTimer invalidate];
        myLoadingTimer = nil;
        [requestSendPopUpView removeFromSuperview];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [self unavailableContractorPopup];
            }
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==2) {
                [self requestDeclinedByContractorPopup];
            }
            
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] == 3) {
                estimatedDateIDStr =[responseObject objectForKey:@"DateID"];
                NSString *estimatedTime = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"EstimatedTimeArrival"]];
                NSArray *nameStr = [estimatedTime componentsSeparatedByString:@"."];
                NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                NSLog(@"%@",fileKey);
                NSString *reserveDate = [CommonUtils convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                estimatedTimeArrivalStr = [CommonUtils changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                [self requestAcceptedByContractorPopup];
            }
            
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] == 0)
            {
                estimatedDateIDStr =[responseObject objectForKey:@"DateID"];
                if ([[responseObject objectForKey:@"Message"]isEqualToString:@"Contractor have already decline request."]) {
                    [self requestDeclinedByContractorPopup];
                }
                else{
                    NSString *estimatedTime = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"EstimatedTimeArrival"]];
                    NSArray *nameStr = [estimatedTime componentsSeparatedByString:@"."];
                    NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                    NSLog(@"%@",fileKey);
                    NSString *reserveDate = [CommonUtils convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                    estimatedTimeArrivalStr = [CommonUtils changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                    [self requestAcceptedByContractorPopup];
                }
            }
        }
        return ;
    }];
}

- (void)checkDateRequestAutoDeclineOrNot{
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APICheckDateRequestAcceptOrNot,userIdStr,dateIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        [myLoadingTimer invalidate];
        myLoadingTimer = nil;
        [requestSendPopUpView removeFromSuperview];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
        }
    }];
}

- (void)sendSignalRRequestToContaractorWithDateID:(NSString *)dateID WithTimer:(NSInteger)timervalue{
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?dateID=%@",APISendSignalRRequest,dateID];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ServerRequest requestWithUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
   
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            myTimer = [NSTimer scheduledTimerWithTimeInterval:timervalue target: self
                                                     selector: @selector(checkDateRequestacceptOrNotTimerCall:) userInfo: nil repeats: YES];
        }
    }];
}

- (void)simulateProgress {
    
    double delayInSeconds =1.5;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //  CGFloat increment = (arc4random() % 5) / 10.0f + 0.1;
        CGFloat increment = (100 % 2) / 10.0f + 0.08;
        CGFloat progress  = [progressView progress] + increment;
        [progressView setProgress:progress];
        if (progress < 1.0) {
            [self simulateProgress];
        }
    });
}


#pragma mark On Demand Request Sent Popup

- (void)requestSentPopup:(NSString *)timerValueFromRequest {
    
    requestSendPopUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    requestSendPopUpView.backgroundColor = [UIColor grayColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2-137, self.view.frame.size.width-40, 275)];
    
    //    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, 275)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 5, contentView.frame.size.width-2, 269)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    UILabel *titleTextLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 8, whiteView.frame.size.width, 25) andTitle:@"Sending Request...." andTextColor:[UIColor darkGrayColor]];
    [titleTextLabel setTag: 1000];
    [titleTextLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self performSelector:@selector(changePopUpText) withObject:nil afterDelay:5];
    
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [contentView addSubview:titleTextLabel];
    
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+12, whiteView.frame.size.width, .5)];
    firstLineView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:firstLineView];
    
    CGRect frame = CGRectMake(0, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+10, contentView.frame.size.width, 0);
    progressView = [[GradientProgressView alloc] initWithFrame:frame];
    [contentView addSubview:progressView];
    // Starts the moving gradient effect
    myLoadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateLoadingLabel) userInfo:nil repeats:YES];

  //  [progressView startAnimating];
    // Continuously updates the progress value using random values
   // [self simulateProgress];
    
    UILabel *contractorNameLabel = [CommonUtils createLabelWithRect:CGRectMake(0, firstLineView.frame.origin.y+firstLineView.frame.size.height+5, whiteView.frame.size.width, 30) andTitle:[NSString stringWithFormat:@"%@",userNameLbl.text] andTextColor:[UIColor darkGrayColor]];
    contractorNameLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    contractorNameLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:contractorNameLabel];
    
    UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(contentView.frame.size.width/2-55, contractorNameLabel.frame.origin.y+contractorNameLabel.frame.size.height+5, 110, 110)];
    circleView.layer.cornerRadius=circleView.frame.size.width/2;
    circleView.layer.masksToBounds=YES;
    circleView.layer.borderWidth = 2.0;
    circleView.layer.borderColor = [UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:1.0].CGColor;
    [contentView addSubview:circleView];
    
    UIImageView *contractorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(contentView.frame.size.width/2-50, contractorNameLabel.frame.origin.y+contractorNameLabel.frame.size.height+10, 100, 100)];
    contractorImageView.layer.cornerRadius=contractorImageView.frame.size.width/2;
    contractorImageView.layer.masksToBounds=YES;
    
    NSURL *imageUrl = [NSURL URLWithString:self.imageUrlStr];
    [contractorImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"user_default"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    [contractorImageView sd_setImageWithURL:imageUrl
    //                        placeholderImage:[UIImage imageNamed:@"user_default"]];
    
    [contentView addSubview:contractorImageView];
    
    
    UIButton *cencelDateRequestButton = [CommonUtils createButtonWithRect:CGRectMake(20, circleView.frame.origin.y+circleView.frame.size.height+20, contentView.frame.size.width-40, 40) andText:@"CANCEL" andTextColor:[UIColor whiteColor] andFontSize:@"" andImgName:@""];
    [cencelDateRequestButton addTarget:self action:@selector(cancelDateRequest) forControlEvents:UIControlEventTouchUpInside];
    [cencelDateRequestButton setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:1.0]];
    cencelDateRequestButton.layer.cornerRadius = 3.0;
    [contentView addSubview:cencelDateRequestButton];
    [requestSendPopUpView addSubview:contentView];
    
    [self.view addSubview:requestSendPopUpView];
    if ([dateIdStr length] || [timerValueFromRequest length]) {
        counter = [timerValueFromRequest integerValue];
        counter = counter*60;
        [self sendSignalRRequestToContaractorWithDateID:dateIdStr WithTimer:counter];
    }
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
    // Starts the moving gradient effect
 //   [progressView startAnimating];
    // Continuously updates the progress value using random values
   // [self simulateProgress];
  
}


- (void)updateLoadingLabel {
    
    UILabel *changeTextLabel = (UILabel *)[self.view viewWithTag:1000];
    if (++dotsToShow >= 4) dotsToShow = 0;  // an integer state that rotates 0, 1, 2, 3 and then repeats
    
    NSInteger dotsToHide = 3 - dotsToShow;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:changeTextLabel.text];
    if (dotsToHide > 0) {
        [string setAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} range:NSMakeRange(string.length - dotsToHide, dotsToHide)];
    }
    changeTextLabel.attributedText = string;
    
//    if ([changeTextLabel.text isEqualToString:@"Sending Request."]) {
//        changeTextLabel.text = @"Sending Request..";
//    } else if ([changeTextLabel.text isEqualToString:@"Sending Request.."]) {
//        changeTextLabel.text = @"Sending Request...";
//    } else if ([changeTextLabel.text isEqualToString:@"Sending Request..."]) {
//        changeTextLabel.text = @"Sending Request.";
//    }
//    else if ([changeTextLabel.text isEqualToString:@"Waiting For Acceptance..."]) {
//        changeTextLabel.text = @"Waiting For Acceptance.";
//    }
//    else if ([changeTextLabel.text isEqualToString:@"Waiting For Acceptance..."]) {
//        changeTextLabel.text = @"Waiting For Acceptance.";
//    }
//    else if ([changeTextLabel.text isEqualToString:@"Waiting For Acceptance..."]) {
//        changeTextLabel.text = @"Waiting For Acceptance.";
//    }
//    else if ([changeTextLabel.text isEqualToString:@"Waiting For Acceptance"]) {
//        changeTextLabel.text = @"Waiting For Acceptance.";
//    }
//    else if ([changeTextLabel.text isEqualToString:@"Sending Request"]) {
//        changeTextLabel.text = @"Sending Request.";
//    }
//

}


#pragma mark: PopUp TextChange Methode Called
-(void)changePopUpText {
    
    UILabel *changeTextLabel = (UILabel *)[self.view viewWithTag:1000];
    [changeTextLabel setText:@"Waiting For Acceptance...."];
//    [progressView startAnimating];
//    [self simulateProgress];
    
}

- (void)requestDeclinedByContractorPopup {
    
    requestDeclinedByContractorPopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    requestDeclinedByContractorPopupView.backgroundColor = [UIColor grayColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2-107, self.view.frame.size.width-40, 215)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0;
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 10, contentView.frame.size.width-2, 202)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    UILabel *titleTextLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 10, whiteView.frame.size.width, 18) andTitle:@"Declined!" andTextColor:[UIColor darkGrayColor]];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    [contentView addSubview:titleTextLabel];
    UILabel *contractorMessageLabel = [CommonUtils createLabelWithRect:CGRectMake(20, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+25, whiteView.frame.size.width-20, 30) andTitle:[NSString stringWithFormat:@"We're sorry but %@ has declined your request.",userNameLbl.text] andTextColor:[UIColor darkGrayColor]];
    contractorMessageLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    contractorMessageLabel.numberOfLines = 0;
    contractorMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contractorMessageLabel.textAlignment = NSTextAlignmentCenter;
    [contractorMessageLabel sizeToFit];
    [contentView addSubview:contractorMessageLabel];
    UIButton *cencelDateRequestButton = [CommonUtils createButtonWithRect:CGRectMake(20, contractorMessageLabel.frame.origin.y+contractorMessageLabel.frame.size.height+60, contentView.frame.size.width-40, 40) andText:@"CLOSE" andTextColor:[UIColor whiteColor] andFontSize:@"" andImgName:@""];
    [cencelDateRequestButton addTarget:self action:@selector(cancelButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [cencelDateRequestButton setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:1.0]];
    cencelDateRequestButton.layer.cornerRadius = 3.0;
    [contentView addSubview:cencelDateRequestButton];
    [requestDeclinedByContractorPopupView addSubview:contentView];
    [self.view addSubview:requestDeclinedByContractorPopupView];
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


- (void)requestAcceptedByContractorPopup {
    
    
    if (estimatedTimeOfArrivalByContractorPopupView) {
        [estimatedTimeOfArrivalByContractorPopupView removeFromSuperview];
    }
    estimatedTimeOfArrivalByContractorPopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    estimatedTimeOfArrivalByContractorPopupView.backgroundColor = [UIColor grayColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2-127, self.view.frame.size.width-40, 255)];
    
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 10, contentView.frame.size.width-2, 242)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    
    UILabel *titleTextLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 10, whiteView.frame.size.width, 18) andTitle:@"Date Accepted!" andTextColor:[UIColor darkGrayColor]];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    [contentView addSubview:titleTextLabel];
    
    UILabel *contractorMessageLabel = [CommonUtils createLabelWithRect:CGRectMake(0, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+25, whiteView.frame.size.width, 30) andTitle:[NSString stringWithFormat:@"%@ is on the way.",userNameLbl.text] andTextColor:[UIColor darkGrayColor]];
    contractorMessageLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    contractorMessageLabel.numberOfLines = 0;
    contractorMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contractorMessageLabel.textAlignment = NSTextAlignmentCenter;
    // [contractorMessageLabel sizeToFit];
    [contentView addSubview:contractorMessageLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, contractorMessageLabel.frame.origin.y+contractorMessageLabel.frame.size.height+25, contentView.frame.size.width-40, 65)];
    bgView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    [contentView addSubview:bgView];
    
    UILabel *extimatedTimeTitleLabel = [CommonUtils createLabelWithRect:CGRectMake(20, 5, bgView.frame.size.width-20, 25) andTitle:[NSString stringWithFormat:@"Estimated Time of Arrival"] andTextColor:[UIColor darkGrayColor]];
    extimatedTimeTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    extimatedTimeTitleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:extimatedTimeTitleLabel];
    
    UILabel *extimatedTimeLabel = [CommonUtils createLabelWithRect:CGRectMake(20, extimatedTimeTitleLabel.frame.origin.y+extimatedTimeTitleLabel.frame.size.height+5, bgView.frame.size.width-20, 30) andTitle:[NSString stringWithFormat:@"%@",estimatedTimeArrivalStr] andTextColor:[UIColor blackColor]];
    extimatedTimeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    extimatedTimeLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:extimatedTimeLabel];
    
    UIButton *closeButton = [CommonUtils createButtonWithRect:CGRectMake(20, bgView.frame.origin.y+bgView.frame.size.height+15, contentView.frame.size.width/2-20, 40) andText:@"CLOSE" andTextColor:[UIColor whiteColor] andFontSize:@"" andImgName:@""];
    [closeButton addTarget:self action:@selector(cancelButtonGoHomePushed) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:1.0]];
    closeButton.layer.cornerRadius = 3.0;
    [contentView addSubview:closeButton];
    
    UIButton *viewDetailsButton = [CommonUtils createButtonWithRect:CGRectMake(contentView.frame.size.width/2+5, bgView.frame.origin.y+bgView.frame.size.height+15, contentView.frame.size.width/2-20, 40) andText:@"VIEW DETAILS" andTextColor:[UIColor whiteColor] andFontSize:@"" andImgName:@""];
    [viewDetailsButton addTarget:self action:@selector(viewDateListMethodCall) forControlEvents:UIControlEventTouchUpInside];
    [viewDetailsButton setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:1.0]];
    viewDetailsButton.layer.cornerRadius = 3.0;
    [contentView addSubview:viewDetailsButton];
    
    [estimatedTimeOfArrivalByContractorPopupView addSubview:contentView];
    [self.view addSubview:estimatedTimeOfArrivalByContractorPopupView];
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


-(void)setTab:(Class)class{
    int i = 0;
    for (UINavigationController *controller in self.tabBarController.viewControllers){
        if ([controller isKindOfClass:class]){
            break;
        }
        i++;
    }
    self.tabBarController.selectedIndex = i;
}


-(void)tabBarController:(UITabBarController *)tabBarController
didSelectViewController:(UIViewController *)viewController
{
    
    NSLog(@"Selected index: %lu", (unsigned long)tabBarController.selectedIndex);
    
    if (viewController == tabBarController.moreNavigationController)
    {
        tabBarController.moreNavigationController.delegate = self;
    }
    
    NSUInteger selectedIndex = tabBarController.selectedIndex;
    switch (selectedIndex) {
        case 0:
            NSLog(@"click me %lu",self.tabBarController.selectedIndex);
            break;
        case 1:
            NSLog(@"click me again!! %lu",self.tabBarController.selectedIndex);
            break;
        default:
            break;
    }
}


- (void)viewDateListMethodCall {
    
    [estimatedTimeOfArrivalByContractorPopupView removeFromSuperview];
    DateDetailsViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateDetail"];
    dateDetailsView.self.dateIdStr =  estimatedDateIDStr;
    dateDetailsView.isFromRequestNow = TRUE;
    dateDetailsView.self.dateTypeStr = @"16";
    checkTabSecond = YES;
    checkTab = NO;
    [self.navigationController pushViewController:dateDetailsView animated:NO];
    
    
}


- (void)tabBarControllerClass {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *searchScreenView = [storyboard instantiateViewControllerWithIdentifier:@"search"];
    //searchScreenView.view.backgroundColor = [UIColor whiteColor];
    searchScreenView.title = @"Search";
    searchScreenView.tabBarItem.image = [UIImage imageNamed:@"search"];
    searchScreenView.tabBarItem.selectedImage = [UIImage imageNamed:@"search_hover"];
    
    DatesViewController *datesView = [storyboard instantiateViewControllerWithIdentifier:@"dates"];
    //datesView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    //datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.title = @"Dates";
    datesView.isFromDateDetails = NO;

    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    // messageView.tabBarItem.badgeValue =messageCountStr;
    messageView.title = @"Messages";
    messageView.tabBarItem.image = [UIImage imageNamed:@"message"];
    messageView.tabBarItem.selectedImage = [UIImage imageNamed:@"message_hover"];
    
    NotificationsViewController *notiView = [storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notiView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    //notiView.tabBarItem.badgeValue = notificationsCountStr;
    notiView.title = @"Notifications";
    notiView.tabBarItem.image = [UIImage imageNamed:@"notification"];
    notiView.tabBarItem.selectedImage = [UIImage imageNamed:@"notification_hover"];
    
    AccountViewController *accountView = [storyboard instantiateViewControllerWithIdentifier:@"account"];
    // accountView.view.backgroundColor = [UIColor colorWithRed:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#> ];
    accountView.title = @"Account";
    accountView.tabBarItem.image = [UIImage imageNamed:@"user"];
    accountView.tabBarItem.selectedImage = [UIImage imageNamed:@"user_hover"];
    
    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:searchScreenView];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:datesView];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:messageView];
    UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:notiView];
    UINavigationController *navC5 = [[UINavigationController alloc] initWithRootViewController:accountView];
    
    /**************************************** Key Code ****************************************/
    APPDELEGATE.tabBarC    = [[LCTabBarController alloc] init];
    
    //    tabBarC.itemTitleFont          = [UIFont boldSystemFontOfSize:11.0f];
    //    tabBarC.itemTitleColor         = [UIColor greenColor];
    APPDELEGATE.tabBarC.selectedItemTitleColor = [UIColor purpleColor];
    
    // tabBarC.selectedItemTitleColor =  [UIColor colorWithRed:190/255.0 green:78/255.0 blue:80/255.0 alpha:1.0];
    
    //    tabBarC.itemImageRatio         = 0.5f;
    //    tabBarC.badgeTitleFont         = [UIFont boldSystemFontOfSize:12.0f];
    
    APPDELEGATE.tabBarC.viewControllers        = @[navC1, navC2, navC3, navC4, navC5];
    // self.window.rootViewController = tabBarC;
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:NO];
    
}

-(void)updateBadges:(NSNotification*) noti {
    
    NSDictionary* responseObject = noti.userInfo;
    if ([[responseObject objectForKey:@"Dates"] isEqualToString:@"0"]) {
        
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
        
    } else {
        
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [responseObject objectForKey:@"Dates"];
    }
    
    if ([[responseObject  objectForKey:@"Mesages"] isEqualToString:@"0"]) {
        
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
        
    } else {
        
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue  = [responseObject objectForKey:@"Mesages"];
    }
    
    if ([[responseObject objectForKey:@"Notifications"] isEqualToString:@"0"]) {
        
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
        
    } else {
        
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue  = [responseObject objectForKey:@"Notifications"];
    }
}


- (void)acceptDateRequestViewDetailsButtonClicked {
    
    [estimatedTimeOfArrivalByContractorPopupView removeFromSuperview];
    
    for ( UINavigationController *controller in self.tabBarController.viewControllers ) {
        if ( [[controller.childViewControllers objectAtIndex:0] isKindOfClass:[DatesViewController class]]) {
            
            checkTab = YES;
            checkTabSecond = NO;
            self.tabBarController.selectedIndex = 1;
            [self.tabBarController setSelectedViewController:controller];
            break;
        }
    }
}

#pragma mark Unavaible Service Contractor Popup
- (void)unavailableContractorPopup {
    
    unavailableContractorPopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    unavailableContractorPopupView.backgroundColor = [UIColor grayColor];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2-127, self.view.frame.size.width-40, 255)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 5, contentView.frame.size.width-2, 218)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    
    UILabel *titleTextLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 10, whiteView.frame.size.width, 18) andTitle:@"Unavailable" andTextColor:[UIColor darkGrayColor]];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    [contentView addSubview:titleTextLabel];
    
    UILabel *contractorMessageLabel = [CommonUtils createLabelWithRect:CGRectMake(20, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+25, whiteView.frame.size.width-20, 30) andTitle:[NSString stringWithFormat:@"We are sorry but %@ is not available right now. Please try again later or reserve her.",userNameLbl.text] andTextColor:[UIColor darkGrayColor]];
    contractorMessageLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    contractorMessageLabel.numberOfLines = 0;
    contractorMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contractorMessageLabel.textAlignment = NSTextAlignmentCenter;
    [contractorMessageLabel sizeToFit];
    [contentView addSubview:contractorMessageLabel];
    
    UIButton *closeButton = [CommonUtils createButtonWithRect:CGRectMake(20, contractorMessageLabel.frame.origin.y+contractorMessageLabel.frame.size.height+35, contentView.frame.size.width/2-20, 40) andText:@"CLOSE" andTextColor:[UIColor whiteColor] andFontSize:@"" andImgName:@""];
    [closeButton addTarget:self action:@selector(cancelUnAvaibleButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:1.0]];
    closeButton.layer.cornerRadius = 3.0;
    [contentView addSubview:closeButton];
    
    UIButton *reserveHerButton = [CommonUtils createButtonWithRect:CGRectMake(contentView.frame.size.width/2+5, contractorMessageLabel.frame.origin.y+contractorMessageLabel.frame.size.height+35, contentView.frame.size.width/2-20, 40) andText:@"RESERVE" andTextColor:[UIColor whiteColor] andFontSize:@"" andImgName:@""];
    [reserveHerButton addTarget:self action:@selector(reserveHerclickedCall) forControlEvents:UIControlEventTouchUpInside];
    [reserveHerButton setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:1.0]];
    reserveHerButton.layer.cornerRadius = 3.0;
    [contentView addSubview:reserveHerButton];
    
    [unavailableContractorPopupView addSubview:contentView];
    [self.view addSubview:unavailableContractorPopupView];
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



- (void)cancelButtonGoHomePushed {
    
    [estimatedTimeOfArrivalByContractorPopupView removeFromSuperview];
    SearchViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [self.navigationController pushViewController:notiView animated:NO];
    
}


- (void)cancelUnAvaibleButtonPushed {
    
    [unavailableContractorPopupView removeFromSuperview];
    SearchViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [self.navigationController pushViewController:notiView animated:NO];
    
}

- (void)cancelButtonPushed {
    
    [requestDeclinedByContractorPopupView removeFromSuperview];
    SearchViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [self.navigationController pushViewController:notiView animated:NO];
}

- (void)reserveHerclickedCall {
    
    [unavailableContractorPopupView removeFromSuperview];
    ReserveViewController *reserveView = [self.storyboard instantiateViewControllerWithIdentifier:@"reserve"];
    reserveView.reserveDataDictionary = _requestNowDataDictionary;
    reserveView.self.imageUrlStr = self.imageUrlStr;
    [self.navigationController pushViewController:reserveView animated:YES];
    
}


#pragma mark Enter Promo Code Popup

- (void)promoCodePopup {
    
    prmoCodePopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    prmoCodePopupView.backgroundColor = [UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:0.9];
    //prmoCodePopupView.alpha = 0.6;
    
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
    submitButton.layer.cornerRadius = 3.0;
    [submitButton setTag:200];
    [submitButton setEnabled:NO];
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

- (void)checkPromoCodeValidOrNotMethodCall {
    
    if ([promoCodeTextField.text length]) {
        [self enterPromoCodeWithCode:promoCodeTextField.text];
    }
}


- (void)cancelDateRequest {
    
    [myTimer invalidate];
    myTimer=nil;
    
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIDeclineDate,userIdStr,dateIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        [myLoadingTimer invalidate];
        myLoadingTimer = nil;
        [requestSendPopUpView removeFromSuperview];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                             andButtonsWithTitle:@[@"OK"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle)
                 {
                     if ([buttonTitle isEqualToString:@"OK"]) {
                         SearchViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
                         [self.navigationController pushViewController:datesView animated:NO];
                         
                     }}];
                
                
            } else {
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        } else {
            
            NSLog(@"Error");
        }
    }];
    
}

#pragma mark Address Validate Api Call ( Check Address Commercial or Residential)

- (void)addressValidateApiData {
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.smartystreets.com/street-address?auth-id=a7344e85-7340-5fb1-373e-26e4140fe2e7&auth-token=i6zc2hTNJH0NvYnxcLHT&street=%@&city=%@&state=%@&candidates=10",streetStr,cityStr,stateStr];
    
    //    NSString *datadUrl = @"https://api.smartystreets.com/street-address?auth-id=a7344e85-7340-5fb1-373e-26e4140fe2e7&auth-token=i6zc2hTNJH0NvYnxcLHT&street=3301%20South%20Greenfield%20Rd&city=Gilbert&state=AZ&candidates=10";
    
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
         
         if (dataArray.count>0) {
             
             NSDictionary *dataDictionary = [dataArray objectAtIndex:0];
             
             NSString *dataStr = [[dataDictionary objectForKey:@"metadata"] objectForKey:@"rdi"];
             if ([dataStr isEqualToString:@"Commercial"]) {
                 
                 addressVerify = @"yes";
                 
             } else {
                 
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
        NSLog(@"response object Post Contractor Search List %@",responseObject);
        // NSLog(@"Url List %@",urlstr);
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
                //[CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}


@end
