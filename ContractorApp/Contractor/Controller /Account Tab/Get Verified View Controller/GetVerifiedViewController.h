
//  GetVerifiedViewController.h
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface GetVerifiedViewController : UIViewController {
    
   IBOutlet UIImageView *photoVerifyImageView;
   IBOutlet UIImageView *idVerificationImageView;
   IBOutlet UIImageView *backgroundCheckImageView;
    
    IBOutlet UIButton *photoVerificationButton;
    IBOutlet UIButton *idVerificationButton;
    
    IBOutlet UIButton *backgroundCheckedButton;
    
    
}

//@property (strong, nonatomic) IBOutlet UIImageView *photoVerifyImageView;

//@property (strong, nonatomic) IBOutlet UIImageView *backgroundCheckImageView;


- (IBAction)backButtonClicked:(id)sender;

- (IBAction)photoVerificationButtonClicked:(id)sender;

- (IBAction)idVerificationButtonCLicked:(id)sender;

- (IBAction)backgorundChecked:(id)sender;





@end
