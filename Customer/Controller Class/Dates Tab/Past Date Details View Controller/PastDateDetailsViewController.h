//
//  PastDateDetailsViewController.h
//  Customer
//
//  Created by Jamshed Ali on 10/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastDateDetailsViewController : UIViewController {
    
    IBOutlet UIScrollView *bgScrollView;
    IBOutlet UIButton *needHelpButton;
    IBOutlet UIImageView *userImage;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *datelabel;
    IBOutlet UILabel *locationLabel;
    IBOutlet UILabel *statusLabel;
    IBOutlet UILabel *minimumAmountLabel;
    IBOutlet UILabel *additonalTimeLabel;
    IBOutlet UILabel *subtotalLabel;
    IBOutlet UILabel *creditCardFeesLabel;
    IBOutlet UILabel *chargeBackFeesLabel;
    IBOutlet UILabel *totalAmountLabel;
    IBOutlet UILabel *cardNumberLabel;
    IBOutlet UILabel *paidDirectlyToUser;
    IBOutlet UILabel *dateStartTimeLabel;
    IBOutlet UILabel *dateEndTimeLabel;
    IBOutlet UIView *chargeBreakDownView;
    IBOutlet UILabel *additionalTitleTimeLabel;
    IBOutlet UILabel *creditCardTitleLabel;
    IBOutlet UILabel *paymentMethodLabel;
    IBOutlet UILabel *totalTitleLabel;
    IBOutlet UILabel *totalTitleSeperatorLabel;
    IBOutlet UILabel *chargeBackTitleLabel;
    IBOutlet UIImageView *greenStartImage;
    IBOutlet UILabel *sepeartorLabel;

    IBOutlet UIImageView *redEndImage;
    
    
    IBOutlet UIImageView *reservationTimeImage;
    
    IBOutlet UIImageView *locationImage;
    IBOutlet UIImageView *dateImage;

    IBOutlet UIImageView *statusImage;
    
    IBOutlet UIImageView *ratingImage;
    
    IBOutlet UILabel *durationTitleLabel;
    IBOutlet UILabel *durationTimeValueLabel;
    IBOutlet UILabel *breakdownChargeBackTitleLabel;
    IBOutlet UILabel *breakdownChargeBackLabel;
    
    IBOutlet UIView *seperatorDownView;
    
    //cancellationfee Customer View
    IBOutlet UIView *cancellationFeeView;
    IBOutlet UIView *mainHistoryDetailsView;

    IBOutlet UILabel *cancellationFeeLabel;
    IBOutlet UILabel *subTotalLabel;
    IBOutlet UIButton *needHelpSecondButton;

    IBOutlet UILabel *totalEarningsLabelTitle;
    IBOutlet UILabel *totalEarningsSeperatorLabel;

    IBOutlet UILabel *totalEarningsLabel;
    IBOutlet UILabel *breakDownLabel;
    IBOutlet UILabel *breakDownLabelWithStatus;
    IBOutlet UILabel *cardStatusTypeLabel;
    IBOutlet UIView *completeFeeViewWithCancellationCharges;

    //caompletedPayment Customer View
    IBOutlet UIView *completeFeeView;
    IBOutlet UILabel *completeBaseFeeLabel;
    IBOutlet UILabel *subTotalCompleteLabel;
    IBOutlet UIButton *needHelpThirdButton;
    IBOutlet UILabel *totalEarningsCompleteLabelTitle;
    IBOutlet UILabel *totalEarningsCompleteSeperatorLabel;

    IBOutlet UILabel *totalEarningsCompleteLabel;
    IBOutlet UILabel *breakDownCompleteLabel;
    IBOutlet UILabel *breakDownCompleteLabelWithStatus;
    IBOutlet UILabel *cardStatusCompleteTypeLabel;
    IBOutlet UILabel *tipsCompleteLabel;
    IBOutlet UILabel *discountCompleteLabelTitle;
    IBOutlet UILabel *discountCompleteLabel;
    IBOutlet UILabel *couponCodeCompleteLabel;
    IBOutlet UIButton *rateYourDateButton;


}

@property(nonatomic,strong)NSString *dateIdStr;
@property(strong,nonatomic)NSString *dateTypeStr;
@property(strong,nonatomic)NSString *userNameStr;
@property (strong, nonatomic) NSString *dateRequestType;
@property(strong,nonatomic)NSString *picUrlStr;


- (IBAction)backButtonClicked:(id)sender;
- (IBAction)needHelpButtonClicked:(id)sender;
- (IBAction)needHelpThirdButtonClicked:(id)sender;
- (IBAction)needHelpSecondButtonClicked:(id)sender;

- (IBAction)rateYourDateButtonClicked:(id)sender;
@end
