
//  DateDetailsViewController.m
//  Customer
//  Created by Jamshed Ali on 10/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "DateDetailsViewController.h"

@interface DateDetailsViewController () {
    
    SingletonClass *sharedInstance;
    NSMutableArray *imageArray;
    NSDictionary *dataDictionary;
    UIView *dateBottomlineView;
    UIView *profileBottomlineView;
    NSString *customerIdStr;
    NSString *isFavouriteStr;
    NSString *hourlyRateStr;
    NSString *minimumHourStr;
    NSString *isOnlineStr;
    NSString *paymentMethodStr;
    NSString *rateAfterMinimumHourStr;
    UIView *secondProductReportPopup;
    UIView *estimatedArrivalView;
    NSString *setPrimaryUrlStr;
    NSDateFormatter *dateFormatter;
    BOOL favourite;
    NSString *userIdStr;
    NSString *buttonStatus;
    NSString *dateCountStr;
    NSString *messageCountStr;
    NSString *notificationsCountStr;
    LCTabBarController *tabBarC;
    NSString *totalDistanceStr;
    NSString *totalDistanceStrInMeter;
  // NSString  *bookTimeSlotDate;
    NSString *totalTimeStr;
    NSString *userNameStr;
}
@property (nonatomic,retain)PEARImageSlideViewController * slideImageViewController;
@property (weak, nonatomic) IBOutlet UIView *etaView;
@end

@implementation DateDetailsViewController
@synthesize dateTypeStr,statusTypeStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    dateCountStr = @"";
    messageCountStr = @"";
    notificationsCountStr = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:YES];
    sharedInstance = [SingletonClass sharedInstance];
    dateFormatter = [[NSDateFormatter alloc]init];
    userIdStr = sharedInstance.userId;
    dateBottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, dateInfoButton.frame.size.height - 1.0f, dateInfoButton.frame.size.width, 1)];
    dateBottomlineView.backgroundColor = [UIColor purpleColor];
    [dateInfoButton addSubview:dateBottomlineView];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    dateBottomlineView.hidden = NO;
    profileBottomlineView.hidden = YES;
    sharedInstance.imagePopupCondition = @"no";
    if ([sharedInstance.requestTypeStr isEqualToString:@"1"]) {
        [dateImageView setImage:[UIImage imageNamed:@"lightning"]];
    }
    else{
        [dateImageView setImage:[UIImage imageNamed:@"calendar_Other"]];
        
    }
    [self dateDetailsApiCall];
  
    likeDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
    likeDetailsLbl.numberOfLines = 0;
    [likeDetailsLbl sizeToFit];
    
    datingTitleLbl.frame = CGRectMake(15, likeDetailsLbl.frame.origin.y+likeDetailsLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
    
    datingDetailsLbl.frame = CGRectMake(15, datingTitleLbl.frame.origin.y+datingTitleLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
    
    datingDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
    datingDetailsLbl.numberOfLines = 0;
    [datingDetailsLbl sizeToFit];
    
    imageCountLabel.layer.cornerRadius = 5;
    availaibleLabel.layer.cornerRadius = 5;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    NSLog(@"view will appear method Call");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dateEndThenPaymentScreen:)
                                                 name:@"dateEndThenPaymentScreen"
                                               object:nil];

    NSString *requestToEndDAteValue = [[NSUserDefaults standardUserDefaults] valueForKey:@"requestToEndDateValue"];
    if (requestToEndDAteValue != nil) {
        if ([requestToEndDAteValue isEqualToString:@"1"]) {
            [requestToEndDate setEnabled:NO];
            [requestToEndDate setBackgroundColor:[UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1.0]];
        }
        else{
            [requestToEndDate setEnabled:YES];
            [requestToEndDate setBackgroundColor:[UIColor colorWithRed:129.0/255.0 green:90.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            
        }
    }
 
    }

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [estimatedArrivalView removeFromSuperview];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"dateEndThenPaymentScreen"
                                                  object:nil];
}

- (void)dateEndThenPaymentScreen:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    NSString *dateIDValueStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateId"]];
    PaymentDateCompletedViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentDateCompleted"];
    dateDetailsView.isFromLoginView = NO;
    dateDetailsView.self.dateIdStr = dateIDValueStr;
    dateDetailsView.self.dateTypeStr = requestTypeStr;
    [self.navigationController pushViewController:dateDetailsView animated:YES];
    
}



-(void)viewDidLayoutSubviews {
    
    if ([buttonStatus isEqualToString:@"0"]) {
        bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
        [requestToEndDate setHidden:YES];

        [_etaView setHidden:YES];
    }
    else if ([buttonStatus isEqualToString:@"1"]){
        bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
        [requestToEndDate setHidden:YES];

        [_etaView setHidden:YES];
        
    }
    else if ([buttonStatus isEqualToString:@"2"] || [self.dateTypeStr isEqualToString:@"16"]){
        bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+300);
        [requestToEndDate setHidden:YES];

        [_etaView setHidden:NO];
        
    }
    else if ([buttonStatus isEqualToString:@"3"]){
        bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
        [requestToEndDate setHidden:YES];
        [_etaView setHidden:YES];
        
    }
    else if ([buttonStatus isEqualToString:@"4"]){
        bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+200);
       [requestToEndDate setHidden:NO];
        [_etaView setHidden:YES];
        
    }
    else{
        bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
        [requestToEndDate setHidden:YES];
        [_etaView setHidden:YES];
        
    }
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([imageArray count]) {
        return [imageArray count];
        
    }else{
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    cell =nil;
    
    if(cell ==nil) {
        
        cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    }
    
    UILabel *imageCountLbl = (UILabel *)[cell viewWithTag:777];
    UIView *imageCountView = (UIView *)[cell viewWithTag:323];
    [imageCountView setHidden:YES];
    
    if (imageArray.count) {
        [imageCountView setHidden:NO];
        [imageCountLbl setHidden:NO];
        UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
        NSString *imageUrlStr = [imageArray objectAtIndex:indexPath.row];
        //    NSString *imageData = [dict valueForKey:@"PicUrl"];
        NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
        [recipeImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //    [recipeImageView sd_setImageWithURL:imageUrl
        //                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [cell.backgroundView addSubview:recipeImageView];
        //[recipeImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
        NSString *countStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        NSString *imageCountStr = [NSString stringWithFormat:@"%ld",(unsigned long)imageArray.count];
        imageCountLbl.text = [NSString stringWithFormat:@"%@/%@",countStr,imageCountStr];
    }
    else {
        
        [imageCountView setHidden:YES];
        [imageCountLbl setHidden:YES];
    }
    return cell;
}

- (void)setSlideViewWithImageCountData:(NSInteger)imageCount {
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([sharedInstance.imagePopupCondition  isEqualToString: @"no"]) {
        sharedInstance.imagePopupCondition = @"yes";
        _slideImageViewController = [PEARImageSlideViewController new];
        [_slideImageViewController setImageLists:[imageArray mutableCopy]];
        [_slideImageViewController showAtIndex:0];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, collectionView.frame.size.height );
}

-(void)doumeePrice:(UIButton *)sender {
    
    [self productWeightPricePopupButtonPushed];
}
#pragma marl Date Cancel Method Call

- (IBAction)cancelDateButtonClicked:(id)sender {
    if ([buttonStatus isEqualToString:@"3"]) {
        double distanceTime = [totalDistanceStrInMeter doubleValue];
        if (distanceTime>0.2) {
            [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"Are you sure you want to cancel this date? Because you are not near the date location or Doumee. "
                                         andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle)
             {
                 if ([buttonTitle isEqualToString:@"Yes"]) {
                     [self callAPiForCancel];
                     
                 }
             }];
        }
        else{
            [self callAPiForCancel];
        }
    }
    else{
        [self callAPiForCancel];
        
    }
}




