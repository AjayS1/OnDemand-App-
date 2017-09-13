
//  OnDemandDatePushNotificationViewController.m
//  Contractor
//  Created by Jamshed Ali on 08/09/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "OnDemandDatePushNotificationViewController.h"
#import "OnDemandDateReasonForDeclineViewController.h"

#import "DateCancelViewController.h"
#import "PaymentDateCompletedViewController.h"
#import "OneToOneMessageViewController.h"

#import "DateReportSubmitViewController.h"
#import "NSUserDefaults+DemoSettings.h"

#import "PEARImageSlideViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "KGModal.h"
#import "CommonUtils.h"
#import "SingletonClass.h"
#import "ServerRequest.h"
#import "KGModal.h"
#import "KxMenu.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AppDelegate.h"
#import "AlertView.h"
#import "DatesViewController.h"
#import "NotificationsViewController.h"
#import "DashboardViewController.h"
#import "MessagesViewController.h"
#import "AccountViewController.h"
#import "DateDetailsViewController.h"
#import "CommonUtils.h"
#import <MessageUI/MessageUI.h>
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width


@interface OnDemandDatePushNotificationViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>{
    
    SingletonClass *sharedInstance;
    NSMutableArray *imageArray;
    NSDictionary *dataDictionary;
    UIView *dateBottomlineView;
    UIView *profileBottomlineView;
    UIView *requestDeclinedByContractorPopupView;
    NSString *customerIdStr;
    UITextField *distanceTextField;
    NSString *setPrimaryUrlStr;
    NSString *totalDistanceStr;
    NSString *totalDistanceStrInMeter;
    NSString *totalTimeStr;
    NSString *estimatedTimeArraivalStr;
    NSTimer *timer;
    NSString *dateCountStr;
    NSString *messageCountStr;
    NSString *notificationsCountStr;
    NSInteger counter;
    float latitudeValue;
    float longitudeValue;
    NSString *userIdStr;
    NSString *filePath;
    NSDateFormatter *dateFormatter;
    UIView  *estimatedTimeOfArrivalByContractorPopupView;
    BOOL checkTab;
    BOOL isAlreadyCheckTheCustomerCancelRequest;;
    BOOL checkTabSecond;
    BOOL checkLogFile;
    NSString *timerValue;
    
    NSString *stringToBeSent;
}

@property (nonatomic,retain)PEARImageSlideViewController * slideImageViewController;
@end

@implementation OnDemandDatePushNotificationViewController

@synthesize dateTypeStr,dateRequestTypeStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    checkTab = NO;
    checkTabSecond = NO;
  //  [self setNeedsStatusBarAppearanceUpdate];
    sharedInstance.isFromDateDetailsDateRequest = NO;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"view will appear method Call");
    [super viewWillAppear:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    NSLog(@"sharedInstance.onDemandPushNotificationArray On Demand Date Psu Notification View Did Load === %@",sharedInstance.onDemandPushNotificationArray);
    [self.tabBarController.tabBar setHidden:YES];
    if (sharedInstance.isFromDateDetailsDateRequest) {
        checkTabSecond = YES;
    }
    
    if (checkTab) {
        DashboardViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"dashboard"];
        [self.navigationController pushViewController:notiView animated:YES];
        return;
    }
    
    if (checkTabSecond) {
        
        for ( UINavigationController *controller in APPDELEGATE.tabBarC.viewControllers ) {
            NSLog(@"Controller %lu",(unsigned long)controller.childViewControllers.count);
            NSLog(@"Controller %@",[controller.childViewControllers objectAtIndex:0] );
            if ( [[controller.childViewControllers objectAtIndex:0] isKindOfClass:[DatesViewController class]] ) {
                self.tabBarController.selectedIndex = 1;
                checkTab = YES;
                [self.tabBarController setSelectedViewController:controller];
                break;
            }
        }
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dateRequestCancelByCustomer:)
                                                 name:@"dateRequestCancelByCustomer"
                                               object:nil];
    
    NSLog(@"Date Type %@",APPDELEGATE.requestTypeStr);
    dateFormatter = [[NSDateFormatter alloc]init];
    [self viewDataLoad];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"dateRequestCancelByCustomer"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    [timer invalidate];
    timer = nil;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
    timer = nil;
}

- (void)dateRequestCancelByCustomer:(NSNotification*) noti {
    
    isAlreadyCheckTheCustomerCancelRequest = TRUE;
    [timer invalidate];
    timer = nil;
    NSLog(@"sharedInstance.onDemandPushNotificationArray dateRequestCancelByCustomer=== %@",sharedInstance.onDemandPushNotificationArray);
    if (sharedInstance.onDemandPushNotificationArray.count) {
        if (sharedInstance.onDemandPushNotificationArray.count >1) {
            if (sharedInstance.onDemandPushNotificationArray.count) {
                [sharedInstance.onDemandPushNotificationArray removeObjectAtIndex:0];
            }
            [self viewDataLoad];
        }
        else
        {
            sharedInstance.checkPushNotificationOnDemandStr = @"No";
            if (sharedInstance.onDemandPushNotificationArray.count == 1) {
                [sharedInstance.onDemandPushNotificationArray removeAllObjects];
            }
            [self requestDeclinedByContractorPopup];
            // [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)tabBarCountApiCall {
    
    NSString *userIdStri = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStri,@"UserID",@"2" ,@"userType",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                    dateCountStr  = nil;
                }
                else {
                    dateCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Dates"];
                }
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Mesages"] isEqualToString:@"0"]) {
                    messageCountStr = nil;
                }
                else {
                    messageCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Mesages"];
                }
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Notifications"] isEqualToString:@"0"]) {
                    notificationsCountStr   = nil;
                }
                else {
                    notificationsCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Notifications"];
                }
            }
            else{
            }
        }
        else
        {
        }
        [self tabBarControllerClass];
    }];
}


