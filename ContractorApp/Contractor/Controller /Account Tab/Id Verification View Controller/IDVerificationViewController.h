
//  IDVerificationViewController.h
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface IDVerificationViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate> {
    
    IBOutlet UIButton *photoButton;
     IBOutlet UIImageView *profileImageView;
}


- (IBAction)uploadPhotoButtonClicked:(id)sender;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;
@end
