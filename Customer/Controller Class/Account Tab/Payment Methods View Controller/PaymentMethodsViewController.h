
//  PaymentMethodsViewController.h
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface PaymentMethodsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UILabel *primaryFirstLabel;
    IBOutlet UILabel *primarySecondLable;
    IBOutlet UIImageView *checkMarkSecondImageView;
    IBOutlet UILabel *cardFirstNameLabel;
    IBOutlet UILabel *cardSecondNameLabel;
    IBOutlet UIButton *creditCardButtonClicked;
    IBOutlet UIImageView *checkMarkFirstImageView;
    
    IBOutlet UITableView *paymentTableView;
}


- (IBAction)creditCardButtonClicked:(id)sender;
- (IBAction)bankAccountButtonClicked:(id)sender;


//- (IBAction)deleteAccountDetails:(id)sender;
//- (IBAction)verifyAccountDetails:(id)sender;
//- (IBAction)setPrimaryAccount:(id)sender;

@end
