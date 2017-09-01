
//  PaymentMethodsViewController.m
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "PaymentMethodsViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "AddBankAccountViewController.h"
#import "BankAccountVerificationViewController.h"
#import "ServerRequest.h"
#import "PaymentTableViewCell.h"
#import "OptionPickerViewSheet.h"
#import "AlertView.h"
#import "AppDelegate.h"
#import "CreditCardViewController.h"

#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width


@interface PaymentMethodsViewController () {
    
    NSMutableArray *accountArray;
    SingletonClass *sharedInstance;
    NSInteger selectedIndexPath;
    UIActionSheet *actionSheetView;
}

@property (strong, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountExpiryLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountPrimaryLabel;

@end

@implementation PaymentMethodsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    paymentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    sharedInstance = [SingletonClass sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    [self setViewOfLabel];
    [self fetchGetPaymentMethodListApiData];
    
}
-(void)setViewOfLabel {
    
    if (WIN_WIDTH == 320) {

        [self.accountTypeLabel  setFrame:CGRectMake(38, 11, 45, 21)];
        [self.accountNumberLabel  setFrame:CGRectMake(90, 11, 85, 21)];
        [self.accountPrimaryLabel  setFrame:CGRectMake(175, 11,66, 21)];
        [self.accountExpiryLabel  setFrame:CGRectMake(230, 11, 0, 21)];
        [self.accountStatusLabel  setFrame:CGRectMake(230, 11, 76, 21)];
        [self.accountTypeLabel setContentMode:UIViewContentModeLeft];
        [self.accountNumberLabel   setContentMode:UIViewContentModeLeft];
        [self.accountExpiryLabel setContentMode:UIViewContentModeLeft];
        [self.accountStatusLabel  setContentMode:UIViewContentModeLeft];
        [self.accountStatusLabel setBackgroundColor:[UIColor clearColor]];
        
    }
    else if (WIN_WIDTH == 414){
        
        [self.accountTypeLabel  setFrame:CGRectMake(45, 11, 70, 21)];
        [self.accountNumberLabel  setFrame:CGRectMake(130, 11, 85, 21)];
        [self.accountPrimaryLabel  setFrame:CGRectMake(220, 11, 60, 21)];
        [self.accountExpiryLabel  setFrame:CGRectMake(275, 11, 0, 21)];
        [self.accountStatusLabel  setFrame:CGRectMake(275, 11, 76, 21)];
        [self.accountStatusLabel setBackgroundColor:[UIColor whiteColor]];
        
    }
    else if (WIN_WIDTH == 375){
        
    }
    
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
        
    } else {
        
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return accountArray.count?accountArray.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PaymentTableViewCell *cell;
    cell = nil;
    if (cell == nil) {
        cell = (PaymentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"paymentCell"];
    }
    if (accountArray.count) {
        SingletonClass *customData = [accountArray objectAtIndex:indexPath.row];
        NSString *primaryYesOrNo = customData.accountVerificationStatus;
        if ([primaryYesOrNo isEqualToString:@"0"]) {
            
            cell.selectedImageView.image = [UIImage imageNamed:@"not_verified"];
            
        } else {
            
            cell.selectedImageView.image = [UIImage imageNamed:@"verified"];
        }
        
        NSString *primaryValue =[NSString stringWithFormat:@"%@",customData.accountPrimary];;
        if ([primaryValue isEqualToString:@"True"]) {
            
            [cell.accountPrimaryLabel setText:@"Primary"];
            
        } else {
            
            [cell.accountPrimaryLabel setText:@""];
        }
        
        [cell.accountStatusLabel setText: customData.accountStatus];
        [cell.accountTypeLabel setText: customData.bankName];
        [cell.accountExpiryLabel setText: customData.expiryDate];
        NSString *trimmedString=[customData.accountNumStr substringFromIndex:MAX((int)[customData.accountNumStr length]-4, 0)];
        cell.accountNumberLabel.text = [NSString stringWithFormat:@"****%@",trimmedString];
        cell.accountTypeLabel.minimumScaleFactor = 12;
//        cell.accountTypeLabel.numberOfLines = 0;
//        cell.accountTypeLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        cell.accountTypeLabel.textAlignment = NSTextAlignmentLeft;
//        [cell.accountTypeLabel sizeToFit];
        //        cell.accountNumberLabel.numberOfLines = 0;
        //        cell.accountNumberLabel.adjustsFontSizeToFitWidth = YES;
        //        [cell.accountNumberLabel sizeToFit];
        
    }
    
    
    //    NSString *verificationStatusYesOrNo = [NSString stringWithFormat:@"%@",[[accountArray objectAtIndex:indexPath.row] objectForKey:@"VerificationStatus"]];
    //
    //    if ([verificationStatusYesOrNo isEqualToString:@"Verified"]) {
    //
    //        cell.verifyButton.hidden = YES;
    //
    //    } else if ([verificationStatusYesOrNo isEqualToString:@"Pending"]) {
    //
    //
    //    } else {
    //
    //    }
    
    // cell.accountStatusLabel
    cell.setPrimaryButton.tag = indexPath.row;
    cell.deleteButton.tag = indexPath.row;
    cell.verifyButton.tag = indexPath.row;
    
    return cell;
    
}

-(void )tableView:(UITableView * ) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
    selectedIndexPath = indexPath.row;
    SingletonClass *customData = [accountArray objectAtIndex:indexPath.row];
    ;
    NSString *primaryYesOrNo = customData.accountPrimary;
    NSString *verificationStatus = customData.accountVerificationStatus;
    if ([customData.accountStatus isEqualToString:@"Blocked"]) {
        [[AlertView sharedManager] presentAlertWithTitle:@"Bank Account Blocked" message:@"Your bank account has been blocked. Do you want to delete this account?"
                                     andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               if ([buttonTitle isEqualToString:@"Yes"]) {
                                                   [self deleteAccountButtonWith:selectedIndexPath];
                                               }
                                           }];
    }
    else{
    if ([primaryYesOrNo isEqualToString:@"False"] && (![verificationStatus isEqualToString:@"1"])) {
        actionSheetView = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Set Primary",@"Delete",nil];
        if(WIN_HEIGHT == 1024)
            [actionSheetView showInView:[[[UIApplication sharedApplication] delegate] window].rootViewController.view];
        else
            [actionSheetView showInView:[UIApplication sharedApplication].keyWindow];
    }
    
    else if((![primaryYesOrNo isEqualToString:@"False"]) && (![verificationStatus isEqualToString:@"1"])) {
        actionSheetView = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Delete",nil];
        if(WIN_HEIGHT == 1024)
            [actionSheetView showInView:[[[UIApplication sharedApplication] delegate] window].rootViewController.view];
        else
            [actionSheetView showInView:[UIApplication sharedApplication].keyWindow];
    }
    
    else if(([verificationStatus isEqualToString:@"1"]) && [primaryYesOrNo isEqualToString:@"False"]) {
        actionSheetView = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Set Primary",@"Delete",nil];
        if(WIN_HEIGHT == 1024)
            [actionSheetView showInView:[[[UIApplication sharedApplication] delegate] window].rootViewController.view];
        else
            [actionSheetView showInView:[UIApplication sharedApplication].keyWindow];
    }
    else if(([verificationStatus isEqualToString:@"1"]) && [primaryYesOrNo isEqualToString:@"True"]) {
        //        actionSheetView = [[UIActionSheet alloc] initWithTitle:nil
        //                                                      delegate:self
        //                                             cancelButtonTitle:@"Cancel"
        //                                        destructiveButtonTitle:nil
        //                                             otherButtonTitles:@"Delete",nil];
        
      }
    }
    NSLog(@"IndexPath %ld",(long)selectedIndexPath);
    
    //actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
    
    UILabel *buttonValue = [[UILabel alloc]init];
    [buttonValue setText:[actionSheet buttonTitleAtIndex:buttonIndex]];
    switch (buttonIndex) {
        case 0:{
            if ([buttonValue.text isEqualToString:@"Set Primary"]) {
                [self setPrimaryAccountButtonWith:selectedIndexPath];
            }
//            else if([buttonValue.text isEqualToString:@"Verify"]){
//                [self verifyButtonWith:selectedIndexPath];
//                
//            }
            else if([buttonValue.text isEqualToString:@"Delete"]){
                [self deleteAccountButtonWith:selectedIndexPath];
                
            }
            
        }
            break;
            
        case 1:{
            if ([buttonValue.text isEqualToString:@"Set Primary"]) {
                [self setPrimaryAccountButtonWith:selectedIndexPath];
            }
//            else if([buttonValue.text isEqualToString:@"Verify"]){
//                [self verifyButtonWith:selectedIndexPath];
//                
//            }
            else if([buttonValue.text isEqualToString:@"Delete"]){
                [self deleteAccountButtonWith:selectedIndexPath];
                
            }
            
        }
            break;
        case 2:{
            if ([buttonValue.text isEqualToString:@"Set Primary"]) {
                [self setPrimaryAccountButtonWith:selectedIndexPath];
            }
//            else if([buttonValue.text isEqualToString:@"Verify"]){
//                [self verifyButtonWith:selectedIndexPath];
//                
//            }
            else if([buttonValue.text isEqualToString:@"Delete"]){
                [self deleteAccountButtonWith:selectedIndexPath];
                
            }
        }
            break;
            
        default:
            return;
            break;
    }
}

