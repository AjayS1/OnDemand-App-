
//  RatingViewController.m
//  Customer
//  Created by Jamshed Ali on 16/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "RatingViewController.h"
#import "DatesViewController.h"
#import "ServerRequest.h"
#import "HCSStarRatingView.h"
#import "AppDelegate.h"
#import "AlertView.h"
#import "DashboardViewController.h"
#import "DatesViewController.h"
#import "MessagesViewController.h"
#import "NotificationsViewController.h"
#import "AccountViewController.h"
@interface RatingViewController () {
    NSString *ratingValueStr;
    NSString * dateCountStr;
    NSString *messageCountString;
    SingletonClass *sharedInstance;

    NSString * notificationsCountStr;
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
    //    [contractorImageView sd_setImageWithURL:imageUrl
    //                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(70, 165, self.view.frame.size.width-140, 30)];
    
    starRatingView.backgroundColor = [UIColor clearColor];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    //    starRatingView.value = 4;
    starRatingView.value = 0;
    
    starRatingView.tintColor = [UIColor redColor];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:starRatingView];
    
    ratingTextView.backgroundColor=[UIColor whiteColor];
    ratingTextView.layer.cornerRadius = 2.0;
    ratingTextView.layer.borderWidth =1.0;
    ratingTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ratingTextView.text=@"";
    ratingTextView.placeholder =@"Leave a comment";
    ratingTextView.textColor=[UIColor grayColor];
    ratingTextView.delegate=self;
    ratingTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    if (self.isFromDateDetails) {
        [_backButton setHidden:YES];
    }else{
        [_backButton setHidden:YES];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    sharedInstance = [SingletonClass sharedInstance];

    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
#pragma mark Submit Payment Method Call
- (IBAction)submitPaymentMethodCall:(id)sender {
    
    if ([ratingValueStr isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Please select the rating."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        
    } else {
        
        NSString *urlstr=[NSString stringWithFormat:@"%@?DateID=%@&Rating=%@&Comment=%@&usertype=%@",APISubmitDateRateApiCall,self.dateIdStr,ratingValueStr,ratingTextView.text,@"2"];
        
        
        NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
              //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
                
            }
            else{
                if(!error){
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
//                        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
//                                                     andButtonsWithTitle:@[@"Ok"] onController:self
//                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//                                                               if ([buttonTitle isEqualToString:@"Ok"]) {
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
//                                                               }
//                                                           }];
                    }
                    else
                    {
                        [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                }
            }
        }];
    }
}

#pragma mark Rating Get
- (IBAction)didChangeValue:(HCSStarRatingView *)sender {
    
    NSLog(@"Changed rating to %.1f", sender.value);
    ratingValueStr = [NSString stringWithFormat:@"%.1f",sender.value];
}

- (IBAction)backMethodCall:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)needHelpMethodCall:(id)sender {
}
- (void)tabBarCountApiCall {
    
    NSString *loginID = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:loginID,@"UserID",@"2" ,@"userType",nil];
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
                    messageCountString = nil;
                }
                else {
                    messageCountString = [[responseObject objectForKey:@"result"] objectForKey:@"Mesages"];
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
    messageView.tabBarItem.badgeValue = messageCountString;
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
}

@end
