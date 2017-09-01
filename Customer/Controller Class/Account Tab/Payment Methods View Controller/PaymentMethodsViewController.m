
//  PaymentMethodsViewController.m
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "PaymentMethodsViewController.h"

#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@interface PaymentMethodsViewController ()<UIActionSheetDelegate> {
    
    NSMutableArray *dataArray;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    NSInteger selectedIndexPath;
    NSMutableDictionary *dataDic;
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
}

- (void)viewWillAppear:(BOOL)animated {
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    dataDic = [[NSMutableDictionary alloc]init];
    [self setViewOfLabel];
    [self fetchGetPaymentMethodListApiData];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
}


-(void)setViewOfLabel {
    
    if (WIN_WIDTH == 320) {
        
        [self.accountTypeLabel  setFrame:CGRectMake(45, 11, 35, 21)];
        [self.accountNumberLabel  setFrame:CGRectMake(80, 11, 75, 21)];
        [self.accountPrimaryLabel  setFrame:CGRectMake(160, 11, 56, 21)];
        [self.accountExpiryLabel  setFrame:CGRectMake(235, 11, 30, 21)];
        [self.accountStatusLabel  setFrame:CGRectMake(255, 11, 76, 21)];
        [self.accountTypeLabel setContentMode:UIViewContentModeLeft];
        [self.accountNumberLabel   setContentMode:UIViewContentModeLeft];
        [self.accountExpiryLabel setContentMode:UIViewContentModeLeft];
        [self.accountStatusLabel  setContentMode:UIViewContentModeLeft];
        [self.accountStatusLabel setBackgroundColor:[UIColor clearColor]];
        
    }
    else if (WIN_WIDTH == 414)
    {
        [self.accountTypeLabel  setFrame:CGRectMake(45, 11, 60, 21)];
        [self.accountNumberLabel  setFrame:CGRectMake(115, 11, 75, 21)];
        [self.accountPrimaryLabel  setFrame:CGRectMake(200, 11, 60, 21)];
        [self.accountExpiryLabel  setFrame:CGRectMake(270, 11, 45, 21)];
        [self.accountStatusLabel  setFrame:CGRectMake(310, 11, 76, 21)];
        [self.accountStatusLabel setBackgroundColor:[UIColor whiteColor]];
        
    }
    else if (WIN_WIDTH == 375){
        [self.accountTypeLabel  setFrame:CGRectMake(45, 11, 60, 21)];
        [self.accountNumberLabel  setFrame:CGRectMake(100, 11, 75, 21)];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButtonMethodClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bankAccountButtonClicked:(id)sender {
    
    AddBankAccountViewController *addBankAccountView = [self.storyboard instantiateViewControllerWithIdentifier:@"addBank"];

    [self.navigationController pushViewController:addBankAccountView animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count?dataArray.count:0;
    // return 10;
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
    if (WIN_WIDTH == 320) {
        [self.accountExpiryLabel setContentMode:UIViewContentModeLeft];
    }
    if (dataArray.count) {
        SingletonClass *customData = [dataArray objectAtIndex:indexPath.row];
        
        NSString *primaryAccount = [NSString stringWithFormat:@"%@",customData.accountPrimary];
        
        if ([primaryAccount isEqualToString:@"True"]) {
            
            [cell.accountPrimaryLabel setText:@"Primary"];
        }
        else {
            [cell.accountPrimaryLabel setText:@""];
        }
        
        NSString *primaryYesOrNo = customData.accountVerifyStatus;
        if ([primaryYesOrNo isEqualToString:@"0"]) {
            cell.selectedImageView.image = [UIImage imageNamed:@"not_verified"];
        }
        else {
            cell.selectedImageView.image = [UIImage imageNamed:@"verified"];
        }
        
        NSString *trimmedString=[customData.accountNumStr substringFromIndex:MAX((int)[customData.accountNumStr length]-4, 0)];
        cell.accountNumberLabel.text = [NSString stringWithFormat:@"****%@",trimmedString];
        [cell.accountStatusLabel setText: customData.accountStatus];
        [cell.accountTypeLabel setText: customData.bankName];
        cell.accountTypeLabel.minimumScaleFactor = 12;
        cell.accountTypeLabel.numberOfLines = 0;
        cell.accountTypeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.accountTypeLabel.textAlignment = NSTextAlignmentLeft;
        [cell.accountTypeLabel sizeToFit];
        [cell.accountExpiryLabel setText: customData.expiryDate];
        cell.accountNumberLabel.numberOfLines = 0;
        cell.accountNumberLabel.adjustsFontSizeToFitWidth = YES;
        [cell.accountNumberLabel sizeToFit];
    }
    
    
    //    NSString *verificationStatusYesOrNo = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"VerificationStatus"]];
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
    
    //    cell.verifyButton.tag = indexPath.row;
    //    cell.deleteButton.tag = indexPath.row;
    //    cell.setPrimaryButton.tag = indexPath.row;
    //
    //    NSString *accountStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"AccountNumber"]];
    //
    //    NSString *codeNumberStr = [accountStr substringFromIndex: [accountStr length] - 4];
    //
    //    cell.accountNumberLabel.text = [NSString stringWithFormat:@"%@ %@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Name"],codeNumberStr];
    //
    //    cell.accountNumberLabel.numberOfLines = 0;
    //    cell.accountNumberLabel.adjustsFontSizeToFitWidth = YES;
    //    [cell.accountNumberLabel sizeToFit];
    //
    //    cell.setPrimaryButton.tag = indexPath.row;
    //    cell.deleteButton.tag = indexPath.row;
    
    return cell;
}


-(void )tableView:(UITableView * ) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    selectedIndexPath = indexPath.row;
    SingletonClass *customData = [dataArray objectAtIndex:indexPath.row];
    ;
    NSString *verificationStatus;
    verificationStatus  = customData.accountVerifyStatus;
    NSString *primaryYesOrNo = customData.accountPrimary;
    
    if ([customData.accountStatus isEqualToString:@"Blocked"]) {
        [[AlertView sharedManager] presentAlertWithTitle:@"Credit Card Blocked" message:@"Your credit card has been blocked. Do you want to delete this card?"
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
                                             otherButtonTitles:@"Set Primary",@"Verify",@"Delete",nil];
        
        if(WIN_HEIGHT == 1024)
            [actionSheetView showInView:[[[UIApplication sharedApplication] delegate] window].rootViewController.view];
        else
            [actionSheetView showInView:[UIApplication sharedApplication].keyWindow];
        
        
    } else if((![primaryYesOrNo isEqualToString:@"False"]) && (![verificationStatus isEqualToString:@"1"])) {
        actionSheetView = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Verify",@"Delete",nil];
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
    else if(([verificationStatus isEqualToString:@"1"]) && [primaryYesOrNo isEqualToString:@"True"]){
        //        actionSheetView = [[UIActionSheet alloc] initWithTitle:nil
        //                                                  delegate:self
        //                                         cancelButtonTitle:@"Cancel"
        //                                    destructiveButtonTitle:nil
        //                                         otherButtonTitles:nil,nil];
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
            else if([buttonValue.text isEqualToString:@"Verify"]){
                [self verifyAccountDetailsWith:selectedIndexPath];
            }
            else if([buttonValue.text isEqualToString:@"Delete"]){
                [self deleteAccountButtonWith:selectedIndexPath];
            }
        }
            break;
            
        case 1:
        {
            if ([buttonValue.text isEqualToString:@"Set Primary"]) {
                [self setPrimaryAccountButtonWith:selectedIndexPath];
            }
            else if([buttonValue.text isEqualToString:@"Verify"]){
                [self verifyAccountDetailsWith:selectedIndexPath];
            }
            else if([buttonValue.text isEqualToString:@"Delete"]){
                [self deleteAccountButtonWith:selectedIndexPath];
            }
        }
            break;
        case 2:{
            if ([buttonValue.text isEqualToString:@"Set Primary"]) {
                [self setPrimaryAccountButtonWith:selectedIndexPath];
            }
            else if([buttonValue.text isEqualToString:@"Verify"]){
                [self verifyAccountDetailsWith:selectedIndexPath];
                
            }
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


- (IBAction)creditCardButtonClicked:(id)sender {
    
    CreditCardViewController *creditCardView = [self.storyboard instantiateViewControllerWithIdentifier:@"creditCard"];
    [self.navigationController pushViewController:creditCardView animated:YES];
}


- (void)deleteAccountButtonWith:(NSInteger)tag {
    
    NSInteger selectedValue =  tag;
    SingletonClass *bankDetails = [dataArray objectAtIndex:selectedValue];
    
    NSString *accountNumberStr = [NSString stringWithFormat:@"%@",bankDetails.accountNumStr];
    NSString *accpontType = bankDetails.accountType;
    
    if ([accpontType isEqualToString:@"Bank"]) {
        
    } else {
        
        accpontType = @"credit";
    }
    
    //   NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    NSString *urlstr=[NSString stringWithFormat:@"%@?UserID=%@&Number=%@&Type=%@",APIDeletePaymentMethodApiCall,userIdStr,accountNumberStr,accpontType];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    /http://ondemandapinew.flexsin.in/API/Account/DeletePaymentMethod?UserID=Cr009ffc5&Number=0987654321&Type=Bank
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [dataArray removeObjectAtIndex:tag];
                [[AlertView sharedManager] presentAlertWithTitle:@"Success" message:[responseObject objectForKey:@"Message"]
                                             andButtonsWithTitle:@[@"Ok"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                       if ([buttonTitle isEqualToString:@"Ok"]) {
                                                           [paymentTableView reloadData];
                                                       }
                                                   }];
                
            } else {
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        } else {
            
            NSLog(@"Error");
        }
    }];
    
}

- (void)verifyAccountDetailsWith:(NSInteger )tag {
    
    NSInteger selectedValue =  tag;
    
    SingletonClass *bankDetails = [dataArray objectAtIndex:selectedValue];
    [dataDic setObject:bankDetails forKey:@"DataValue"];
    NSLog(@"Dic Data %@",[dataDic valueForKey:@"DataValue"]);
    CreditCardVerificationViewController *verificationView = [self.storyboard instantiateViewControllerWithIdentifier:@"creditCardVerification"];
    verificationView.isFromCreditCardAddSxreen = NO;
    verificationView.isFromCreditCardAddStr = NO;
    verificationView.isFromCreditCardDeclinedStr = NO;

    verificationView.self.accountDataDictionary = [dataDic valueForKey:@"DataValue"] ;
    [self.navigationController pushViewController:verificationView animated:YES];
    
}

- (void)setPrimaryAccountButtonWith:(NSUInteger)tag{
    
    SingletonClass *bankDetails = [dataArray objectAtIndex:tag];
    NSString *accountNumberStr = [NSString stringWithFormat:@"%@",bankDetails.accountNumStr];
    NSString *accpontType = bankDetails.accountType;
    if ([accpontType isEqualToString:@"Bank"]) {
        
    } else {
        
        accpontType = @"Credit";
    }
    
    //  http://ondemandapinew.flexsin.in/api/account/PaymentMethodPrimary?userID=Cu0059036&Number=4242424242424242&Type=Credit
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Number=%@&Type=%@",APISetPrimaryPaymentMethodApiCall,userIdStr,accountNumberStr,accpontType];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
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
                // [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                //[paymentTableView reloadData];
                
            } else {
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        } else {
            
            NSLog(@"Error");
        }
    }];
}

#pragma mark--Get Payment Method List API Call
- (void)fetchGetPaymentMethodListApiData {
    
    //http://ondemandapinew.flexsin.in/API/Account/ListUserPaymentMethod?userID=Cr00a827c
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlForQA:APIGetPaymentMethodList withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            [dataArray removeAllObjects];
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                dataArray = [[NSMutableArray alloc]init];
                // dataDic = [[responseObject objectForKey:@"result"]objectForKey:@"MasterValues"];
                NSLog(@"DatDict %@",[responseObject objectForKey:@"result"]);
                //dataArray = [[dataDic objectForKey:@"MasterValues"] mutableCopy];
                dataArray = [SingletonClass parseDateForPayment:[[responseObject objectForKey:@"result"]objectForKey:@"MasterValues"]];
                [paymentTableView reloadData];
            }
            
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        
    }];
}
@end

