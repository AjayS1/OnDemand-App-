
//  RatingViewController.m
//  Customer
//  Created by Jamshed Ali on 16/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "RatingViewController.h"
@interface RatingViewController () {
    NSString *ratingValueStr;
    NSString *dateCountStr;
    NSString *messageCountStr;
    NSString *notificationsCountStr;
    SingletonClass *sharedInstance;
    
}

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@end
@implementation RatingViewController
@synthesize dateIdStr,imageUrlStr,dateCompletedTimeStr;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    ratingValueStr = @"";
    contractorNameLabel.text =  self.nameStr;
    needHelpButton.layer.cornerRadius = 2;
    needHelpButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    needHelpButton.layer.borderWidth = 1;
    contractorImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    contractorImageView.layer.cornerRadius=contractorImageView.frame.size.height/2;
    contractorImageView.layer.borderWidth=2.0;
    contractorImageView.layer.masksToBounds = YES;
    contractorImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    NSURL *imageUrl = [NSURL URLWithString:self.imageUrlStr];
    [contractorImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(70, 165, self.view.frame.size.width-140, 30)];
    starRatingView.backgroundColor = [UIColor clearColor];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    //    starRatingView.value = 4;
    starRatingView.value = 0;
    starRatingView.tintColor = [UIColor lightGrayColor];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:starRatingView];
    
    ratingTextView.backgroundColor=[UIColor whiteColor];
    ratingTextView.layer.cornerRadius = 1.0;
    ratingTextView.layer.borderWidth =1.0;
    ratingTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ratingTextView.text=@"";
    ratingTextView.placeholder =@"Leave a comment";
    ratingTextView.textColor=[UIColor grayColor];
    ratingTextView.delegate=self;
    ratingTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if (self.isFromDateDetails) {
        [_backButton setHidden:YES];
    }
    else{
        [_backButton setHidden:YES];
    }
}

#pragma mark Rating Get
- (IBAction)didChangeValue:(HCSStarRatingView *)sender {
    NSLog(@"Changed rating to %.1f", sender.value);
    ratingValueStr = [NSString stringWithFormat:@"%.1f",sender.value];
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    sharedInstance = [SingletonClass sharedInstance];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}

- (void)viewDidLayoutSubviews {
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 800);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark textField Scroll Up
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //Keyboard becomes visible
    scrollView.frame = CGRectMake(scrollView.frame.origin.x,
                                  scrollView.frame.origin.y,
                                  scrollView.frame.size.width,
                                  scrollView.frame.size.height - 350 + 50);
    //resize
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    //keyboard will hide
    scrollView.frame = CGRectMake(scrollView.frame.origin.x,
                                  scrollView.frame.origin.y,
                                  scrollView.frame.size.width,
                                  scrollView.frame.size.height + 350 - 50); //resize
}

- (IBAction)backMethodCall:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)needHelpMethodCall:(id)sender {
}

