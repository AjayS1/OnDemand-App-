
//  DateDetailsViewController.m
//  Customer
//  Created by Jamshed Ali on 10/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "DateDetailsViewController.h"
#import "DateCancelViewController.h"
#import "PaymentDateCompletedViewController.h"
#import "OneToOneMessageViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
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
#import "AppDelegate.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "RatingViewController.h"
#import "AlertView.h"
#import "DatesViewController.h"
#import "DashboardViewController.h"
#import "MessagesViewController.h"
#import "NotificationsViewController.h"
#import "AccountViewController.h"

#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@interface DateDetailsViewController ()<UITextFieldDelegate> {
    
    SingletonClass *sharedInstance;
    NSMutableArray *imageArray;
    NSDictionary *dataDictionary;
    UIView *dateBottomlineView;
    UIView *profileBottomlineView;
    NSString *customerIdStr;
    NSString *buttonStatus ;
    NSString *dateCountStr;
    NSString *messageCountStr;
    NSString *notificationsCountStr;
    UITextField *distanceTextField;
    NSString *setPrimaryUrlStr;
    NSString *totalDistanceStr;
    NSString *totalDistanceStrInMeter;
    // NSString  *bookTimeSlotDate;
    NSString *totalTimeStr;
    NSString *estimatedTimeArraivalStr;
    UIView *secondProductReportPopup;
    UIView *estimatedTimeArrivalView;
    NSTimer *timer;
    NSInteger counter;
    NSDateFormatter *dateFormatter;
    NSString *userIdStr;
    float latitudeValue;
    BOOL checkTab;
    BOOL checkTabSecond;
    float longitudeValue;
    NSDate *convertedReservationTime;
}

@property (nonatomic,retain)PEARImageSlideViewController * slideImageViewController;
@property (nonatomic,weak) UIImageView * detailsImageView;
@property (nonatomic,weak) IBOutlet UIButton  * addressButton;
@property (nonatomic,weak) IBOutlet MBSliderView  * leftSliderView;
@property (nonatomic,weak) IBOutlet UIView *seperatorView;
@end

@implementation DateDetailsViewController
@synthesize dateIdStr,dateTypeStr,dateRequestTypeStr;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [ontheWayButton setHidden:YES];
    [confirmButton setHidden:YES];
    [startDateButton setHidden:YES];
    [endDateButton setHidden:YES];
    
    // [notesLabel setFrame:CGRectMake(66, 103, 285, 21)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [ontheWayButton setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [confirmButton setHidden:YES];
    [startDateButton setHidden:YES];
    [endDateButton setHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    sharedInstance = [SingletonClass sharedInstance];

    if ([sharedInstance.requestTypeStr isEqualToString:@"1"]) {
        [dateImageView setImage:[UIImage imageNamed:@"lightning"]];
    }
    else{
        [dateImageView setImage:[UIImage imageNamed:@"calendar_Other"]];

    }
    sharedInstance.imagePopupCondition = @"no";
    
    userIdStr = sharedInstance.userId;
    dateFormatter = [[NSDateFormatter alloc]init];
    [self dateRequestReceviedApiCall];
    
    [self.tabBarController.tabBar setHidden:YES];
    onDemandTimerLabel.hidden = YES;
    self.bgScrollView.delegate =self;
    //    [self estimatedTimeOfArrivalByContractorPopup];
    if (sharedInstance.IsFromDateDetailsOnDemand) {
        DashboardViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"dashboard"];
        sharedInstance.IsFromDateDetailsOnDemand = NO;
        [self.navigationController pushViewController:notiView animated:NO];
        return;
    }
    
    totalDistanceStr  = @"";
    totalTimeStr  = @"";
    estimatedTimeArraivalStr = @"";
    //[_addressButton setBackgroundColor:[UIColor redColor]];
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
    //[dateInfoButton setBackgroundColor:[UIColor redColor]];
    [_seperatorView setFrame:CGRectMake(0, dateInfoButton.frame.size.height + dateInfoButton.frame.origin.y+6, self.view.frame.size.width, 1)];
    [dateInfoButton setBackgroundColor:[UIColor clearColor]];
    [profileButton setBackgroundColor:[UIColor clearColor]];

  
    [self.leftSliderView setDelegate:self]; // set the MBSliderView delegate
    [self.leftSliderView setBackgroundColor:[UIColor whiteColor]];
    
    dateBottomlineView.hidden = NO;
    profileBottomlineView.hidden = YES;
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    
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
    
    if ([self.dateTypeStr isEqualToString:@"1"] && [self.dateRequestTypeStr isEqualToString:@"1"]) {
        
        dateTitleLabel.text = @"ON DEMAND REQUEST";
        backButton.hidden = YES;
        [_detailsImageView setFrame:CGRectMake(0, 22, self.view.frame.size.width, 221)];
        
    } else if ([self.dateTypeStr isEqualToString:@"1"] && [self.dateRequestTypeStr isEqualToString:@"2"]) {
        
        dateTitleLabel.text = @"DATE DETAILS";
        [_detailsImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 243)];
        
    }
    else{
        dateTitleLabel.text = @"DATE DETAILS";
        [_detailsImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 243)];
        
    }
    [acceptOrMessageButton setTitle:@"MESSAGES" forState:UIControlStateNormal];
    
    if ([self.dateTypeStr isEqualToString:@"1"]) {
        [declineOrRejectBuuton setTitle:@"DECLINE" forState:UIControlStateNormal];
        [acceptOrMessageButton setTitle:@"ACCEPT" forState:UIControlStateNormal];
        
    }
    else if ([self.dateTypeStr isEqualToString:@"3"]) {
        
        
        [declineOrRejectBuuton setTitle:@"CANCEL" forState:UIControlStateNormal];
        [acceptOrMessageButton setTitle:@"MESSAGES" forState:UIControlStateNormal];
        
        
    }
    else if ([self.dateTypeStr isEqualToString:@"7"]) {
        
        
        [declineOrRejectBuuton setTitle:@"CANCEL" forState:UIControlStateNormal];
        
    }
    else if ([self.dateTypeStr isEqualToString:@"8"]) {
        
        
        [declineOrRejectBuuton setTitle:@"CANCEL" forState:UIControlStateNormal];
        
        
    }
    else  {
        [declineOrRejectBuuton setTitle:@"CANCEL" forState:UIControlStateNormal];
        
    }
    
    if (checkTab) {
        
        DashboardViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"dashboard"];
        checkTab = NO;
        [self.navigationController pushViewController:notiView animated:YES];
        return;
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
}


- (void)checkSignalRReqest:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    
    if ([requestTypeStr isEqualToString:@"1"]) {
        NSString *dateIdString = [responseObject objectForKey:@"dateId"];
        NSDictionary *dataDictionaryValue = @{@"DateID":dateIdString,@"Type":requestTypeStr};
        if (sharedInstance.onDemandPushNotificationArray.count) {
            [sharedInstance.onDemandPushNotificationArray removeAllObjects];
        }
        [sharedInstance.onDemandPushNotificationArray addObject:dataDictionaryValue];
        NSLog(@"sharedInstance.onDemandPushNotificationArray ==  %@",sharedInstance.onDemandPushNotificationArray);
        OnDemandDatePushNotificationViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"onDamndDatePushNotification"];
        [self.navigationController pushViewController:dateDetailsView animated:YES];
    }
    else {
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    
}

- (void)viewDraw {
    
    self.endDateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, endDateButton.frame.size.width
                                                               , 30)];
    self.endDateView.backgroundColor = [UIColor clearColor];
    [endDateButton addSubview: self.endDateView];
    self.startDateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, startDateButton.frame.size.width
                                                                 , 30)];
    self.startDateView.backgroundColor = [UIColor clearColor];
    
    [startDateButton addSubview:self.startDateView];
    self.confirmArrivedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, confirmButton.frame.size.width, 50)];
    self.confirmArrivedView.backgroundColor = [UIColor clearColor];
    [confirmButton addSubview:self.confirmArrivedView];
    
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(thirdBlackSlideToRightWithGestureRecognizer:)];
    swipeRightOrange.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.endDateView addGestureRecognizer:swipeRightOrange];
    UISwipeGestureRecognizer *swipeRightBlack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(secondBlackSlideToRightWithGestureRecognizer:)];
    swipeRightBlack.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.startDateView addGestureRecognizer:swipeRightBlack];
    UISwipeGestureRecognizer *swipeLeftGreen = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeLeftGreen.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.confirmArrivedView addGestureRecognizer:swipeLeftGreen];
    
}