- (void)tabBarControllerClass {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashboardViewController *dashBoardScreenView = [storyboard instantiateViewControllerWithIdentifier:@"dashboard"];
    dashBoardScreenView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    dashBoardScreenView.title = @"Dashboard";
    dashBoardScreenView.tabBarItem.image = [UIImage imageNamed:@"dashboard"];
    dashBoardScreenView.tabBarItem.selectedImage = [UIImage imageNamed:@"dashboard_hover"];
    
    DatesViewController *datesView = [storyboard instantiateViewControllerWithIdentifier:@"dates"];
    datesView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.isFromDateDetails = NO;
    datesView.title = @"Dates";
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor whiteColor];
    messageView.tabBarItem.badgeValue = messageCountStr;
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
    // accountView.view.backgroundColor = [UIColor whiteColor];
    accountView.title = @"Account";
    accountView.tabBarItem.image = [UIImage imageNamed:@"user"];
    accountView.tabBarItem.selectedImage = [UIImage imageNamed:@"user_hover"];
    
    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:dashBoardScreenView];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:datesView];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:messageView];
    UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:notiView];
    UINavigationController *navC5 = [[UINavigationController alloc] initWithRootViewController:accountView];
    
    /**************************************** Key Code ****************************************/
    
    APPDELEGATE.tabBarC    = [[LCTabBarController alloc] init];
    [APPDELEGATE tabBarC].selectedItemTitleColor = [UIColor purpleColor];
    [APPDELEGATE tabBarC].viewControllers        = @[navC1, navC2, navC3, navC4, navC5];
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:NO];
}


