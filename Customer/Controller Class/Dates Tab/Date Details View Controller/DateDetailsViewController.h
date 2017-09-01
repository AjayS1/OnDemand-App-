
//  DateDetailsViewController.h
//  Customer
//  Created by Jamshed Ali on 10/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface DateDetailsViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    
    IBOutlet UIScrollView *bgScrollView;

    IBOutlet UICollectionView *imageCollectionView;
    IBOutlet UILabel *customerNameLabel;
    IBOutlet UILabel *bodySizeLabel;
    IBOutlet UIImageView *favouriteImageView;
    IBOutlet UILabel *distanceLabel;
    
    IBOutlet UIImageView *photoVerified;
    IBOutlet UIImageView *idVerified;
    IBOutlet UIImageView *backgroundVerified;
    
    IBOutlet UILabel *dateTimeLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *notesLabel;
    IBOutlet UILabel *dateStatusLabel;
    
    IBOutlet UILabel *photoVerificationLabel;
    IBOutlet UILabel *idVerificationLabel;
    IBOutlet UILabel *backgroundVerificationLabel;

    IBOutlet UILabel *distanceOfContractorLabel;
    IBOutlet UILabel *timeOfContractorLabel;
   
    IBOutlet UILabel *titleNameLabel;
    IBOutlet UIButton *favouriteButton;
    
    IBOutlet UIButton *cancelDateButton;
    IBOutlet UIButton *messageButton;
    IBOutlet UIView *cancelDateBgView;
    
    IBOutlet UIView *profileView;
    IBOutlet UIView *dateInforamtionView;
    
    IBOutlet UIButton *dateInfoButton;
    IBOutlet UIButton *requestToEndDate;
    IBOutlet UIButton *contractorTypeButton;
    
    IBOutlet UILabel *likeDetailsLbl;
    IBOutlet UILabel *datingTitleLbl;
    IBOutlet UILabel *imageCountLabel;
    IBOutlet UILabel *datingDetailsLbl;
    IBOutlet UILabel *availaibleLabel;
    IBOutlet UIImageView *previewImageView;
    
    IBOutlet UIImageView *notesImageView;
    IBOutlet UIImageView *eventImageView;
    IBOutlet UIImageView *dateImageView;

    
}

@property(strong,nonatomic)NSString *statusTypeStr;
@property(strong,nonatomic)NSString *contractorIdStr;
@property(strong,nonatomic)NSString *dateIdStr;
@property(strong,nonatomic)NSString *dateTypeStr;
@property(assign)BOOL isFromRequestNow;

@property (strong, nonatomic) IBOutlet UILabel *imageCountLabel;

- (IBAction)backBtnClicked:(id)sender;
- (IBAction)requestBtnClicked:(id)sender;
- (IBAction)reserveHerBrnClicked:(id)sender;
- (IBAction)profileImageClicked:(id)sender;
- (IBAction)doumeePriceButtonClicked:(id)sender;
- (IBAction)settingsButtonClicked:(id)sender;

- (IBAction)dateInformationAction:(id)sender;
- (IBAction)profileAction:(id)sender;
- (IBAction)favouriteClicked:(id)sender;



 
@end
