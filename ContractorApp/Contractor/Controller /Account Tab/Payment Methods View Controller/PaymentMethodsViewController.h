
//  PaymentMethodsViewController.h
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface PaymentMethodsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate> {
    
    IBOutlet UITableView *paymentTableView;
    
}

@property (strong, nonatomic) IBOutlet UILabel *primaryFirstLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkMarkFirstImageView;
@property (strong, nonatomic) IBOutlet UILabel *primarySecondLable;
@property (strong, nonatomic) IBOutlet UIImageView *checkMarkSecondImageView;
@property (strong, nonatomic) IBOutlet UILabel *cardFirstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardSecondNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *creditCardButtonClicked;

- (IBAction)bankAccountButtonClicked:(id)sender;
//- (IBAction)deleteAccountButtonClicked:(id)sender;
//- (IBAction)setPrimaryAccountButtonClicked:(id)sender;

//- (IBAction)verifyButtonClicked:(id)sender;

@end