- (void)viewDataLoad {
    
    sharedInstance = [SingletonClass sharedInstance];
    sharedInstance.imagePopupCondition = @"no";
    sharedInstance.checkPushNotificationOnDemandStr = @"Yes";
    self.dateIdStr = [NSString stringWithFormat:@"%@",[[sharedInstance.onDemandPushNotificationArray lastObject] objectForKey:@"DateID"]];
    onDemandTimerLabel.hidden = NO;
    totalDistanceStr  = @"";
    totalTimeStr  = @"";
    estimatedTimeArraivalStr = @"";
    profileView.hidden = YES;
    dateInforamtionView.hidden = NO;
    
    if (WIN_WIDTH == 320) {
        [dateInfoButton setFrame:CGRectMake(dateInfoButton.frame.origin.x, dateInfoButton.frame.origin.y,  self.view.frame.size.width/2, dateInfoButton.frame.size.height)];
        
        dateBottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, dateInfoButton.frame.size.height+3.5, self.view.frame.size.width/2, 3)];
        dateBottomlineView.backgroundColor = [UIColor purpleColor];
        [dateInfoButton addSubview:dateBottomlineView];
        [profileButton setFrame:CGRectMake(dateInfoButton.frame.origin.x+dateInfoButton.frame.size.width+0, profileButton.frame.origin.y,  self.view.frame.size.width/2+20, profileButton.frame.size.height)];
        profileBottomlineView = [[UIView alloc] initWithFrame:CGRectMake(-10, profileButton.frame.size.height+3.5, profileButton.frame.size.width, 3)];
        profileBottomlineView.backgroundColor = [UIColor purpleColor];
        [profileButton addSubview:profileBottomlineView];
        
    }
    else{
        [dateInfoButton setFrame:CGRectMake(dateInfoButton.frame.origin.x, dateInfoButton.frame.origin.y,  self.view.frame.size.width/2, dateInfoButton.frame.size.height)];
        dateBottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, dateInfoButton.frame.size.height+3.5, dateInfoButton.frame.size.width, 3)];
        dateBottomlineView.backgroundColor = [UIColor purpleColor];
        [dateInfoButton addSubview:dateBottomlineView];
        [profileButton setFrame:CGRectMake(dateInfoButton.frame.origin.x+dateInfoButton.frame.size.width+0, profileButton.frame.origin.y,  self.view.frame.size.width/2+20, profileButton.frame.size.height)];
        profileBottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, profileButton.frame.size.height+3.5, profileButton.frame.size.width, 3)];
        profileBottomlineView.backgroundColor = [UIColor purpleColor];
        [profileButton addSubview:profileBottomlineView];
        
    }
    [seperatorView setFrame:CGRectMake(0, dateInfoButton.frame.size.height + dateInfoButton.frame.origin.y+6, self.view.frame.size.width, 1)];
    dateBottomlineView.hidden = NO;
    profileBottomlineView.hidden = YES;
    [self dateRequestReceviedApiCall];
    
    likeDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
    likeDetailsLbl.numberOfLines = 0;
    [likeDetailsLbl sizeToFit];
    datingTitleLbl.frame = CGRectMake(15, likeDetailsLbl.frame.origin.y+likeDetailsLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
    datingDetailsLbl.frame = CGRectMake(15, datingTitleLbl.frame.origin.y+datingTitleLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
    datingDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
    datingDetailsLbl.numberOfLines = 0;
    [datingDetailsLbl sizeToFit];
    
    // imageCountLabel.layer.cornerRadius = 5;
    availaibleLabel.layer.cornerRadius = 5;
    if ( [self.dateRequestTypeStr isEqualToString:@"1"]) {
        
        dateTitleLabel.text = @"ON DEMAND REQUEST";
        backButton.hidden = YES;
    }
    confirmButton.hidden = YES;
    startDateButton.hidden = YES;
    endDateButton.hidden = YES;
    [declineOrRejectBuuton setTitle:@"DECLINE" forState:UIControlStateNormal];
    [acceptOrMessageButton setTitle:@"ACCEPT" forState:UIControlStateNormal];
}


- (void)viewDidLayoutSubviews {
    self.bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 800);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([imageArray count]) {
        return [imageArray count];
        
    }
    else
    {
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
    
    if (imageArray.count)
    {
        [imageCountView setHidden:NO];
        [imageCountLbl setHidden:NO];
        UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:500];
        NSString *imageUrlStr = [imageArray objectAtIndex:indexPath.row];
        NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
        [recipeImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [cell.backgroundView addSubview:recipeImageView];
        NSString *countStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        NSString *imageCountStr = [NSString stringWithFormat:@"%ld",(unsigned long)imageArray.count];
        imageCountLbl.text = [NSString stringWithFormat:@"%@/%@",countStr,imageCountStr];
        [recipeImageView setFrame:CGRectMake(0, 19, self.view.frame.size.width, 245)];
        imageCountLbl.text = [NSString stringWithFormat:@"%@/%@",countStr,imageCountStr];
        imageCountView.backgroundColor = [UIColor blackColor];
        imageCountView.layer.cornerRadius = 4;
        imageCountView.alpha =  0.5;
        imageCountView.layer.masksToBounds = YES;
        [cell addSubview:imageCountView];
    }
    else
    {
        [imageCountView setHidden:YES];
        [imageCountLbl setHidden:YES];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([sharedInstance.imagePopupCondition  isEqualToString: @"no"]) {
        _slideImageViewController = [PEARImageSlideViewController new];
        [_slideImageViewController setImageLists:[imageArray mutableCopy]];
        [_slideImageViewController showAtIndex:0];
        sharedInstance.imagePopupCondition = @"yes";
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, collectionView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClicked:(id)sender {
    
    if ([self.dateTypeStr isEqualToString:@"1"]) {
        [timer invalidate];
    }
    [self.navigationController popViewControllerAnimated:YES];
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


- (IBAction)settingsButtonClicked:(id)sender {
    UIButton *btn =(UIButton *)sender;
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"Block User"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(blockItem:)],
      
      [KxMenuItem menuItem:@"Report User"
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


- (void)blockItem:(id)sender {
    
    //  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    
    
    NSString *userIdString = sharedInstance.userId;
    NSString *urlstr=[NSString stringWithFormat:@"%@?userIDTO=%@&userIDFrom=%@",APIAddBlcokUser,customerIdStr,userIdString];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
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
}

- (void)reportItem:(id)sender {
    
    NSLog(@"%@", sender);
    
    DateReportSubmitViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateReportSubmit"];
    dateReportView.self.requestType = @"OnDemandProfileReport";
    dateReportView.self.customerIdStr = customerIdStr;
    dateReportView.self.dateIdStr = self.dateIdStr;
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
    [self.bgScrollView addSubview:profileView];
    float  sizeOfContent = 0;
    UIView *lLast = [self.bgScrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    sizeOfContent = wd+ht;
    self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.frame.size.width, sizeOfContent+180);
}


- (void)cancelButtonPushed {
    
    [[KGModal sharedInstance] hideAnimated:YES];
}

- (void)dateRequestReceviedApiCall {
    
    NSString *userIdString = sharedInstance.userId;
    NSLog(@"sharedInstance.onDemandPushNotificationArray in On Demand Push Notification Controller--%@",sharedInstance.onDemandPushNotificationArray);
    NSString *urlstr=[NSString stringWithFormat:@"%@?LoginID=%@&DateID=%@",APIDateRequestDetails,userIdString,self.dateIdStr];
    //    NSString *urlstr=[NSString stringWithFormat:@"%@?userType=%@&DateID=%@&DateType=%@",APIGetDateDetails,@"1",@"Date11330",@"3"];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            [[AlertView sharedManager] presentAlertWithTitle:@"Sorry!" message:@"An error occured while fetching the date details."
                                         andButtonsWithTitle:@[@"Ok"] onController:self
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                   if ([buttonTitle isEqualToString:@"Ok"]) {
                                                       [self tabBarCountApiCall];
                                                   }
                                               }];
        }
        else
        {
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
             
                    dataDictionary = [responseObject objectForKey:@"result"];
                    //DateID
                    self.dateIdStr = [NSString stringWithFormat:@"%@",[dataDictionary objectForKey:@"DateID"]];
                    NSArray *imageDataArray = [dataDictionary objectForKey:@"ContractorPictureList"];
                    customerNameLabel.text =  [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"UserName"];
                    int imgProductRatingWidth = customerNameLabel.frame.origin.x+customerNameLabel.frame.size.width+5;
                    bodySizeLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Ethnicity"],[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"AGE"],[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Height"]];
                    favouriteImageView.frame = CGRectMake(imgProductRatingWidth, 5, 24, 22);
                    timerValue = [NSString stringWithFormat:@"%@",[dataDictionary objectForKey:@"ReqTimeOut"]];
                    if ((![timerValue isEqualToString:@""]) || (![timerValue isEqualToString:@"0"])) {
                           [self startCountdown:timerValue];
                    }
                 
                    distanceLabel.text =  [[[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"location"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bodyTypeLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"BodyType"];
                    weightLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Weight"];
                    hairLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"HairColor"];
                    eyeColorLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"EyeColor"];
                    smokingLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Smoking"];
                    drinkingLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Drinking"];
                    educationLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Education"];
                    if ([[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Language"] length]) {
                        NSString *languageValue = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Language"];
                        if ([languageValue length] > 0) {
                            languageValue = [languageValue substringToIndex:[languageValue length] - 1];
                        }
                        else {
                            //no characters to delete... attempting to do so will result in a crash
                        }
                        languageLabel.text = languageValue;
                    }

                   // languageLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Language"];
                    
                    if ([[dataDictionary objectForKey:@"MettUplocation"] isKindOfClass:[NSDictionary class]]) {
                        
                        //dateTimeLabel.text = [[dataDictionary objectForKey:@"MettUplocation"]objectForKey:@"RequestTime"];
                        
                        NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [[dataDictionary objectForKey:@"MettUplocation"]objectForKey:@"RequestTime"]];
                        NSArray *nameStr = [reserveTimeStr componentsSeparatedByString:@"."];
                        NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                        NSLog(@"%@",fileKey);
                        NSString *reserveDate = [self convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                        dateTimeLabel.text = [self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                        
                        if ([[[dataDictionary objectForKey:@"MettUplocation"]objectForKey:@"Location"] length]) {
                            addressLabel.text = [[dataDictionary objectForKey:@"MettUplocation"]objectForKey:@"Location"];
                            [addressLabel adjustsFontSizeToFitWidth];
                            addressLabel.minimumScaleFactor = 12;
                            addressLabel.numberOfLines = 0;
                            addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
                            addressLabel.textAlignment = NSTextAlignmentLeft;
                            [addressLabel sizeToFit];
                            //addressLabel.backgroundColor = [UIColor redColor];
                            NSLog(@"Address Label Height %f",addressLabel.frame.size.height);
                            [self getLatLongFromAddress:addressLabel.text];
                        }
                        
                        if ([[[dataDictionary objectForKey:@"ContractorProfile"] objectForKey:@"MeetLocationLat"] length]) {
                            sharedInstance.meetUpLatitude = [[dataDictionary objectForKey:@"ContractorProfile"] objectForKey:@"MeetLocationLat"];
                            sharedInstance.meetUpLongitude = [[dataDictionary objectForKey:@"ContractorProfile"] objectForKey:@"MeetLocationLong"];
                        }
                    }
                    dateTimeLabel.hidden = YES;
                    dateImageView.hidden = YES;
                   // addressLabel.frame = dateTimeLabel.frame;
                    addressLabel.frame = CGRectMake(dateTimeLabel.frame.origin.x, dateTimeLabel.frame.origin.y, addressLabel.frame.size.width, addressLabel.frame.size.height);

                    [locationImageView setFrame:CGRectMake(locationImageView.frame.origin.x, addressLabel.frame.origin.y-1, locationImageView.frame.size.width, locationImageView.frame.size.height)];
                    notesLabel.text = [[dataDictionary objectForKey:@"MettUplocation"]objectForKey:@"Notes"];
                    if ([notesLabel.text isEqualToString:@""]) {
                        notesLabel.text = @"";
                        notesImageView.hidden = YES;

                    }
                    else{
                        notesLabel.hidden = NO;
                        notesImageView.hidden = NO;
                        [notesLabel setFrame:CGRectMake(notesLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+6, notesLabel.frame.size.width, notesLabel.frame.size.height)];
                        [notesImageView setFrame:CGRectMake(notesImageView.frame.origin.x, notesLabel.frame.origin.y, notesImageView.frame.size.width, notesImageView.frame.size.height)];
                    }
              
                    NSString *photoVerifiedCheck = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorVerifiedItem"]objectForKey:@"PhotoStatus"]];
                    NSString *idVerifiedCheck = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorVerifiedItem"]objectForKey:@"DocumentStatus"]];
                    NSString *backgroundVerifiedCheck = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorVerifiedItem"]objectForKey:@"BackGroundStatus"]];
                    
                    customerIdStr = [NSString stringWithFormat:@"%@",[dataDictionary objectForKey:@"CustomerID"]];
                    
                    
                    if ([photoVerifiedCheck isEqualToString:@"1"]) {
                        
                        photoVerified.image = [UIImage imageNamed:@"verified.png"];
                        [photoVerificationLabel setTextColor:[UIColor colorWithRed:109.0/255.0 green:162.0/255.0 blue:79.0/255.0 alpha:1.0]];
                        
                        
                    } else {
                        
                        photoVerified.image = [UIImage imageNamed:@"not_verified.png"];
                        [photoVerificationLabel setTextColor:[UIColor darkGrayColor]];
                        
                    }
                    
                    if ([idVerifiedCheck isEqualToString:@"1"]) {
                        
                        idVerified.image = [UIImage imageNamed:@"verified.png"];
                        [idVerificationLabel setTextColor:[UIColor colorWithRed:109.0/255.0 green:162.0/255.0 blue:79.0/255.0 alpha:1.0]];
                        
                        
                    } else {
                        
                        idVerified.image = [UIImage imageNamed:@"not_verified.png"];
                        [idVerificationLabel setTextColor:[UIColor darkGrayColor]];
                        
                    }
                    
                    if ([backgroundVerifiedCheck isEqualToString:@"1"]) {
                        
                        backgroundVerified.image = [UIImage imageNamed:@"verified.png"];
                        [backgroundVerificationLabel setTextColor:[UIColor colorWithRed:109.0/255.0 green:162.0/255.0 blue:79.0/255.0 alpha:1.0]];
                        
                        
                    } else {
                        
                        backgroundVerified.image = [UIImage imageNamed:@"not_verified.png"];
                        [backgroundVerificationLabel setTextColor:[UIColor darkGrayColor]];
                        
                    }
                    
                    likeDetailsLbl.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Description"];
                    likeDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
                    likeDetailsLbl.numberOfLines = 0;
                    [likeDetailsLbl sizeToFit];
                    datingTitleLbl.frame = CGRectMake(15, likeDetailsLbl.frame.origin.y+likeDetailsLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
                    
                    datingDetailsLbl.frame = CGRectMake(15, datingTitleLbl.frame.origin.y+datingTitleLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
                    
                    
                    datingDetailsLbl.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"PrefrencesDescription"];
                    
                    datingDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
                    datingDetailsLbl.numberOfLines = 0;
                    [datingDetailsLbl sizeToFit];
                    
                    //imageCountLabel.layer.cornerRadius = 5;
                    availaibleLabel.layer.cornerRadius = 5;
                    
                    
                    NSMutableArray *getImageArray;
                    imageArray = [[NSMutableArray alloc]init];
                    getImageArray = [[NSMutableArray alloc]init];
                    NSString *checkPrimaryStr = @"";
                    if ([[dataDictionary objectForKey:@"ContractorPictureList"] isKindOfClass:[NSArray class]]) {
                        for(NSDictionary *imagedataDictionary in imageDataArray) {
                            NSString *checkPrimaryImage = [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"isPrimary"]];
                            if ([checkPrimaryImage isEqualToString:@"1"]) {
                                setPrimaryUrlStr =  [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"PicUrl"]];
                                [imageArray insertObject:setPrimaryUrlStr atIndex:0];
                            }
                            else
                            {
                                NSString *imageUrlStr = [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"PicUrl"]];
                                [imageArray addObject:imageUrlStr];
                            }
                        }
                    }
                    
                    if (!(imageArray.count)) {
                        
                        UIImageView *recipeImageView = (UIImageView *)[self.view viewWithTag:500];
                        [recipeImageView setImage:[UIImage imageNamed:@"placeholder.png"] ];
                    }
                    
                    [imageCollectionView reloadData];
                    onDemandTimerLabel.hidden = YES;
                    [self googleDistanceTimeApiCall];
                    onDemandTimerLabel.hidden = NO;
                }
                else {
                    
                    if ([[responseObject objectForKey:@"Message"] isKindOfClass:[NSDictionary class]]) {
                        
                        [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                    
                }
            }
            
        }
    }];
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

#pragma mark:- Change UTC time Current Local Time

- (NSString *) convertUTCTimeToLocalTime:(NSString *)dateString WithFormate:(NSString *)formate{
    
    //Log: dateString - 2016-03-08 06:00:00 // Time in UTC
    //dateFormatter = [[NSDateFormatter alloc] init];
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

//34.1239125,-118.1583092016

-(void)getLatLongFromAddress :(NSString *)address
{
    
    //NSArray *addresseArray = [address componentsSeparatedByString:@","];
    //    NSInteger lastSecondObject = addresseArray.count-2;
    //    NSString *addressToBeSearch = [NSString stringWithFormat:@"%@ %@",[addresseArray objectAtIndex:lastSecondObject],[addresseArray lastObject]];
    //  NSLog(@"Address Value %@",addressToBeSearch);
    if (!APPDELEGATE.geocoder) {
        
        APPDELEGATE.geocoder = [[CLGeocoder alloc] init];
    }
    
    [APPDELEGATE.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            NSLog(@"%@",locatedAt);
            
            NSString  *streetString = [CommonUtils checkStringForNULL:placemark.thoroughfare];
            NSLog(@"street %@",streetString);
            
            NSString  *    cityStr = [CommonUtils checkStringForNULL:placemark.locality];
            NSString  *   stateStr = [CommonUtils checkStringForNULL:placemark.administrativeArea];
            NSString  *countryStr = [CommonUtils checkStringForNULL:placemark.country];
            if (!countryStr.length) {
                countryStr = @"";
            }
            if (!cityStr.length) {
                cityStr = @"";
            }
            if (!stateStr.length) {
                stateStr = @"";
            }
            
            NSString  * zipCodeStr = [CommonUtils checkStringForNULL:placemark.postalCode];
            CLLocation *location = placemark.location;
            NSString *latitude=  [NSString stringWithFormat:@"%.6f", location.coordinate.latitude];
            NSString *longitude=[NSString stringWithFormat:@"%.6f",location.coordinate.longitude];
            if (!zipCodeStr.length) {
                zipCodeStr = @"";
            }
            
            sharedInstance.meetUpLatitude = latitude ;
            sharedInstance.meetUpLongitude = longitude ;
        }
    }];
}

