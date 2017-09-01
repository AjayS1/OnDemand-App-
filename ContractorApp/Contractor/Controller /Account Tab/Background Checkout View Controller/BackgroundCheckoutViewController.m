
//  BackgroundCheckoutViewController.m
//  Customer
//  Created by Jamshed Ali on 27/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "BackgroundCheckoutViewController.h"
#import "CreditCardVerificationViewController.h"
#import "BankAccountVerificationViewController.h"
#import "AddBankAccountViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "OrderProcessedViewController.h"
#import "PaymentMethodsViewController.h"
#import "ServerRequest.h"
#import "PaymentTableViewCell.h"
#import "AlertView.h"
#import "GetVerifiedViewController.h"
#import "AccountViewController.h"
#import "AppDelegate.h"
#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@interface BackgroundCheckoutViewController () {
    NSMutableArray *dataArray;
    NSString *bankAccountNumberStr;
    NSString *verifyIdStr;
    NSString *bankAccountTypeStr;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
}

@property (weak, nonatomic) IBOutlet UILabel *productIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *productQtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productLineTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *productIDLabelValue;
@property (weak, nonatomic) IBOutlet UILabel *productDescriptionLabelValue;
@property (weak, nonatomic) IBOutlet UILabel *productQtyLabelValue;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabelValue;
@property (weak, nonatomic) IBOutlet UILabel *productLineTotalLabelValue;
@property (weak, nonatomic) IBOutlet UILabel *productTotalLabelValue;
@property (weak, nonatomic) IBOutlet UILabel *productTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTotal;
@property (weak, nonatomic) IBOutlet UILabel *productCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *productMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation BackgroundCheckoutViewController
@synthesize socialSecurityNumberStr,fisrtNameStr,lastNameStr,zipCodeStr;
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    sharedInstance = [SingletonClass sharedInstance];
    
    userIdStr = sharedInstance.userId;
    
    verifyIdStr =@"";
    bankAccountTypeStr = @"";
    bankAccountNumberStr = @"";
    [self.submitButton setEnabled:NO];
    [self.submitButton setBackgroundColor:[UIColor colorWithRed:190.0/255.0 green:152.0/255.0 blue:196.0/255.0 alpha:0.8]];
    
    //paymentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setLabelView];
    [self fetchGetPaymentMethodListApiData];
    
}



