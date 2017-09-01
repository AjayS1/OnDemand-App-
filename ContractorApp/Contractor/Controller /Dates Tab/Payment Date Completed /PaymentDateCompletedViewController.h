
//  PaymentDateCompletedViewController.h
//  Customer
//  Created by Jamshed Ali on 16/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface PaymentDateCompletedViewController : UIViewController<UITextFieldDelegate> {
    
    
    IBOutlet UILabel *dateHeaderLabel;
    IBOutlet UILabel *contractorNameLabel;
    IBOutlet UIImageView *contractorImageView;
    IBOutlet UILabel *totalPayAmountLabel;
    IBOutlet UILabel *totalTimeLabel;
    IBOutlet UILabel *tipsAmountLabel;
    IBOutlet UILabel *rewardAmountLabel;
    IBOutlet UILabel *fourDigitCodeLabel;
    IBOutlet UITextField *codeTextField;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *collectAmountUserLabel;
}

@property(nonatomic,strong)NSString *dateIdStr;
@property(nonatomic,strong)NSString *dateTypeStr;
- (IBAction)notReceivedPaymentMethodCall:(id)sender;

- (IBAction)submitPaymentMethodCall:(id)sender;
- (IBAction)dontGetCodeMethodCall:(id)sender;
- (IBAction)backMethodCall:(id)sender;

@end