- (IBAction)addressButtonClicked:(id)sender {
    
    NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
    NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([sharedInstance.meetUpLatitude doubleValue] ,[sharedInstance.meetUpLongitude doubleValue]);
    NSLog(@"Esstimate Value %f",coordinate.latitude);
    
    // 27.1767° N, 78.0081° E
    //create MKMapItem out of coordinates
    if ([sharedInstance.meetUpLatitude doubleValue]!=0) {
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",[latitudeStr doubleValue],[lonitudeStr doubleValue],[sharedInstance.meetUpLatitude doubleValue],[sharedInstance.meetUpLongitude doubleValue] ];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        
    }
    else
    {
        //using iOS 5 which has the Google Maps application
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",[latitudeStr doubleValue],[lonitudeStr doubleValue],[sharedInstance.meetUpLatitude doubleValue],[sharedInstance.meetUpLongitude doubleValue] ];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        
    }}


- (void)startCountdown:(NSString *)timerVale {
    
    if (timerVale != nil) {
        counter = [timerVale integerValue];
        counter = counter *60 ;
        timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(countdownTimer:)
                                               userInfo:nil
                                                repeats:YES];
    }
 }

- (void)countdownTimer:(NSTimer *)timer1 {
    
    counter--;
    NSLog(@"counter down show %ld ",(long)counter);
    int minutes = ((long)counter / 60) % 60;
    int seconds = (long)counter % 60;
    
    onDemandTimerLabel.text = [NSString stringWithFormat:@"%02d:%02d TIME LEFT",minutes,seconds];
    if (counter <= 0) {
        
        [timer1 invalidate];
        
        if (sharedInstance.onDemandPushNotificationArray.count >1) {
            [sharedInstance.onDemandPushNotificationArray removeObjectAtIndex:0];
            [self viewDataLoad];
            
        }
        else {
            
            [timer1 invalidate];
            sharedInstance.checkPushNotificationOnDemandStr = @"No";
            [sharedInstance.onDemandPushNotificationArray removeObjectAtIndex:0];
            if (checkLogFile) {
                checkLogFile = NO;
            }
            else{
                checkLogFile = NO;
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
    }
}


#pragma mark Decline Date Request Method Call
- (IBAction)declineDateRequestButtonClicked:(id)sender {
    [timer invalidate];
    if (sharedInstance.isFromCancelDateRequest)
    {
        [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:@"This request has expired."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle)
         {
             if ([buttonTitle isEqualToString:@"OK"]) {
                 [self tabBarCountApiCall];
                 sharedInstance.isFromCancelDateRequest = NO;
             }}];
    }
    else
    {
        [self callAPiForCancel];
    }
}


-(void)callAPiForCancel{
    
    //http://ondemandapinew.flexsin.in/API/Account/GetCancellationFee?UserID=Cr0036e78&DateID=Date31491
    NSString    * urlString = [NSString stringWithFormat:@"%@?userID=%@&DateID=%@&ReasonID=%@",APIDateDecline,userIdStr,self.dateIdStr,@"0"];
    NSString *encoded = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [timer invalidate];
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
//                    [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
//                                                 andButtonsWithTitle:@[@"OK"] onController:self
//                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle)
//                     {
//                         if ([buttonTitle isEqualToString:@"OK"]) {
                    
                             // DatesViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                             [self tabBarControllerClass];
//                         }
//            }];
                }
                
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}

