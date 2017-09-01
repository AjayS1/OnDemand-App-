//
//  UpdateMobileNumberViewController.h
//  Customer
//
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateMobileNumberViewController : UIViewController {
    
    IBOutlet UIButton *countryCodeButton;
    IBOutlet UITextField *mobileTextField;
    IBOutlet UITextField *countryCodeTextField;

    
}
@property(nonatomic,strong)NSString *userMobileNmbrStr;
@property(nonatomic,strong)NSString *countryID;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;
//- (IBAction)countryCodeButtonClicked:(id)sender;

@end