- (void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer {
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIDateConfirmedArrived,userIdStr,self.dateIdStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [UIView animateWithDuration:0.7
                                 animations:^ {
                                     confirmButton.hidden = YES;
                                     startDateButton.hidden = NO;
                                     endDateButton.hidden = YES;
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     [UIView beginAnimations:nil context:nil];
                                     [UIView setAnimationDuration:5.3];
                                     confirmButton.hidden = YES;
                                     startDateButton.hidden = NO;
                                     endDateButton.hidden = YES;
                                     [UIView commitAnimations];
                                 }];
                [self dateRequestReceviedApiCallForAnotherPurpose];
                
            } else {
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}


- (void)secondBlackSlideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer {
    
    [[AlertView sharedManager] presentAlertWithTitle:@"Are you sure you want to start the date?" message:@"You cannot cancel the date after date starts."
                                 andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                       dismissedWith:^(NSInteger index, NSString *buttonTitle)
     {
         if ([buttonTitle isEqualToString:@"Yes"]) {
             
             NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIStartDate,userIdStr,self.dateIdStr];
             NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             [ProgressHUD show:@"Please wait..." Interaction:NO];
             [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
                 NSLog(@"response object Get UserInfo List %@",responseObject);
                 [ProgressHUD dismiss];
                 if(!error){
                     
                     NSLog(@"Response is --%@",responseObject);
                     if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                         confirmButton.hidden = YES;
                         startDateButton.hidden = YES;
                         endDateButton.hidden = NO;
                         [UIView animateWithDuration:0.7f
                                          animations:^ {
                                              CGRect frame = endDateButton.frame;
                                              frame.origin.x = (self.view.frame.size.width-endDateButton.frame.size.width)/2;
                                              endDateButton.frame = frame;
                                              endDateButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView beginAnimations:nil context:nil];
                                              [UIView setAnimationDuration:5.3];
                                              [UIView commitAnimations];
                                          }];
                         [self dateRequestReceviedApiCallForAnotherPurpose];
                         
                     } else {
                         [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                     }
                 }
             }];
         }
     }];
}


- (void)thirdBlackSlideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIEndDate,userIdStr,self.dateIdStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    // [UIView animateWithDuration:0.5 animations:^{
    [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                RatingViewController *rateViewCall = [self.storyboard instantiateViewControllerWithIdentifier:@"rating"];
                rateViewCall.isFromDateDetails = NO;
                
                rateViewCall.self.dateIdStr = dateIdStr;
                rateViewCall.self.nameStr = [[dataDictionary objectForKey:@"result"]objectForKey:@"UserName"];
                rateViewCall.self.imageUrlStr = setPrimaryUrlStr;
                // rateViewCall.self.dateCompletedTimeStr = [[dataDictionary objectForKey:@"result"]objectForKey:@"EndTime"];
                [self.navigationController pushViewController:rateViewCall animated:YES];
                //                PaymentDateCompletedViewController *paymentView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentDateCompleted"];
                //                paymentView.self.dateIdStr = dateIdStr;
                //                [self.navigationController pushViewController:paymentView animated:YES];
                
            } else {
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
    
    
    //}];
}


- (void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.endDateView.frame = CGRectOffset(self.endDateView.frame, -self.view.frame.size.width, 0.0);
        self.startDateView.frame = CGRectOffset(self.startDateView.frame, -self.view.frame.size.width, 0.0);
        // self.viewGreen.frame = CGRectOffset(self.viewGreen.frame, -(self.view.frame.size.width)*3, 0.0);
    }];
}

- (void)secondSlideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer {
    
    [UIView animateWithDuration:0.5 animations:^{
        //self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, -self.view.frame.size.width, 0.0);
        self.startDateView.frame = CGRectOffset(self.startDateView.frame, -self.view.frame.size.width, 0.0);
        self.confirmArrivedView.frame = CGRectOffset(self.confirmArrivedView.frame, -self.view.frame.size.width, 0.0);
    }];
}