#pragma mark Date Accept Button Clicked
- (IBAction)acceptDateRequestButtonClicked:(id)sender {
    if (sharedInstance.isFromCancelDateRequest)
    {
        [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:@"This request has expired."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle)
         {
             if ([buttonTitle isEqualToString:@"OK"]) {
                 [self tabBarCountApiCall];
                 sharedInstance.isFromCancelDateRequest = NO;
             }}];
    }
    else
    {
        //stringToBeSent = [stringToBeSent stringByAppendingString:[NSString stringWithFormat:@"\ncalculate total Time =%@",totalTimeStr]];
        if ([totalTimeStr isEqualToString:@"0"])
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:@"We could not find the distance between the date location and your location."
                                         andButtonsWithTitle:@[@"OK"] onController:self
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle)
             {
                 if ([buttonTitle isEqualToString:@"OK"]) {
                     checkLogFile = YES;
                     [self tabBarControllerClass];
                 }
             }];
        }
        else
        {
            [self estimatedTimeOfArrivalByContractorPopup];
            
        }
    }
}




- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:{
            NSLog(@"You sent the email.");
            [self tabBarCountApiCall];
        }
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)setTextValueWithString:(NSString *)fileStr
{
    NSError *error;
    NSString *stringToWrite = fileStr;
    filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"myfile.txt"];
    
    [stringToWrite writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
}
#pragma mark-- Calculte Distance Time by Google api between Customer and Contractor