- (IBAction)backBtnClicked:(id)sender {
    
    
    if (sharedInstance.isFromCancelDateRequest)
    {
        [self tabBarCountApiCall];
        sharedInstance.isFromCancelDateRequest = NO;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        // [self tabBarCountApiCall];
    }
    
}


- (IBAction)messageButtonClicked:(id)sender {
    
    if ([self.dateTypeStr isEqualToString:@"1"]) {
        
    }
    else {
        
        [NSUserDefaults saveIncomingAvatarSetting:YES];
        [NSUserDefaults saveOutgoingAvatarSetting:YES];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self getUserMessageApiCall];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Get User Message API Call
- (void)getUserMessageApiCall {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@&DateID=%@&UserType=%@",APIGetMessagebyUser,userIdStr,self.contractorIdStr,self.dateIdStr,@"1"];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            [NSUserDefaults saveIncomingAvatarSetting:YES];
            [NSUserDefaults saveOutgoingAvatarSetting:YES];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"MessageBYUser"] isKindOfClass:[NSArray class]]) {
                    
                    NSArray *messageData =  [[responseObject objectForKey:@"result"]objectForKey:@"MessageBYUser"];
                    
                    // sharedInstance.dateEndMessageDisableStr = @"";
                    
                    sharedInstance.dateEndMessageDisableStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"DateStatus"]];
                    
                    if ([sharedInstance.dateEndMessageDisableStr isEqualToString:@"1"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"2"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"4"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"6"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"10"]|| [sharedInstance.dateEndMessageDisableStr isEqualToString:@"11"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"13"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"15"]) {
                        
                        [CommonUtils showAlertWithTitle:@"Alert!" withMsg:@"Date is already cancel by Doumees" inController:self];
                        
                    }
                    else {
                        
                        OneToOneMessageViewController *vc = [OneToOneMessageViewController messagesViewController];
                        sharedInstance.messagessDataMArray = [messageData copy];
                        sharedInstance.recipientIdStr = self.contractorIdStr;
                        
                        sharedInstance.userNameStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"AppLoginUserName"]];
                        sharedInstance.userImageUrlStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ApploginPicName"]];
                        sharedInstance.dateIdStr = self.dateIdStr;
                        
                        sharedInstance.recipientNameStr = [customerNameLabel.text capitalizedString];
                        
                        vc.self.recipientIdStr = self.contractorIdStr;
                        vc.self.userImageUrlStr =  setPrimaryUrlStr;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    
                }
                
            } else {
                
                sharedInstance.dateEndMessageDisableStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"DateStatus"]];

                if ([sharedInstance.dateEndMessageDisableStr isEqualToString:@"1"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"2"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"4"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"6"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"10"]|| [sharedInstance.dateEndMessageDisableStr isEqualToString:@"11"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"13"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"15"]) {
                    
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:@"Date is already cancel by Doumees" inController:self];
                    
                } else {
                    
                    OneToOneMessageViewController *vc = [OneToOneMessageViewController messagesViewController];
                    sharedInstance.recipientIdStr = self.contractorIdStr;
                    
                    sharedInstance.messagessDataMArray = [[NSMutableArray alloc]init];
                    
                    sharedInstance.dateEndMessageDisableStr = @"";
                    
                    sharedInstance.userNameStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"AppLoginUserName"]];
                    sharedInstance.userImageUrlStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ApploginPicName"]];
                    sharedInstance.dateIdStr = self.dateIdStr;
                    sharedInstance.recipientNameStr = [customerNameLabel.text capitalizedString];
                    vc.self.recipientIdStr = self.contractorIdStr;
                    vc.self.userImageUrlStr =  setPrimaryUrlStr;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
            }
        } else {
            
            [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
        }
    }];
}

