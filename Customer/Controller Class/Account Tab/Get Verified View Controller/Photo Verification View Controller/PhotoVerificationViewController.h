
//  PhotoVerificationViewController.h
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface PhotoVerificationViewController : UIViewController <UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)proceedButtonClicked:(id)sender;

@property(nonatomic, strong) IBOutlet UILabel *step1Label;
@property(nonatomic, strong) IBOutlet UILabel *step2Label;
@property(nonatomic, strong) IBOutlet UILabel *step3Label;
@property(nonatomic, strong) IBOutlet UILabel *step4Label;
@property(nonatomic, strong) IBOutlet UIButton *proceedButton;


@end
