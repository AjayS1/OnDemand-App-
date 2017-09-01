//
//  PaymentTypesViewController.m
//  Contractor
//
//  Created by Deepak on 9/2/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "PaymentTypesViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "AppDelegate.h"
#import "NotificationTableViewCell.h"
#import "ServerRequest.h"

@interface PaymentTypesViewController () {
    
    NSDictionary *itemDict;
    NSString *creditMasterStr;
    NSString *creditVisaStr;
    NSString *creditAmericanStr;
    
    SingletonClass *sharedInstance;
}

@end

@implementation PaymentTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedInstance = [SingletonClass sharedInstance];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    // Do any additional setup after loading the view.
    paymentTypeTableDataArray = [[NSMutableArray alloc]initWithObjects:@"Cash",@"Credit Card Visa",@"Credit card MasterCard",@"Credit card AmericanExpress",@"Venmo",@"Square Cash",@"PayPal",nil];
    arrayCheckUnchek = [[NSMutableArray alloc]init];
    selectedDataArray = [[NSMutableArray alloc]init];
    checkedTypeDataArray = [[NSMutableArray alloc]init];
    
    paymentTypeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //[self getPreferencesPaymentTypeApiData];
    [self getpaymentTypeData];
}


- (void)getpaymentTypeData {
    
    
    if ([[self.paymentTypeDict valueForKey:@"isCashPaymentReceiveMethod"] isKindOfClass:[NSNull class]]) {
        
        CashPament = @"";
        
    } else {
        
        CashPament = [self.paymentTypeDict valueForKey:@"isCashPaymentReceiveMethod"];
    }
    
    if ([[self.paymentTypeDict valueForKey:@"isVenmoPaymentReceiveMethod"] isKindOfClass:[NSNull class]]) {
        
        VemnoPament = @"";
        
    } else {
        
        VemnoPament = [self.paymentTypeDict valueForKey:@"isVenmoPaymentReceiveMethod"];
    }
    
    
    if ([[self.paymentTypeDict valueForKey:@"isSquareCashPaymentReceiveMethod"] isKindOfClass:[NSNull class]]) {
        
        squareCashPament = @"";
        
    } else {
        
        squareCashPament = [self.paymentTypeDict valueForKey:@"isSquareCashPaymentReceiveMethod"];
    }
    
    
    if ([[self.paymentTypeDict valueForKey:@"isPayPalPaymentReceiveMethod"] isKindOfClass:[NSNull class]]) {
        
        payPalPament = @"";
        
    } else {
        
        payPalPament = [self.paymentTypeDict valueForKey:@"isPayPalPaymentReceiveMethod"];
    }
    
    
    if ([[self.paymentTypeDict valueForKey:@"isCreditPaymentReceiveMethod"] isKindOfClass:[NSNull class]]) {
        
        creditCardPament = @"";
        
    } else {
        
        creditCardPament = [self.paymentTypeDict valueForKey:@"isCreditPaymentReceiveMethod"];
    }
    
    if ([[self.paymentTypeDict valueForKey:@"CreditPaymentValue"] isKindOfClass:[NSNull class]]) {
        
        
        
    } else {
        
        creditCardPamentValue = [self.paymentTypeDict valueForKey:@"CreditPaymentValue"];
        
        
        itemArry = [creditCardPamentValue componentsSeparatedByString:@","];
        
        for(int i =0; i<itemArry.count; i++)
        {
            typeStr = [itemArry objectAtIndex:i];
            if([typeStr isEqualToString:@"1"]){
                creditMasterStr = @"True";
            }else if ([typeStr isEqualToString:@"2"]){
                creditVisaStr = @"True";
            }else if ([typeStr isEqualToString:@"3"]){
                creditAmericanStr = @"True";
            }
        }
        [selectedDataArray addObject:creditCardPamentValue];
    }
    
    
    if([CashPament isEqualToString:@"True"])
    {
        isCash = @"1";
    }
    else
    {
        isCash = @"0";
    }
    if ([VemnoPament isEqualToString:@"True"])
    {
        isVemno = @"1";
    }
    else
    {
        isVemno = @"0";
    }
    if ([squareCashPament isEqualToString:@"True"])
    {
        issquareCash = @"1";
    }
    else
    {
        issquareCash = @"0";
    }
    if ([payPalPament isEqualToString:@"True"])
    {
        ispayPal = @"1";
    }
    else
    {
        ispayPal = @"0";
    }
    if ([creditCardPament isEqualToString:@"True"])
    {
        creditCard = @"1";
    }
    else
    {
        creditCard = @"0";
    }
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    
    
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




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return paymentTypeTableDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotificationTableViewCell *cell;
    cell = nil;
    if (cell == nil) {
        
        cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
        cell.nameLbl.text = [paymentTypeTableDataArray objectAtIndex:indexPath.row];
        cell.checkncheckdBtn.tag = indexPath.row;
        
        for(int i =0; i<itemArry.count; i++)
        {
            typeStr = [itemArry objectAtIndex:i];
            
            if (indexPath.row == 0) {
                
                if([CashPament isEqualToString:@"True"]){
                    
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Check"];
                    
                }
                else{
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Uncheck"];
                    
                }
            }else if (indexPath.row == 1) {
                if([creditVisaStr isEqualToString:@"True"]){
                    
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Check"];
                    //[selectedDataArray addObject:@"1"];
                    
                }
                else{
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Uncheck"];
                }
            }else if (indexPath.row == 2) {
                if([creditMasterStr isEqualToString:@"True"]){
                    
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Check"];
                    //[selectedDataArray addObject:@"2"];
                    
                }
                else{
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Uncheck"];
                    
                }
                
            }else if (indexPath.row == 3) {
                if([creditAmericanStr isEqualToString:@"True"]){
                    
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Check"];
                    //[selectedDataArray addObject:@"3"];
                    
                }
                else{
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Uncheck"];
                    
                }
                
            }else if (indexPath.row == 4) {
                
                if([VemnoPament isEqualToString:@"True"]){
                    
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Check"];
                    
                }
                else{
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Uncheck"];
                    
                }
            }else if (indexPath.row == 5) {
                if([squareCashPament isEqualToString:@"True"]){
                    
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Check"];
                    
                }
                else{
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Uncheck"];
                    
                }
                
            }else if (indexPath.row == 6) {
                if([payPalPament isEqualToString:@"True"]){
                    
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Check"];
                    
                }
                else{
                    [cell.checkncheckdBtn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                    [arrayCheckUnchek addObject:@"Uncheck"];
                    
                }
                
            }
            
        }
        [cell.checkncheckdBtn addTarget:self action:@selector(checkedUncheckedbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    selectedIndex = indexPath.row;
    //    NSString *strData = [genderPreferencesTableDataArray objectAtIndex:selectedIndex];
    //    [[NSUserDefaults standardUserDefaults]setObject:strData forKey:@"GenderData"];
    //    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark-- PreferencesGetPaymentType API Call
-(void)getPreferencesPaymentTypeApiData
{
    
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@",APIPrefernceGetpayment,userIdStr];
    
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
                    
                    itemDict = [responseObject valueForKey:@"Item"];
                    
                    CashPament = [itemDict valueForKey:@"isCashPaymentReceiveMethod"];
                    VemnoPament = [itemDict valueForKey:@"isVenmoPaymentReceiveMethod"];
                    squareCashPament = [itemDict valueForKey:@"isSquareCashPaymentReceiveMethod"];
                    payPalPament = [itemDict valueForKey:@"isPayPalPaymentReceiveMethod"];
                    creditCardPament = [itemDict valueForKey:@"isCreditPaymentReceiveMethod"];
                    creditCardPamentValue = [itemDict valueForKey:@"CreditPaymentValue"];
                    [selectedDataArray addObject:creditCardPamentValue];
                    [checkedTypeDataArray addObject:itemDict];
                    
                    
                    //[paymentTypeTableView reloadData];
                }
                
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            } else {
                
                NSLog(@"Error");
            }
        }
    }];
    
}