-(void)callAPiForCancel
{
    NSLog(@"Button Status VAlue %@", buttonStatus);
    
    if ([buttonStatus isEqualToString:@"4"])
    {
        [self cancelTheDAtterStarted];
    }
    else if ([buttonStatus isEqualToString:@"0"])
        {
        // http://ondemandapiqa.flexsin.in/API/Customer/DeclineDate
        NSString    * urlString = [NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIDeclineDate,sharedInstance.userId,self.dateIdStr];
        
        NSString *encoded = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
//                    [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
//                                                 andButtonsWithTitle:@[@"OK"] onController:self
//                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle)
//                     {
//                         if ([buttonTitle isEqualToString:@"OK"]) {
                             [self.navigationController popViewControllerAnimated:YES];
                         }
//                     }];
                //}
                else {
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
        
    }

    else
    {
    CancelDateViewController *cancelDateView = [self.storyboard instantiateViewControllerWithIdentifier:@"cancelDate"];
    cancelDateView.self.dateIdStr = _dateIdStr;
        
    if (self.isFromRequestNow) {
        cancelDateView.self.isFromRequestNow = TRUE;
    }
    else
    {
        cancelDateView.self.isFromRequestNow = FALSE;
    }
        
    cancelDateView.buttonStatus = buttonStatus;
    NSLog(@"Date Type String Value %@",self.dateTypeStr);
    cancelDateView.dateTypeStr = self.dateTypeStr;
    cancelDateView.addressCancelValue = sharedInstance.addressValueWhileCancelTheDate;
    [self.navigationController pushViewController:cancelDateView animated:YES];
    }
    
}
-(void)cancelTheDAtterStarted{
    
        //http://ondemandapinew.flexsin.in/API/Account/GetCancellationFee?UserID=Cr0036e78&DateID=Date31491
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIGetCancelFee,userIdStr,self.dateIdStr];
        NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest requestWithUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            if(!error)
            {
             
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    sharedInstance.IsCancellationFeeAllowed = [responseObject objectForKey:@"ISCancelFeeAplied"];
                    sharedInstance.cancellationFee = [responseObject objectForKey:@"CancellationnFee"];
                   // if ( ([sharedInstance.cancellationFee integerValue] == 0)) {
                                CancelDateViewController *cancelDateView = [self.storyboard instantiateViewControllerWithIdentifier:@"cancelDate"];
                                cancelDateView.self.dateIdStr = _dateIdStr;
                                cancelDateView.buttonStatus = buttonStatus;
                                if (self.isFromRequestNow) {
                                    cancelDateView.self.isFromRequestNow = TRUE;
                                }
                                else{
                                    cancelDateView.self.isFromRequestNow = FALSE;
                                }
                                NSLog(@"Date Type String Value %@",self.dateTypeStr);
                                cancelDateView.dateTypeStr = self.dateTypeStr;
                                cancelDateView.addressCancelValue =sharedInstance.addressValueWhileCancelTheDate;
                                [self.navigationController pushViewController:cancelDateView animated:YES];
    
                }
                else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==2)
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
                
            }
        } ];

}

- (void)tabBarCountApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"1" ,@"userType",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Dates"] isEqualToString:@"0"])
                {
                    dateCountStr  = nil;
                }
                else
                {
                    dateCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Dates"];
                }
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Mesages"] isEqualToString:@"0"])
                {
                    messageCountStr = nil;
                }
                else
                {
                    messageCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Mesages"];
                }
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Notifications"] isEqualToString:@"0"])
                {
                    notificationsCountStr   = nil;
                }
                else
                {
                    notificationsCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Notifications"];
                }
            }
        }
        [self tabBarControllerClass];
    }];
}


- (void)tabBarControllerClass {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *searchScreenView = [storyboard instantiateViewControllerWithIdentifier:@"search"];
    searchScreenView.view.backgroundColor = [UIColor whiteColor];
    searchScreenView.title = @"Search";
    searchScreenView.tabBarItem.image = [UIImage imageNamed:@"search"];
    searchScreenView.tabBarItem.selectedImage = [UIImage imageNamed:@"search_hover"];
    
    DatesViewController *datesView = [storyboard instantiateViewControllerWithIdentifier:@"dates"];
    datesView.view.backgroundColor = [UIColor whiteColor];
    datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.title = @"Dates";
    datesView.isFromDateDetails = NO;
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor whiteColor];
    messageView.tabBarItem.badgeValue =messageCountStr;
    messageView.title = @"Messages";
    messageView.tabBarItem.image = [UIImage imageNamed:@"message"];
    messageView.tabBarItem.selectedImage = [UIImage imageNamed:@"message_hover"];
    
    NotificationsViewController *notiView = [storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notiView.view.backgroundColor = [UIColor whiteColor];
    notiView.tabBarItem.badgeValue = notificationsCountStr;
    notiView.title = @"Notifications";
    notiView.tabBarItem.image = [UIImage imageNamed:@"notification"];
    notiView.tabBarItem.selectedImage = [UIImage imageNamed:@"notification_hover"];
    
    AccountViewController *accountView = [storyboard instantiateViewControllerWithIdentifier:@"account"];
    accountView.view.backgroundColor = [UIColor whiteColor];
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
    APPDELEGATE.tabBarC.selectedItemTitleColor = [UIColor purpleColor];
    APPDELEGATE.tabBarC.viewControllers        = @[navC1, navC2, navC3, navC4, navC5];
    // self.window.rootViewController = tabBarC;
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:NO];
    
}


#pragma mark: UIButton Action Method
- (IBAction)requestBtnClicked:(id)sender {
}

- (IBAction)reserveHerBrnClicked:(id)sender {
}

- (IBAction)requestToEndButton:(UIButton *)sender {

  
}

- (IBAction)requestToEndDateAction:(UIButton *)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:@"End Date" message:@"Are you sure you want to send request to end date?"
                                 andButtonsWithTitle:@[@"Yes",@"No"] onController:self
                                       dismissedWith:^(NSInteger index, NSString *buttonTitle)
     {
         if ([buttonTitle isEqualToString:@"Yes"]) {
             
             NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIRequestToEndDateByCustomer,userIdStr,self.dateIdStr];
             NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             
             [ProgressHUD show:@"Please wait..." Interaction:NO];
             [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
                 NSLog(@"response object Get UserInfo List %@",responseObject);
                 [ProgressHUD dismiss];
                 if(!error){
                     if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
                     {
                  
                     [[AlertView sharedManager] presentAlertWithTitle:@"Request Sent" message:@"Your request has been sent."
                                                  andButtonsWithTitle:@[@"OK"] onController:self
                                                        dismissedWith:^(NSInteger index, NSString *buttonTitle)
                      
                      {
                          sharedInstance.requestEndDateButton = @"1";
                          [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"requestToEndDateValue"];
                          [[NSUserDefaults standardUserDefaults] synchronize];
                          if ([sharedInstance.requestEndDateButton isEqualToString:@"1"]) {
                              [requestToEndDate setEnabled:NO];
                              [requestToEndDate setBackgroundColor:[UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1.0]];
                          }
                          else{
                              [requestToEndDate setEnabled:YES];
                              [requestToEndDate setBackgroundColor:[UIColor colorWithRed:129.0/255.0 green:90.0/255.0 blue:145.0/255.0 alpha:1.0]];

                              
                          }
                      }];
                 }
             }
             }];
     }
         
     }];
  
}

