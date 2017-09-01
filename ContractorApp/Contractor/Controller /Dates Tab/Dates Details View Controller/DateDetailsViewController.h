
//  DateDetailsViewController.h
//  Customer
//  Created by Jamshed Ali on 10/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import <CoreLocation/CoreLocation.h>
#import "MBSliderView.h"

@interface DateDetailsViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UIScrollViewDelegate,MBSliderViewDelegate> {
    
    IBOutlet UIScrollView *bgScrollView;
    IBOutlet UILabel *likeDetailsLbl;
    IBOutlet UILabel *datingTitleLbl;
    IBOutlet UILabel *imageCountLabel;
    IBOutlet UILabel *datingDetailsLbl;
    IBOutlet UILabel *availaibleLabel;
    IBOutlet UIImageView *previewImageView;
    IBOutlet UILabel *seperatorLabel;

    IBOutlet UICollectionView *imageCollectionView;
    
    IBOutlet UILabel *customerNameLabel;
    IBOutlet UILabel *bodySizeLabel;
    IBOutlet UIImageView *favouriteImageView;
    IBOutlet UILabel *distanceLabel;
    
    IBOutlet UIImageView *photoVerified;
    IBOutlet UIImageView *idVerified;
    IBOutlet UIImageView *backgroundVerified;
    
    IBOutlet UIView *profileView;
    IBOutlet UIView *dateInforamtionView;
    
    IBOutlet UILabel *bodyTypeLabel;
    IBOutlet UILabel *weightLabel;
    IBOutlet UILabel *hairLabel;
    IBOutlet UILabel *eyeColorLabel;
    IBOutlet UILabel *smokingLabel;
    IBOutlet UILabel *drinkingLabel;
    IBOutlet UILabel *educationLabel;
    IBOutlet UILabel *languageLabel;
    IBOutlet UILabel *dateStatusLabel;
    IBOutlet UILabel *dateTimeLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *notesLabel;
    
    IBOutlet UILabel *notesTitleLabel;
    IBOutlet UILabel *onDemandTimerLabel;
    
    IBOutlet UIButton *dateInfoButton;
    IBOutlet UIButton *profileButton;
    
    IBOutlet UILabel *photoVerificationLabel;
    IBOutlet UILabel *idVerificationLabel;
    IBOutlet UILabel *backgroundVerificationLabel;

    IBOutlet UIButton *declineOrRejectBuuton;
    IBOutlet UIButton *acceptOrMessageButton;
    
    IBOutlet UIButton *confirmButton;
    IBOutlet UIButton *startDateButton;
    IBOutlet UIButton *endDateButton;
    IBOutlet UIButton *ontheWayButton;

    IBOutlet UILabel *dateTitleLabel;
    IBOutlet UIButton *backButton;
    
    IBOutlet UIImageView *notesImageView;
    IBOutlet UIImageView *eventImageView;
    IBOutlet UIImageView *locationImageView;
    IBOutlet UIImageView *dateImageView;

    
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property(strong,nonatomic)NSString *dateIdStr;
@property (nonatomic, strong) CLGeocoder* geocoder;
@property (strong, nonatomic) IBOutlet UILabel *imageCountLabel;

@property(strong,nonatomic)NSString *dateTypeStr;
@property(strong,nonatomic)NSString *dateRequestTypeStr;
@property(assign)BOOL isFromOnDemandRequest;


@property (strong, nonatomic)  UIView *endDateView;
@property (strong, nonatomic)  UIView *startDateView;
@property (strong, nonatomic)  UIView *confirmArrivedView;

- (IBAction)backBtnClicked:(id)sender;

- (IBAction)doumeePriceButtonClicked:(id)sender;
- (IBAction)settingsButtonClicked:(id)sender;

- (IBAction)dateInformationAction:(id)sender;
- (IBAction)profileAction:(id)sender;

//@property(strong,nonatomic)NSString *dateIdStr;

- (IBAction)declineDateRequestButtonClicked:(id)sender;
- (IBAction)acceptDateRequestButtonClicked:(id)sender;

//- (IBAction)confirmButtonClicked:(id)sender;
//- (IBAction)startDateButtonClicked:(id)sender;
//- (IBAction)endDateButtonClicked:(id)sender;



@end
