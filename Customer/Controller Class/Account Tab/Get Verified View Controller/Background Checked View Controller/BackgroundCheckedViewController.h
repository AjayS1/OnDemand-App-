
//  BackgroundCheckedViewController.h
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface BackgroundCheckedViewController : UIViewController<UITextFieldDelegate> {
    
    IBOutlet UITextField *securityNumberTextField;
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *lastNameTextField;
    IBOutlet UITextField *zipCodeTextField;
    
}


- (IBAction)backButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;



@end
