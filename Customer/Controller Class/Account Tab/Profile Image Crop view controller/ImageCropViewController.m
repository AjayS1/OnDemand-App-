//
//  ImageCropViewController.m
//  Customer
//
//  Created by Sampurna on 13/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "ImageCropViewController.h"
#import "PECropViewController.h"
#import "PECropView.h"
#import "AppDelegate.h"
@interface ImageCropViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, PECropViewControllerDelegate>

@property (nonatomic, retain) IBOutlet PECropView *cropper;

@end

@implementation ImageCropViewController
{
    BOOL checkAnimation;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    
    checkAnimation=NO;

    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = self.cropImageView.image;
    
    UIImage *image = self.cropImageView.image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    

   UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }

   [self presentViewController:navigationController animated:YES completion:NULL];

}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    self.cropImageView.image = croppedImage;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[self updateEditButtonEnabled];
    }
}
- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
     //   [self updateEditButtonEnabled];
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)updateEditButtonEnabled
{
   // self.editButton.enabled = !!self.imageView.image;
}

- (IBAction)backBtnClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cropDonebutton:(id)sender {
    
   
}

// Rotate a image view in 360 degree.
- (IBAction)rotateButton:(id)sender {

    static int numRot = 0;
    self.cropImageView.transform = CGAffineTransformMakeRotation(M_PI_2 * numRot);
    ++numRot;
    
}


- (IBAction)doneButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
