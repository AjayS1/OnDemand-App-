
//  AddBankAccountViewController.h
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import <UIKit/UIKit.h>

@interface AddBankAccountViewController : UIViewController<UIScrollViewDelegate> {
    
    IBOutlet UITextField *accountTypeTextField;
    IBOutlet UITextField *bankNameTextField;
    IBOutlet UITextField *accountHolderTextField;
    IBOutlet UITextField *routingNumberTextField;
    IBOutlet UITextField *accountNumberTextField;
    
    IBOutlet UIScrollView *scrollView;
}


- (IBAction)backButtonClicked:(id)sender;
- (IBAction)addBankAccountClicked:(id)sender;

@end
