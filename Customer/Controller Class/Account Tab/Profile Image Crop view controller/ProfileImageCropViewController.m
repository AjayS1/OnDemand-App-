//
//  ProfileImageCropViewController.m
//  Customer
//
//  Created by Sampurna on 13/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "ProfileImageCropViewController.h"

static NSString *isPrimaryPhotoOrNot;

#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@interface ProfileImageCropViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, PECropViewControllerDelegate,TOCropViewControllerDelegate> {
    
    NSArray * imageArray;
    NSString *photoIdStr;
    NSString *isPrimary;
    BOOL primarySlectedValue;
    
    NSString *isPrimaryValue;
    NSString *defaultImage ;
    NSString *imageName;
    BOOL imageUpload;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    ALAlertBanner *banner;
    BOOL isPrimaryPhoto;
    NSInteger imageSelctedIndex;
    NSInteger photoStatus;
    NSArray *masterArray;
    UIImage *img;
}

@property (weak, nonatomic) IBOutlet UILabel *dontHaveLabel;
@property (weak, nonatomic) IBOutlet UILabel *addPhotoLabel;
@property (nonatomic, assign) TOCropViewCroppingStyle croppingStyle;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *croppedImage;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *cropButtonLayer;
@property (nonatomic, assign) NSInteger angle;

@property (nonatomic, assign) CGRect croppedFrame;

@property (weak, nonatomic) IBOutlet UIImageView *photosImageView;

@end

@implementation ProfileImageCropViewController
@synthesize previewImageView;
#pragma mark: UIViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.cropButtonLayer.layer.borderWidth = 1.0;
    self.cropButtonLayer.layer.borderColor =([UIColor colorWithRed:166.0/255.0 green:110.0/255.0 blue:171.0/255.0 alpha:0.8]).CGColor;
    self.cropButtonLayer.clipsToBounds = YES;
    [self.cropButtonLayer.layer setMasksToBounds:YES];
    self.statusLabel.layer.borderWidth = 0.0;
    self.statusLabel.clipsToBounds = YES;
    self.statusLabel.layer.cornerRadius = 5.0f;
    [self.statusLabel.layer setMasksToBounds:YES];
    [_statusLabel setHidden:YES];
    [self.dontHaveLabel setHidden:NO];
    [self.photosImageView setHidden:NO];
    [self.addPhotoLabel setHidden:NO];
    [self.imageCollectionView setHidden : YES];
    [_statusLabel setHidden:YES];
    _cropButtonLayer.hidden = YES;
    _arrowImageView.hidden = YES;
    [self.previewImageView setHidden:YES];
    [makePrimaryButton setHidden:YES];
    [self.deleteButton setHidden:YES];
    [self.cropButton setHidden:YES];
    [self.cropButton setHidden:YES];
    [self viewDidLayoutSubviews];
    // [self.imageCollectionView reloadData];
    
    imageSelctedIndex = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    
    sharedInstance = [SingletonClass sharedInstance];
    imageDataArray = [[NSMutableArray alloc]init];
    bgScrollView.delegate =self;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (banner) {
        [banner hide];
    }
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    userIdStr = sharedInstance.userId;
    [_activityView setHidden:YES];
    primarySlectedValue = NO;
    [self.dontHaveLabel setHidden:YES];
    [self.addPhotoLabel setHidden:YES];
    
    if (APPDELEGATE.hubConnection)
    {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    //[self.photosImageView setHidden:YES];
    [_statusLabel setHidden:YES];
    [self.dontHaveLabel setHidden:NO];
    [self.photosImageView setHidden:NO];
    [self.addPhotoLabel setHidden:NO];
    [self.imageCollectionView setHidden : YES];
    [_statusLabel setHidden:YES];
    _cropButtonLayer.hidden = YES;
    _arrowImageView.hidden = YES;
    [self.previewImageView setHidden:YES];
    [makePrimaryButton setHidden:YES];
    [self.deleteButton setHidden:YES];
    [self.cropButton setHidden:YES];
    [self.cropButton setHidden:YES];
    [self viewDidLayoutSubviews];
    [self.imageCollectionView reloadData];
    //  [self.previewImageView setHidden:YES];
    self.cropButton.imageEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 10);
    self.cropButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self userListPhotoAPICall];
    
}

#pragma mark: UIScroll View Layout
-(void)viewDidLayoutSubviews

{
    if (WIN_WIDTH == 320) {
        if (imageDataArray.count) {
            bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+180);
            
        }
        else{
            bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
            
        }
        
    }
    else
    {
        if (imageDataArray.count) {
            bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+50);
        }
        else{
            bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
            
        }
    }
}


