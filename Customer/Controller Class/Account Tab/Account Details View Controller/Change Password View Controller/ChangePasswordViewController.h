
//  ChangePasswordViewController.h
//  Customer
//  Created by Jamshed Ali on 20/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate> {
    
    IBOutlet UITextField *currentPasswordTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *confirmPasswordTextField;
}
@property(nonatomic,strong)NSString *userPasswordStr;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;
@end