- (IBAction)profileImageClicked:(id)sender {
    
    if ([sharedInstance.imagePopupCondition  isEqualToString: @"no"]) {
        _slideImageViewController = [PEARImageSlideViewController new];
        NSArray *imageLists = @[
                                [UIImage imageNamed:@"banner_img1.png"],
                                [UIImage imageNamed:@"banner_img1.png"],
                                [UIImage imageNamed:@"banner_img1.png"],
                                [UIImage imageNamed:@"banner_img1.png"],
                                [UIImage imageNamed:@"banner_img1.png"]
                                ].copy;
        [_slideImageViewController setImageLists:imageLists];
        [_slideImageViewController showAtIndex:0];
        sharedInstance.imagePopupCondition = @"yes";
    }
}

- (IBAction)doumeePriceButtonClicked:(id)sender {
    [self doumeePricePopupButtonPushed];
}

- (IBAction)settingsButtonClicked:(id)sender {
    
    UIButton *btn =(UIButton *)sender;
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"Alert"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(alertItem:)],
      [KxMenuItem menuItem:@"Report"
                     image:nil
                    target:self
                    action:@selector(reportItem:)],
      
      ];
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor whiteColor];
    first.alignment = NSTextAlignmentCenter;
    [KxMenu showMenuInView:self.view
                  fromRect:btn.frame
                 menuItems:menuItems];
}


- (void)alertItem:(id)sender {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@",APIAddContractorInAlertList,userIdStr,self.contractorIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        else {
            NSLog(@"Error");
        }
    }];
}

- (void)reportItem:(id)sender {
    
    NSLog(@"%@", sender);
    DateReportSubmitViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateReportSubmit"];
    dateReportView.self.requestType = @"ProfileReport";
    dateReportView.self.contractorIdStr = self.contractorIdStr;
    dateReportView.self.dateIdStr = _dateIdStr;
    [self.navigationController pushViewController:dateReportView animated:YES];
}

- (IBAction)dateInformationAction:(id)sender {
    
    profileView.hidden = YES;
    dateInforamtionView.hidden = NO;
    dateBottomlineView.hidden = NO;
    profileBottomlineView.hidden = YES;
}

- (IBAction)profileAction:(id)sender {
    
    profileView.hidden = NO;
    dateInforamtionView.hidden = YES;
    dateBottomlineView.hidden = YES;
    profileBottomlineView.hidden = NO;
}


#pragma mark Add Favourite Mark
- (IBAction)favouriteClicked:(id)sender {
    
    if(favourite) {
        
        NSString *urlstr=[NSString stringWithFormat:@"%@?userIDTO=%@&userIDFrom=%@",APIDeleteFavouriteUser,self.contractorIdStr,userIdStr];
        NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    favouriteImageView.image = [UIImage imageNamed:@"heart_light"];
                    favourite = FALSE;
                }
                else {
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
        
    } else {
        
        NSString *urlstr=[NSString stringWithFormat:@"%@?userIDTO=%@&userIDFrom=%@",APIAddFavouriteUser,self.contractorIdStr,userIdStr];
        NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    favouriteImageView.image = [UIImage imageNamed:@"heart"];
                    favourite = TRUE;
                }
                else {
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
    }
}


#pragma mark Product Weight Price Popup

-(void)productWeightPricePopupButtonPushed {
    
    secondProductReportPopup = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    secondProductReportPopup.backgroundColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:0.8];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height/2-20, self.view.frame.size.width-100, 100)];
    
    //  UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, self.view.frame.size.width-100, 100)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 5, contentView.frame.size.width-2, 94)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    
    UILabel *titleTextLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 10, whiteView.frame.size.width, 25) andTitle:@"Settings" andTextColor:[UIColor darkGrayColor]];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [contentView addSubview:titleTextLabel];
    
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+12, whiteView.frame.size.width, .5)];
    firstLineView.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:firstLineView];
    
    UILabel *priceLabel = [CommonUtils createLabelWithRect:CGRectMake(0, firstLineView.frame.origin.y+firstLineView.frame.size.height+5, whiteView.frame.size.width, 30) andTitle:@"Report" andTextColor:[UIColor darkGrayColor]];
    priceLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    //  [contentView addSubview:priceLabel];
    
    UIButton *blockButton = [CommonUtils createButtonWithRect:CGRectMake(20, firstLineView.frame.origin.y+firstLineView.frame.size.height+8, whiteView.frame.size.width-40, 30) andText:@"Block" andTextColor:[UIColor whiteColor] andFontSize:@"" andImgName:@""];
    [blockButton addTarget:self action:@selector(blockMethodCall) forControlEvents:UIControlEventTouchUpInside];
    [blockButton setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:1.0]];
    blockButton.layer.cornerRadius = 3.0;
    [contentView addSubview:blockButton];
    [secondProductReportPopup addSubview:contentView];
    [self.view addSubview : secondProductReportPopup];
    
    UILabel *minimumHourPriceLabel = [CommonUtils createLabelWithRect:CGRectMake(0, priceLabel.frame.origin.y+priceLabel.frame.size.height, whiteView.frame.size.width, 30) andTitle:@"Issue" andTextColor:[UIColor darkGrayColor]];
    minimumHourPriceLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    minimumHourPriceLabel.textAlignment = NSTextAlignmentCenter;
    // [contentView addSubview:minimumHourPriceLabel];
    contentView.hidden = NO;
    contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration : 0.3/1.5 animations:^{
        contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.3/2 animations:^{
             contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
         }
                          completion:^(BOOL finished) {
                              [UIView animateWithDuration:0.3/2 animations:^{
                                  contentView.transform = CGAffineTransformIdentity;
                              }];
                          }];
     }];
    // [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    
}

-(void)blockMethodCall {
    
    /*
     
     // http://ondemandapi.flexsin.in/API/Account/BlockUser?userIDTO=Cu00ff662&userIDFrom=Cu00e2618
     
     //  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
     
     self.dateIdStr = @"Date7";
     
     NSString *urlstr=[NSString stringWithFormat:@"%@?userIDTO=%@&userIDFrom=%@",APIAddBlcokUser,customerIdStr,userIdStr];
     
     [ProgressHUD show:@"Please wait..." Interaction:NO];
     [ServerRequest AFNetworkPostRequestUrl:urlstr withParams:nil CallBack:^(id responseObject, NSError *error) {
     NSLog(@"response object Get UserInfo List %@",responseObject);
     [ProgressHUD dismiss];
     if(!error){
     
     NSLog(@"Response is --%@",responseObject);
     if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
     
     [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
     [self.navigationController popViewControllerAnimated:YES];
     
     } else {
     [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
     }
     }
     }];
     */
    
}