-(void)setLabelView{
    
    if (WIN_WIDTH == 320) {
        
        [self.productIDLabelValue setFrame:CGRectMake(17, 45, 65, 21)];
        [self.productDescriptionLabelValue setFrame:CGRectMake(87, 45, 70, 21)];
        [self.productQtyLabelValue setFrame:CGRectMake(162, 45, 25, 21)];
        [self.productPriceLabelValue setFrame:CGRectMake(192, 45, 50, 21)];
        [self.productLineTotalLabelValue setFrame:CGRectMake(247, 45, 80, 21)];
        [self.productIDLabel setFrame:CGRectMake(17, 83, 65, 21)];
        [self.productDescriptionLabel setFrame:CGRectMake(87, 83, 70, 21)];
        [self.productQtyLabel setFrame:CGRectMake(162, 83, 25, 21)];
        [self.productPriceLabel setFrame:CGRectMake(192, 83, 50, 21)];
        [self.productLineTotalLabel setFrame:CGRectMake(247, 83, 80, 21)];
        [self.productTotal setFrame:CGRectMake(210, 143, 39, 21)];
        [self.productTotalLabel setFrame:CGRectMake(247, 143, 80, 21)];
    }
    else if (WIN_WIDTH == 414){
        [self.productIDLabelValue setFrame:CGRectMake(25, 45, 65, 21)];
        [self.productDescriptionLabelValue setFrame:CGRectMake(98, 45, 80, 21)];
        [self.productQtyLabelValue setFrame:CGRectMake(185, 45, 30, 21)];
        [self.productPriceLabelValue setFrame:CGRectMake(220, 45, 50, 21)];
        [self.productLineTotalLabelValue setFrame:CGRectMake(280, 45, 80, 21)];
        
        [self.productIDLabel setFrame:CGRectMake(25, 83, 65, 21)];
        [self.productDescriptionLabel setFrame:CGRectMake(98, 83, 80, 21)];
        [self.productQtyLabel setFrame:CGRectMake(185, 83, 30, 21)];
        [self.productPriceLabel setFrame:CGRectMake(220, 83, 50, 21)];
        [self.productLineTotalLabel setFrame:CGRectMake(280, 83, 80, 21)];
        [self.productTotal setFrame:CGRectMake(235, 143, 40, 21)];
        [self.productTotalLabel setFrame:CGRectMake(280, 143, 80, 21)];
        
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

- (IBAction)backButtonMethodClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
    // return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PaymentTableViewCell *cell;
    cell = nil;
    if (cell == nil) {
        cell = (PaymentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"paymentCell"];
    }
    
    
    NSString *primaryYesOrNo = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"isPrimary"]];
    
    if ([primaryYesOrNo isEqualToString:@"False"]) {
        
        cell.selectedImageView.image = [UIImage imageNamed:@""];
        
    } else {
        
        cell.selectedImageView.image = [UIImage imageNamed:@"check_icon.png"];
    }
    
    NSString *verificationStatusYesOrNo = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"VerificationStatus"]];
    
    if ([verificationStatusYesOrNo isEqualToString:@"Verified"]) {
        
        cell.verifyButton.hidden = YES;
        
    } else if ([verificationStatusYesOrNo isEqualToString:@"Pending"]) {
        
        
    } else {
        
    }
    
    cell.verifyButton.tag = indexPath.row;
    cell.deleteButton.tag = indexPath.row;
    cell.setPrimaryButton.tag = indexPath.row;
    
    cell.selectedImageView.hidden = YES;
    cell.verifyButton.hidden = YES;
    cell.deleteButton.hidden = YES;
    cell.setPrimaryButton.hidden = YES;
    
    NSString *accountStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"AccountNumber"]];
    
    NSString *codeNumberStr = [accountStr substringFromIndex: [accountStr length] - 4];
    
    cell.accountNumberLabel.text = [NSString stringWithFormat:@"%@ %@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Name"],codeNumberStr];
    
    cell.setPrimaryButton.tag = indexPath.row;
    cell.deleteButton.tag = indexPath.row;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    bankAccountNumberStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"AccountNumber"]];
    verifyIdStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"VerfyID"]];
    bankAccountNumberStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"AccountNumber"]];
    
    NSString *accpontType = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"PaymentMethod"]];
    
    if ([accpontType isEqualToString:@"Bank"]) {
        
        bankAccountTypeStr = @"1";
        
        if ([verifyIdStr isEqual:@"<null>"]|| [verifyIdStr isEqual: [NSNull null]]) {
            
            [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Please verify your bank account." inController:self];
            
        }
        
    } else {
        
        bankAccountTypeStr = @"2";
        if (![verifyIdStr isKindOfClass:[NSString class]]) {
            
            [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Please verify your credit card." inController:self];
        }
    }
}


- (IBAction)creditCardButtonClicked:(id)sender {
    
    //   CreditCardViewController *creditCardView = [self.storyboard instantiateViewControllerWithIdentifier:@"creditCard"];
    //   [self.navigationController pushViewController:creditCardView animated:YES];
}


- (IBAction)deleteAccountDetails:(id)sender {
    
    UIButton *button = sender;
    
    NSLog(@"button tag %ld",(long)button.tag);
    
    NSString *tagValue = [NSString stringWithFormat:@"%ld",(long)button.tag];
    
    NSString *accountNumberStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:[tagValue integerValue]] objectForKey:@"AccountNumber"]];
    
    NSString *accpontType = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:[tagValue integerValue]] objectForKey:@"PaymentMethod"]];
    
    if ([accpontType isEqualToString:@"Bank"]) {
        
    } else {
        
        accpontType = @"credit";
    }
    
    //  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Number=%@&Type=%@",APIDeletePaymentMethodApiCall,userIdStr,accountNumberStr,accpontType];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                [dataArray removeObjectAtIndex:[tagValue integerValue]];
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                [paymentTableView reloadData];
                
            } else {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        } else {
            
            NSLog(@"Error");
        }
    }];
    
}

