//
//  ProfileImageCropViewController.h
//  Customer
//
//  Created by Sampurna on 13/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECropViewController.h"

@interface ProfileImageCropViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    NSMutableArray *imageDataArray;
     UIImage* image;
    
    IBOutlet UIButton *makePrimaryButton;
    IBOutlet UIScrollView *bgScrollView;

}


@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *primaryButton;

@property (weak, nonatomic) IBOutlet UIButton *cropButton;
- (IBAction)makePrimaryButton:(id)sender;
- (IBAction)deleteButton:(id)sender;
- (IBAction)cropbutton:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)addImageButton:(id)sender;




@end