-(void)viewDidLayoutSubviews
{
    self.bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+220);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([imageArray count]) {
        return [imageArray count];
    }
    else {
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
        UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
        NSString *imageUrlStr = [imageArray objectAtIndex:indexPath.row];
        //    NSString *imageData = [dict valueForKey:@"PicUrl"];
        NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
        [recipeImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [recipeImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, cell.frame.size.height)];
        [cell.backgroundView addSubview:recipeImageView];
        if ([self.dateTypeStr isEqualToString:@"1"] && [self.dateRequestTypeStr isEqualToString:@"1"]) {
        }
        else if ([self.dateTypeStr isEqualToString:@"1"] && [self.dateRequestTypeStr isEqualToString:@"2"]) {
            
        }
        NSString *countStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        NSString *imageCountStr = [NSString stringWithFormat:@"%ld",(unsigned long)imageArray.count];
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

- (void)setSlideViewWithImageCountData:(NSInteger)imageCount {
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

-(void)doumeePrice:(UIButton *)sender {
    [self productWeightPricePopupButtonPushed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClicked:(id)sender {
    
    if (_isFromOnDemandRequest)
    {
        DatesViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
        datesView.isFromDateDetails = YES;
        self.tabBarController.selectedIndex = 1;
        _isFromOnDemandRequest = NO;
        [self.navigationController pushViewController:datesView animated:NO];
    }
    
    else
    {
        if (sharedInstance.isFromCancelDateRequest)
        {
            [self tabBarCountApiCall];
            sharedInstance.isFromCancelDateRequest = NO;
        }
        else
        {
            if ([self.dateTypeStr isEqualToString:@"1"]) {
                [timer invalidate];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)tabBarCountApiCall {
    
    NSString *userIdString = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdString,@"UserID",@"2" ,@"userType",nil];
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
    
    // self.window.rootViewController = tabBarC;
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:NO];
    [APPDELEGATE.tabBarC setSelectedIndex:1];
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
    [self productWeightPricePopupButtonPushed];
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
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userIDTO=%@&userIDFrom=%@",APIAddBlcokUser,customerIdStr,userIdStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                             andButtonsWithTitle:@[@"OK"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle)
                 {
                     if ([buttonTitle isEqualToString:@"OK"]) {
                         [self.navigationController popViewControllerAnimated:YES];
                     }}];
            }
            else {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}


- (void)reportItem:(id)sender {
    
    NSLog(@"%@", sender);
    
    DateReportSubmitViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateReportSubmit"];
    dateReportView.self.requestType = @"ProfileReport";
    dateReportView.self.customerIdStr = customerIdStr;
    dateReportView.self.dateIdStr = self.dateIdStr;
    [self.navigationController pushViewController:dateReportView animated:YES];
}


- (IBAction)dateInformationAction:(id)sender {
    
    profileView.hidden = YES;
    dateInforamtionView.hidden = NO;
    dateBottomlineView.hidden = NO;
    profileBottomlineView.hidden = YES;
    profileBottomlineView.backgroundColor = [UIColor clearColor];
    dateBottomlineView.backgroundColor = [UIColor purpleColor];

    
}

- (IBAction)profileAction:(id)sender {
    
    profileView.hidden = NO;
    dateInforamtionView.hidden = YES;
    [dateBottomlineView setHidden:YES];
    dateBottomlineView.backgroundColor = [UIColor clearColor];
    profileBottomlineView.backgroundColor = [UIColor purpleColor];
    profileBottomlineView.hidden = NO;
    [self.bgScrollView addSubview:profileView];
    
    float  sizeOfContent = 0;
    UIView *lLast = [self.bgScrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    sizeOfContent = wd+ht;
    self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.frame.size.width, sizeOfContent+180);
    
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
    
    
    UILabel *minimumHourPriceLabel = [CommonUtils createLabelWithRect:CGRectMake(0, priceLabel.frame.origin.y+priceLabel.frame.size.height, whiteView.frame.size.width, 30) andTitle:@"Issue" andTextColor:[UIColor darkGrayColor]];
    minimumHourPriceLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    minimumHourPriceLabel.textAlignment = NSTextAlignmentCenter;
    // [contentView addSubview:minimumHourPriceLabel];
    [secondProductReportPopup addSubview:contentView];
    [self.view addSubview : secondProductReportPopup];
    contentView.hidden = NO;
    contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration : 0.3/1.5 animations:^{
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
    //  [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    
}

-(void)blockMethodCall {
    
    // /*
    
    // http://ondemandapi.flexsin.in/API/Account/BlockUser?userIDTO=Cu00ff662&userIDFrom=Cu00e2618
    
    NSString *userIdString = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    
    self.dateIdStr = @"Date7";
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userIDTO=%@&userIDFrom=%@",APIAddBlcokUser,customerIdStr,userIdString];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [secondProductReportPopup removeFromSuperview];
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                [secondProductReportPopup removeFromSuperview];
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
    [secondProductReportPopup removeFromSuperview];
    [[KGModal sharedInstance] hideAnimated:YES];
    //  */
    
}


- (void)cancelButtonPushed {
    [secondProductReportPopup removeFromSuperview];
    [[KGModal sharedInstance] hideAnimated:YES];
}

- (void)dateRequestReceviedApiCall {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userType=%@&DateID=%@&DateType=%@",APIGetDateDetails,@"2",self.dateIdStr,self.dateTypeStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
        }
        else
        {
            if(!error)
            {
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    dataDictionary = [responseObject objectForKey:@"result"];
                    NSArray *imageDataArray = [responseObject objectForKey:@"UserPicture"];
                    NSDictionary *userVerifiedItemDic = [responseObject objectForKey:@"UserVerifiedItem"];
                    
                    if ([[dataDictionary objectForKey:@"UserName"] length]) {
                        customerNameLabel.text =  [dataDictionary objectForKey:@"UserName"];
                        //                    customerNameLabel.numberOfLines = 0;
                        //                    customerNameLabel.lineBreakMode =NSLineBreakByWordWrapping;
                        //                    [customerNameLabel sizeToFit];
                    }
                    
                    int imgProductRatingWidth = customerNameLabel.frame.origin.x+customerNameLabel.frame.size.width+5;
                    if ([[dataDictionary objectForKey:@"Ethencity"] length]) {
                        bodySizeLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[dataDictionary objectForKey:@"Ethencity"],[dataDictionary objectForKey:@"Age"],[dataDictionary objectForKey:@"Height"]];
                    }
                   // CancellationFee
                    sharedInstance.cancellationFee = [dataDictionary objectForKey:@"CancallationFeeDefault"];
                    favouriteImageView.frame = CGRectMake(imgProductRatingWidth, 5, 24, 22);
                    [favouriteImageView setHidden:YES];
                    if ([[dataDictionary objectForKey:@"location"] length]) {
                        distanceLabel.text =  [dataDictionary objectForKey:@"location"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"BodyType"] length]) {
                        bodyTypeLabel.text = [dataDictionary objectForKey:@"BodyType"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"Weight"] length]) {
                        weightLabel.text = [dataDictionary objectForKey:@"Weight"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"HairColor"] length]) {
                        hairLabel.text = [dataDictionary objectForKey:@"HairColor"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"EyeColor"] length]) {
                        eyeColorLabel.text = [dataDictionary objectForKey:@"EyeColor"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"Smoking"] length]) {
                        smokingLabel.text = [dataDictionary objectForKey:@"Smoking"];
                    }
                    
                    if ([[dataDictionary objectForKey:@"Drinking"] length]) {
                        drinkingLabel.text = [dataDictionary objectForKey:@"Drinking"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"Education"] length]) {
                        educationLabel.text = [dataDictionary objectForKey:@"Education"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"Language"] length]) {
                        NSString *languageValue = [dataDictionary objectForKey:@"Language"];
                        if ([languageValue length] > 0) {
                            languageValue = [languageValue substringToIndex:[languageValue length] - 1];
                        }
                        else {
                            //no characters to delete... attempting to do so will result in a crash
                        }
                        languageLabel.text = languageValue;
                    }
                    
                    if ([[responseObject objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
                        
                        if ([[dataDictionary objectForKey:@"ReservationTime"] length]) {
                            [self.leftSliderView setHidden:NO];
                            NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"ReservationTime"]];
                            NSArray *arrayOfReservationTime = [reserveTimeStr componentsSeparatedByString:@"."];
                            NSString *deletedString = [arrayOfReservationTime objectAtIndex:0];
                            NSString *reserveDate = [self convertUTCTimeToLocalTime:deletedString WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                            NSString *dateStatusStr = [NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"EventTime"]];
                            NSArray *nameStr = [dateStatusStr componentsSeparatedByString:@"."];
                            NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                            NSLog(@"%@",fileKey);
                            NSString *dateStatusDate = [self convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                            NSString *estimatedTime =[NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"EstimatedArrivalTime"]];
                            NSArray *arrayOfestimatedTime = [estimatedTime componentsSeparatedByString:@"."];
                            NSString *estimatedString = [arrayOfestimatedTime objectAtIndex:0];
                            NSString *estimatedTimeArrival = [self convertUTCTimeToLocalTime:estimatedString WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                            NSString *estimatedTimeArrivalValue = [NSString stringWithFormat:@"ETA %@",[self changeDateINString:estimatedTimeArrival WithFormate:@"yyyy-MM-dd HH:mm:ss"]];
                            NSLog(@"Esstimate Value %@",estimatedTimeArrivalValue);

                            buttonStatus =[NSString stringWithFormat:@"%@",[dataDictionary objectForKey:@"ButtonStatus"]];
                            
                            if ([buttonStatus isEqualToString:@"0"]) {
                                dateTimeLabel.text = [self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                                // convertedReservationTime = [self changeDateInDateFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                            }
                            else
                            {
                                dateTimeLabel.text = [self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                                // convertedReservationTime = [self changeDateInDateFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                            }
                            
                            dateStatusLabel.text = [NSString stringWithFormat:@"%@ @ %@",[dataDictionary objectForKey:@"Event"],[self changeDateINString:dateStatusDate WithFormate:@"yyyy-MM-dd HH:mm:ss"]];
                            //dateTimeLabel.text = [dataDictionary objectForKey:@"ReservationTime"];
                        }
                        
                        if ([[dataDictionary objectForKey:@"Location"] length])
                        {
                            
                            addressLabel.text = [[[dataDictionary objectForKey:@"Location"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                            [addressLabel adjustsFontSizeToFitWidth];
                            addressLabel.minimumScaleFactor = 12;
                            addressLabel.numberOfLines = 0;
                            addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
                            addressLabel.textAlignment = NSTextAlignmentLeft;
                            [addressLabel sizeToFit];
                            
                            [self getLatLongFromAddress:addressLabel.text];
                        }
                        
                        if ([[dataDictionary objectForKey:@"MeetLocationLat"] length])
                        {
                            sharedInstance.meetUpLatitude = [dataDictionary objectForKey:@"MeetLocationLat"];
                            sharedInstance.meetUpLongitude = [dataDictionary objectForKey:@"MeetLocationLong"];
                        }
                        
                        if ([[dataDictionary objectForKey:@"Notes"] length])
                        {
                            notesLabel.text = [dataDictionary objectForKey:@"Notes"];
                        }
;
                        [locationImageView setFrame:CGRectMake(locationImageView.frame.origin.x, addressLabel.frame.origin.y-1, locationImageView.frame.size.width, locationImageView.frame.size.height)];
                        if ([notesLabel.text isEqualToString:@""]) {
                            
                            notesImageView.hidden = YES;
                            notesLabel.hidden = YES;
                            notesTitleLabel.frame = CGRectMake(15, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, self.view.frame.size.width-30, 25);
                            [dateStatusLabel setFrame:CGRectMake(dateStatusLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+6, dateStatusLabel.frame.size.width, dateStatusLabel.frame.size.height)];
                            [eventImageView setFrame:CGRectMake(eventImageView.frame.origin.x, dateStatusLabel.frame.origin.y, eventImageView.frame.size.width, eventImageView.frame.size.height)];
                            [seperatorLabel setFrame:CGRectMake(0, dateStatusLabel.frame.origin.y+dateStatusLabel.frame.size.height+10, self.view.frame.size.width, 1)];
                            [_leftSliderView setFrame:CGRectMake(_leftSliderView.frame.origin.x, seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+8, _leftSliderView.frame.size.width,  _leftSliderView.frame.size.height)];

                        }
                        else
                        {
                            notesImageView.hidden = NO;
                            notesLabel.hidden = NO;
                            notesTitleLabel.frame = CGRectMake(15, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, self.view.frame.size.width-30, 25);
                            [notesLabel setFrame:CGRectMake(notesLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+6, notesLabel.frame.size.width, notesLabel.frame.size.height)];
                            [dateStatusLabel setFrame:CGRectMake(addressLabel.frame.origin.x, notesLabel.frame.origin.y+notesLabel.frame.size.height+6, dateTimeLabel.frame.size.width, dateTimeLabel.frame.size.height)];
                            [notesImageView setFrame:CGRectMake(notesImageView.frame.origin.x, notesLabel.frame.origin.y, notesImageView.frame.size.width, notesImageView.frame.size.height)];
                            [dateStatusLabel setFrame:CGRectMake(dateStatusLabel.frame.origin.x, notesLabel.frame.origin.y+notesLabel.frame.size.height+5, dateStatusLabel.frame.size.width, dateStatusLabel.frame.size.height)];
                            [eventImageView setFrame:CGRectMake(eventImageView.frame.origin.x, dateStatusLabel.frame.origin.y, eventImageView.frame.size.width, eventImageView.frame.size.height)];
                            [seperatorLabel setFrame:CGRectMake(0, dateStatusLabel.frame.origin.y+dateStatusLabel.frame.size.height+10, self.view.frame.size.width, 1)];
                            [_leftSliderView setFrame:CGRectMake(_leftSliderView.frame.origin.x, seperatorLabel.frame.origin.y+seperatorLabel.frame.size.height+8, _leftSliderView.frame.size.width,  _leftSliderView.frame.size.height)];
                        }
                       
                        
                        
                        if ([self.dateRequestTypeStr isEqualToString:@"2"])
                        {
                        }
                    }
                    
                    if ([buttonStatus isEqualToString:@"1"])
                    {
                        [self.leftSliderView setBackgroundColor:[UIColor colorWithRed:16.0/255.0 green:115.0/255.0 blue:185.0/255.0 alpha:1.0]];
                        [self.leftSliderView setText:@"On the Way"];
                        [seperatorLabel setHidden:NO];
                    }
                    
                    else if ([buttonStatus isEqualToString:@"2"])
                    {
                        [self.leftSliderView setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:143.0/255.0 alpha:1.0]];
                        [self.leftSliderView setText:@"CONFIRM YOU'VE ARRIVED"];
                        [seperatorLabel setHidden:NO];
                        
                    }
                    
                    else if ([buttonStatus isEqualToString:@"3"])
                    {
                        
                        [self.leftSliderView setBackgroundColor:[UIColor colorWithRed:108.0/255.0 green:162.0/255.0 blue:78.0/255.0 alpha:1.0]];
                        [self.leftSliderView setText:@"START DATE"];
                        [seperatorLabel setHidden:NO];
                        
                        //                    [ontheWayButton setHidden:YES];
                        //                    [confirmButton setHidden:YES];
                        //                    [startDateButton setHidden:NO];
                        //                    [endDateButton setHidden:YES];
                    }
                    else if ([buttonStatus isEqualToString:@"4"])
                    {
                        [self.leftSliderView setBackgroundColor:[UIColor colorWithRed:191.0/255.0 green:41.0/255.0 blue:50.0/255.0 alpha:1.0]];
                        [self.leftSliderView setText:@"END DATE"];
                        
                        //                    [ontheWayButton setHidden:YES];
                        //                    [confirmButton setHidden:YES];
                        //                    [startDateButton setHidden:YES];
                        //                    [endDateButton setHidden:NO];
                    }
                    else if ([buttonStatus isEqualToString:@"0"])
                    {
                        [self.leftSliderView setHidden:YES];
                        [seperatorLabel setHidden:YES];
                        //[self.leftSliderView setText:@"On the Way"];
                        
                        //                    [ontheWayButton setHidden:YES];
                        //                    [confirmButton setHidden:YES];
                        //                    [startDateButton setHidden:YES];
                        //                    [endDateButton setHidden:YES];
                    }
                    
                    if ([userVerifiedItemDic count]) {
                        NSString *photoVerifiedCheck = [NSString stringWithFormat:@"%@",[userVerifiedItemDic valueForKey:@"PhotoStatus"]];
                        NSString *idVerifiedCheck = [NSString stringWithFormat:@"%@",[userVerifiedItemDic valueForKey:@"DocumentStatus"]];
                        NSString *backgroundVerifiedCheck = [NSString stringWithFormat:@"%@",[userVerifiedItemDic valueForKey:@"BackGroundStatus"]];
                        
                        customerIdStr = [NSString stringWithFormat:@"%@",[dataDictionary objectForKey:@"CustomerID"]];
                        if ([photoVerifiedCheck isEqualToString:@"1"]) {
                            
                            photoVerified.image = [UIImage imageNamed:@"verified.png"];
                            [photoVerificationLabel setTextColor:[UIColor colorWithRed:109.0/255.0 green:162.0/255.0 blue:79.0/255.0 alpha:1.0]];
                        }
                        else {
                            
                            photoVerified.image = [UIImage imageNamed:@"not_verified.png"];
                            [photoVerificationLabel setTextColor:[UIColor darkGrayColor]];
                            
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
                    }
                    
                    if ([[dataDictionary objectForKey:@"Description"] length]) {
                        likeDetailsLbl.text = [dataDictionary objectForKey:@"Description"];
                        likeDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
                        likeDetailsLbl.numberOfLines = 0;
                        [likeDetailsLbl sizeToFit];
                    }
                    
                    datingTitleLbl.frame = CGRectMake(15, likeDetailsLbl.frame.origin.y+likeDetailsLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
                    datingDetailsLbl.frame = CGRectMake(15, datingTitleLbl.frame.origin.y+datingTitleLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
                    
                    if ([[dataDictionary objectForKey:@"MyDatePreferences"] length]) {
                        datingDetailsLbl.text = [dataDictionary objectForKey:@"MyDatePreferences"];
                        datingDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
                        datingDetailsLbl.numberOfLines = 0;
                        [datingDetailsLbl sizeToFit];
                    }
                    
                    imageCountLabel.layer.cornerRadius = 5;
                    availaibleLabel.layer.cornerRadius = 5;
                    
                    NSMutableArray *getImageArray;
                    imageArray = [[NSMutableArray alloc]init];
                    getImageArray = [[NSMutableArray alloc]init];
                    NSString *checkPrimaryStr = @"";
                    
                    if ([[responseObject objectForKey:@"UserPicture"] isKindOfClass:[NSArray class]]) {
                        for(NSDictionary *imagedataDictionary in imageDataArray) {
                            NSString *checkPrimaryImage = [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"isPrimary"]];
                            if ([checkPrimaryImage isEqualToString:@"1"]) {
                                checkPrimaryStr = @"yes";
                                setPrimaryUrlStr =  [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"PicUrl"]];
                            }
                            
                            NSString *imageUrlStr = [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"PicUrl"]];
                            [imageArray addObject:imageUrlStr];
                            
                        }
                        if ([checkPrimaryStr isEqualToString:@""]) {
                            if (imageArray.count) {
                                setPrimaryUrlStr =  [NSString stringWithFormat:@"%@",[imageArray objectAtIndex:0]];
                            }
                        }
                    }
                    
                    if (!(imageArray.count)) {
                        UIImageView *recipeImageView = (UIImageView *)[self.view viewWithTag:100];
                        //    NSString *imageData = [dict valueForKey:@"PicUrl"];
                        [recipeImageView setImage:[UIImage imageNamed:@"placeholder.png"] ];
                    }
                    
                    [self googleDistanceTimeApiCall];
                    
                    [imageCollectionView reloadData];
                    onDemandTimerLabel.hidden = YES;
                    if ([self.dateTypeStr isEqualToString:@"1"] && [self.dateRequestTypeStr isEqualToString:@"1"]) {
                        [self googleDistanceTimeApiCall];
                        onDemandTimerLabel.hidden = NO;
                        [self startCountdown];
                    }
                    
                } else {
                    
                    if ([[responseObject objectForKey:@"Message"] isKindOfClass:[NSDictionary class]]) {
                        [self.leftSliderView setHidden:YES];
                        if ([[responseObject objectForKey:@"Message"] isKindOfClass:[NSNull class]]) {
                            [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"No data found." inController:self];
                        }
                        else{
                            [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                        }
                        
                    }
                }
            }
        }
    }];
}

#pragma Mark:- Date Details for Slider Button

- (void)dateRequestReceviedApiCallForAnotherPurpose{
    
    //http://ondemandapinew.flexsin.in/API/Account/GetDateDetail?userType=1&DateID=Date11330&DateType=3
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userType=%@&DateID=%@&DateType=%@",APIGetDateDetails,@"2",self.dateIdStr,self.dateTypeStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
        }
        else{
            if(!error)
            {
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    dataDictionary = [responseObject objectForKey:@"result"];
                    NSArray *imageDataArray = [responseObject objectForKey:@"UserPicture"];
                    NSDictionary *userVerifiedItemDic = [responseObject objectForKey:@"UserVerifiedItem"];
                    
                    if ([[dataDictionary objectForKey:@"UserName"] length]) {
                        customerNameLabel.text =  [dataDictionary objectForKey:@"UserName"];
                    }
                    
                    int imgProductRatingWidth = customerNameLabel.frame.origin.x+customerNameLabel.frame.size.width+5;
                    if ([[dataDictionary objectForKey:@"Ethencity"] length]) {
                        bodySizeLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[dataDictionary objectForKey:@"Ethencity"],[dataDictionary objectForKey:@"Age"],[dataDictionary objectForKey:@"Height"]];
                    }
                    
                    favouriteImageView.frame = CGRectMake(imgProductRatingWidth, 5, 24, 22);
                    [favouriteImageView setHidden:YES];
                    if ([[dataDictionary objectForKey:@"location"] length]) {
                        distanceLabel.text =  [dataDictionary objectForKey:@"location"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"BodyType"] length]) {
                        bodyTypeLabel.text = [dataDictionary objectForKey:@"BodyType"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"Weight"] length]) {
                        weightLabel.text = [dataDictionary objectForKey:@"Weight"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"HairColor"] length]) {
                        hairLabel.text = [dataDictionary objectForKey:@"HairColor"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"EyeColor"] length]) {
                        eyeColorLabel.text = [dataDictionary objectForKey:@"EyeColor"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"Smoking"] length]) {
                        smokingLabel.text = [dataDictionary objectForKey:@"Smoking"];
                    }
                    
                    if ([[dataDictionary objectForKey:@"Drinking"] length]) {
                        drinkingLabel.text = [dataDictionary objectForKey:@"Drinking"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"Education"] length]) {
                        educationLabel.text = [dataDictionary objectForKey:@"Education"];
                        
                    }
                    if ([[dataDictionary objectForKey:@"Language"] length]) {
                        NSString *languageValue = [dataDictionary objectForKey:@"Language"];
                        if ([languageValue length] > 0) {
                            languageValue = [languageValue substringToIndex:[languageValue length] - 1];
                        }
                        else {
                            //no characters to delete... attempting to do so will result in a crash
                        }
                        languageLabel.text = languageValue;
                    }
                    
                    buttonStatus =[NSString stringWithFormat:@"%@",[dataDictionary objectForKey:@"ButtonStatus"]];
                    if ([buttonStatus isEqualToString:@"4"]){
                        [declineOrRejectBuuton setTitle:@"CANCEL" forState:UIControlStateNormal];
                        declineOrRejectBuuton.layer.borderColor = [UIColor clearColor].CGColor;
                        declineOrRejectBuuton.userInteractionEnabled = YES;
                        [declineOrRejectBuuton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        declineOrRejectBuuton.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:144.0/255.0 alpha:1.0];
                    }
                    else {
                        [declineOrRejectBuuton setTitle:@"CANCEL" forState:UIControlStateNormal];
                        declineOrRejectBuuton.layer.borderColor = [UIColor clearColor].CGColor;
                        declineOrRejectBuuton.userInteractionEnabled = YES;
                        [declineOrRejectBuuton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        declineOrRejectBuuton.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:144.0/255.0 alpha:1.0];
                    }
                    
                    if ([[responseObject objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
                        
                        if ([[dataDictionary objectForKey:@"ReservationTime"] length]) {
                            
                            NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"ReservationTime"]];
                            NSArray *arrayOfReservationTime = [reserveTimeStr componentsSeparatedByString:@"."];
                            NSString *deletedString = [arrayOfReservationTime objectAtIndex:0];
                            NSString *reserveDate = [self convertUTCTimeToLocalTime:deletedString WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                            
                            NSString *dateStatusStr = [NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"EventTime"]];
                            NSArray *nameStr = [dateStatusStr componentsSeparatedByString:@"."];
                            NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                            NSLog(@"%@",fileKey);
                            NSString *dateStatusDate = [self convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                            
                            
                            NSString *estimatedTime =[NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"EstimatedArrivalTime"]];
                            NSArray *arrayOfestimatedTime = [estimatedTime componentsSeparatedByString:@"."];
                            NSString *estimatedString = [arrayOfestimatedTime objectAtIndex:0];
                            NSString *estimatedTimeArrival = [self convertUTCTimeToLocalTime:estimatedString WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                            NSString *estimatedTimeArrivalValue = [NSString stringWithFormat:@"ETA %@",[self changeDateINString:estimatedTimeArrival WithFormate:@"yyyy-MM-dd HH:mm:ss"]];
                            NSLog(@"Esstimate Value %@",estimatedTimeArrivalValue);

                            if ([buttonStatus isEqualToString:@"0"]) {
                                dateTimeLabel.text = [self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                                
                            }
                            else{
                                dateTimeLabel.text = [self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                                
                            }
                            dateStatusLabel.text = [NSString stringWithFormat:@"%@ @ %@",[dataDictionary objectForKey:@"Event"],[self changeDateINString:dateStatusDate WithFormate:@"yyyy-MM-dd HH:mm:ss"]];
                            //dateTimeLabel.text = [dataDictionary objectForKey:@"ReservationTime"];
                            
                        }
                        if ([[dataDictionary objectForKey:@"Location"] length]) {
                            addressLabel.text = [dataDictionary objectForKey:@"Location"];
                            [self getLatLongFromAddress:addressLabel.text];
                        }
                        if ([[dataDictionary objectForKey:@"MeetLocationLat"] length]) {
                            sharedInstance.meetUpLatitude = [dataDictionary objectForKey:@"MeetLocationLat"];
                            sharedInstance.meetUpLongitude = [dataDictionary objectForKey:@"MeetLocationLong"];
                        }
                        [addressLabel adjustsFontSizeToFitWidth];
                        addressLabel.minimumScaleFactor = 12;
                        addressLabel.numberOfLines = 0;
                        addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        addressLabel.textAlignment = NSTextAlignmentLeft;
                        [addressLabel sizeToFit];
                        notesTitleLabel.frame = CGRectMake(15, addressLabel.frame.origin.y+addressLabel.frame.size.height+10, self.view.frame.size.width-30, 25);
                        [notesLabel setFrame:CGRectMake(addressLabel.frame.origin.x, addressLabel.frame.origin.y+addressLabel.frame.size.height+2, notesLabel.frame.size.width, notesLabel.frame.size.height)];
                        [dateStatusLabel setFrame:CGRectMake(addressLabel.frame.origin.x, notesLabel.frame.origin.y+notesLabel.frame.size.height+2, dateTimeLabel.frame.size.width, dateTimeLabel.frame.size.height)];
                        //                [_etaView setFrame:CGRectMake(_etaView.frame.origin.x, dateStatusLabel.frame.origin.y+dateStatusLabel.frame.size.height+20, _etaView.frame.size.width, _etaView.frame.size.height)];
                        
                        [notesImageView setFrame:CGRectMake(notesImageView.frame.origin.x, notesLabel.frame.origin.y+2, notesImageView.frame.size.width, notesImageView.frame.size.height)];
                        [eventImageView setFrame:CGRectMake(eventImageView.frame.origin.x, dateStatusLabel.frame.origin.y+2, eventImageView.frame.size.width, eventImageView.frame.size.height)];
                        
                        if ([[dataDictionary objectForKey:@"Notes"] length]) {
                            notesLabel.text = [dataDictionary objectForKey:@"Notes"];
                        }
                        notesLabel.numberOfLines = 0;
                        notesLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        notesLabel.textAlignment = NSTextAlignmentLeft;
                        [notesLabel sizeToFit];
                        
                    }
                    
                    
                    if ([userVerifiedItemDic count]) {
                        NSString *photoVerifiedCheck = [NSString stringWithFormat:@"%@",[userVerifiedItemDic valueForKey:@"PhotoStatus"]];
                        NSString *idVerifiedCheck = [NSString stringWithFormat:@"%@",[userVerifiedItemDic valueForKey:@"DocumentStatus"]];
                        NSString *backgroundVerifiedCheck = [NSString stringWithFormat:@"%@",[userVerifiedItemDic valueForKey:@"BackGroundStatus"]];
                        
                        customerIdStr = [NSString stringWithFormat:@"%@",[dataDictionary objectForKey:@"CustomerID"]];
                        
                        
                        if ([photoVerifiedCheck isEqualToString:@"1"]) {
                            
                            photoVerified.image = [UIImage imageNamed:@"verified.png"];
                            [photoVerificationLabel setTextColor:[UIColor colorWithRed:109.0/255.0 green:162.0/255.0 blue:79.0/255.0 alpha:1.0]];
                            
                            
                        }
                        else {
                            
                            photoVerified.image = [UIImage imageNamed:@"not_verified.png"];
                            [photoVerificationLabel setTextColor:[UIColor darkGrayColor]];
                            
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
                    }
                    
                    if ([[dataDictionary objectForKey:@"Description"] length]) {
                        likeDetailsLbl.text = [dataDictionary objectForKey:@"Description"];
                        likeDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
                        likeDetailsLbl.numberOfLines = 0;
                        [likeDetailsLbl sizeToFit];
                    }
                    
                    datingTitleLbl.frame = CGRectMake(15, likeDetailsLbl.frame.origin.y+likeDetailsLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
                    
                    datingDetailsLbl.frame = CGRectMake(15, datingTitleLbl.frame.origin.y+datingTitleLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
                    
                    if ([[dataDictionary objectForKey:@"MyDatePreferences"] length]) {
                        datingDetailsLbl.text = [dataDictionary objectForKey:@"MyDatePreferences"];
                        datingDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
                        datingDetailsLbl.numberOfLines = 0;
                        [datingDetailsLbl sizeToFit];
                    }
                    
                    imageCountLabel.layer.cornerRadius = 5;
                    availaibleLabel.layer.cornerRadius = 5;
                    
                    NSMutableArray *getImageArray;
                    imageArray = [[NSMutableArray alloc]init];
                    getImageArray = [[NSMutableArray alloc]init];
                    
                    NSString *checkPrimaryStr = @"";
                    
                    if ([[responseObject objectForKey:@"UserPicture"] isKindOfClass:[NSArray class]]) {
                        
                        for(NSDictionary *imagedataDictionary in imageDataArray) {
                            
                            NSString *checkPrimaryImage = [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"isPrimary"]];
                            
                            if ([checkPrimaryImage isEqualToString:@"1"]) {
                                
                                checkPrimaryStr = @"yes";
                                setPrimaryUrlStr =  [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"PicUrl"]];
                                NSString *imageUrlStr = [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"PicUrl"]];
                                [imageArray addObject:imageUrlStr];
                            }
                            
                            
                        }
                        if ([checkPrimaryStr isEqualToString:@""]) {
                            
                            setPrimaryUrlStr =  [NSString stringWithFormat:@"%@",[imageArray objectAtIndex:0]];
                        }
                    }
                    [self googleDistanceTimeApiCall];
                    
                    [imageCollectionView reloadData];
                    onDemandTimerLabel.hidden = YES;
                    if ([self.dateTypeStr isEqualToString:@"1"] && [self.dateRequestTypeStr isEqualToString:@"1"]) {
                        [self googleDistanceTimeApiCall];
                        onDemandTimerLabel.hidden = NO;
                        [self startCountdown];
                        
                    }
                    
                } else {
                    
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
//-(NSDate *)changeDateInDateFormateWithString :(NSString *)string WithFormate:(NSString *)formate{
//    NSDateFormatter *date = [[NSDateFormatter alloc]init];
//    [date setDateFormat:formate];
//    NSDate *formatedDate = [date dateFromString:string];
//    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//    [dateFormatter1 setDateFormat:@"MMMM d, YYYY @ hh:mm aaa"];
//    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
//    return formatedDate;
//}



-(NSString *)changeDateINString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"hh:mm aaa"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
    
}


- (void)startCountdown {
    
    counter = 120;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(countdownTimer:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)countdownTimer:(NSTimer *)timerValue {
    counter--;
    NSLog(@"counter down show %ld ",(long)counter);
    
    int minutes = ((long)counter / 60) % 60;
    int seconds = (long)counter % 60;
    onDemandTimerLabel.text = [NSString stringWithFormat:@"%02d:%02d TIME LEFT",minutes,seconds];
    
    if (counter <= 0) {
        
        [timerValue invalidate];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark:- Change UTC time Current Local Time

- (NSString *) convertUTCTimeToLocalTime:(NSString *)dateString WithFormate:(NSString *)formate{
    
    //Log: dateString - 2016-03-08 06:00:00 // Time in UTC
    //dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    
    NSTimeZone *gmtTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //Log: gmtTimeZone - GMT (GMT) offset 0
    
    [dateFormatter setTimeZone:gmtTimeZone];
    NSDate *  dateFromString = [dateFormatter dateFromString:dateString];
    //Log: dateFromString - 2016-03-08 06:00:00 +0000
    
    [NSTimeZone setDefaultTimeZone:[NSTimeZone systemTimeZone]];
    NSTimeZone * sourceTimeZone = [NSTimeZone defaultTimeZone];
    //Log: sourceTimeZone - America/New_York (EDT) offset -14400 (Daylight)
    
    // Add daylight time
    BOOL isDayLightSavingTime = [sourceTimeZone isDaylightSavingTimeForDate:dateFromString];
    NSLog(@"IsDayLightSavingValue %d",isDayLightSavingTime);
     [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:sourceTimeZone];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:dateFromString];
    //Log: dateRepresentation - 2016-03-08 01:00:00
    return dateRepresentation;
}

-(NSString *)setDateStatusWithDate:(NSString *)date
{
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter *dateFormatter3= [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter *dateFormatter4= [[NSDateFormatter alloc] init];
    [dateFormatter4 setDateFormat:@"EEEE"];
    // NSDate *formattedDate = [dateFormatter3 dateFromString:date];
    NSDate *dateConverted = [dateFormatter2 dateFromString:date];
    NSInteger dayDiff = (int)[dateConverted timeIntervalSinceNow] / (60*60*24);
    NSDateComponents *componentsToday = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *componentsDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateConverted];
    NSInteger day = [componentsToday day] - [componentsDate day];
    NSString *dateStatus;
    NSLog(@"Day %ld",(long)day);
    if (dayDiff == 0) {
        NSLog(@"Today");
        dateStatus = @"Today";
    } else if (dayDiff == -1) {
        NSLog(@"Yesterday");
        dateStatus = @"Yesterday";
        
    } else if(dayDiff > -7 && dayDiff < -1) {
        NSLog(@"This week");
        dateStatus = [dateFormatter4 stringFromDate:dateConverted];
    } else if(dayDiff > -14 && dayDiff <= -7) {
        dateStatus = [dateFormatter3 stringFromDate:dateConverted];
        NSLog(@"Last week");
    } else if(dayDiff >= -60 && dayDiff <= -30) {
        NSLog(@"Last month");
        dateStatus = [dateFormatter3 stringFromDate:dateConverted];
    } else {
        dateStatus = [dateFormatter3 stringFromDate:dateConverted];
        NSLog(@"A long time ago");
    }
    return dateStatus;
}


#pragma mark Decline Date / Cancel Date Request Method Call
- (IBAction)declineDateRequestButtonClicked:(id)sender {
//    [self callAPiForCancel];
    if ([buttonStatus isEqualToString:@"4"]) {
        [self callAPiForCancelDateAfterStart];
    }
    else{
        
        [timer invalidate];
        DateCancelViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateCancel"];
        dateReportView.self.dateIdStr = self.dateIdStr;
        dateReportView.self.dateDiclineOrDateCancelStr = @"Date Decline";
        dateReportView.self.titleStr = @"CANCEL DATE";
        dateReportView.buttonSattus = buttonStatus;
        dateReportView.dateTypeStr = self.dateTypeStr;
        if(self.isFromOnDemandRequest){
            sharedInstance.isFromMessageCancelDetails = TRUE;
        }
        else{
            sharedInstance.isFromMessageCancelDetails = FALSE;
        }
        [self.navigationController pushViewController:dateReportView animated:YES];

    }
}

-(void)callAPiForCancelDateAfterStart{
    
    //http://ondemandapiqa.flexsin.in/API/Contractor/DeclineDate?userID=Cu0055c6f1&DateID=Date31427&ReasonID=0
    //http://ondemandapinew.flexsin.in/API/Account/GetCancellationFee?UserID=Cr0036e78&DateID=Date31491
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIGetCancelFee,userIdStr,self.dateIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                sharedInstance.IsCancellationFeeAllowed = [responseObject objectForKey:@"ISCancelFeeAplied"];
                sharedInstance.cancellationFee = [responseObject objectForKey:@"CancellationnFee"];
                
                if ([self.dateTypeStr isEqualToString:@"1"]) {
                    [timer invalidate];
                    DateCancelViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateCancel"];
                    dateReportView.self.dateIdStr = self.dateIdStr;
                    dateReportView.self.dateDiclineOrDateCancelStr = @"Date Decline";
                    dateReportView.self.titleStr = @"CANCEL DATE";
                    dateReportView.buttonSattus = buttonStatus;
                    dateReportView.dateTypeStr = self.dateTypeStr;
                    if(self.isFromOnDemandRequest){
                        sharedInstance.isFromMessageCancelDetails = TRUE;
                    }
                    else{
                        sharedInstance.isFromMessageCancelDetails = FALSE;
                    }
                    [self.navigationController pushViewController:dateReportView animated:YES];
                }
                
                else
                {
                    
                    DateCancelViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateCancel"];
                    dateReportView.self.dateIdStr = self.dateIdStr;
                    dateReportView.self.dateDiclineOrDateCancelStr = @"Date Cancel";
                    dateReportView.self.titleStr =@"CANCEL DATE";
                    dateReportView.buttonSattus = buttonStatus;
                    dateReportView.dateTypeStr = self.dateTypeStr;
                    if(self.isFromOnDemandRequest)
                    {
                        sharedInstance.isFromMessageCancelDetails = TRUE;
                    }
                    else
                    {
                        sharedInstance.isFromMessageCancelDetails = FALSE;
                    }
                    [self.navigationController pushViewController:dateReportView animated:YES];
                }
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
    }];
}

#pragma mark Date Accept Button Clicked
- (IBAction)acceptDateRequestButtonClicked:(id)sender {
    
    if ([self.dateTypeStr isEqualToString:@"1"] && [self.dateRequestTypeStr isEqualToString:@"2"]) {
        //http://ondemandapinew.flexsin.in/API/Contractor/AcceptDate?userID=Cu0055c6f1&DateID=Date31427&EstimatedTimeArrival=2016-12-30
        //16:53:00.000
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@&EstimatedTimeArrival=%@",APIDateAccept,userIdStr,self.dateIdStr,@""];
        NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
    }
    else if ([self.dateTypeStr isEqualToString:@"1"] && [self.dateRequestTypeStr isEqualToString:@"1"])
    {
        // On Demand Request
        [self estimatedTimeOfArrivalByContractorPopup];
    }
    else
    {
        [dateBottomlineView removeFromSuperview];
        [dateBottomlineView setHidden:YES];
        [profileBottomlineView setHidden:YES];
        [profileBottomlineView removeFromSuperview];
        [self getUserMessageApiCall];
    }
}


#pragma mark-- Calculte Distance Time by Google api between Customer and Contractor

-(void)googleDistanceTimeApiCall {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
        NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
        
        // get CLLocation fot both addresses
        CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:[latitudeStr doubleValue] longitude:[lonitudeStr doubleValue]];
        CLLocation *meetLocation = [[CLLocation alloc] initWithLatitude:[sharedInstance.meetUpLatitude doubleValue] longitude:[sharedInstance.meetUpLongitude doubleValue]];
        
        // calculate distance between them
        CLLocationDistance distance = [endLocation distanceFromLocation:meetLocation];
        NSLog(@"Distance %f",distance);
        NSLog(@"Calculated Miles %@", [NSString stringWithFormat:@"%.1fmi",(distance/1609.344)]);
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

//        NSString *webServiceUrl =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false",sharedInstance.currentAddressStr,addressLabel.text];
//        
//        NSString *encodedUrl = [webServiceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
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
                 } else {
                     
                     totalDistanceStrInMeter  = @"0";
                     totalTimeStr  = @"0";
                 }
                 
                 //  [self estimatedTimeOfArrivalByContractorPopup];
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"network error:%@",error);
                 
                 totalDistanceStrInMeter  = @"0";
                 totalTimeStr  = @"0";
             }];
    }
    else {
        [ServerRequest networkConnectionLost];
    }
}