#pragma mark Submit Payment Method Call
- (IBAction)submitPaymentMethodCall:(id)sender {
    if ([ratingValueStr isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                        message:@"Please select the rating."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        //Just for check
        //  self.dateIdStr = @"Date202751";
        NSString *urlstr=[NSString stringWithFormat:@"%@?DateID=%@&Rating=%@&Comment=%@&usertype=%@",APISubmitDateRateApiCall,self.dateIdStr,ratingValueStr,ratingTextView.text,@"1"];
        NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            if(!error)
            {
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    [[NSUserDefaults standardUserDefaults] setValue:@"10" forKey:@"requestToEndDateValue"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
//                                                 andButtonsWithTitle:@[@"Ok"] onController:self
//                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//                                                           if ([buttonTitle isEqualToString:@"Ok"])
//                                                           {
                                                               if ((![sharedInstance.otherDateType isKindOfClass:[NSNull class]]) || (![sharedInstance.otherDateTypeID isKindOfClass:[NSNull class]]))
                                                               {
                                                               if (([sharedInstance.otherDateType isEqualToString: @"9"]) && (sharedInstance.otherDateTypeID != nil) && (![sharedInstance.otherDateTypeID isEqualToString:@""])) {
                                                                   [self paymentCompletedApiCallWithDateType:sharedInstance.otherDateType WithDateID:sharedInstance.otherDateTypeID];
                                                               }
                                                               else{
                                                                   if (self.isFromDateDetails)
                                                                   {
                                                                       if (self.isFromLoginViewController) {
                                                                           if (self.isFromCreditCardView) {
                                                                               [self tabBarCountApiCall];
                                                                           }
                                                                           else{
                                                                               [self tabBarCountApiCall];
                                                                           }
                                                                       }
                                                                       else
                                                                       {
                                                                           [self.navigationController popViewControllerAnimated:YES];
                                                                       }
                                                                   }
                                                                   else
                                                                   {
                                                                       if (self.isFromLoginViewController) {
                                                                           if (self.isFromCreditCardView) {
                                                                               [self tabBarCountApiCall];
                                                                           }
                                                                           else{
                                                                               [self tabBarCountApiCall];
                                                                           }
                                                                       }
                                                                       else
                                                                       {
                                                                           [self.tabBarController.tabBar setHidden:NO];
                                                                           DatesViewController *dateView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                                                                           dateView.isFromDateDetails = YES;
                                                                           [self.tabBarController setSelectedIndex:1];
                                                                           [self.navigationController pushViewController:dateView animated:NO];
                                                                       }
                                                                   }
                                                               }
                                                           }
                                                               else
                                                               {
                                                                   if (self.isFromDateDetails)
                                                                   {
                                                                       if (self.isFromLoginViewController) {
                                                                           if (self.isFromCreditCardView) {
                                                                               [self tabBarCountApiCall];
                                                                           }
                                                                           else{
                                                                               [self tabBarCountApiCall];
                                                                           }
                                                                       }
                                                                       else
                                                                       {
                                                                           [self.navigationController popViewControllerAnimated:YES];
                                                                       }
                                                                   }
                                                                   else
                                                                   {
                                                                       if (self.isFromLoginViewController) {
                                                                           if (self.isFromCreditCardView) {
                                                                               [self tabBarCountApiCall];
                                                                           }
                                                                           else{
                                                                               [self tabBarCountApiCall];
                                                                           }
                                                                       }
                                                                       else
                                                                       {
                                                                           [self.tabBarController.tabBar setHidden:NO];
                                                                           DatesViewController *dateView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                                                                           dateView.isFromDateDetails = YES;
                                                                           [self.tabBarController setSelectedIndex:1];
                                                                           [self.navigationController pushViewController:dateView animated:NO];
                                                                       }
                                                                   }
                                                               }
//                                                       }
//                                                       }];
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
    }
}

-(void)paymentCompletedApiCallWithDateType:(NSString *)dateType WithDateID:(NSString *)dateId{
    PaymentDateCompletedViewController *paymentView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentDateCompleted"];
    paymentView.self.dateIdStr =  dateId;
    paymentView.isFromLoginView = YES;
    paymentView.self.dateTypeStr = [NSString stringWithFormat:@"%@",dateType];
    [self.navigationController pushViewController:paymentView animated:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)tabBarCountApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"1" ,@"userType",nil];
    // [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        // [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Dates"] isEqualToString:@"0"])
                {
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
    //searchScreenView.view.backgroundColor = [UIColor whiteColor];
    searchScreenView.title = @"Search";
    searchScreenView.tabBarItem.image = [UIImage imageNamed:@"search"];
    searchScreenView.tabBarItem.selectedImage = [UIImage imageNamed:@"search_hover"];
    
    DatesViewController *datesView = [storyboard instantiateViewControllerWithIdentifier:@"dates"];
    //datesView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.title = @"Dates";
    datesView.isFromDateDetails = NO;
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    messageView.tabBarItem.badgeValue =messageCountStr;
    messageView.title = @"Messages";
    messageView.tabBarItem.image = [UIImage imageNamed:@"message"];
    messageView.tabBarItem.selectedImage = [UIImage imageNamed:@"message_hover"];
    
    NotificationsViewController *notiView = [storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notiView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    notiView.tabBarItem.badgeValue = notificationsCountStr;
    notiView.title = @"Notifications";
    notiView.tabBarItem.image = [UIImage imageNamed:@"notification"];
    notiView.tabBarItem.selectedImage = [UIImage imageNamed:@"notification_hover"];
    
    AccountViewController *accountView = [storyboard instantiateViewControllerWithIdentifier:@"account"];
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
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
