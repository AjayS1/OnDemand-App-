
//  BackgroundCheckoutViewController.h
//  Customer
//  Created by Jamshed Ali on 27/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface BackgroundCheckoutViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UILabel *primaryFirstLabel;
    IBOutlet UILabel *primarySecondLable;
    IBOutlet UIImageView *checkMarkSecondImageView;
    IBOutlet UILabel *cardFirstNameLabel;
    IBOutlet UILabel *cardSecondNameLabel;
    IBOutlet UIButton *creditCardButtonClicked;
    IBOutlet UIImageView *checkMarkFirstImageView;
    
    IBOutlet UITableView *paymentTableView;
}



@property(nonatomic,strong)NSString *socialSecurityNumberStr;
@property(nonatomic,strong)NSString *fisrtNameStr;
@property(nonatomic,strong)NSString *lastNameStr;
@property(nonatomic,strong)NSString *zipCodeStr;


- (IBAction)creditCardButtonClicked:(id)sender;

- (IBAction)deleteAccountDetails:(id)sender;
- (IBAction)verifyAccountDetails:(id)sender;
- (IBAction)setPrimaryAccount:(id)sender;

- (IBAction)backButtonMethodClicked:(id)sender;

- (IBAction)submitMethodCall:(id)sender;


@end
