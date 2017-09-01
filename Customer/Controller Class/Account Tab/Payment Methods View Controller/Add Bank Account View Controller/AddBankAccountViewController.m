
//  AddBankAccountViewController.m
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "AddBankAccountViewController.h"

@interface AddBankAccountViewController () {
    
    SingletonClass *sharedInstance;
}


@end

@implementation AddBankAccountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    sharedInstance = [SingletonClass sharedInstance];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [scrollView addGestureRecognizer:gestureRecognizer];
    
}

- (void)viewDidLayoutSubviews {
    
    scrollView.contentSize = CGSizeMake(320, 800);
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
}

-(void) hideKeyBoard:(id) sender {
    // Do whatever such as hiding the keyboard
    [self.view endEditing:YES];
    
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


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Add Bank Account Api Call
- (void)AddAccountDetailApiCall {
    
    //  NSString *ipAddressStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"IPAddressValue"];
    
    NSString *ipAddressStr  = sharedInstance.ipAddressStr;
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:userIdStr forKey:@"userID"];
    [params setValue:accountTypeTextField.text forKey:@"AccountType"];
    [params setValue:bankNameTextField.text forKey:@"BankName"];
    [params setValue:accountHolderTextField.text forKey:@"AccountHolderName"];
    [params setValue:routingNumberTextField.text forKey:@"RoutingNumber"];
    [params setValue:accountNumberTextField.text forKey:@"AccountNumber"];
    [params setValue:ipAddressStr forKey:@"IpAddress"];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    
    [ServerRequest AFNetworkPostRequestUrl:APIAddBanckAccountDetail withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                BankAccountVerificationViewController *bankAccountVerificationView = [self.storyboard instantiateViewControllerWithIdentifier:@"bankAccountVerification"];
                bankAccountVerificationView.self.bankAccountNumberStr = accountNumberTextField.text;
                [self.navigationController pushViewController:bankAccountVerificationView animated:YES];
                
            }
            else {
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                
            }
        }
    }];
    
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addBankAccountClicked:(id)sender {
    
    if([accountTypeTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please select the account type." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else if([bankNameTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter the bank name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else if([accountHolderTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter the account holder name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }else if([routingNumberTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter the routing number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else if([accountNumberTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter the bank account number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    else {
        
        NSString *ipAddressStr  = sharedInstance.ipAddressStr;
        NSString *userIdStr = sharedInstance.userId;
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:userIdStr forKey:@"userID"];
        [params setValue:accountTypeTextField.text forKey:@"AccountType"];
        [params setValue:bankNameTextField.text forKey:@"BankName"];
        [params setValue:accountHolderTextField.text forKey:@"AccountHolderName"];
        [params setValue:routingNumberTextField.text forKey:@"RoutingNumber"];
        [params setValue:accountNumberTextField.text forKey:@"AccountNumber"];
        [params setValue:ipAddressStr forKey:@"IpAddress"];
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrl:APIAddBanckAccountDetail withParams:params CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get Comments List %@",responseObject);
            [ProgressHUD dismiss];
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    BankAccountVerificationViewController *bankAccountVerificationView = [self.storyboard instantiateViewControllerWithIdentifier:@"bankAccountVerification"];
                    bankAccountVerificationView.self.bankAccountNumberStr = accountNumberTextField.text;
                    [self.navigationController pushViewController:bankAccountVerificationView animated:YES];
                    
                } else{
                    
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
        
    }
    
}
@end