-(void)cancelButtonPushed{
    [secondProductReportPopup removeFromSuperview];
    [[KGModal sharedInstance] hideAnimated:YES];
}

#pragma Mark: Api Methode Call
-(void)sendRequestEndDateApi
{
//http://doumeesApi.flexsin.in/API/Customer/RequestToEndDate?userID=Cr0018e7f&DateID=Date202775
//    Success Response
//    {
//        "$id": "1",
//        "StatusCode": 1,
//        "Message": "Your request has been sent."
//    }
//    
//    
//    If date not started and customer hit this api.
//    {
//        "$id": "1",
//        "StatusCode": 0,
//        "Message": "This date not started. You can send request while date will start."
//    }
}
- (void)dateDetailsApiCall {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userType=%@&DateID=%@&DateType=%@",APIGetDateDetails,@"1",self.dateIdStr,self.dateTypeStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                dataDictionary = [responseObject mutableCopy];
                titleNameLabel.text = @"DATE DETAILS";
                self.contractorIdStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"result"]objectForKey:@"ContractorID"]];
                buttonStatus = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"result"]objectForKey:@"ButtonStatus"]];
                customerNameLabel.text =  [[dataDictionary objectForKey:@"result"]objectForKey:@"UserName"];
                customerNameLabel.numberOfLines = 0;
                customerNameLabel.lineBreakMode =NSLineBreakByWordWrapping;
                [customerNameLabel sizeToFit];
                if ([[[dataDictionary objectForKey:@"result"]objectForKey:@"HourlyRate"] length]) {
                    hourlyRateStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"result"]objectForKey:@"HourlyRate"]];
                }
                if ([[[dataDictionary objectForKey:@"result"]objectForKey:@"MinimumHours"] length]) {
                    minimumHourStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"result"]objectForKey:@"MinimumHours"]];
                }
                if ([[[dataDictionary objectForKey:@"result"]objectForKey:@"IsOnline"] length]) {
                    isOnlineStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"result"]objectForKey:@"IsOnline"]];
                }
                if ([[[dataDictionary objectForKey:@"result"]objectForKey:@"PaymentMethod"] length]) {
                    paymentMethodStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"result"]objectForKey:@"PaymentMethod"]];
                }
                if ([[[dataDictionary objectForKey:@"result"]objectForKey:@"RateAfterMinimumHour"] length]) {
                    rateAfterMinimumHourStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"result"]objectForKey:@"RateAfterMinimumHour"]];
                }
                if (![[[dataDictionary objectForKey:@"result"]objectForKey:@"ContractorType"]isKindOfClass:[NSNull class]]) {
                    [contractorTypeButton setTitle:[[dataDictionary objectForKey:@"result"]objectForKey:@"ContractorType"] forState:UIControlStateNormal];
                }
                buttonStatus =[NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"result"]objectForKey:@"ButtonStatus"]];
                int imgProductRatingWidth = customerNameLabel.frame.origin.x+customerNameLabel.frame.size.width+5;
                favourite = [[[dataDictionary objectForKey:@"result"]objectForKey:@"isFavourite"] boolValue];
                
                if (favourite) {
                    
                    favouriteImageView.image = [UIImage imageNamed:@"heart"];
                } else {
                    
                    favouriteImageView.image = [UIImage imageNamed:@"heart_light"];
                }
                
                bodySizeLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[[dataDictionary objectForKey:@"result"]objectForKey:@"Ethencity"],[[dataDictionary objectForKey:@"result"]objectForKey:@"Age"],[[dataDictionary objectForKey:@"result"]objectForKey:@"Height"]];
                favouriteImageView.frame = CGRectMake(imgProductRatingWidth, 5, 24, 22);
                favouriteButton.frame = CGRectMake(imgProductRatingWidth, 5, 40, 40);
                
                
                if ([[[dataDictionary objectForKey:@"result"]objectForKey:@"MeetLocationLat"] length]) {
                    sharedInstance.meetUpLatitude = [[dataDictionary objectForKey:@"result"]objectForKey:@"MeetLocationLat"];
                    sharedInstance.meetUpLongitude = [[dataDictionary objectForKey:@"result"]objectForKey:@"MeetLocationLong"];
                }
                
                NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"result"]objectForKey:@"ReservationTime"]];
                NSArray *arrayOfTime = [reserveTimeStr componentsSeparatedByString:@"."];
                NSString *reservationTime = [arrayOfTime objectAtIndex:0];
                NSString *reserveDate = [CommonUtils convertUTCTimeToLocalTime:reservationTime WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                NSString *dateStatusStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"result"]objectForKey:@"EventTime"]];
                NSArray *nameStr = [dateStatusStr componentsSeparatedByString:@"."];
                NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                NSLog(@"%@",fileKey);
                NSString *dateStatusDate = [CommonUtils convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                dateTimeLabel.text = [CommonUtils changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                NSString *estimatedTime =[NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"result"] objectForKey:@"EstimatedArrivalTime"]];
                NSArray *arrayOfestimatedTime = [estimatedTime componentsSeparatedByString:@"."];
                NSString *estimatedString = [arrayOfestimatedTime objectAtIndex:0];
                NSString *estimatedTimeArrival = [CommonUtils convertUTCTimeToLocalTime:estimatedString WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                NSString *estimatedTimeArrivalValue = [NSString stringWithFormat:@"ETA %@",[CommonUtils changeDateINString:estimatedTimeArrival WithFormate:@"yyyy-MM-dd HH:mm:ss"]];
                NSLog(@"Estimated Arrival Time %@",estimatedTimeArrivalValue);
                dateTimeLabel.text = [self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                dateStatusLabel.text = [NSString stringWithFormat:@"%@ @ %@",[[dataDictionary objectForKey:@"result"]objectForKey:@"Event"],[self changeDateINString:dateStatusDate WithFormate:@"yyyy-MM-dd HH:mm:ss"]];
                
                sharedInstance.dateStatusValue =[[dataDictionary objectForKey:@"result"]objectForKey:@"Event"];
                
                [self setMessageButtonEnableANdDisable];
//                         locationLabel.text =  [[[[dataDictionary objectForKey:@"result"]objectForKey:@"Location"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                addressLabel.text = [[[[dataDictionary objectForKey:@"result"]objectForKey:@"Location"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                
                [addressLabel adjustsFontSizeToFitWidth];
                addressLabel.minimumScaleFactor = 12;
                addressLabel.numberOfLines = 0;
                addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
                addressLabel.textAlignment = NSTextAlignmentLeft;
                [addressLabel sizeToFit];
                
                sharedInstance.addressValueWhileCancelTheDate = [[dataDictionary objectForKey:@"result"]objectForKey:@"Location"];
                notesLabel.text = [[dataDictionary objectForKey:@"result"]objectForKey:@"Notes"];
                
                NSString *photoVerifiedCheck = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"UserVerifiedItem"]objectForKey:@"PhotoStatus"]];
                NSString *idVerifiedCheck = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"UserVerifiedItem"]objectForKey:@"DocumentStatus"]];
                NSString *backgroundVerifiedCheck = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"UserVerifiedItem"]objectForKey:@"BackGroundStatus"]];
                
                if ([photoVerifiedCheck isEqualToString:@"1"]) {
                    photoVerified
                    .image = [UIImage imageNamed:@"verified.png"];
                    [photoVerificationLabel setTextColor:[UIColor colorWithRed:109.0/255.0 green:162.0/255.0 blue:79.0/255.0 alpha:1.0]];
                } else {
                    
                    photoVerified.image = [UIImage imageNamed:@"not_verified.png"];
                    [photoVerificationLabel setTextColor:[UIColor darkGrayColor]];
                }
                if ([notesLabel.text isEqualToString:@""] ){
                    notesLabel.hidden = YES;
                    notesImageView.hidden = YES;
//                    [notesLabel setFrame:CGRectMake(notesLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+8, notesLabel.frame.size.width, notesLabel.frame.size.height)];
//                    [notesImageView setFrame:CGRectMake(notesImageView.frame.origin.x+12, notesLabel.frame.origin.y+5, 15, 15)];
                    [dateStatusLabel setFrame:CGRectMake(dateStatusLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+8, dateStatusLabel.frame.size.width, dateStatusLabel.frame.size.height)];
                    [eventImageView setFrame:CGRectMake(eventImageView.frame.origin.x, dateStatusLabel.frame.origin.y, eventImageView.frame.size.width, eventImageView.frame.size.height)];
                }
                else
                {
                    notesLabel.hidden = NO;
                    notesImageView.hidden = NO;
                    [notesLabel setFrame:CGRectMake(notesLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+8, notesLabel.frame.size.width, notesLabel.frame.size.height)];
                    [notesImageView setFrame:CGRectMake(notesImageView.frame.origin.x+12, notesLabel.frame.origin.y+5, 15, 15)];
                    [eventImageView setFrame:CGRectMake(eventImageView.frame.origin.x, dateStatusLabel.frame.origin.y, eventImageView.frame.size.width, eventImageView.frame.size.height)];
                    [dateStatusLabel setFrame:CGRectMake(dateStatusLabel.frame.origin.x, notesLabel.frame.origin.y+notesLabel.frame.size.height+5, dateStatusLabel.frame.size.width, dateStatusLabel.frame.size.height)];
                }
               
                
                if (WIN_WIDTH == 320) {
                    [_etaView setFrame:CGRectMake(_etaView.frame.origin.x, dateStatusLabel.frame.origin.y+dateStatusLabel.frame.size.height+8, _etaView.frame.size.width, _etaView.frame.size.height)];
                      [requestToEndDate setFrame:CGRectMake(requestToEndDate.frame.origin.x, dateStatusLabel.frame.origin.y+dateStatusLabel.frame.size.height+25, requestToEndDate.frame.size.width, requestToEndDate.frame.size.height)];
                }
                else{
                    [_etaView setFrame:CGRectMake(_etaView.frame.origin.x, dateStatusLabel.frame.origin.y+dateStatusLabel.frame.size.height+8, _etaView.frame.size.width, _etaView.frame.size.height)];
                      [requestToEndDate setFrame:CGRectMake(requestToEndDate.frame.origin.x, dateStatusLabel.frame.origin.y+dateStatusLabel.frame.size.height+25, requestToEndDate.frame.size.width, requestToEndDate.frame.size.height)];
                }
                

                
                if ([idVerifiedCheck isEqualToString:@"1"]) {
                    
                    idVerified.image = [UIImage imageNamed:@"verified.png"];
                    [idVerificationLabel setTextColor:[UIColor colorWithRed:109.0/255.0 green:162.0/255.0 blue:79.0/255.0 alpha:1.0]];
                    
                }
                else {
                    idVerified.image = [UIImage imageNamed:@"not_verified.png"];
                    [idVerificationLabel setTextColor:[UIColor darkGrayColor]];
                }
                
                if ([backgroundVerifiedCheck isEqualToString:@"1"]) {
                    
                    backgroundVerified.image = [UIImage imageNamed:@"verified.png"];
                    [backgroundVerificationLabel setTextColor:[UIColor colorWithRed:109.0/255.0 green:162.0/255.0 blue:79.0/255.0 alpha:1.0]];
                }
                else {
                    
                    backgroundVerified.image = [UIImage imageNamed:@"not_verified.png"];
                    [backgroundVerificationLabel setTextColor:[UIColor darkGrayColor]];
                }
                
                NSMutableArray *getImageArray;
                imageArray = [[NSMutableArray alloc]init];
                getImageArray = [[NSMutableArray alloc]init];
                NSString *checkPrimaryStr = @"";
                if([[dataDictionary objectForKey:@"UserPicture"] isKindOfClass:[NSArray class] ]) {
                    NSArray *imageDataArray = [dataDictionary objectForKey:@"UserPicture"];
                    
                    for(NSDictionary *imagedataDictionary in imageDataArray) {
                        NSString *checkPrimaryImage = [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"isPrimary"]];
                        if ([checkPrimaryImage isEqualToString:@"1"]) {
                            checkPrimaryStr = @"yes";
                            setPrimaryUrlStr =  [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"PicUrl"]];
                        }
                        
                        NSString *imageUrlStr = [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"PicUrl"]];
                        if (imageUrlStr.length) {
                            [imageArray addObject:imageUrlStr];
                        }
                    }
                    
                    if ([checkPrimaryStr isEqualToString:@""]) {
                        if (imageArray.count) {
                            setPrimaryUrlStr =  [NSString stringWithFormat:@"%@",[imageArray objectAtIndex:0]];
                        }
                    }
                }
                
                [self googleDistanceTimeApiCall];
                [imageCollectionView reloadData];
                
            } else {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

-(NSString *)changeDateINString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"hh:mm aaa"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
    
}

