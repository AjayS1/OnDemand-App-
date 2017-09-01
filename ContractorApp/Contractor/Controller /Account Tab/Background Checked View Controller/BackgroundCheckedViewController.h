
//  BackgroundCheckedViewController.h
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface BackgroundCheckedViewController : UIViewController {
    
    
    IBOutlet UITextField *zipCodeTextField;
    IBOutlet UITextField *securityNumberTextField;
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *lastNameTextField;
}

//@property (strong, nonatomic) IBOutlet UITextField *securityNumberTextField;
//
//@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
//
//@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;




- (IBAction)backButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;



@end