#pragma mark Estimated time Of Arrival Popup
- (void)estimatedTimeOfArrivalByContractorPopup {
    
    estimatedTimeArrivalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    estimatedTimeArrivalView.backgroundColor = [UIColor grayColor];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2-127, self.view.frame.size.width-40, 255)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0;
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 10, contentView.frame.size.width-2, 242)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, 40)];
    headerBgView.backgroundColor = [UIColor colorWithRed:191/255.0 green:151/255.0 blue:197/255.0 alpha:1.0];;
    [contentView addSubview:headerBgView];
    
    UILabel *titleTextLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 10, whiteView.frame.size.width, 18) andTitle:@"ESTIMATED TIME OF ARRIVAL" andTextColor:[UIColor whiteColor]];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [contentView addSubview:titleTextLabel];
    
    UILabel *subTitleLabel = [CommonUtils createLabelWithRect:CGRectMake(20, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+25, whiteView.frame.size.width-20, 30) andTitle:[NSString stringWithFormat:@"What is your estimated time of arrival?"] andTextColor:[UIColor darkGrayColor]];
    subTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    // [contractorMessageLabel sizeToFit];
    [contentView addSubview:subTitleLabel];
    
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
        
    } else {
        
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
    
    UILabel *distanceValueLabel = [CommonUtils createLabelWithRect:CGRectMake(20, subTitleLabel.frame.origin.y+subTitleLabel.frame.size.height+5, whiteView.frame.size.width-20, 30) andTitle:[NSString stringWithFormat:@"%@ Miles Away, %@",totalDistanceStrInMeter,totalTimeStr] andTextColor:[UIColor darkGrayColor]];
    
    distanceValueLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    distanceValueLabel.numberOfLines = 0;
    distanceValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    distanceValueLabel.textAlignment = NSTextAlignmentCenter;
    // [contractorMessageLabel sizeToFit];
    [contentView addSubview:distanceValueLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, distanceValueLabel.frame.origin.y+distanceValueLabel.frame.size.height+10, contentView.frame.size.width-40, 45)];
    bgView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    [contentView addSubview:bgView];
    
    distanceTextField = [CommonUtils createTextFieldWithRect:CGRectMake(20, bgView.frame.origin.y+5, bgView.frame.size.width-20, 35) andText:@"" andTextColor:[UIColor darkGrayColor] withPlaceHolderText:@""];
    distanceTextField.borderStyle = UITextBorderStyleNone;
    distanceTextField.font = [UIFont fontWithName:@"Helvetica" size:16];
    distanceTextField.text = estimatedTimeArraivalStr;
    distanceTextField.textAlignment = NSTextAlignmentCenter;
    distanceTextField.delegate =self;
    distanceTextField.keyboardType = UIKeyboardTypeNumberPad;
    distanceTextField.tag = 10;
    distanceTextField.backgroundColor = [UIColor clearColor];
    [contentView addSubview:distanceTextField];
    /*
     bookTimeSlot = [NSString stringWithFormat:@"%@ %@",dayTimeTextField.text,selectedTimeSlot];
     [dateFormatter1  setDateFormat:@"MM/dd/yyyy HH:mm a"];
     bookTimeSlotDate  = [dateFormatter1 dateFromString:bookTimeSlot];
     NSString * reserverDateWithTime = [self toStringFromDateTime:bookTimeSlotDate];
     NSLog(@"Reserve Time>>%@",reserverDateWithTime);
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
     */
    UIButton *submitButton = [CommonUtils createButtonWithRect:CGRectMake(0, 255-40, contentView.frame.size.width, 40) andText:@"SUBMIT" andTextColor:[UIColor whiteColor] andFontSize:@"" andImgName:@""];
    [submitButton addTarget:self action:@selector(acceptDateRequestSubmitButtonClickedApiCall) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:1.0]];
    submitButton.layer.cornerRadius = 3.0;
    [contentView addSubview:submitButton];
    [estimatedTimeArrivalView addSubview:contentView];
    [self.view addSubview:estimatedTimeArrivalView];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [distanceTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


- (void)acceptDateRequestSubmitButtonClickedApiCall {
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat: @"yyyy-MM-dd"];
    NSDate *nowdate = [NSDate date];
    distanceTextField.text = @"0:0";
    NSString *submitMeetingTime = [NSString stringWithFormat:@"%@ %@",[dateFormatter1 stringFromDate:nowdate],@"0:0"];
    [dateFormatter1  setDateFormat:@"MM/dd/yyyy HH:mm a"];
    //http://ondemandapinew.flexsin.in/API/Contractor/OntheWay?DateID=Date31427&EstimatedTimeArrival=2016-12-30 12:21:17.310
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@&EstimatedTimeArrival=%@",APIDateOnTheWay,userIdStr,self.dateIdStr,submitMeetingTime];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                //  [self dateRequestReceviedApiCall];
                [self.leftSliderView setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:143.0/255.0 alpha:1.0]];
                [self.leftSliderView setText:@"CONFIRM YOU'VE ARRIVED"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            else  if ([[responseObject objectForKey:@"StatusCode"] intValue] ==0)
            {
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
            else{
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];

            }
        }
    }];
    [secondProductReportPopup removeFromSuperview];
}

