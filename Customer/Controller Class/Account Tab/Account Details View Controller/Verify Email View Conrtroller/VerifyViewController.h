//
//  VerifyViewController.h
//  Customer
//
//  Created by Jamshed Ali on 20/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyViewController : UIViewController {
    
    IBOutlet UITextField *codeTextField;
}

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;

@end
