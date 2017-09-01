//
//  ImageCropViewController.h
//  Customer
//
//  Created by Sampurna on 13/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCropViewController : UIViewController {
    
    
}

@property(nonatomic,strong) IBOutlet UIImageView *cropImageView;

- (IBAction)backBtnClicked:(id)sender;
- (IBAction)cropDonebutton:(id)sender;
- (IBAction)rotateButton:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;



@end