#pragma mark: UICollection View delagate methode
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([imageDataArray count]) {
        return [imageDataArray count];
        
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    cell =nil;
    
    if(cell ==nil) {
        
        cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    }
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    NSDictionary *dict = [imageDataArray objectAtIndex:indexPath.row];
    NSString *imageData = [dict valueForKey:@"PicUrl"];
    NSURL *imageUrl = [NSURL URLWithString:imageData];
    [recipeImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    [recipeImageView sd_setImageWithURL:imageUrl
    //                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [cell.backgroundView addSubview:recipeImageView];
    
    if (cell.selected) {
        recipeImageView.layer.borderWidth = 2.0;
        recipeImageView.layer.borderColor = [UIColor whiteColor].CGColor; // highlight selection
    }
    else
    {
        recipeImageView.layer.borderColor = [UIColor clearColor].CGColor; // Default color
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (imageDataArray.count) {
        
        [self.dontHaveLabel setHidden:YES];
        [self.imageCollectionView setHidden:NO];
        [self.addPhotoLabel setHidden:YES];
        [self.photosImageView setHidden:YES];
        NSDictionary *dictOfStatus = [masterArray objectAtIndex:indexPath.row];
        photoStatus = [[dictOfStatus objectForKey:@"Status"] integerValue];
        UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
        UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
        recipeImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        recipeImageView.layer.borderWidth = 2.0;
        [self.previewImageView setHidden:NO];
        [makePrimaryButton setHidden:NO];
        [self.deleteButton setHidden:NO];
        [self.cropButton setHidden:NO];
        NSDictionary *dict = [imageDataArray objectAtIndex:indexPath.row];
        NSString *statusValue = [NSString stringWithFormat:@"%@",[dictOfStatus valueForKey:@"Status"]];
        if ([statusValue isEqualToString:@"1"])
        {
            [_statusLabel setText:@"Approved"];
        }
        else{
            [_statusLabel setText:@"Pending"];
        }
        imageSelctedIndex =indexPath.row;
        NSString *imageData = [dict valueForKey:@"PicUrl"];
        NSURL *imageUrl = [NSURL URLWithString:imageData];
        [previewImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        photoIdStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"ID"]];
        isPrimary = [NSString stringWithFormat:@"%@",[dict valueForKey:@"isPrimary"]];
        imageName = [NSString stringWithFormat:@"%@",[dict valueForKey:@"PicName"]];
        
        if ([isPrimary isEqualToString:@"1"]) {
            [makePrimaryButton setHidden:NO];
            makePrimaryButton.backgroundColor = [UIColor whiteColor];
            [makePrimaryButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            makePrimaryButton.titleLabel.textColor = [UIColor grayColor];
            makePrimaryButton.titleLabel.text =@"PRIMARY PHOTO";
            [makePrimaryButton setTitle:@"PRIMARY PHOTO" forState:UIControlStateNormal];
            [_deleteButton setHidden:NO];
            [_deleteButton setHidden:NO];
            [_cropButton setHidden:NO];
            [_cropButtonLayer setHidden:NO];

//            [_cropButton setFrame:_deleteButton.frame];
//            [_cropButtonLayer setFrame:_deleteButton.frame];
            [_arrowImageView setFrame:CGRectMake(_arrowImageView.frame.origin.x, _deleteButton.frame.origin.y+7, _arrowImageView.frame.size.width, _arrowImageView.frame.size.height)];
            
            
        }
        else {
            [makePrimaryButton setHidden:NO];
            
            //makePrimaryButton.backgroundColor = [UIColor whiteColor];
            [makePrimaryButton setBackgroundColor:[UIColor colorWithRed:132/255.0 green:90/255.0 blue:140/255.0 alpha:1.0]];
            [makePrimaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            makePrimaryButton.titleLabel.textColor = [UIColor whiteColor];
            makePrimaryButton.titleLabel.text =@"MAKE PRIMARY";
            [makePrimaryButton setTitle:@"MAKE PRIMARY" forState:UIControlStateNormal];
            [_deleteButton setHidden:NO];
            [_cropButton setFrame:CGRectMake(_deleteButton.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+10,_deleteButton.frame.size.width, _deleteButton.frame.size.height)];
            [_cropButtonLayer setFrame:CGRectMake(_deleteButton.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+10,_deleteButton.frame.size.width, _deleteButton.frame.size.height)];
            [_arrowImageView setFrame:CGRectMake(_arrowImageView.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+17, _arrowImageView.frame.size.width, _arrowImageView.frame.size.height)];
            
        }
        //[self.imageCollectionView reloadData];
        
    }
    else
    {
        [self.dontHaveLabel setHidden:NO];
        [self.imageCollectionView setHidden:YES];
        [self.addPhotoLabel setHidden:NO];
        [self.photosImageView setHidden:NO];
        [self.previewImageView setHidden:YES];
        [makePrimaryButton setHidden:YES];
        [self.deleteButton setHidden:YES];
        [self.cropButton setHidden:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.layer.borderColor = [UIColor clearColor].CGColor;
    recipeImageView.layer.borderWidth = 1.0;
    cell.backgroundColor = [UIColor clearColor];
}
#pragma mark: Other USeful methode
-(void)makePrimaryImage {
    
    [makePrimaryButton setHidden:NO];
    makePrimaryButton.backgroundColor = [UIColor whiteColor];
    [makePrimaryButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    makePrimaryButton.titleLabel.textColor = [UIColor grayColor];
    makePrimaryButton.titleLabel.text =@"PRIMARY PHOTO";
    [makePrimaryButton setTitle:@"PRIMARY PHOTO" forState:UIControlStateNormal];
    
}
- (void)doSharePhoto {
    
    ALAlertBannerPosition position = ALAlertBannerPositionBottom;
    ALAlertBannerStyle randomStyle = ALAlertBannerStyleSuccess;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    if (topView) {
        
        banner = [ALAlertBanner alertBannerForView:topView style:randomStyle position:position title:@"Your photo has been uploaded successfully." subtitle:@"Wait for admin approval." tappedBlock:^(ALAlertBanner *alertBanner) {
            NSLog(@"tapped!");
            [alertBanner hide];
        }];
        banner.secondsToShow = 3.5;
        banner.showAnimationDuration = 0.25;
        banner.hideAnimationDuration = 0.2;
        // [banner show];
    }
    
    UIViewController *vc = self.navigationController.visibleViewController;
    NSLog(@"Presented Controller %@",vc);
    
    if ([vc  isKindOfClass:[ProfileImageCropViewController class]])
    {
        [self userListPhotoAPICall];
    }
    else
    {
    }
}

#pragma mark: User Image Api Call
- (void)userListPhotoAPICall  {
    
    //   NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"UserID",nil];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest requestWithUrlForQA:APIGetUserListPhoto withParams:params CallBack:^(id responseObject, NSError *error) {
        [ProgressHUD dismiss];
        
        NSLog(@"response object Get Alert List %@",responseObject);
        
        if(!error){
            [_statusLabel setHidden:YES];
            [_cropButton setHidden:YES];
            [_cropButtonLayer setHidden:YES];
            NSLog(@"Response is --%@",responseObject);
            if (imageDataArray.count) {
                [self.previewImageView setHighlighted:NO];
            }
            else{
                [self.previewImageView setHighlighted:YES];
                
            }
            imageDataArray = [[NSMutableArray alloc]init];
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                NSDictionary *userProfileDictionary = [responseObject objectForKey:@"result"];
                masterArray = [userProfileDictionary objectForKey:@"MasterValues"];
                int count = 0;
                for(NSDictionary *dictObj in masterArray)
                {
                    [imageDataArray addObject:dictObj];
                    [_statusLabel setHidden:NO];
                    
                    isPrimary = [NSString stringWithFormat:@"%@",[dictObj valueForKey:@"isPrimary"]];
                    NSDictionary *dict;
                    if(imageUpload) {
                        
                        dict = [imageDataArray lastObject];
                        
                    } else {
                        
                        dict = [imageDataArray objectAtIndex:0];
                    }
                    if (primarySlectedValue == NO) {
                        if ([isPrimary isEqualToString:@"1"]) {
                            //            [_cropButton setFrame:_deleteButton.frame];
                            //            [_cropButtonLayer setFrame:_deleteButton.frame];
                            primarySlectedValue = YES;
                            NSString *statusValue = [NSString stringWithFormat:@"%@",[dictObj valueForKey:@"Status"]];
                            photoStatus = [statusValue integerValue];

                            if ([statusValue isEqualToString:@"1"])
                            {
                                [_statusLabel setText:@"Approved"];
                            }
                            else{
                                [_statusLabel setText:@"Pending"];
                            }
                            isPrimaryPhotoOrNot = isPrimary;
                            
                            photoIdStr = [NSString stringWithFormat:@"%@",[dictObj valueForKey:@"ID"]];
                            imageName = [NSString stringWithFormat:@"%@",[dictObj valueForKey:@"PicName"]];
                            NSString *imageData = [dictObj valueForKey:@"PicUrl"];
                            photoIdStr = [NSString stringWithFormat:@"%@",[dictObj valueForKey:@"ID"]];
                            
                            imageSelctedIndex = count;
                            NSURL *imageUrl = [NSURL URLWithString:imageData];
                            [previewImageView.image setAccessibilityIdentifier:imageData];
                            [previewImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                            //                        if (previewImageView.image.accessibilityIdentifier) {
                            [self makePrimaryImage];
                            [_deleteButton setHidden:NO];
                            [_cropButton setHidden:NO];
                            [_cropButtonLayer setHidden:NO];

                          //  [_cropButton setFrame:_deleteButton.frame];
                          //  [_cropButtonLayer setFrame:_deleteButton.frame];
                            [_arrowImageView setFrame:CGRectMake(_arrowImageView.frame.origin.x, _deleteButton.frame.origin.y+7, _arrowImageView.frame.size.width, _arrowImageView.frame.size.height)];
                            
                            
                            //                        }
                        }
                        else{
                            if (imageDataArray.count) {
                                NSDictionary *dictOfStatus = [masterArray objectAtIndex:0];
                                NSDictionary *dict = [imageDataArray objectAtIndex:0];
                                NSString *statusValue = [NSString stringWithFormat:@"%@",[dictOfStatus valueForKey:@"Status"]];
                                photoIdStr = [NSString stringWithFormat:@"%@",[dictOfStatus valueForKey:@"ID"]];
                                photoStatus = [statusValue integerValue];

                                if ([statusValue isEqualToString:@"1"])
                                {
                                    [_statusLabel setText:@"Approved"];
                                }
                                else{
                                    [_statusLabel setText:@"Pending"];
                                }
                                imageSelctedIndex = 0;
                                NSString *imageData = [dict valueForKey:@"PicUrl"];
                                NSURL *imageUrl = [NSURL URLWithString:imageData];
                                [previewImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                                [makePrimaryButton setHidden:NO];
                                
                                //makePrimaryButton.backgroundColor = [UIColor whiteColor];
                                [makePrimaryButton setBackgroundColor:[UIColor colorWithRed:132/255.0 green:90/255.0 blue:140/255.0 alpha:1.0]];
                                [makePrimaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                makePrimaryButton.titleLabel.textColor = [UIColor whiteColor];
                                makePrimaryButton.titleLabel.text =@"MAKE PRIMARY";
                                [makePrimaryButton setTitle:@"MAKE PRIMARY" forState:UIControlStateNormal];
                                [_deleteButton setHidden:NO];
                                [_cropButton setFrame:CGRectMake(_deleteButton.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+10,_deleteButton.frame.size.width, _deleteButton.frame.size.height)];
                                [_cropButtonLayer setFrame:CGRectMake(_deleteButton.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+10,_deleteButton.frame.size.width, _deleteButton.frame.size.height)];
                                [_arrowImageView setFrame:CGRectMake(_arrowImageView.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+17, _arrowImageView.frame.size.width, _arrowImageView.frame.size.height)];
                            }
                        }
                    }
                    
                    count ++;
                }
                //                [self.imageCollectionView reloadData];
                if (imageDataArray.count) {
                    
                    [self.dontHaveLabel setHidden:YES];
                    [self.addPhotoLabel setHidden:YES];
                    [self.imageCollectionView setHidden : NO];
                    [self.photosImageView setHidden:YES];
                    [self.previewImageView setHidden:NO];
                    [makePrimaryButton setHidden:NO];
                    [_statusLabel setHidden:NO];
                    _cropButtonLayer.hidden = NO;
                    _arrowImageView.hidden = NO;
                    if ([isPrimaryPhotoOrNot isEqualToString:@"1"]) {
                        [self.deleteButton setHidden:NO];
                    }
                    else
                    {
                        
                        [self.deleteButton setHidden:NO];
                        [_cropButton setFrame:CGRectMake(_deleteButton.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+10,_deleteButton.frame.size.width, _deleteButton.frame.size.height)];
                        [_cropButtonLayer setFrame:CGRectMake(_deleteButton.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+10,_deleteButton.frame.size.width, _deleteButton.frame.size.height)];
                        [_arrowImageView setFrame:CGRectMake(_arrowImageView.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+17, _arrowImageView.frame.size.width, _arrowImageView.frame.size.height)];
                    }
                    [self.cropButton setHidden:NO];
                    [self viewDidLayoutSubviews];
                    
                }
                else{
                    
                    [self.dontHaveLabel setHidden:NO];
                    [self.addPhotoLabel setHidden:NO];
                    [  self.imageCollectionView setHidden : YES];
                    [self.photosImageView setHidden:NO];
                    [self.previewImageView setHidden:YES];
                    [makePrimaryButton setHidden:YES];
                    [_statusLabel setHidden:YES];
                    _cropButtonLayer.hidden = YES;
                    _arrowImageView.hidden = YES;
                    [self viewDidLayoutSubviews];
                    
                    [self.deleteButton setHidden:YES];
                    [self.cropButton setHidden:YES];
                }
                [self.imageCollectionView reloadData];
                
            }
            
            else if (([[responseObject objectForKey:@"StatusCode"] intValue] == 2)){
                if (imageDataArray.count) {
                    
                    [self.dontHaveLabel setHidden:YES];
                    [self.addPhotoLabel setHidden:YES];
                    
                    [self.photosImageView setHidden:YES];
                    [self.previewImageView setHidden:NO];
                    [makePrimaryButton setHidden:NO];
                    [self.deleteButton setHidden:NO];
                    [self.imageCollectionView setHidden : NO];
                    [_statusLabel setHidden:NO];
                    _cropButtonLayer.hidden = NO;
                    _arrowImageView.hidden = NO;
                    [self.cropButton setHidden:NO];
                    [self viewDidLayoutSubviews];
                    
                }
                else{
                    
                    [self.dontHaveLabel setHidden:NO];
                    [self.addPhotoLabel setHidden:NO];
                    [self.imageCollectionView setHidden : YES];
                    [_statusLabel setHidden:YES];
                    _cropButtonLayer.hidden = YES;
                    _arrowImageView.hidden = YES;
                    [self.photosImageView setHidden:NO];
                    [self.previewImageView setHidden:YES];
                    [makePrimaryButton setHidden:YES];
                    [self.deleteButton setHidden:YES];
                    [self.cropButton setHidden:YES];
                }
                [self viewDidLayoutSubviews];
                
                [self.imageCollectionView reloadData];
            }
            else
            {
                // [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                [self.dontHaveLabel setHidden:NO];
                [self.photosImageView setHidden:NO];
                [self.addPhotoLabel setHidden:NO];
                [self.imageCollectionView setHidden : YES];
                [_statusLabel setHidden:YES];
                _cropButtonLayer.hidden = YES;
                _arrowImageView.hidden = YES;
                [self.previewImageView setHidden:YES];
                [makePrimaryButton setHidden:YES];
                [self.deleteButton setHidden:YES];
                [self.cropButton setHidden:YES];
                [self.cropButton setHidden:YES];
                [self viewDidLayoutSubviews];
                [self.imageCollectionView reloadData];
            }
        }
    }];
}

#pragma mark: UIMemory Mangement methode
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark: UIButton Methode Action
- (IBAction)makePrimaryButton:(id)sender {
    
    
//    if([isPrimary isEqualToString:@"1"]) {
//        
//    } else {
    
        if (photoStatus == 1) {
            NSString *userIdStr = sharedInstance.userId;
            NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&picID=%@&isPrimary=%@",APISetPrimaryPhoto,userIdStr,photoIdStr,@"1"];
            NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                [ProgressHUD dismiss];
                if(!error){
                    NSLog(@"Response is --%@",responseObject);
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                        [[AlertView sharedManager] presentAlertWithTitle:@"" message:[responseObject objectForKey:@"Message"]
                                                     andButtonsWithTitle:@[@"OK"] onController:self
                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                               [self userListPhotoAPICall];
                                                               
                                                           }];
                    } else {
                        
                        [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                }
            }];
        }
        else if (photoStatus == 0)
        {
            [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"This photo is in pending state. You can not make it a primary photo." inController:self];
        }
    //}
}

- (IBAction)deleteButton:(id)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"Are you sure you want to delete this photo?"
                                 andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                           if ([buttonTitle isEqualToString:@"Yes"]) {
                                               
                                               if ([photoIdStr length]) {
                                                   primarySlectedValue = NO;
                                                   NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&picID=%@",APIDeleteUserPhoto,userIdStr,photoIdStr];
                                                   NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                   
                                                   [ProgressHUD show:@"Please wait..." Interaction:NO];
                                                   [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                                                       NSLog(@"response object Get UserInfo List %@",responseObject);
                                                       
                                                       [ProgressHUD dismiss];
                                                       if(!error){
                                                           
                                                           NSLog(@"Response is --%@",responseObject);
                                                           
                                                           if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                                                               
                                                               [[AlertView sharedManager] presentAlertWithTitle:@"" message:[responseObject objectForKey:@"Message"]
                                                                                            andButtonsWithTitle:@[@"OK"] onController:self
                                                                                                  dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                                                                      [self userListPhotoAPICall];
                                                                                                      
                                                                                                  }];
                                                           } else {
                                                               
                                                               [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                                                           }
                                                       }
                                                   }];
                                                   
                                                   
                                               }
                                               else{
                                                   [CommonUtils showAlertWithTitle:@"Alert!" withMsg:@"Please, Select photo to delete." inController:self];
                                               }
                                               
                                           }
                                       }];
}

