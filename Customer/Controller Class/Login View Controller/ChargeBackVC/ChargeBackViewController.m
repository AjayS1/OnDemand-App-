//
//  ChargeBackViewController.m
//  Customer
//
//  Created by Aditi on 24/05/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import "ChargeBackViewController.h"
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@interface ChargeBackViewController (){
    NSString *dateCountStr;
    NSString *messageCountStr;
    NSString *notificationsCountStr;
}
@property (weak,nonatomic) IBOutlet UITextView *chargeBackTextView;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *signOffButton;

@end

@implementation ChargeBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    [_chargeBackTextView setText:self.pendingChargeBackString];
    if (WIN_WIDTH == 320) {
        [self.chargeBackTextView setFrame:CGRectMake(self.chargeBackTextView.frame.origin.x, self.chargeBackTextView.frame.origin.y, self.chargeBackTextView.frame.size.width, self.chargeBackTextView.frame.size.height+40)];
        float heightOfTextView = self.chargeBackTextView.frame.size.height+self.chargeBackTextView.frame.origin.y;
        [self.emailButton setFrame:CGRectMake(self.emailButton.frame.origin.x, heightOfTextView+15, self.emailButton.frame.size.width, self.emailButton.frame.size.height)];
        [self.signOffButton setFrame:CGRectMake(self.signOffButton.frame.origin.x, self.emailButton.frame.origin.y+self.emailButton.frame.size.height+15, self.signOffButton.frame.size.width, self.signOffButton.frame.size.height)];
    }
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)tryAgainButtonMethodeAction:(id)sender {
    
    //[self.navigationController popViewControllerAnimated:YES];
    [self tabBarCountApiCall ];
    
  }


-(IBAction)emailActionMethode:(id)sender{
  //  [self PayAmountByPaymentMethodListApiData];
}
- (void)tabBarCountApiCall {
    
   // NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:_userIDString,@"UserID",@"1" ,@"userType",nil];
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

- (void)PayAmountByPaymentMethodListApiData {

    NSString *urlstr=[NSString stringWithFormat:@"%@?DateID=%@",APIChargeBackAmount,self.dateIDString];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Param%@",urlstr);
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApiForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [[AlertView sharedManager] presentAlertWithTitle:@"Email Sent" message:[responseObject objectForKey:@"Message"]
                                             andButtonsWithTitle:@[@"OK"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                       if ([buttonTitle isEqualToString:@"OK"]) {
                                                           [self.navigationController popViewControllerAnimated:NO];

                                                       }
                                                   }];
            }
            
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        
    }];
}


@end
