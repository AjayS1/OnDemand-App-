//
//  NonSufficientVC.m
//  Contractor
//
//  Created by Aditi on 09/02/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import "NonSufficientVC.h"
#import "AppDelegate.h"
#import "DashboardViewController.h"
#import "DatesViewController.h"
#import "MessagesViewController.h"
#import "NotificationsViewController.h"
#import "AccountViewController.h"
#import "AlertView.h"
#import "AddBankAccountViewController.h"

@interface NonSufficientVC (){
    NSString *  dateCountStr;
    NSString *  messageCountString;
    NSString *  notificationsCountStr;
}
@property (weak,nonatomic) IBOutlet UITextView *pendingLabelText;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;


@end

@implementation NonSufficientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    [_pendingLabelText setText:self.nonSufficientMessage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)tryAgainButtonMethodeAction:(id)sender
{
    [self tryAgainBankAccountMethode];
    [self.tryAgainButton setBackgroundColor:[UIColor colorWithRed:203.0/255.0 green:171.0/255.0 blue:207.0/255.0 alpha:1.0]];
    [_tryAgainButton setEnabled:NO];
}

-(IBAction)signOffButtonActionMethode:(id)sender
{
    
    AddBankAccountViewController *addBankAccountView = [self.storyboard instantiateViewControllerWithIdentifier:@"addBank"];
    addBankAccountView.isFromNonSufficientScreen = YES;
    addBankAccountView.dateIDString = self.dateIdString;
    [self.navigationController pushViewController:addBankAccountView animated:YES];
    
}

-(void)tryAgainBankAccountMethode{
    {

     NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Dateid=%@",APITryAgainApiCall,self.userIDStr,self.dateIdString];
      NSString   *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *valueToSave = @"1";
            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"tryAgainButtonValue"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest requestWIthNewURLForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                [ProgressHUD dismiss];
                
                if(!error){
                    
                    NSLog(@"Response is --%@",responseObject);
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                        [[AlertView sharedManager] presentAlertWithTitle:@"Success" message:[responseObject objectForKey:@"Message"]
                                                     andButtonsWithTitle:@[@"Ok"] onController:self
                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle)
                         {
                             if ([buttonTitle isEqualToString:@"Ok"]) {
                                 [self tabBarCountApiCall];
                             }
                         }];
                    }
                    else {
                        [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject valueForKey:@"Message"] inController:self];
                    }
                }
            }];
    }
}

- (void)tabBarCountApiCall {
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.userIDStr,@"UserID",@"2" ,@"userType",nil];
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
