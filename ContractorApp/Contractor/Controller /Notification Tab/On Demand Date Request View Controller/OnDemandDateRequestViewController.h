//
//  OnDemandDateRequestViewController.h
//  Contractor
//
//  Created by Jamshed Ali on 19/07/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
@interface OnDemandDateRequestViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    
    IBOutlet UIScrollView *bgScrollView;
    IBOutlet UILabel *likeDetailsLbl;
    IBOutlet UILabel *datingTitleLbl;
    IBOutlet UILabel *imageCountLabel;
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
    
    IBOutlet UILabel *dateTimeLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *notesLabel;
    
    IBOutlet UIButton *dateInfoButton;
    IBOutlet UIButton *profileButton;
}


@property(strong,nonatomic)NSString *dateIdStr;
@property (strong, nonatomic) IBOutlet UILabel *imageCountLabel;

- (IBAction)backBtnClicked:(id)sender;
- (IBAction)requestBtnClicked:(id)sender;
- (IBAction)reserveHerBrnClicked:(id)sender;
- (IBAction)profileImageClicked:(id)sender;
- (IBAction)doumeePriceButtonClicked:(id)sender;
- (IBAction)settingsButtonClicked:(id)sender;

- (IBAction)dateInformationAction:(id)sender;
- (IBAction)profileAction:(id)sender;

@end