#pragma mark - UIActionSheet Delegate Method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
}

- (IBAction)backButtonMethodClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bankAccountButtonClicked:(id)sender {
    
    AddBankAccountViewController *addBankAccountView = [self.storyboard instantiateViewControllerWithIdentifier:@"addBank"];
    addBankAccountView.isFromNonSufficientScreen = NO;
    [self.navigationController pushViewController:addBankAccountView animated:YES];
    
}

- (IBAction)creditCardButtonClicked:(id)sender {
    
    CreditCardViewController *creditCardView = [self.storyboard instantiateViewControllerWithIdentifier:@"creditCard"];
    [self.navigationController pushViewController:creditCardView animated:YES];
}

- (void)deleteAccountButtonWith:(NSInteger)tag {
    
    NSInteger selectedValue =  tag;
    SingletonClass *bankDetails = [accountArray objectAtIndex:selectedValue];
    
    NSString *accountNumberStr = [NSString stringWithFormat:@"%@",bankDetails.accountNumStr];
    
    //  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    
    NSString *userIdStr = sharedInstance.userId;
    //    /http://ondemandapinew.flexsin.in/API/Account/DeletePaymentMethod?UserID=Cr009ffc5&Number=0987654321&Type=Bank
    NSString *urlstr=[NSString stringWithFormat:@"%@?UserID=%@&Number=%@&Type=%@",APIDeletePaymentAccount,userIdStr,accountNumberStr,@"Bank"];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
          //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    [accountArray removeObjectAtIndex:tag];
                    [[AlertView sharedManager] presentAlertWithTitle:@"Success" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"Ok"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           if ([buttonTitle isEqualToString:@"Ok"]) {
                                                               [paymentTableView reloadData];
                                                           }
                                                       }];
                    
                    //[self fetchGetPaymentMethodListApiData];
                    
                } else {
                    
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}