- (IBAction)messageButtonClicked:(id)sender {
    [dateBottomlineView removeFromSuperview];
    [dateBottomlineView setHidden:YES];
    [profileBottomlineView setHidden:YES];

    [profileBottomlineView removeFromSuperview];
    [self getUserMessageApiCall];
}

- (IBAction)addressButtonClicked:(id)sender {
    
    NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
    NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([sharedInstance.meetUpLatitude doubleValue] ,[sharedInstance.meetUpLongitude doubleValue]);
    NSLog(@"Variable Of Coprdinate %f",coordinate.latitude);
    // 27.1767° N, 78.0081° E
    //create MKMapItem out of coordinates
    if ([sharedInstance.meetUpLatitude doubleValue]!=0) {
        
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",[latitudeStr doubleValue],[lonitudeStr doubleValue],[sharedInstance.meetUpLatitude doubleValue],[sharedInstance.meetUpLongitude doubleValue] ];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
    else {
        //using iOS 5 which has the Google Maps application
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",[latitudeStr doubleValue],[lonitudeStr doubleValue],[sharedInstance.meetUpLatitude doubleValue],[sharedInstance.meetUpLongitude doubleValue] ];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
}

-(void)getLatLongFromAddress :(NSString *)address
{
    
    NSArray *addresseArray = [address componentsSeparatedByString:@","];
    NSInteger lastSecondObject = addresseArray.count-2;
    NSString *addressToBeSearch = [NSString stringWithFormat:@"%@ %@",[addresseArray objectAtIndex:lastSecondObject],[addresseArray lastObject]];
    NSLog(@"Address Value %@",addressToBeSearch);
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
            
            NSString  * cityStr = [CommonUtils checkStringForNULL:placemark.locality];
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
            latitudeValue = [latitude floatValue];
            longitudeValue= [longitude floatValue];
            sharedInstance.meetUpLatitude =[NSString stringWithFormat:@"%f",latitudeValue];
            sharedInstance.meetUpLongitude =[NSString stringWithFormat:@"%f",longitudeValue];
        }
    }];
}

