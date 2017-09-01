
//  OnDemandDatePushNotificationViewController.h
//  Contractor
//  Created by Jamshed Ali on 08/09/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface OnDemandDatePushNotificationViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate> {
    
    IBOutlet UIScrollView *bgScrollView;
    IBOutlet UILabel *likeDetailsLbl;
    IBOutlet UILabel *datingTitleLbl;

    IBOutlet UILabel *datingDetailsLbl;
    IBOutlet UILabel *availaibleLabel;
    IBOutlet UIImageView *previewImageView;
    
    IBOutlet UICollectionView *imageCollectionView;
    
    IBOutlet UILabel *customerNameLabel;
    IBOutlet UILabel *bodySizeLabel;
    IBOutlet UIImageView *favouriteImageView;
    IBOutlet UILabel *distanceLabel;
    
    IBOutlet UIImageView *photoVerified;
    IBOutlet UIImageView *idVerified;
    IBOutlet UIImageView *backgroundVerified;
    IBOutlet UILabel *photoVerificationLabel;
    IBOutlet UILabel *idVerificationLabel;
    IBOutlet UILabel *backgroundVerificationLabel;

    IBOutlet UIView *profileView;
     IBOutlet UIView *seperatorView;
    IBOutlet UIView *dateInforamtionView;
    
    IBOutlet UILabel *bodyTypeLabel;
    IBOutlet UILabel *weightLabel;
    IBOutlet UILabel *hairLabel;
    IBOutlet UILabel *eyeColorLabel;
    IBOutlet UILabel *smokingLabel;
    IBOutlet UILabel *drinkingLabel;
    IBOutlet UILabel *educationLabel;
    IBOutlet UILabel *languageLabel;
    
    IBOutlet UILabel *dateTimeLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *notesLabel;
    
    IBOutlet UIImageView *notesImageView;
    IBOutlet UIImageView *locationImageView;
    IBOutlet UIImageView *dateImageView;

    IBOutlet UILabel *onDemandTimerLabel;
    
    IBOutlet UIButton *dateInfoButton;
    IBOutlet UIButton *profileButton;
    IBOutlet UIButton *declineOrRejectBuuton;
    IBOutlet UIButton *acceptOrMessageButton;
    IBOutlet UIButton *confirmButton;
    IBOutlet UIButton *startDateButton;
    IBOutlet UIButton *endDateButton;
    IBOutlet UILabel *dateTitleLabel;
    IBOutlet UIButton *backButton;
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property(strong,nonatomic)NSString *dateIdStr;
@property(strong,nonatomic)NSString *dateTypeStr;
@property(strong,nonatomic)NSString *dateRequestTypeStr;

- (IBAction)backBtnClicked:(id)sender;
- (IBAction)settingsButtonClicked:(id)sender;
- (IBAction)dateInformationAction:(id)sender;
- (IBAction)profileAction:(id)sender;
- (IBAction)declineDateRequestButtonClicked:(id)sender;
- (IBAction)acceptDateRequestButtonClicked:(id)sender;

@end