- (void)googleDistanceTimeApiCall {
    
    //  http://maps.googleapis.com/maps/api/directions/json?origin=noida sector 63&destination=chandani chauck,delhi&sensor=false
    // 780 Huntington Cir,Pasadena,South,CA,United States,91106
    if([AFNetworkReachabilityManager sharedManager].reachable)
    {
        
        NSString *webServiceUrl =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false",sharedInstance.currentAddressStr,addressLabel.text];
        NSLog(@"Google Address Api Call web Service Url === %@",webServiceUrl);
        NSString*destinationString = addressLabel.text;
        NSString*sourceString = sharedInstance.currentAddressStr;
        if ([destinationString isKindOfClass:[NSString class]] || [destinationString length]) {
            if ([destinationString containsString:@"(null)"] || [destinationString containsString:@"null"]) {
                destinationString = [destinationString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                destinationString = [destinationString stringByReplacingOccurrencesOfString:@"null" withString:@""];
            }
        }
        
        if ([sourceString isKindOfClass:[NSString class]] || [sourceString length]) {
            if ([sourceString containsString:@"(null)"] || [sourceString containsString:@"null"]) {
                sourceString = [sourceString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                sourceString = [sourceString stringByReplacingOccurrencesOfString:@"null" withString:@""];
            }
        }
        
        NSString *encodedDestinationString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                                   NULL,
                                                                                                                   (CFStringRef)destinationString,
                                                                                                                   NULL,
                                                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                                   kCFStringEncodingUTF8 ));
        
        NSString *encodedSourceString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                              NULL,
                                                                                                              (CFStringRef)sourceString,
                                                                                                              NULL,
                                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                              kCFStringEncodingUTF8 ));
        NSString *webServiceUrlforEncoded = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false",encodedSourceString,encodedDestinationString];
        NSLog(@"Encoded String %@",webServiceUrlforEncoded);
        
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
                 //  NSLog(@"Google Distance time == %@",jsonData);
                 NSArray *routesArray = [jsonData objectForKey:@"routes"];
                 // [self setTextValueWithString:[routesArray objectAtIndex:0]];
                 
                 if (routesArray.count>0) {
                     NSArray *distanceTimeArray = [[routesArray objectAtIndex:0] objectForKey:@"legs"];
                     totalDistanceStr = [[[distanceTimeArray objectAtIndex:0]objectForKey:@"distance"]objectForKey:@"text"];
                     double distanceInMeter = (([totalDistanceStr doubleValue]*1000));
                     totalDistanceStrInMeter = [NSString stringWithFormat:@"%.1f",(distanceInMeter/1609.344)];
                     totalTimeStr = [[[distanceTimeArray objectAtIndex:0]objectForKey:@"duration"]objectForKey:@"text"];
                 }
                 
                 else
                 {
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

- (void)googleDistanceTimeApiCallHavingLalLongValue {
    
    //  http://maps.googleapis.com/maps/api/directions/json?origin=noida sector 63&destination=chandani chauck,delhi&sensor=false
    // 780 Huntington Cir,Pasadena,South,CA,United States,91106
    if([AFNetworkReachabilityManager sharedManager].reachable)
    {
        
        NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
        NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
        NSString *strUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=%@", [latitudeStr doubleValue],  [lonitudeStr doubleValue], [sharedInstance.meetUpLatitude doubleValue],  [sharedInstance.meetUpLongitude doubleValue], @"DRIVING"];
        NSURL *url = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        if(jsonData != nil)
        {
            NSError *error = nil;
            id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            NSMutableArray *arrDistance=[result objectForKey:@"routes"];
            if ([arrDistance count]==0) {
                NSLog(@"N.A.");
            }
            else{
                NSMutableArray *arrLeg=[[arrDistance objectAtIndex:0]objectForKey:@"legs"];
                NSMutableDictionary *dictleg=[arrLeg objectAtIndex:0];
                NSLog(@"%@",[NSString stringWithFormat:@"Estimated Time %@",[[dictleg   objectForKey:@"duration"] objectForKey:@"text"]]);
                totalTimeStr =[NSString stringWithFormat:@"Estimated Time %@",[[dictleg   objectForKey:@"duration"] objectForKey:@"text"]];
            }
        }
        else{
            NSLog(@"N.A.");
        }
    }
    else {
        [ServerRequest networkConnectionLost];
    }
}

#pragma mark Estimated time Of Arrival Popup

- (void)estimatedTimeOfArrivalByContractorPopup {
    
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"HH:mm:ss";
    [dateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    // The Current Time is 12:48:26
    NSString *currentTimeStr =[NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:now]];
    
    NSArray *currentTimeArray = [currentTimeStr componentsSeparatedByCharactersInSet:
                                 [NSCharacterSet characterSetWithCharactersInString:@":"]
                                 ];
    
    NSString *currentHourStr = [currentTimeArray objectAtIndex:0];
    NSString *currentMinutesStr = [currentTimeArray objectAtIndex:1];
    NSString *currentSecondStr = [currentTimeArray objectAtIndex:2];
    
    int currentHours = [currentHourStr intValue];
    int currentMints = [currentMinutesStr intValue];
    int currentSeconds = [currentSecondStr intValue];
    
    int currentHourSecond = currentHours * (60 * 60);
    int currentMinutesSecond = currentMints * 60;
    int currentTotalSecond = currentHourSecond + currentMinutesSecond + currentSeconds;
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
        estimatedTimeArraivalStr = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes,secondValue];
        
    }
    else
    {
        NSArray *estimatedTimeArray = [totalTimeStr componentsSeparatedByCharactersInSet:
                                       [NSCharacterSet characterSetWithCharactersInString:@" "]
                                       ];
        NSString *minutesStr = [estimatedTimeArray objectAtIndex:0];
        int secondMints = [minutesStr intValue];
        int minutesSecond = secondMints * 60;
        currentTotalSecond = currentTotalSecond +minutesSecond;
        int minutes = (currentTotalSecond / 60) % 60;
        int hours = currentTotalSecond / 3600;
        int secondValue = 0;
        estimatedTimeArraivalStr = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes,secondValue];
    }
    [self acceptDateRequestSubmitButtonClickedApiCallWithStr:estimatedTimeArraivalStr];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [estimatedTimeOfArrivalByContractorPopupView removeFromSuperview];
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [distanceTextField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.tag == 10) {
        
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            // BasicAlert(@"", @"This field accepts only numeric entries.");
            return NO;
        }
        else
        {
            NSString *text = textField.text;
            NSInteger length = text.length;
            BOOL shouldReplace = YES;
            
            if (![string isEqualToString:@""])
            {
                switch (length)
                {
                    case 2:
                        textField.text = [text stringByAppendingString:@":"];
                        break;
                        
                    default:
                        break;
                }
                if (length > 4)
                    shouldReplace = NO;
            }
            
            return shouldReplace;
        }
    }
    return YES;
}