#pragma mark Get User Message API Call
- (void)getUserMessageApiCall {
    
    [NSUserDefaults saveIncomingAvatarSetting:YES];
    [NSUserDefaults saveOutgoingAvatarSetting:YES];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@&DateID=%@&UserType=%@",APIGetMessagebyUser,customerIdStr,userIdStr,self.dateIdStr,@"2"];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error)
     {
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
                     sharedInstance.dateEndMessageDisableStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"DateStatus"]];
                     if ([sharedInstance.dateEndMessageDisableStr isEqualToString:@"1"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"2"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"4"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"6"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"10"]|| [sharedInstance.dateEndMessageDisableStr isEqualToString:@"11"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"13"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"15"]) {
                         [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Date is already cancel by Doumees" inController:self];
                     }
                     else
                     {
                         
                         OneToOneMessageViewController *vc = [OneToOneMessageViewController messagesViewController];
                         sharedInstance.messagessDataMArray = [messageData copy];
                         sharedInstance.recipientIdStr = customerIdStr;
                         sharedInstance.dateEndMessageDisableStr = @"";
                         sharedInstance.userNameStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"AppLoginUserName"]];
                         sharedInstance.userImageUrlStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ApploginPicName"]];
                         sharedInstance.dateIdStr = self.dateIdStr;
                         sharedInstance.recipientNameStr = [customerNameLabel.text capitalizedString];
                         
                         vc.self.recipientIdStr = customerIdStr;
                         vc.self.userImageUrlStr =  setPrimaryUrlStr;
                         [self.navigationController pushViewController:vc animated:YES];
                     }
                 }
             }
             else
             {
                 
                 sharedInstance.dateEndMessageDisableStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"DateStatus"]];
                 if ([sharedInstance.dateEndMessageDisableStr isEqualToString:@"1"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"2"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"4"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"6"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"10"]|| [sharedInstance.dateEndMessageDisableStr isEqualToString:@"11"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"13"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"15"]) {
                     
                     [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Date is already cancel by Doumees" inController:self];
                     
                 }
                 else {
                     
                     OneToOneMessageViewController *vc = [OneToOneMessageViewController messagesViewController];
                     sharedInstance.messagessDataMArray = [[NSMutableArray alloc]init];
                     sharedInstance.recipientIdStr = customerIdStr;
                     sharedInstance.dateEndMessageDisableStr = @"";
                     sharedInstance.userNameStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"AppLoginUserName"]];
                     sharedInstance.userImageUrlStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ApploginPicName"]];
                     sharedInstance.dateIdStr = self.dateIdStr;
                     sharedInstance.recipientNameStr = [customerNameLabel.text capitalizedString];
                     vc.self.recipientIdStr = customerIdStr;
                     vc.self.userImageUrlStr =  setPrimaryUrlStr;
                     [self.navigationController pushViewController:vc animated:YES];
                 }
             }
         }
         else {
             
             [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
         }
     }];
}

