
//  DateReportSubmitViewController.m
//  Customer
//  Created by Jamshed Ali on 30/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "DateReportSubmitViewController.h"

@interface DateReportSubmitViewController () {
    
    SingletonClass *sharedInstance;
    NSString *userIdStr;
}

@end

@implementation DateReportSubmitViewController

@synthesize requestType,contractorIdStr,dateIdStr,issueIdStr;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _messageTextView.layer.cornerRadius = 0;
    _messageTextView.layer.borderWidth = 1.0;
    _messageTextView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
    userIdStr = sharedInstance.userId;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    sharedInstance = [SingletonClass sharedInstance];
    
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


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonClicked:(id)sender {
    if([_messageTextView.text length]==0) {
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter the reason." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
    }
    else
    {
        
        if([self.requestType isEqualToString:@"pastDateDetails"]) {
            
            NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@&IssueID=%@&Notes=%@&usertype=%@",APIDateCompletedSubmitIssueApiCall,userIdStr,self.dateIdStr,self.issueIdStr,_messageTextView.text,@"2"];
            
            NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
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
                                 
                                 [self.navigationController popViewControllerAnimated:NO];
                                 sharedInstance.isFromReportSubmit = YES;
                                 //[self tabBarControllerClass];
                             }}];
                        //                        [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                        
                    }
                    else {
                        
                        [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                }
                else {
                    NSLog(@"Error");
                }
            }];
            
        }
        else if([self.requestType isEqualToString:@"do not get the code"]) {
            
            NSString *urlstr=[NSString stringWithFormat:@"%@?customerID=%@&DateID=%@&description=%@",APIDonotReceiveCodeApiCall,userIdStr,self.dateIdStr,_messageTextView.text];
            
            NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                [ProgressHUD dismiss];
                if(!error){
                    
                    NSLog(@"Response is --%@",responseObject);
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                                     andButtonsWithTitle:@[@"OK"] onController:self
                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle)
                         {
                             if ([buttonTitle isEqualToString:@"OK"]) {
                                 [APPDELEGATE.tabBarC.tabBar setHidden:YES];
                                 [self tabBarControllerClass];
                                 
                                 //                                 DatesViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                                 //                                 [self.navigationController pushViewController:datesView animated:YES];
                             }}];
                        
                        
                    }
                    else {
                        
                        [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                }
            }];
        }
        else {
            
            NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@&DateID=%@&Description=%@&Type=%@",APIReportContractorApiCall,userIdStr,self.contractorIdStr,self.dateIdStr,_messageTextView.text,@"1"];
            
            NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                [ProgressHUD dismiss];
                if(!error){
                    NSLog(@"Response is --%@",responseObject);
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                                     andButtonsWithTitle:@[@"OK"] onController:self
                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle)
                         {
                             if ([buttonTitle isEqualToString:@"OK"]) {
                                 [APPDELEGATE.tabBarC.tabBar setHidden:YES];
                                 [self tabBarControllerClass];
                             }}];
                    }
                    else {
                        [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                }
                else {
                    NSLog(@"Error");
                }
            }];
        }
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)tabBarControllerClass {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *searchScreenView = [storyboard instantiateViewControllerWithIdentifier:@"search"];
    searchScreenView.title = @"Search";
    searchScreenView.tabBarItem.image = [UIImage imageNamed:@"search"];
    searchScreenView.tabBarItem.selectedImage = [UIImage imageNamed:@"search_hover"];
    
    DatesViewController *datesView = [storyboard instantiateViewControllerWithIdentifier:@"dates"];
    datesView.title = @"Dates";
    datesView.isFromDateDetails = NO;
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    messageView.title = @"Messages";
    messageView.tabBarItem.image = [UIImage imageNamed:@"message"];
    messageView.tabBarItem.selectedImage = [UIImage imageNamed:@"message_hover"];
    
    NotificationsViewController *notiView = [storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notiView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
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
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:NO];
    
    
}




@end
