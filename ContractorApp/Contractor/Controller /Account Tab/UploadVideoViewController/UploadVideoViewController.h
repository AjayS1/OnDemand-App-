//
//  UploadVideoViewController.h
//  Contractor
//
//  Created by Kirti Rai on 19/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadVideoViewController : UIViewController {
    
    IBOutlet UIImageView *imageView;
}
@property(strong,nonatomic) UIImageView *imageViewTumbnail;
@property(strong,nonatomic) NSURL *videoPathUrl;

- (IBAction)submitVideoBtnClicked:(id)sender;
- (IBAction)ReRecordBtnClicked:(id)sender;
- (IBAction)cancelBtnClicked:(id)sender;

@end