#pragma mark Date Accept Api Method Call

- (void)acceptDateRequestSubmitButtonClickedApiCallWithStr:(NSString *)estimatedArrivalTime{
    
    [timer invalidate];
    [estimatedTimeOfArrivalByContractorPopupView removeFromSuperview];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat: @"MM/dd/yyyy"];
    NSDate *nowdate = [NSDate date];
    //    NSString *submitMeetingTime = [NSString stringWithFormat:@"%@ %@",[dateFormatter1 stringFromDate:nowdate],estimatedArrivalTime];
    
    NSString *submitMeetingTime = [self getUTCFormateDateWithString:[dateFormatter1 stringFromDate:nowdate] withSelectedSlotValue:estimatedArrivalTime];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat: @"yyyy-MM-dd hh:mm:ss"];
    NSDateFormatter *etaDateFormatter = [[NSDateFormatter alloc] init];
    [etaDateFormatter setDateFormat: @"HH:mm:ss"];
    NSDate *etaDate = [dateFormatter2 dateFromString:submitMeetingTime];
    NSString *strETATime = [dateFormatter2 stringFromDate:etaDate];
    NSDate *dateETA = [etaDateFormatter dateFromString:strETATime];
    NSString *ETATime = [etaDateFormatter stringFromDate:dateETA];
    NSLog(@"ETA Value %@",ETATime);
    if (submitMeetingTime == nil) {
        submitMeetingTime = @"";
    }
    NSString *userIdString = sharedInstance.userId;
    //http://ondemandapinew.flexsin.in/API/Contractor/AcceptDate?userID=Cu0055c6f1&DateID=Date31427&EstimatedTimeArrival=2016-12-30 16:53:00.000
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@&EstimatedTimeArrival=%@",APIDateAccept,userIdString,self.dateIdStr,submitMeetingTime];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                [estimatedTimeOfArrivalByContractorPopupView removeFromSuperview];
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    [timer invalidate];
                    //   [estimatedTimeOfArrivalByContractorPopupView removeFromSuperview];
                    if (sharedInstance.onDemandPushNotificationArray.count >1) {
                        [sharedInstance.onDemandPushNotificationArray removeObjectAtIndex:0];
                        [self viewDataLoad];
                        [self viewDateListMethodCall];
                    }
                    
                    else {
                        
                        sharedInstance.checkPushNotificationOnDemandStr = @"No";
                        [sharedInstance.onDemandPushNotificationArray removeObjectAtIndex:0];
                        [self viewDateListMethodCall];
                        
                    }
                    
                }
                else {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }];
}