//  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
//}

- (IBAction)cropbutton:(id)sender {
    
    
    //    PECropViewController *controller = [[PECropViewController alloc] init];
    //    controller.delegate = self;
    //    controller.image = self.previewImageView.image;
    //    NSDictionary *dict = [imageDataArray objectAtIndex:imageSelctedIndex];
    //    NSString *str = [NSString stringWithFormat:@"%@",[dict valueForKey:@"PicName"]];
    //    //  NSArray *arraySttring = [str componentsSeparatedByString:@"/"];
    //    // NSArray *arraySttring1 = [[arraySttring lastObject] componentsSeparatedByString:@"/"];
    //    defaultImage = str;
    //
    //    controller.keepingCropAspectRatio = YES;
    //    controller.cropAspectRatio = 1.0;
    //    UIImage *imageView = self.previewImageView.image;
    //    CGFloat width = imageView.size.width;
    //    CGFloat height = imageView.size.height;
    //    CGFloat length = MAX(width, height);
    //    controller.imageCropRect = CGRectMake((width - length) / 2,
    //                                          (height - length) / 2,
    //                                          length,
    //                                          length);
    //
    //
    //    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    //    }
    //    [self presentViewController:navigationController animated:YES completion:NULL];
    self.croppingStyle = TOCropViewCroppingStyleDefault;
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:self.croppingStyle image:self.previewImageView.image];
    cropController.delegate = self;
    NSLog(@"%@",cropController.toolbarItems);
    NSDictionary *dict = [imageDataArray objectAtIndex:imageSelctedIndex];
    NSString *str = [NSString stringWithFormat:@"%@",[dict valueForKey:@"PicName"]];
    defaultImage = str;
    // -- Uncomment these if you want to test out restoring to a previous crop setting --
    //cropController.angle = 90; // The initial angle in which the image will be rotated
    //cropController.imageCropFrame = CGRectMake(0,0,2848,4288); //The
    
    // -- Uncomment the following lines of code to test out the aspect ratio features --
    //cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare; //Set the initial aspect ratio as a square
    cropController.aspectRatioLockEnabled = YES; // The crop box is locked to the aspect ratio and can't be resized away from it
    //cropController.resetAspectRatioEnabled = NO; // When tapping 'reset', the aspect ratio will NOT be reset back to default
    
    // -- Uncomment this line of code to place the toolbar at the top of the view controller --
    // cropController.toolbarPosition = TOCropViewControllerToolbarPositionTop;
    sharedInstance.IsCropPhotoDirect = YES;
    self.image = self.previewImageView.image;
    
    //If profile picture, push onto the same navigation stack
    if (self.croppingStyle == TOCropViewCroppingStyleCircular) {
        //[picker pushViewController:cropController animated:YES];
    }
    else { //otherwise dismiss, and then present from the main controller
        //  [picker dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:cropController animated:YES completion:nil];
        //        }];
    }
    
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.croppedFrame = cropRect;
    self.angle = angle;
    _croppedImage = image;
    [self updateImageViewWithImage:_croppedImage fromCropViewController:cropViewController];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.croppedFrame = cropRect;
    self.angle = angle;
    _croppedImage = image;
    [self updateImageViewWithImage:_croppedImage fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)croppedImage fromCropViewController:(TOCropViewController *)cropViewController
{
    if (sharedInstance.IsCropPhotoDirect) {
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        // [self.previewImageView setImage:croppedImage];
        NSString *mimeType;
        NSString *fileName;
        NSData *fileData;
        NSArray *nameStr = [imageName componentsSeparatedByString:@"."];
        NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
        NSLog(@"fileKey %@",fileKey);
        
        fileName =[NSString stringWithFormat:@"%@",imageName];
        fileData =UIImageJPEGRepresentation(croppedImage, 1.0);
        mimeType =@"image/jpeg";
        //    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&isPrimary=%@&Type=%@&PicName=%@",@"http://ondemandapinew.flexsin.in/api/ImgaeUploader/Post",userIdStr,isPrimary,@"UserImageUpdate",imageName];
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@&Image=%@&picName=%@",@"http://doumees.flexsin.in/api/ImgaeUploader/Post",userIdStr,@"UserImageUpdate",imageName,defaultImage];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        ;
        // [ProgressHUD show:@"Please wait..." Interaction:NO];
        [manager POST:urlstr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //  [self doSharePhoto];
            if(fileData){
                
                [formData appendPartWithFileData:fileData
                                            name:@"Image"
                                        fileName:@"Image"
                                        mimeType:mimeType];
            }
        }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [ProgressHUD dismiss];
                  [cropViewController dismissViewControllerAnimated:YES completion:NULL];
                  
                  if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                      [[AlertView sharedManager]presentAlertWithTitle:@"Alert!" message:@"Success" andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                          if ([buttonTitle isEqualToString:@"OK"]) {
                              [self doSharePhoto];
                              
                          }
                      }];
                      
                  }
                  else {
                      [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                  }
                  // callback(responseObject,nil);
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [ProgressHUD dismiss];
                  //  callback(nil,error);
              }];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //[self updateEditButtonEnabled];
        }
    }
}


