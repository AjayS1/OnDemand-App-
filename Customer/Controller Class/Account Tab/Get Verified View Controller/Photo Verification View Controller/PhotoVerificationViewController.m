
//  PhotoVerificationViewController.m
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "PhotoVerificationViewController.h"

@interface PhotoVerificationViewController () {
    
    NSURL *videoPathUrl;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    UIImageView *videoImageView;
}
@end

@implementation PhotoVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    if (WIN_WIDTH == 320) {
        [self.step1Label adjustsFontSizeToFitWidth];
        
        self.step1Label.minimumScaleFactor = 12;
        self.step1Label.numberOfLines = 0;
        self.step1Label.lineBreakMode = NSLineBreakByWordWrapping;
        self.step1Label.textAlignment = NSTextAlignmentLeft;
        [self.step1Label sizeToFit];
        
        self.step2Label.minimumScaleFactor = 12;
        self.step2Label.numberOfLines = 0;
        self.step2Label.lineBreakMode = NSLineBreakByWordWrapping;
        self.step2Label.textAlignment = NSTextAlignmentLeft;
        [self.step2Label sizeToFit];
        
        self.step3Label.minimumScaleFactor = 12;
        self.step3Label.numberOfLines = 0;
        self.step3Label.lineBreakMode = NSLineBreakByWordWrapping;
        self.step3Label.textAlignment = NSTextAlignmentLeft;
        [self.step3Label sizeToFit];
        
        self.step4Label.minimumScaleFactor = 12;
        self.step4Label.numberOfLines = 0;
        self.step4Label.lineBreakMode = NSLineBreakByWordWrapping;
        self.step4Label.textAlignment = NSTextAlignmentLeft;
        [self.step4Label sizeToFit];
        
        self.step2Label.frame = CGRectMake(self.step2Label.frame.origin.x, self.step1Label.frame.origin.y+self.step1Label.frame.size.height+8, self.step2Label.frame.size.width, self.step2Label.frame.size.height);
        self.step3Label.frame = CGRectMake(self.step3Label.frame.origin.x, self.step2Label.frame.origin.y+self.step2Label.frame.size.height+8, self.step3Label.frame.size.width, self.step3Label.frame.size.height);
        self.step4Label.frame = CGRectMake(self.step4Label.frame.origin.x, self.step3Label.frame.origin.y+self.step3Label.frame.size.height+8, self.step4Label.frame.size.width, self.step4Label.frame.size.height);
        self.proceedButton.frame = CGRectMake(self.proceedButton.frame.origin.x, self.step4Label.frame.origin.y+self.step3Label.frame.size.height+25, self.proceedButton.frame.size.width, self.proceedButton.frame.size.height);

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)proceedButtonClicked:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    else
    {
        [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
    }
}

- (void)showcamera {
    
    UIImagePickerController *imagePickerCam = [[UIImagePickerController alloc] init];
    imagePickerCam.delegate = self;
    imagePickerCam.sourceType =
    UIImagePickerControllerSourceTypeCamera;
    imagePickerCam.cameraDevice=UIImagePickerControllerCameraDeviceFront;
    
    imagePickerCam.mediaTypes = [NSArray arrayWithObjects:
                                 (NSString *) kUTTypeMovie,
                                 nil];
    
    UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 60)];
    overlayView.backgroundColor = [UIColor blackColor];
    overlayView.alpha = 0.4;
    
    CBAutoScrollLabel *cameratitleLabel = [[CBAutoScrollLabel alloc] init];
    cameratitleLabel.text= [NSString stringWithFormat:@"PLEASE READ: Hi, I am %@ %@ on Doumees",sharedInstance.firstNameStr,sharedInstance.lastNameStr];
    float widthIs =   [cameratitleLabel.text
                       boundingRectWithSize:cameratitleLabel.frame.size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{ NSFontAttributeName:cameratitleLabel.font }
                       context:nil]
    .size.width;
    NSLog(@"the width of yourLabel is %f", widthIs)
    ;
    cameratitleLabel.center = overlayView.center;
    cameratitleLabel.frame = CGRectMake(20, 0, widthIs, 60);
    cameratitleLabel.textColor = [UIColor whiteColor];
    cameratitleLabel.backgroundColor=[UIColor clearColor];
    cameratitleLabel.labelSpacing = 30 ; // distance between start and end labels
    cameratitleLabel.pauseInterval = 1.7; // seconds of pause before scrolling starts again
    cameratitleLabel.scrollSpeed = 30; // pixels per second
    cameratitleLabel.textAlignment = NSTextAlignmentLeft; // centers text when no auto-scrolling is applied
    cameratitleLabel.fadeLength = 12.f;
    cameratitleLabel.scrollDirection = CBAutoScrollDirectionLeft;
    [cameratitleLabel observeApplicationNotifications];
    cameratitleLabel.userInteractionEnabled=NO;
    imagePickerCam.allowsEditing = NO;
    [overlayView addSubview:cameratitleLabel];
    [imagePickerCam.view addSubview:overlayView];
    [overlayView bringSubviewToFront:imagePickerCam.view];
    //The event handling method
    [self presentViewController:imagePickerCam animated:YES completion:nil];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Camera"]) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            [myAlertView show];
            
        }
        else {
            
            UIImagePickerController *imagePickerCam =
            [[UIImagePickerController alloc] init];
            imagePickerCam.delegate = self;
            imagePickerCam.sourceType =
            UIImagePickerControllerSourceTypeCamera;
            imagePickerCam.cameraDevice=UIImagePickerControllerCameraDeviceFront;
            imagePickerCam.modalPresentationStyle = UIModalPresentationCurrentContext;
            imagePickerCam.mediaTypes = [NSArray arrayWithObjects:
                                         (NSString *) kUTTypeMovie,
                                         nil];
            imagePickerCam.allowsEditing = NO;
            
            UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 60)];
            
            overlayView.backgroundColor = [UIColor blackColor];
            overlayView.alpha = 0.4;
            UILabel *cameratitleLabel = [[UILabel alloc] init];
            cameratitleLabel.textColor = [UIColor blackColor];
            cameratitleLabel.frame = CGRectMake(20, 0, self.view.frame.size.width-40, 60);
            cameratitleLabel.backgroundColor=[UIColor clearColor];
            cameratitleLabel.textColor=[UIColor whiteColor];
            cameratitleLabel.numberOfLines = 2;
            cameratitleLabel.userInteractionEnabled=NO;
            cameratitleLabel.text= [NSString stringWithFormat:@"PLEASE READ: Hi, I am %@ %@ on Doumees",sharedInstance.firstNameStr,sharedInstance.lastNameStr];
            [overlayView addSubview:cameratitleLabel];
            [imagePickerCam.view addSubview:overlayView];
            [overlayView bringSubviewToFront:imagePickerCam.view];
            [self presentViewController:imagePickerCam animated:YES completion:nil];
        }
    }
    
    if ([buttonTitle isEqualToString:@"Gallery"]) {
        
        //change at the time of build
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeMovie,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
}

