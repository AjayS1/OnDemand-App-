//
//  PastDateDetailsViewController.h
//  Customer
//
//  Created by Jamshed Ali on 10/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    DATECANCELBYCONTRCTOR,
    DATECANCELBYCUSTOMER,
    DATECANCELBYCONTRCTORWITHFEE,
    DATECANCELBYCUSTOMERWITHFEE,
    DATECOMPLETEDWITHRATING,
    DATECOMPLETEDWITHOUTRATING
}
PastDateDetailsList;
@interface PastDateDetailsViewController : UIViewController {
    
    IBOutlet UIScrollView *bgScrollView;
    IBOutlet UIButton *needHelpButton;
    IBOutlet UIButton *needHelpSecondButton;

    IBOutlet UIImageView *userImage;
    
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *datelabel;
    IBOutlet UILabel *locationLabel;
    IBOutlet UILabel *statusLabel;
    
    IBOutlet UILabel *minimumAmountLabel;
    IBOutlet UILabel *additonalTimeLabel;
    IBOutlet UILabel *subtotalLabel;
    IBOutlet UILabel *subtotaTitlelLabel;
    IBOutlet UILabel *tipAmountTitlelLabel;

    IBOutlet UILabel *creditCardFeesLabel;
    IBOutlet UILabel *sepeartorLabel;

    IBOutlet UILabel *chargeBackFeesLabel;
    IBOutlet UILabel *chargeBackFeesTitleLabel;
    IBOutlet UIView *seperatorDownTitleView;
    IBOutlet UIView *seperatorDownSecondTitleView;

    IBOutlet UILabel *totalAmountLabel;
    IBOutlet UILabel *totalAmountTitleLabel;

    IBOutlet UILabel *cardNumberLabel;
    IBOutlet UILabel *cardNumberTitleLabel;

    IBOutlet UILabel *paidDirectlyToUser;
    
    IBOutlet UILabel *dateStartTimeLabel;
    IBOutlet UILabel *dateEndTimeLabel;
    
    IBOutlet UIView *chargeBreakDownView;
    IBOutlet UILabel *additionalTitleTimeLabel;
    
    IBOutlet UILabel *durationTitleLabel;
    IBOutlet UILabel *durationTimeValueLabel;
    
    IBOutlet UIImageView *greenStartImage;
    
    IBOutlet UIImageView *redEndImage;
    
    
    IBOutlet UIImageView *reservationTimeImage;
    
    IBOutlet UIImageView *locationImage;
    IBOutlet UIImageView *statusImage;
    
    IBOutlet UIImageView *ratingImage;
    
    IBOutlet UIView *seperatorDownView;

    IBOutlet UILabel *locationTitleLabel;
    IBOutlet UILabel *statusTitleLabel;
    IBOutlet UILabel *breakDownCompleteLabel;
    
    //cancellationfee Customer View
    IBOutlet UIView *cancellationFeeView;
    IBOutlet UILabel *cancellationFeeLabel;
    IBOutlet UILabel *subTotalLabel;
    IBOutlet UILabel *doumeesFeeLabel;
    IBOutlet UILabel *transactionFeeLabel;
    IBOutlet UILabel *totalEarningsLabelTitle;
    IBOutlet UILabel *totalEarningsLabel;
    IBOutlet UILabel *breakDownLabel;
    IBOutlet UILabel *breakDownLabelWithStatus;
    IBOutlet UILabel *tipsCompleteLabel;
    IBOutlet UIButton *rateYourDateButton;
    IBOutlet UILabel *cardStatusTypeLabel;
    IBOutlet UILabel *cardPaymentStatusTypeLabel;
    IBOutlet UILabel *breakDownLabelWithStatusComplete;

    __weak IBOutlet UILabel *breakDownlabelWithCharging;

}

//@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollView;
//@property (strong, nonatomic) IBOutlet UIButton *needHelpButton;
//@property(strong,nonatomic)NSString *dateIdStr;
//
//- (IBAction)backButtonClicked:(id)sender;

@property(nonatomic,strong)NSString *dateIdStr;
@property(strong,nonatomic)NSString *dateTypeStr;
@property (strong, nonatomic) NSString *dateRequestedType;
@property(nonatomic) PastDateDetailsList theDateState;
@property(strong,nonatomic)NSString *userNameStr;
@property(strong,nonatomic)NSString *picUrlStr;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)needHelpButtonClicked:(id)sender;
- (void)showProperList:(PastDateDetailsList)mode;
- (IBAction)rateYourDateButtonClicked:(id)sender;


@end