-(NSString *)getUTCFormateDateWithString:(NSString *)localDate withSelectedSlotValue:(NSString *)selctedValue
{
    NSDateFormatter *dateFormateForTime = [[NSDateFormatter alloc] init];
    [dateFormateForTime setDateFormat:@"HH:mm:ss"];
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
    NSString *timeForString ;
    NSString *utcFromate;
    if ([CommonUtils checkTheFormateType]) {
        timeForString   = selctedValue;
        utcFromate = [NSString stringWithFormat:@"%@T%@",dateString,timeForString];
        
    }
    else{
        timeForString = [self  changeformate_string24hr:selctedValue];
        NSLog( @"Time Formate value in String %@",timeForString);
        utcFromate   = [NSString stringWithFormat:@"%@T%@:00",dateString,timeForString];
    }
    
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

-(NSString *)changeformate_string24hr:(NSString *)date
{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"HH:mm:ss"];
    NSDate* wakeTime = [df dateFromString:date];
    [df setDateFormat:@"HH:mm"];
    return [df stringFromDate:wakeTime];
}


- (void)viewDateListMethodCall {
    
    DateDetailsViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateDetail"];
    dateDetailsView.self.dateIdStr =  self.dateIdStr;
    dateDetailsView.self.dateTypeStr = @"16";
    dateDetailsView.isFromOnDemandRequest = TRUE;
    checkTabSecond = YES;
    checkTab = NO;
    [self.navigationController pushViewController:dateDetailsView animated:YES];
    
}

- (void)requestDeclinedByContractorPopup {
    
    [ProgressHUD dismiss];
    requestDeclinedByContractorPopupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    requestDeclinedByContractorPopupView.backgroundColor = [UIColor grayColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2-107, self.view.frame.size.width-40, 215)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0;
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 10, contentView.frame.size.width-2, 202)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    UILabel *titleTextLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 15, whiteView.frame.size.width, 18) andTitle:@"Date Canceled" andTextColor:[UIColor darkGrayColor]];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    [contentView addSubview:titleTextLabel];
    UILabel *contractorMessageLabel = [CommonUtils createLabelWithRect:CGRectMake(20, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+25, whiteView.frame.size.width-20, 30) andTitle:[NSString stringWithFormat:@"Date request has been canceled by customer."] andTextColor:[UIColor darkGrayColor]];
    contractorMessageLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    contractorMessageLabel.numberOfLines = 0;
    contractorMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contractorMessageLabel.textAlignment = NSTextAlignmentCenter;
    [contractorMessageLabel sizeToFit];
    [contentView addSubview:contractorMessageLabel];
    UIButton *cencelDateRequestButton = [CommonUtils createButtonWithRect:CGRectMake(20, contractorMessageLabel.frame.origin.y+contractorMessageLabel.frame.size.height+20, contentView.frame.size.width-40, 40) andText:@"CLOSE" andTextColor:[UIColor whiteColor] andFontSize:@"" andImgName:@""];
    [cencelDateRequestButton addTarget:self action:@selector(closeButtonPushed) forControlEvents:UIControlEventTouchUpInside];
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

- (void)closeButtonPushed {
    [requestDeclinedByContractorPopupView removeFromSuperview];
    [self tabBarCountApiCall];
}


@end