- (IBAction)verifyAccountDetails:(id)sender {
    
    UIButton *button = sender;
    NSLog(@"button tag %ld",(long)button.tag);
    NSString *tagValue = [NSString stringWithFormat:@"%ld",(long)button.tag];
    
    NSString *paymentMethodType = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:[tagValue integerValue]] objectForKey:@"PaymentMethod"]];
    
    if ([paymentMethodType isEqualToString:@"Bank"]) {
        
        NSString *accountStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:[tagValue integerValue]] objectForKey:@"AccountNumber"]];
        
        BankAccountVerificationViewController *bankAccountVerificationView = [self.storyboard instantiateViewControllerWithIdentifier:@"bankAccountVerification"];
        bankAccountVerificationView.self.bankAccountNumberStr = accountStr;
        bankAccountVerificationView.isFromAddBankAccountStr = NO;
        NSString *accountVAlueStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:[tagValue integerValue]] objectForKey:@"Name"]];
        if ([accountVAlueStr length]) {
        bankAccountVerificationView. bankName =[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:[tagValue integerValue]] objectForKey:@"Name"]];
        }
            //bankAccountVerificationView.addedOnStr = bankDetails.addedTime;
        [self.navigationController pushViewController:bankAccountVerificationView animated:YES];
        
    } else {
        
        CreditCardVerificationViewController *verificationView = [self.storyboard instantiateViewControllerWithIdentifier:@"creditCardVerification"];
        verificationView.self.accountDataDictionary = [[dataArray objectAtIndex:[tagValue integerValue]] mutableCopy];
        [self.navigationController pushViewController:verificationView animated:YES];
    }
    
}

- (IBAction)setPrimaryAccount:(id)sender {
    
    UIButton *button = sender;
    NSLog(@"button tag %ld",(long)button.tag);
    NSString *tagValue = [NSString stringWithFormat:@"%ld",(long)button.tag];
    NSString *accountNumberStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:[tagValue integerValue]] objectForKey:@"AccountNumber"]];
    
    NSString *accpontType = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:[tagValue integerValue]] objectForKey:@"PaymentMethod"]];
    
    if ([accpontType isEqualToString:@"Bank"]) {
        
    } else {
        
        accpontType = @"credit";
    }
    
    //   NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Number=%@&Type=%@",APISetPrimaryPaymentMethodApiCall,userIdStr,accountNumberStr,accpontType];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                //[paymentTableView reloadData];
                
                
                [self fetchGetPaymentMethodListApiData];
                
            } else {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        } else {
            
            NSLog(@"Error");
        }
    }];
    
}


#pragma mark--Get Payment Method List API Call
- (void)fetchGetPaymentMethodListApiData {
    
    
    NSString *stringUserID = sharedInstance.userId;
    // NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",nil];
    // NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@",APIGetBucketDetail,@"Cu0055c6f1"];
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@",APIGetBucketDetail,stringUserID];
    
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest requestWithUrlQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
           // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    dataArray = [[NSMutableArray alloc]init];
                    NSDictionary *dataDic = [[responseObject objectForKey:@"result"] mutableCopy];
                    if ([dataDic count]) {
                        
                        sharedInstance.productID = [dataDic valueForKey:@"ProductId"];
                        sharedInstance.productDescription = [dataDic valueForKey:@"Description"];
                        sharedInstance.productQty = [dataDic valueForKey:@"Quantity"];
                        sharedInstance.productPrice = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[dataDic valueForKey:@"Price"] floatValue]]];
                        sharedInstance.productTotal = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[dataDic valueForKey:@"Total"] floatValue]]];
                        sharedInstance.productCardName = [dataDic valueForKey:@"PaymentMethod"];
                        sharedInstance.productTotalPricel = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[dataDic valueForKey:@"LineTotal"] floatValue]]];
                        sharedInstance.accountNumberStr = [dataDic valueForKey:@"AccountNumber"];
                        sharedInstance.UniqueIdStr = [dataDic valueForKey:@"UniqueKey"];
                        sharedInstance.productPriceValue = [NSString stringWithFormat:@"%.2f",[[dataDic valueForKey:@"Total"] floatValue]];
                        
                        [dataArray  addObject:sharedInstance];
                        NSLog(@"data Array%@",dataArray);
                        
                        [self.productIDLabel setText:sharedInstance.productID];
                        [self.productDescriptionLabel setText:sharedInstance.productDescription];
                        [self.productQtyLabel setText:sharedInstance.productQty];
                        [self.productPriceLabel setText:sharedInstance.productPrice];
                        [self.productLineTotalLabel setText:sharedInstance.productTotalPricel];
                        [self.productTotalLabel setText:sharedInstance.productTotal];
                        [self.productCardLabel setText:sharedInstance.productCardName ];
                        [self.submitButton setEnabled:YES];
                        [self.submitButton setBackgroundColor:[UIColor colorWithRed:120.0/255.0 green:78.0/255.0 blue:139.0/255.0 alpha:0.8]];
                        
                        
                    }
                    else{
                        [self.submitButton setEnabled:NO];
                        [self.submitButton setBackgroundColor:[UIColor colorWithRed:190.0/255.0 green:152.0/255.0 blue:196.0/255.0 alpha:0.8]];
                        
                    }
                }
                
                else if([[responseObject objectForKey:@"StatusCode"] intValue] ==2) {
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Bank Account Not Added" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"NO",@"YES"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle)
                     {
                         if ([buttonTitle isEqualToString:@"YES"]) {
                             
                             AddBankAccountViewController *addBankAccountView = [self.storyboard instantiateViewControllerWithIdentifier:@"addBank"];
                             [self.navigationController pushViewController:addBankAccountView animated:YES];
                             
                         }}];
                    
                    
                }
                else if([[responseObject objectForKey:@"StatusCode"] intValue] == 3) {
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Bank Account Not Verified" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"NO",@"YES"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           if ([buttonTitle isEqualToString:@"YES"]) {
                                                               
                                                               PaymentMethodsViewController *paymentInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentMethod"];
                                                               [self.navigationController pushViewController:paymentInfoView animated:YES];
                                                           }
                                                           
                                                       }];
                    
                    
                    
                }
                else if([[responseObject objectForKey:@"StatusCode"] intValue] == 4){
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Bank Account Expired" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"NO",@"YES"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           if ([buttonTitle isEqualToString:@"YES"]) {
                                                               AddBankAccountViewController *addBankAccountView = [self.storyboard instantiateViewControllerWithIdentifier:@"addBank"];
                                                               [self.navigationController pushViewController:addBankAccountView animated:YES];
                                                           }
                                                       }];
                    
                }
                else if([[responseObject objectForKey:@"StatusCode"] intValue] == 5){
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Bank Account" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"NO",@"YES"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           if ([buttonTitle isEqualToString:@"YES"]) {
                                                               
                                                               AddBankAccountViewController *addBankAccountView = [self.storyboard instantiateViewControllerWithIdentifier:@"addBank"];
                                                               [self.navigationController pushViewController:addBankAccountView animated:YES];
                                                           }}];
                }
                
                
                else
                {
                    [[AlertView sharedManager] presentAlertWithTitle:@"Bank Account" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"Ok"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           if ([buttonTitle isEqualToString:@"Ok"]) {
                                                               
                                                           }}];
                }
            }
        }
    }];
}


