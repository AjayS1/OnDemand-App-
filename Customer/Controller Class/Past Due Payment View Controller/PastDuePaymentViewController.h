
//  PastDuePaymentViewController.h
//  Customer
//  Created by Jamshed Ali on 26/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import <UIKit/UIKit.h>

@interface PastDuePaymentViewController : UIViewController {
    
    IBOutlet UIScrollView *bgScrollView;
    
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *dateTimeLabel;
    IBOutlet UIImageView *startTimeImage;
    IBOutlet UILabel *dateStartTimeLabel;
    IBOutlet UIImageView *endDateImage;
    IBOutlet UILabel *dateEndTimeLabel;
    IBOutlet UILabel *dateMeetLocationLabel;
    IBOutlet UILabel *dateStatusLabel;
    IBOutlet UIView *chargeBreakDownHeaderView;
    IBOutlet UILabel *minimumDateAmount;//bAse fee
    IBOutlet UILabel *additionalTimeLabel;
    IBOutlet UILabel *addtionaltimeAmountLabel;//Addtional Time
    IBOutlet UILabel *subtotalLabel;//subtotal label
    IBOutlet UILabel *creditCardFeesAmountLabel;//Tips label
    IBOutlet UILabel *chargeBackFeesAmountLabel;//chargeBack fee
    IBOutlet UILabel *totalAmountLabel;//total Amount
    IBOutlet UIButton *payNowButton;
    IBOutlet UIView *sepeartorView;
    IBOutlet UIView *chargeBreakDownView;
    IBOutlet UIImageView *ratingImage;
    IBOutlet UILabel *ratingLabel;
    IBOutlet UILabel *chargeBreakdownLabelWithValue;
    IBOutlet UILabel *chargeBreakdownLabel;
    IBOutlet UIImageView *locationImage;
    IBOutlet UIImageView *statusImage;
}

@property(nonatomic,strong)NSMutableDictionary *pastDuePaymentDetailsDictionary;

- (IBAction)payNowMethodClicked:(id)sender;




@end