#pragma mark - PECropViewControllerDelegate methods & After Croping Image Update on the Server database

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    
    //    [controller dismissViewControllerAnimated:YES completion:NULL];
    //    if (sharedInstance.IsCropPhotoDirect) {
    //        [self.previewImageView setImage:croppedImage];
    //        NSString *mimeType;
    //        NSString *fileName;
    //        NSData *fileData;
    //        NSArray *nameStr = [imageName componentsSeparatedByString:@"."];
    //        NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
    //        NSLog(@"fileKey %@",fileKey);
    //
    //        fileName =[NSString stringWithFormat:@"%@",imageName];
    //        fileData =UIImageJPEGRepresentation(self.previewImageView.image, 1.0);
    //        mimeType =@"image/jpeg";
    //        //    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&isPrimary=%@&Type=%@&PicName=%@",@"http://ondemandapinew.flexsin.in/api/ImgaeUploader/Post",userIdStr,isPrimary,@"UserImageUpdate",imageName];
    //        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@&Image=%@&picName=%@",@"http://ondemandappv2.flexsin.in/api/ImgaeUploader/Post",userIdStr,@"UserImageUpdate",imageName,defaultImage];
    //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    //        ;
    //        // [ProgressHUD show:@"Please wait..." Interaction:NO];
    //        [manager POST:urlstr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //            //  [self doSharePhoto];
    //            if(fileData){
    //
    //                [formData appendPartWithFileData:fileData
    //                                            name:@"Image"
    //                                        fileName:@"Image"
    //                                        mimeType:mimeType];
    //            }
    //
    //        }
    //              success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //                  [ProgressHUD dismiss];
    //
    //                  if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
    //                      [ self doSharePhoto ];
    //
    //                  } else {
    //
    //                      [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
    //                  }
    //
    //                  // callback(responseObject,nil);
    //              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //                  [ProgressHUD dismiss];
    //                  //  callback(nil,error);
    //              }];
    //        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //            //[self updateEditButtonEnabled];
    //        }
    //
    //    }
    //    else {
    //
    //        self.previewImageView.image = croppedImage;
    //        NSString *mimeType;
    //        NSString *fileName;
    //        NSData *fileData;
    //        NSArray *nameStr = [imageName componentsSeparatedByString:@"."];
    //        NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
    //        NSLog(@"fileKey %@",fileKey);
    //
    //        fileName =[NSString stringWithFormat:@"%@",imageName];
    //        fileData =UIImageJPEGRepresentation(self.previewImageView.image, 1.0);
    //        mimeType =@"image/jpeg";
    //        //    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&isPrimary=%@&Type=%@&PicName=%@",@"http://ondemandapinew.flexsin.in/api/ImgaeUploader/Post",userIdStr,isPrimary,@"UserImageUpdate",imageName];
    //        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@&Image=%@",@"http://ondemandappv2.flexsin.in/api/ImgaeUploader/Post",userIdStr,@"UserImage",imageName];
    //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    //        ;
    //        // [ProgressHUD show:@"Please wait..." Interaction:NO];
    //        [manager POST:urlstr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //            //  [self doSharePhoto];
    //            if(fileData){
    //
    //                [formData appendPartWithFileData:fileData
    //                                            name:@"Image"
    //                                        fileName:@"Image"
    //                                        mimeType:mimeType];
    //            }
    //
    //        }
    //              success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //                  [ProgressHUD dismiss];
    //
    //                  if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
    //                      [ self doSharePhoto ];
    //
    //                  } else {
    //
    //                      [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
    //                  }
    //
    //                  // callback(responseObject,nil);
    //              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //                  [ProgressHUD dismiss];
    //                  //  callback(nil,error);
    //              }];
    //        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //            //[self updateEditButtonEnabled];
    //        }
    //    }
    //
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //   [self updateEditButtonEnabled];
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)backBtnClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addImageButton:(id)sender
{
    if (imageDataArray.count>=10)
    {
        [CommonUtils showAlertWithTitle:@"Alert!" withMsg:@"You can not add more than 10 photos. Please delete any previous photo to add a new photo." inController:self];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                                 delegate: self
                                                        cancelButtonTitle: @"Cancel"
                                                   destructiveButtonTitle: nil
                                                        otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
        [actionSheet showInView:self.view];
        
    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ;
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

- (void)takeNewPhotoFromCamera {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

- (void)choosePhotoFromExistingImages {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}
-(UIImage *)scaleAndRotateImage:(UIImage *)imageRef {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = imageRef.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)(kUTTypeImage)])
    {
        NSLog(@"Image");
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //    previewImageView.image = image;
        img=[self scaleAndRotateImage:image];
        sharedInstance.IsCropPhotoDirect = NO;
        
        if (sharedInstance.IsCropPhotoDirect)
        {
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            self.previewImageView.hidden = NO;
            //  [self.previewImageView setImage:image];
            
            NSString *mimeType;
            NSString *fileName;
            NSData *fileData;
            NSArray *nameStr = [imageName componentsSeparatedByString:@"."];
            NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
            NSLog(@"fileKey %@",fileKey);
            
            fileName =[NSString stringWithFormat:@"%@",imageName];
            fileData = UIImageJPEGRepresentation(img, 0.1);
            mimeType =@"image/jpeg";
            
            NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@&Image=%@&picName=%@",@"http://doumees.flexsin.in/api/ImgaeUploader/Post",userIdStr,@"UserImageUpdate",imageName,defaultImage];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
            ;
            ;
            [manager POST:urlstr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //  [self doSharePhoto];
                if(fileData){
                    
                    [formData appendPartWithFileData:fileData
                                                name:@"Image"
                                            fileName:@"Image"
                                            mimeType:mimeType];
                }
                
            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      
                      if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                          
                          [ProgressHUD dismiss];
                          [picker dismissViewControllerAnimated:YES completion:nil];
                          
                          [[AlertView sharedManager]presentAlertWithTitle:@"Alert!" message:@"Your photo uploaded successfully. Waiting for approval." andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                              if ([buttonTitle isEqualToString:@"OK"]) {
                                  [ self doSharePhoto ];
                                  
                              }
                          }];
                      }
                      else {
                          [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                      }
                      
                      // callback(responseObject,nil);
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
                      [ProgressHUD dismiss];
                      //  callback(nil,error);
                  }];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                //[self updateEditButtonEnabled];
            }
        }
        else
        {
            self.previewImageView.hidden = NO;
            //  self.previewImageView.image = image;
            NSString *mimeType;
            NSString *fileName;
            NSData *fileData;
            img=[self scaleAndRotateImage:image];
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            
            NSArray *nameStr = [imageName componentsSeparatedByString:@"."];
            NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
            NSLog(@"fileKey %@",fileKey);
            
            fileName =[NSString stringWithFormat:@"%@",imageName];
            fileData = UIImageJPEGRepresentation(img, 1.0);
            mimeType =@"image/jpeg";
            //    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&isPrimary=%@&Type=%@&PicName=%@",@"http://ondemandapinew.flexsin.in/api/ImgaeUploader/Post",userIdStr,isPrimary,@"UserImageUpdate",imageName];
            NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@&Image=%@",@"http://doumees.flexsin.in/api/ImgaeUploader/Post",userIdStr,@"UserImage",imageName];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
            ;
            // [ProgressHUD show:@"Please wait..." Interaction:NO];
            [manager POST:urlstr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //  [self doSharePhoto];
                
                if(fileData)
                {
                    [formData appendPartWithFileData:fileData
                                                name:@"Image"
                                            fileName:@"Image"
                                            mimeType:mimeType];
                }
            }
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                          [ProgressHUD dismiss];
                          [picker dismissViewControllerAnimated:YES completion:nil];
                          
                          [[AlertView sharedManager]presentAlertWithTitle:@"Alert!" message:@"Your photo uploaded successfully. Waiting for approval." andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                              if ([buttonTitle isEqualToString:@"OK"]) {
                                  [ self doSharePhoto ];
                                  
                              }
                          }];
                      }
                      else
                      {
                          [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                      }
                      
                      // callback(responseObject,nil);
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      [ProgressHUD dismiss];
                      //  callback(nil,error);
                  }];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                //[self updateEditButtonEnabled];
            }
        }
    }
    else
    {
        NSLog(@"Video");
        [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Video is not suppoted." inController:self];
    }
    
    //vi
}

@end
