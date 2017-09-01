
//  BankAccountVerificationViewController.m
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "BankAccountVerificationViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "AppDelegate.h"
#import "ServerRequest.h"
#import "AlertView.h"
#import "AccountViewController.h"
@interface BankAccountVerificationViewController () {
    
    SingletonClass *sharedInstance;
}
@property (weak, nonatomic) IBOutlet UILabel *bankAccountMessagelabel;

@end

@implementation BankAccountVerificationViewController
@synthesize bankAccountNumberStr;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    sharedInstance = [SingletonClass sharedInstance];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    NSString *accountStr = [NSString stringWithFormat:@"%@",self.bankAccountNumberStr];
    
    NSString *codeNumberStr = [accountStr substringFromIndex: [accountStr length] - 4];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    firstAMountTextField.inputAccessoryView = numberToolbar;
    secondAmountTextField.inputAccessoryView = numberToolbar;
    //Thank you for adding your bank account. We'll make two small deposits on January 27, 2016. Once you see these deposits, come back and enter them here to verify your bank account. You can return here anytime by clicking on the "Verify" button next to your account under Payment Methods.
    if (_isFromAddBankAccountStr) {
        accountNumberStr.text =  [NSString stringWithFormat:@"%@",_bankAccountNumberStrWithValue];
    }
    else{
        accountNumberStr.text =  [NSString stringWithFormat:@"%@ - XXXX XXXX %@",_bankName,codeNumberStr];
    }

    if ([_addedOnStr length]) {
        [_bankAccountMessagelabel setText:[NSString stringWithFormat:@"Thank you for adding your bank account. We'll make two small deposits on %@. Once you see these deposits, come back and enter them here to verify your bank account. You can return here anytime by clicking on the \"Verify\" button next to your account under Payment Methods.",_addedOnStr]];
    }
    
}

-(void)doneWithNumberPad{
    [self.view endEditing:YES];
}
- (void)checkSignalRReqest:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    
    if ([requestTypeStr isEqualToString:@"1"]) {
        
        NSString *dateIdStr = [responseObject objectForKey:@"dateId"];
        NSDictionary *dataDictionary = @{@"DateID":dateIdStr,@"Type":requestTypeStr};
        if (sharedInstance.onDemandPushNotificationArray.count) {
            [sharedInstance.onDemandPushNotificationArray removeAllObjects];
        }
        [sharedInstance.onDemandPushNotificationArray addObject:dataDictionary];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    
    if (_isFromAddBankAccountStr) {
        AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
        accountView.isFromOrderProcess = NO;
        accountView.isFromAddBankAccountProcess = YES;
        accountView.isFromUpdateMobileNumber = NO;
        [self.navigationController pushViewController:accountView animated:NO];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (IBAction)submitButtonClicked:(id)sender {
    
    [self bankAccountVerificationApiCall];
}

#pragma mark Bank Account Verification Api Call
- (void)bankAccountVerificationApiCall {
    
    if([firstAMountTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the first amount." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    else if([secondAmountTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the second amount." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    else
    {
        
        [self.view endEditing:YES];
        //ondemandapinew.flexsin.in/API/Account/VerifyCard?userID=Cu008bd3d&cardNumber=5105105105105100&VerifyID=cus_9oU9YszyhmKmQL&authenticationAmount=0.89
        NSString *userIdStr = sharedInstance.userId;
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&accountNumber=%@&amount1=%@&amount2=%@",APIBankAccountVerificationApiCall,userIdStr,self.bankAccountNumberStr,firstAMountTextField.text,secondAmountTextField.text];
        NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get Comments List %@",responseObject);
            [ProgressHUD dismiss];
            if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
          //      [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
                
            }
            else{
                if(!error) {
                    NSLog(@"Response is --%@",responseObject);
                    
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                        [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                     andButtonsWithTitle:@[@"OK"] onController:self
                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle)
                         {
                             if ([buttonTitle isEqualToString:@"OK"]) {
                                     [self.navigationController popViewControllerAnimated:YES];
                             }}];
                        
                    } else {
                        
                        [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                        
                    }
                }
            }
        }];
    }
}

- (IBAction)comeBackLater:(id)sender {
    
    NSArray *viewControlles = self.navigationController.viewControllers;
    for (id object in viewControlles) {
        
        if ([object isKindOfClass:[AccountViewController class]]) {
            AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
            accountView.isFromOrderProcess = NO;
            accountView.isFromUpdateMobileNumber = NO;
            accountView.isFromCreditCardProcess = NO;
            accountView.isEmailVerifiedOrNotPage = NO;

            [self.navigationController pushViewController:accountView animated:NO];
        }
    }
}

@end