#pragma mark Submit Checkout Method Call
- (IBAction)submitMethodCall:(id)sender {
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    NSString *stringUserID = sharedInstance.userId;
    
    //#warning UnComment at the time of build
    
    NSString *firstNameTextField = [self.fisrtNameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *lastNameTextField = [self.lastNameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&firstName=%@&lastName=%@&SocialSecurityNumber=%@&AccountNumber=%@&UniqueIdentifyKey=%@&PostalCode=%@&userType=%@&amount=%ld",APIBackgroundVerificationApiCall,stringUserID,firstNameTextField,lastNameTextField,self.socialSecurityNumberStr,sharedInstance.accountNumberStr,sharedInstance.UniqueIdStr,self.zipCodeStr,@"1",(long)[sharedInstance.productPriceValue integerValue]];
    
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ServerRequest AFNetworkPostRequestUrlForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
        //    [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    if ([[responseObject valueForKey:@"OrderID"] length]) {
                        sharedInstance.orderNumberStr = [responseObject valueForKey:@"OrderID"];
                        sharedInstance.checkRResultStr = @"Passed";
                    }
                    OrderProcessedViewController *addBankAccountView = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderProcessedViewController"];
                    [self.navigationController pushViewController:addBankAccountView animated:YES];
                    
                }
                else if ([[responseObject objectForKey:@"StatusCode"] intValue] == 2) {
                    
                    if ([[responseObject valueForKey:@"OrderID"] length]) {
                        sharedInstance.orderNumberStr = [responseObject valueForKey:@"OrderID"];
                        sharedInstance.checkRResultStr = @"Not Pass";
                    }
                    OrderProcessedViewController *addBankAccountView = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderProcessedViewController"];
                    [self.navigationController pushViewController:addBankAccountView animated:YES];
                }
                
                else {
                    if ([[responseObject objectForKey:@"Message"] isEqualToString:@"Either ssn or zipcode is incorrect"] || [[responseObject objectForKey:@"Message"] isEqualToString:@"Either ssn or zipcode is incorrect."]) {
                        [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your SSN or Zip Code is incorrect." inController:self];
                    }
                    else{
                        [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                }
            }
        }
    }];
    
}


@end