// MBSliderViewDelegate
- (void) sliderDidSlide:(MBSliderView *)slideView {
    
    // Customization example
    if (slideView ==_leftSliderView)
    {
        if ([_leftSliderView.text isEqualToString:@"On the Way"])
        {
            [self acceptDateRequestSubmitButtonClickedApiCall];
        }
        else if ([_leftSliderView.text isEqualToString:@"CONFIRM YOU'VE ARRIVED"])
        {
            double distanceTime = [totalDistanceStrInMeter doubleValue];
            if (distanceTime>0.2)
            {
                [[AlertView sharedManager] presentAlertWithTitle:@"Confirm Arrival" message:@"Your GPS location does not match the date location. Are you sure you have arrived at the location?"
                                             andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle)
                 {
                     if ([buttonTitle isEqualToString:@"Yes"])
                     {
                         NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIDateConfirmedArrived,userIdStr,self.dateIdStr];
                         NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                         
                         [ProgressHUD show:@"Please wait..." Interaction:NO];
                         [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
                             NSLog(@"response object Get UserInfo List %@",responseObject);
                             [ProgressHUD dismiss];
                             if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
                                 // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
                                 
                             }
                             else
                             {
                                 if(!error)
                                 {
                                     NSLog(@"Response is --%@",responseObject);
                                     if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                                         //[self dateRequestReceviedApiCallForAnotherPurpose];
                                         [self.leftSliderView setBackgroundColor:[UIColor colorWithRed:108.0/255.0 green:162.0/255.0 blue:78.0/255.0 alpha:1.0]];
                                         [self.leftSliderView setText:@"START DATE"];
                                         if (_isFromOnDemandRequest) {
                                             DatesViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                                             datesView.isFromDateDetails = YES;
                                             self.tabBarController.selectedIndex = 1;
                                             [self.navigationController pushViewController:datesView animated:NO];
                                             
                                         }
                                         else
                                         {
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }
                                     }
                                     else
                                     {
                                         [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                                      andButtonsWithTitle:@[@"Ok"] onController:self
                                                                            dismissedWith:^(NSInteger index, NSString *buttonTitle)
                                          {
                                              if ([buttonTitle isEqualToString:@"Ok"]) {
                                                  if (_isFromOnDemandRequest) {
                                                      DatesViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                                                      datesView.isFromDateDetails = YES;
                                                      self.tabBarController.selectedIndex = 1;
                                                      [self.navigationController pushViewController:datesView animated:NO];
                                                  }
                                                  else
                                                  {
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                  }
                                                  
                                              }}];
                                     }
                                 }
                             }
                         }];
                     }
                 }];
            }
            
            else
            {
                NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIDateConfirmedArrived,userIdStr,self.dateIdStr];
                NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [ProgressHUD show:@"Please wait..." Interaction:NO];
                [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
                    NSLog(@"response object Get UserInfo List %@",responseObject);
                    [ProgressHUD dismiss];
                    if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
                        /// [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
                        
                    }
                    else
                    {
                        if(!error)
                        {
                            
                            NSLog(@"Response is --%@",responseObject);
                            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                                DatesViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                                datesView.isFromDateDetails = YES;
                                self.tabBarController.selectedIndex = 1;
                                [self.navigationController pushViewController:datesView animated:NO];
                            }
                            else
                            {
                                [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                             andButtonsWithTitle:@[@"Ok"] onController:self
                                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle)
                                 {
                                     if ([buttonTitle isEqualToString:@"Ok"])
                                     {
                                         if (_isFromOnDemandRequest) {
                                             DatesViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                                             datesView.isFromDateDetails = YES;
                                             self.tabBarController.selectedIndex = 1;
                                             [self.navigationController pushViewController:datesView animated:NO];
                                         }
                                         else
                                         {
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }
                                         
                                     }}];
                            }
                        }
                    }
                }];
            }
        }
        
        else if ([_leftSliderView.text isEqualToString:@"START DATE"])
        {
            [[AlertView sharedManager] presentAlertWithTitle:@"Confirm Start Date" message:@"Are you sure you want to start the date?"
                                         andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle)
             {
                 if ([buttonTitle isEqualToString:@"Yes"]) {
                     
                     NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIStartDate,userIdStr,self.dateIdStr];
                     NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                     [ProgressHUD show:@"Please wait..." Interaction:NO];
                     [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
                         NSLog(@"response object Get UserInfo List %@",responseObject);
                         [ProgressHUD dismiss];
                         if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
                             // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
                         }
                         else
                         {
                             if(!error)
                             {
                                 NSLog(@"Response is --%@",responseObject);
                                 if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                                     // [self dateRequestReceviedApiCallForAnotherPurpose];
                                     [self.leftSliderView setBackgroundColor:[UIColor colorWithRed:191.0/255.0 green:41.0/255.0 blue:50.0/255.0 alpha:1.0]];
                                     [self.leftSliderView setText:@"END DATE"];
                                     [self.navigationController popViewControllerAnimated:YES];
                                     
                                 }
                                 else {
                                     [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                                  andButtonsWithTitle:@[@"Ok"] onController:self
                                                                        dismissedWith:^(NSInteger index, NSString *buttonTitle)
                                      {
                                          if ([buttonTitle isEqualToString:@"Ok"]) {
                                              [self.navigationController popViewControllerAnimated:YES];
                                              
                                          }}];
                                 }
                             }
                         }
                     }];
                 }
             }];
        }
        else if ([_leftSliderView.text isEqualToString:@"END DATE"]){
            NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIEndDate,userIdStr,self.dateIdStr];
            
            NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                [ProgressHUD dismiss];
                if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
                    // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
                    
                }
                else
                {
                    if(!error)
                    {
                        NSLog(@"Response is --%@",responseObject);
                        if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                            [self.leftSliderView setHidden:YES];
                            RatingViewController *rateViewCall = [self.storyboard instantiateViewControllerWithIdentifier:@"rating"];
                            rateViewCall.self.dateIdStr = dateIdStr;
                            rateViewCall.self.nameStr = [dataDictionary objectForKey:@"UserName"];
                            rateViewCall.self.imageUrlStr = setPrimaryUrlStr;
                            [self.navigationController pushViewController:rateViewCall animated:YES];
                        }
                        else
                        {
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"Ok"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle)
                             {
                                 if ([buttonTitle isEqualToString:@"Ok"]) {
                                     [self.navigationController popViewControllerAnimated:YES];
                                 }}];
                        }
                    }
                }
            }];
        }
    }
}

@end
