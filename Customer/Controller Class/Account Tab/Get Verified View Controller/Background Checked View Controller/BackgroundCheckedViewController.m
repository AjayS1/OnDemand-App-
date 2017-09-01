
//  BackgroundCheckedViewController.m
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "BackgroundCheckedViewController.h"

@interface BackgroundCheckedViewController ()

@end

@implementation BackgroundCheckedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    securityNumberTextField.inputAccessoryView = keyboardDoneButtonView;
}

- (IBAction)doneClicked:(id)sender {
    
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
    [firstNameTextField becomeFirstResponder];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == securityNumberTextField) {
        int length = (int)[self getLength:textField.text];
        //NSLog(@"Length  =  %d ",length);
        
        if(length == 9)
        {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3)
        {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"%@",num];
            
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 5)
        {
            NSString *num = [self formatNumber:textField.text];
            //NSLog(@"%@",[num  substringToIndex:3]);
            //NSLog(@"%@",[num substringFromIndex:3]);
            textField.text = [NSString stringWithFormat:@"%@-%@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@-%@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
        return YES;
        
    }
    
    return YES;
}

- (NSString *)formatNumber:(NSString *)mobileNumber {
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSLog(@"%@", mobileNumber);
    int length = (int)[mobileNumber length];
    if(length > 9) {
        mobileNumber = [mobileNumber substringFromIndex: length-9];
        NSLog(@"%@", mobileNumber);
    }
    return mobileNumber;
}

- (int)getLength:(NSString *)mobileNumber {
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    int length = (int)[mobileNumber length];
    return length;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonClicked:(id)sender {
    
    if([securityNumberTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter the security number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    else if([firstNameTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:
                               @"Alert!" message:@"Please enter the first name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    else if([lastNameTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter the last name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    else if([zipCodeTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter the zipcode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else {
        
        BackgroundCheckoutViewController *backgroundCheckoutView = [self.storyboard instantiateViewControllerWithIdentifier:@"backgroundCheckout"];
        backgroundCheckoutView.self.socialSecurityNumberStr = securityNumberTextField.text,
        backgroundCheckoutView.self.fisrtNameStr = firstNameTextField.text;
        backgroundCheckoutView.self.lastNameStr =  lastNameTextField.text,
        backgroundCheckoutView.self.zipCodeStr = zipCodeTextField.text;
        [self.navigationController pushViewController:backgroundCheckoutView animated:YES];
        
    }
    
}
@end