- (void)touchUpInsideCMKShutterButton
{
    NSLog(@"Take");
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ( [mediaType isEqualToString:@"public.movie" ])
    {
        // picker.videoQuality=UIImagePickerControllerQualityTypeLow;
        picker.videoQuality=UIImagePickerControllerQualityType640x480;
        NSLog(@"Picked a movie at URL %@",  [info objectForKey:UIImagePickerControllerMediaURL]);
        videoPathUrl =  [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"> %@", [videoPathUrl absoluteString]);
        NSError *error;
        NSDictionary * properties = [[NSFileManager defaultManager] attributesOfItemAtPath:videoPathUrl.path error:&error];
        NSNumber * size = [properties objectForKey: NSFileSize];
        NSLog(@"Vide info :- %@",properties);
        NSLog(@"Video size :- %@",size);
        NSData * movieData = [NSData dataWithContentsOfURL:videoPathUrl];
        NSLog(@"Video............%.2f",(float)movieData.length/1024.0f/1024.0f);
        float videoSizeValue = (float)movieData.length/1024.0f/1024.0f;
        NSLog(@"typeStr %f",videoSizeValue);
        videoImageView = [[UIImageView alloc] init];
        //  [ProgressHUD show:@"Please Wait.."];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            videoImageView.image =[self thumbnailFromVideoAtURL:videoPathUrl];
            videoImageView.contentMode = UIViewContentModeScaleAspectFill;
            videoImageView.clipsToBounds =NO;
            //     [ProgressHUD dismiss];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                
                [self videoUploadApiCall];
                [picker dismissViewControllerAnimated:YES completion:NULL];

            });
        });
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (UIImage *)thumbnailFromVideoAtURL:(NSURL *)contentURL {
    
    UIImage *theImage = nil;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:contentURL options:nil];
    
    //   AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mediaURL options:nil];
    //   NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    //   AVAssetTrack *track = [tracks objectAtIndex:0];
    //   Then using the AVAssetTrack's naturalSize property:
    //   CGSize mediaSize = track.naturalSize;
    //   NSLog(@"track.naturalSize ...%@",track.naturalSize);
    //    NSLog(@"mediaSize file ...%@",mediaSize);
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
    theImage = [[UIImage alloc] initWithCGImage:imgRef] ;
    CGImageRelease(imgRef);
    return theImage;
}

- (void)videoUploadApiCall {
    
    if (videoPathUrl) {
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        NSString *userIdStr = sharedInstance.userId;
        NSString *mimeType;
        NSString *fileName;
        NSData *fileData;
        fileName =[NSString stringWithFormat:@"%@.mov",@"image"];
        fileData = [NSData dataWithContentsOfURL:videoPathUrl];
        mimeType =@"video/quicktime";
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@",@"http://www.doumees.com/api/ImgaeUploader/Post",userIdStr,@"UserVideo"];
        NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        [manager POST:encodedUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if(fileData){
                [formData appendPartWithFileData:fileData
                                            name:@"image"
                                        fileName:fileName
                                        mimeType:mimeType];
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [ProgressHUD dismiss];
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                             andButtonsWithTitle:@[@"OK"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                       if ([buttonTitle isEqualToString:@"OK"]) {
                                                           AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                                                           accountView.isFromOrderProcess = YES;
                                                           accountView.isFromUpdateMobileNumber = NO;
                                                           accountView.isFromCreditCardProcess = NO;
                                                           accountView.isEmailVerifiedOrNotPage = NO;
                                                           [self.navigationController pushViewController:accountView animated:NO];
                                                       }
                                                       // [self.navigationController popViewControllerAnimated:YES];
                                                   }];
            }
            
            else {
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
            
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  [ProgressHUD dismiss];
              }];
    }
}


@end