-(void)setMessageButtonEnableANdDisable{
    if ([sharedInstance.dateStatusValue isEqualToString:@"Pending"]) {
        //dateStatusLabel.text = @"Pending";
        messageButton.backgroundColor = [UIColor colorWithRed:152.0/255.0 green:152.0/255.0  blue:152.0/255.0  alpha:1.0];
        messageButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    else if ([self.dateTypeStr isEqualToString:@"3"]) {
        messageButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:78.0/255.0  blue:139.0/255.0  alpha:1.0];
        messageButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelDateButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    }
    
    else if ([self.dateTypeStr isEqualToString:@"7"]) {
        
        messageButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:78.0/255.0  blue:139.0/255.0  alpha:1.0];
        messageButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelDateButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    }
    
    else if ([self.dateTypeStr isEqualToString:@"8"]) {
        
        messageButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:78.0/255.0  blue:139.0/255.0  alpha:1.0];
        messageButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelDateButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        cancelDateButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:78.0/255.0  blue:139.0/255.0  alpha:1.0];
        cancelDateButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cancelDateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    else  {
        
        messageButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:78.0/255.0  blue:139.0/255.0  alpha:1.0];
        messageButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelDateButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        cancelDateButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:78.0/255.0  blue:139.0/255.0  alpha:1.0];
        cancelDateButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cancelDateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if ([buttonStatus isEqualToString:@"0"]) {
        [_etaView setHidden:YES];
        [requestToEndDate setHidden:YES];
         [self viewDidLayoutSubviews];
    }
    else if ([buttonStatus isEqualToString:@"1"]){
        [_etaView setHidden:YES];
        [requestToEndDate setHidden:YES];
        [self viewDidLayoutSubviews];
    }
    else if ([buttonStatus isEqualToString:@"2"] || [self.dateTypeStr isEqualToString:@"16"]){
        [_etaView setHidden:NO];
        [requestToEndDate setHidden:YES];
        [self viewDidLayoutSubviews];
    }
    else if ([buttonStatus isEqualToString:@"3"]){
        [_etaView setHidden:YES];
        [requestToEndDate setHidden:YES];
        [self viewDidLayoutSubviews];
    }
    else if ([buttonStatus isEqualToString:@"4"]){
        [_etaView setHidden:YES];
        [requestToEndDate setHidden:NO];

        [self viewDidLayoutSubviews];
    }
    else{
        [_etaView setHidden:YES];
        [requestToEndDate setHidden:YES];
        [self viewDidLayoutSubviews];
    }
}

