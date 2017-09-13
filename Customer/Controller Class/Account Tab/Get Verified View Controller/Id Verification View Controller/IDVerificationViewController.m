
//  IDVerificationViewController.m
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "IDVerificationViewController.h"

@interface IDVerificationViewController () {
    
    SingletonClass *sharedInstance;
    NSString *userIdStr;
}

@end

@implementation IDVerificationViewController

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
        
        self.idVerificationLabel.minimumScaleFactor = 12;
        self.idVerificationLabel.numberOfLines = 0;
        self.idVerificationLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.idVerificationLabel.textAlignment = NSTextAlignmentLeft;
        [self.idVerificationLabel sizeToFit];
        self.idVerificationLabel.frame = CGRectMake(self.idVerificationLabel.frame.origin.x, self.idVerificationLabel.frame.origin.y+8, self.idVerificationLabel.frame.size.width, self.idVerificationLabel.frame.size.height+5);
       profileImageView.frame = CGRectMake(profileImageView.frame.origin.x, self.idVerificationLabel.frame.origin.y+self.idVerificationLabel.frame.size.height+35, profileImageView.frame.size.width, profileImageView.frame.size.height);
       photoButton.frame = CGRectMake(photoButton.frame.origin.x, self.idVerificationLabel.frame.origin.y+self.idVerificationLabel.frame.size.height+35, photoButton.frame.size.width, photoButton.frame.size.height);
      
    _uploadLabel.frame = CGRectMake(_uploadLabel.frame.origin.x, self.idVerificationLabel.frame.origin.y+self.idVerificationLabel.frame.size.height+65, _uploadLabel.frame.size.width, _uploadLabel.frame.size.height);
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)uploadPhotoButtonClicked:(id)sender {
    
    NSString *actionSheetTitle = @"Select";
    NSString *other1 = @"Camera";
    NSString *other2 = @"Gallery";
    NSString *cancelTitle = @"Cancel Button";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
                                                             delegate:self
                                                    cancelButtonTitle:cancelTitle
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:other1, other2 ,nil];
    [actionSheet showInView:self.view];
}

#pragma mark Photo Get From photo library and Camera

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
        else{
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
        
    }
    if ([buttonTitle isEqualToString:@"Gallery"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    photoButton.layer.cornerRadius = 61;
    photoButton.clipsToBounds = YES;
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    profileImageView.image = image;
    [_uploadLabel setHidden:YES];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    // cameraImageView.hidden = YES;
    
}


- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonClicked:(id)sender {
    
    
    if (profileImageView.image) {
        
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        
        //    NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
        
        NSString *mimeType;
        NSString *fileName;
        NSData *fileData;
        
        fileName =[NSString stringWithFormat:@"%@.jpeg",@"image"];
        fileData =UIImageJPEGRepresentation(profileImageView.image, 1.0);
        mimeType =@"image/jpeg";
        
        
        //        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@",@"http://ondemandapp.flexsin.in/api/ImgaeUploader/Post",userIdStr,@"UserDocument"];
        
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@",@"http://api.doumees.com/api/ImgaeUploader/Post",userIdStr,@"UserDocument"];
        NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        
        [manager POST:encoded parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
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
                                                       AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                                                       accountView.isFromOrderProcess = YES;
                                                       accountView.isEmailVerifiedOrNotPage = NO;
                                                       accountView.isFromUpdateMobileNumber = NO;
                                                       accountView.isFromCreditCardProcess = NO;
                                                       [self.navigationController pushViewController:accountView animated:NO];
                                                   }];
                
                
            } else {
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [ProgressHUD dismiss];
            
        }];
        
    } else {
        
        [CommonUtils showAlertWithTitle:@"Alert!" withMsg:@"Please upload the image." inController:self];
    }
    
}
@end
