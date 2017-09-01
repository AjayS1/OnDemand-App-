
//  BankAccountVerificationViewController.h
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface BankAccountVerificationViewController : UIViewController<UITextViewDelegate> {
    
    IBOutlet UITextField *firstAMountTextField;
    IBOutlet UITextField *secondAmountTextField;
}

@property(nonatomic,strong)NSString *bankAccountNumberStr;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;

@end