#pragma mark-- PreferencesPaymentType API Call
-(void)updatePreferencesPaymentTypeApiData
{
    
    NSString *userIdStr = sharedInstance.userId;
    
    creditCardStr = [selectedDataArray componentsJoinedByString:@","];
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&isCash=%@&isVemno=%@&SqareCash=%@&PayPal=%@&CreditCard=%@",APIPrefernceUpdatepayment,userIdStr,isCash,isVemno,issquareCash,ispayPal,creditCardStr];
    
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
           // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    
                    
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            } else {
                
                NSLog(@"Error");
            }
        }
    }];}


-(void)checkedUncheckedbuttonClicked:(id)sender
{
    //Getting the indexPath of cell of clicked button
    NSString *visaCardStr;
    NSString *masterCardStr;
    NSString *americanCardStr;
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:paymentTypeTableView];
    NSIndexPath *indexPath = [paymentTypeTableView indexPathForRowAtPoint:touchPoint];
    UIButton *button = (UIButton *)sender;
    NSInteger theRowIndex = indexPath.row;
    
    if([[arrayCheckUnchek objectAtIndex:indexPath.row] isEqualToString:@"Uncheck"])
    {
        [button setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
        [arrayCheckUnchek replaceObjectAtIndex:indexPath.row withObject:@"Check"];
        NSString *strvalue = [paymentTypeTableDataArray objectAtIndex:theRowIndex];
        
        
        if([strvalue isEqualToString:@"Credit Card Visa"])
        {
            visaCardStr = @"1";
            [selectedDataArray addObject:visaCardStr];
        }
        else if([strvalue isEqualToString:@"Credit card MasterCard"])
        {
            masterCardStr = @"2";
            [selectedDataArray addObject:masterCardStr];
        }
        else if([strvalue isEqualToString:@"Credit card AmericanExpress"])
        {
            americanCardStr = @"3";
            [selectedDataArray addObject:americanCardStr];
        }
        //creditCardStr = [NSString stringWithFormat:@"%@,%@,%@",visaCardStr,masterCardStr,americanCardStr];
        // [selectedDataArray addObject:strvalue];
        NSLog(@"%@",strvalue);
        
        if(indexPath.row==0){
            isCash = @"1";
        }
        else if (indexPath.row==4){
            isVemno = @"1";
            
        }else if (indexPath.row==5){
            issquareCash = @"1";
            
        }else if (indexPath.row==6){
            ispayPal = @"1";
            
        }
        
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [arrayCheckUnchek replaceObjectAtIndex:indexPath.row withObject:@"Uncheck"];
        NSString *strvalue = [paymentTypeTableDataArray objectAtIndex:theRowIndex];
        
        if([strvalue isEqualToString:@"Credit Card Visa"])
        {
            [selectedDataArray removeObject:visaCardStr];
        }
        else if([strvalue isEqualToString:@"Credit card MasterCard"])
        {
            [selectedDataArray removeObject:masterCardStr];
        }
        else if([strvalue isEqualToString:@"Credit card AmericanExpress"])
        {
            [selectedDataArray removeObject:americanCardStr];
        }
        NSLog(@"%@",strvalue);
        
        if(indexPath.row==0){
            isCash = @"0";
        }
        else if (indexPath.row==4){
            isVemno = @"0";
            
        }else if (indexPath.row==5){
            issquareCash = @"0";
            
        }else if (indexPath.row==6){
            ispayPal = @"0";
            
        }
        
    }
}


- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doneButtonClicked:(id)sender
{
    [self updatePreferencesPaymentTypeApiData];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
