
//  BankAccountVerificationViewController.h
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface BankAccountVerificationViewController : UIViewController {
    
   IBOutlet UITextField *firstAMountTextField;
   IBOutlet UITextField *secondAmountTextField;
    IBOutlet UILabel *accountNumberStr;
}
@property (assign) BOOL isFromAddBankAccountStr;

@property(nonatomic,strong)NSString *bankAccountNumberStr;
@property(nonatomic,strong)NSString *bankAccountNumberStrWithValue;
@property(nonatomic,strong)NSString *bankName;

@property(nonatomic,strong)NSString *addedOnStr;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;

@end