#pragma mark-- Set Primary Account Method Call

- (void)setPrimaryAccountButtonWith:(NSInteger )tag {
    
    NSInteger selectedValue =  tag;
    SingletonClass *bankDetails = [accountArray objectAtIndex:selectedValue];
    
    NSString *accountNumberStr = [NSString stringWithFormat:@"%@",bankDetails.accountNumStr];
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Number=%@&Type=%@",APISetPrimaryAccount,userIdStr,accountNumberStr,@"Credit"];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"request URL %@",encodedUrl);
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    //  http://ondemandapinew.flexsin.in/api/account/PaymentMethodPrimary?userID=Cu0059036&Number=4242424242424242&Type=Credit
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            //[CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    [[AlertView sharedManager] presentAlertWithTitle:@"Success" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"Ok"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           if ([buttonTitle isEqualToString:@"Ok"]) {
                                                               [self fetchGetPaymentMethodListApiData];
                                                           }
                                                       }];
                    
                } else {
                    
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}

- (void)verifyButtonWith:(NSInteger)tag {
    
    SingletonClass *bankDetails = [accountArray objectAtIndex:tag];
    NSString *accountNumberStr = [NSString stringWithFormat:@"%@",bankDetails.accountNumStr];
    BankAccountVerificationViewController *bankAccountVerificationView = [self.storyboard instantiateViewControllerWithIdentifier:@"bankAccountVerification"];
    bankAccountVerificationView. bankName =[NSString stringWithFormat:@"%@",bankDetails.bankName];
    bankAccountVerificationView.self.bankAccountNumberStr = accountNumberStr;
    bankAccountVerificationView.addedOnStr = bankDetails.addedTime;
    bankAccountVerificationView.isFromAddBankAccountStr = NO;

    [self.navigationController pushViewController:bankAccountVerificationView animated:YES];
}


#pragma mark--Get Payment Method List API Call
- (void)fetchGetPaymentMethodListApiData {
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",nil];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest requestWithUrlQA:APIGetPaymentMethodList withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
          //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                [accountArray removeAllObjects];
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    accountArray = [[NSMutableArray alloc]init];
                    accountArray = [SingletonClass parseDateForPayment:[[responseObject objectForKey:@"result"]objectForKey:@"MasterValues"]];
                    // accountArray = [[responseObject objectForKey:@"result"]objectForKey:@"MasterValues"];
                    [paymentTableView reloadData];
                    
                } else {
                    
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
            [paymentTableView reloadData];
        }
    }];
}

@end