-(NSString *)changeDateInParticularFormateWithString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MMMM d, YYYY @ hh:mm aaa"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
    
}

- (void)doumeePricePopupButtonPushed {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, self.view.frame.size.width-100, 155)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 5, contentView.frame.size.width-2, 149)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    
    UILabel *titleTextLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 15, whiteView.frame.size.width, 14) andTitle:@"Doumee Rate Card" andTextColor:[UIColor darkGrayColor]];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [contentView addSubview:titleTextLabel];
    
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+12, whiteView.frame.size.width, .5)];
    firstLineView.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:firstLineView];
    
    UILabel *priceLabel = [CommonUtils createLabelWithRect:CGRectMake(0, firstLineView.frame.origin.y+firstLineView.frame.size.height+5, whiteView.frame.size.width, 30) andTitle:[NSString stringWithFormat:@"%@ / hour",[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",hourlyRateStr]]] andTextColor:[UIColor darkGrayColor]];
    priceLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:priceLabel];
    
    UILabel *minimumHourPriceLabel = [CommonUtils createLabelWithRect:CGRectMake(0, priceLabel.frame.origin.y+priceLabel.frame.size.height, whiteView.frame.size.width, 30) andTitle:[NSString stringWithFormat:@"%@ hour minimum",minimumHourStr] andTextColor:[UIColor darkGrayColor]];
    minimumHourPriceLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    minimumHourPriceLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:minimumHourPriceLabel];
    
    UILabel *timeLabel = [CommonUtils createLabelWithRect:CGRectMake(0, minimumHourPriceLabel.frame.origin.y+minimumHourPriceLabel.frame.size.height, whiteView.frame.size.width, 30) andTitle:[NSString stringWithFormat:@"%@ / Minute After",[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"$%@",rateAfterMinimumHourStr]]] andTextColor:[UIColor darkGrayColor]];
    timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:timeLabel];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    
}


