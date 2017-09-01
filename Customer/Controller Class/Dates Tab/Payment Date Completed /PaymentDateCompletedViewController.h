
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
    
    IBOutlet UILabel *startTimeLabel;
    IBOutlet UILabel *endTimeLabel;
    IBOutlet UILabel *totalTimeLabel;
    IBOutlet UILabel *AdditionalTimeLabel;
    IBOutlet UILabel *AdditionalTimeLabelWithAmount;
    IBOutlet UILabel *discountTitleLabel;
    IBOutlet UILabel *discountLabelWithAmount;
    IBOutlet UILabel *tipsAmountLabel;
    IBOutlet UILabel *tipsAmountPercentageLabel;
    IBOutlet UILabel *tipsAmountPercentageDataValue;
    IBOutlet UILabel *baseAmountValue;
    IBOutlet UILabel *subTotalLabel;

    IBOutlet UILabel *rewardAmountLabel;
    IBOutlet UILabel *fourDigitCodeLabel;
    IBOutlet UITextField *codeTextField;
    IBOutlet UIScrollView *scrollView;
}
@property (assign) BOOL isFromLoginView;
@property(nonatomic,strong)NSString *dateIdStr;
@property(nonatomic,strong)NSString *dateTypeStr;

- (IBAction)submitPaymentMethodCall:(id)sender;
- (IBAction)dontGetCodeMethodCall:(id)sender;
- (IBAction)backMethodCall:(id)sender;

@end
