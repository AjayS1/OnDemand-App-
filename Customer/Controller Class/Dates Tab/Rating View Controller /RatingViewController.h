//
//  RatingViewController.h
//  Customer
//
//  Created by Jamshed Ali on 16/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMTextView.h"

@interface RatingViewController : UIViewController<UITextViewDelegate>{
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *dateHeaderLabel;
    
    IBOutlet UILabel *contractorNameLabel;
    IBOutlet UIImageView *contractorImageView;
    
    IBOutlet UILabel *totalPayAmountLabel;
    IBOutlet UILabel *totalTimeLabel;
    IBOutlet UILabel *tipsAmountLabel;
    IBOutlet UILabel *rewardAmountLabel;
    IBOutlet UITextField *codeTextField;
    
    IBOutlet UILabel *fourDigitCodeLabel;
    IBOutlet UIButton *needHelpButton;
    IBOutlet SAMTextView *ratingTextView;
}

@property(nonatomic,strong)NSString *dateIdStr;
@property(nonatomic,strong)NSString *nameStr;
@property(nonatomic,strong)NSString *imageUrlStr;
@property(nonatomic,strong)NSString *dateCompletedTimeStr;
@property(assign)BOOL isFromDateDetails;
@property(assign)BOOL isFromDateDetailsFromPastDate;
@property(assign)BOOL isFromLoginViewController;
@property (assign) BOOL isFromCreditCardView;



- (IBAction)submitPaymentMethodCall:(id)sender;
- (IBAction)needHelpMethodCall:(id)sender;
- (IBAction)backMethodCall:(id)sender;


@end