-(void)googleDistanceTimeApiCall {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
        NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
        CLLocation *endLocation;
        if ([latitudeStr length]) {
            endLocation = [[CLLocation alloc] initWithLatitude:[latitudeStr doubleValue] longitude:[lonitudeStr doubleValue]];
        }
        else{
            endLocation = [[CLLocation alloc] initWithLatitude:[sharedInstance.latiValueStr doubleValue] longitude:[sharedInstance.longiValueStr doubleValue]];
            
        }
        // get CLLocation fot both addresses
        CLLocation *meetLocation = [[CLLocation alloc] initWithLatitude:[sharedInstance.meetUpLatitude doubleValue] longitude:[sharedInstance.meetUpLongitude doubleValue]];
        
        // calculate distance between them
        CLLocationDistance distance = [endLocation distanceFromLocation:meetLocation];
        NSLog(@"Distance %f",distance);
        NSLog(@"Calculated Miles %@", [NSString stringWithFormat:@"%.1fmi",(distance/1609.344)]);
        
//        NSString *webServiceUrl =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false",sharedInstance.currentAddressStr,addressLabel.text];
        
        NSString *encodedDestinationString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                                   NULL,
                                                                                                                   (CFStringRef)addressLabel.text,
                                                                                                                   NULL,
                                                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                                   kCFStringEncodingUTF8 ));
        NSString *encodedSourceString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                              NULL,
                                                                                                              (CFStringRef)sharedInstance.currentAddressStr,
                                                                                                              NULL,
                                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                              kCFStringEncodingUTF8 ));
        NSString *webServiceUrlforEncoded = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false",encodedSourceString,encodedDestinationString];
        NSLog(@"Encoded String %@",webServiceUrlforEncoded);
        //NSString *encodedUrl = [webServiceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        requestSerializer.timeoutInterval = 300;
        manager.requestSerializer = requestSerializer;
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"charset=utf-8", @"application/json", nil];
        manager.responseSerializer = responseSerializer;
        [manager GET:webServiceUrlforEncoded parameters:nil
         
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 NSLog(@"Google Distance time == %@",jsonData);
                 NSArray *routesArray = [jsonData objectForKey:@"routes"];
                 if (routesArray.count>0) {
                     NSArray *distanceTimeArray = [[routesArray objectAtIndex:0] objectForKey:@"legs"];
                     
                     totalDistanceStr = [[[distanceTimeArray objectAtIndex:0]objectForKey:@"distance"]objectForKey:@"text"];
                     double distanceInMeter = (([totalDistanceStr doubleValue]*1000));
                     totalDistanceStrInMeter = [NSString stringWithFormat:@"%.1f",(distanceInMeter/1609.344)];
                     totalTimeStr = [[[distanceTimeArray objectAtIndex:0]objectForKey:@"duration"]objectForKey:@"text"];
                     if (totalTimeStr.length) {
                         [self setDistanceTimeLabel];
                     }
                 }
                 else {
                     totalDistanceStrInMeter  = @"0";
                     totalTimeStr  = @"0";
                 }
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"network error:%@",error);
                 
                 totalDistanceStrInMeter  = @"0";
                 totalTimeStr  = @"0";
             }];
    }
    else {
        [ServerRequest networkConnectionLost];
    }
}

-(void)setDistanceTimeLabel{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"HH:mm:ss aaa ";
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    dateFormatter2.dateFormat = @"MM/dd/yyyy";
    [dateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    // The Current Time is 12:48:26
    NSString *currentTimeStr =[NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:now]];
    NSString *currentDateTimeStr =[NSString stringWithFormat:@"%@",[dateFormatter2 stringFromDate:now]];
    NSArray *currentTimeArray = [currentTimeStr componentsSeparatedByCharactersInSet:
                                 [NSCharacterSet characterSetWithCharactersInString:@":"]
                                 ];
    NSString *currentHourStr = [currentTimeArray objectAtIndex:0];
    NSString *currentMinutesStr = [currentTimeArray objectAtIndex:1];
    NSString *currentSecondStr = [currentTimeArray objectAtIndex:2];
    NSArray *secondArrayWithAmValue = [currentSecondStr componentsSeparatedByString:@" "];
    NSString *currentSecondlastValue = [secondArrayWithAmValue firstObject];
    NSString *currentSecondAmValue = [secondArrayWithAmValue lastObject];
    NSLog(@"Value Of current Time %@",currentSecondAmValue);
    
    int currentHours = [currentHourStr intValue];
    int currentMints = [currentMinutesStr intValue];
    int currentSeconds = [currentSecondlastValue intValue];
    
    int currentHourSecond = currentHours * (60 * 60);
    int currentMinutesSecond = currentMints * 60;
    int currentTotalSecond = currentHourSecond + currentMinutesSecond + currentSeconds;
    NSLog(@"Value Of current Time %d",currentTotalSecond);
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    dateFormatter3.dateFormat = @"MM/dd/yyyy HH:mm:ss";
    NSDateFormatter *dateFormatter4 = [[NSDateFormatter alloc] init];
    dateFormatter4.dateFormat = @"hh:mm aaa";
    
    if ( [totalTimeStr rangeOfString:@"hour"].location != NSNotFound || [totalTimeStr rangeOfString:@"hours"].location != NSNotFound) {
        
        NSArray *estimatedTimeArray = [totalTimeStr componentsSeparatedByCharactersInSet:
                                       [NSCharacterSet characterSetWithCharactersInString:@" "]
                                       ];
        
        NSString *hourStr = [estimatedTimeArray objectAtIndex:0];
        NSString *minutesStr = [estimatedTimeArray objectAtIndex:2];
        
        int secondHours = [hourStr intValue];
        int secondMints = [minutesStr intValue];
        
        int num_seconds = secondHours * (60 * 60);
        int minutesSecond = secondMints * 60;
        int  totalSecond = num_seconds + minutesSecond;
        
        currentTotalSecond = currentTotalSecond +totalSecond;
        
        int minutes = (currentTotalSecond / 60) % 60;
        int hours = currentTotalSecond / 3600;
        
        int secondValue = 0;
        NSString *timeInAM = [NSString stringWithFormat:@"%@ %@",currentDateTimeStr,[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes,secondValue]];
        NSDate *currentDateWithTime = [dateFormatter3 dateFromString:timeInAM];
        NSString *stringValue = [dateFormatter4 stringFromDate:currentDateWithTime];
        NSLog(@"Date Value %@",stringValue);
        timeOfContractorLabel.text = stringValue;
        
    }
    else {
        
        NSArray *estimatedTimeArray = [totalTimeStr componentsSeparatedByCharactersInSet:
                                       [NSCharacterSet characterSetWithCharactersInString:@"  "]
                                       ];
        
        NSString *minutesStr = [estimatedTimeArray objectAtIndex:0];
        int secondMints = [minutesStr intValue];
        int minutesSecond = secondMints * 60;
        currentTotalSecond = currentTotalSecond +minutesSecond;
        int minutes = (currentTotalSecond / 60) % 60;
        int hours = currentTotalSecond / 3600;
        int secondValue = 0;
        NSString *timeInAM = [NSString stringWithFormat:@"%@ %@",currentDateTimeStr,[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes,secondValue]];
        NSDate *currentDateWithTime = [dateFormatter3 dateFromString:timeInAM];
        NSString *stringValue = [dateFormatter4 stringFromDate:currentDateWithTime];
        NSLog(@"Date Value %@",stringValue);
        timeOfContractorLabel.text = stringValue;
    }
    [distanceOfContractorLabel setText:[NSString stringWithFormat:@"%@ miles away",totalDistanceStrInMeter]];
}

-(NSString *)changeDateInParticularFormate :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"hh aaa"];
    NSString *dateRepresentation = [dateFormatter2 stringFromDate:formatedDate];
    return dateRepresentation;
}

@end
