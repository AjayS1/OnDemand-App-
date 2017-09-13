//
//  ProfileImageCropViewController.m
//  Customer
//
//  Created by Sampurna on 13/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "ProfileImageCropViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "ImageCropViewController.h"
#import "ServerRequest.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "PECropViewController.h"
#import "CommonUtils.h"
#import  "ALAlertBanner.h"
#import "ALAlertBannerManager.h"
#import "PECropViewController.h"
#import "PECropView.h"
#import "AlertView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width
#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height
#import "TOCropViewController.h"
static NSString *isPrimaryPhotoOrNot;
@interface ProfileImageCropViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, PECropViewControllerDelegate,TOCropViewControllerDelegate> {
    
    NSArray * imageArray;
    NSString *photoIdStr;
    NSString *isPrimary;
    NSString *imageName;
    BOOL imageUpload;
    SingletonClass *sharedInstance;
    NSString *isPrimaryValue;
    NSInteger imageSelctedIndex;
    NSString *defaultImage ;
    ALAlertBanner *banner;
    UIImage *img;
    NSArray *masterArray;
    NSInteger photoStatus;
    NSMutableArray *imageParseArray;
    BOOL primarySlectedValue;

}

@property (weak, nonatomic) IBOutlet UILabel *addPhotoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (nonatomic, assign) TOCropViewCroppingStyle croppingStyle;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *croppedImage;
@property (nonatomic, assign) NSInteger angle;
@property (nonatomic, assign) CGRect croppedFrame;
@property (weak, nonatomic) IBOutlet UILabel *dontHaveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photosImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *cropButtonLayer;

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
    imageSelctedIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    bgScrollView.delegate =self;
    imageParseArray = [[NSMutableArray alloc] init];
    primarySlectedValue = NO;
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    if (banner) {
        [banner hide];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    sharedInstance = [SingletonClass sharedInstance];
    isPrimary = @"0";
    imageDataArray = [[NSMutableArray alloc]init];
    [self.dontHaveLabel setHidden:YES];
    [self.photosImageView setHidden:YES];
    [self.addPhotoLabel setHidden:YES];
    
    [makePrimaryButton setHidden:YES];
    [self.deleteButton setHidden:YES];
    [self.cropButton setHidden:YES];
    [self.cropButton setHidden:YES];
    [self.cropButtonLayer setHidden:YES];
    [self.arrowImageView setHidden:YES];
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

    self.cropButton.imageEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 10);
    self.cropButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.previewImageView setHidden:YES];
    [self userListPhotoAPICall];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
}

#pragma mark: check SignalR
- (void)checkSignalRReqest:(NSNotification*) noti {
    
    //  NSDictionary *dateData = @{@"userId":userIdStr,@"dateCount":dateCountStr,@"messageCount":mesagesCountStr,@"notificationCount":notificationsCountStr,@"dateType":typeIdStr,@"dateId":dateIdStr};
    
    NSLog(@"checkSignalRReqest method Call");
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    if ([requestTypeStr isEqualToString:@"1"]) {
        NSString *dateIdStr = [responseObject objectForKey:@"dateId"];
        NSDictionary *dataDictionary = @{@"DateID":dateIdStr,@"Type":requestTypeStr};
        if (sharedInstance.onDemandPushNotificationArray.count) {
            [sharedInstance.onDemandPushNotificationArray removeAllObjects];
        }
        [sharedInstance.onDemandPushNotificationArray addObject:dataDictionary];
        
        NSLog(@"sharedInstance.onDemandPushNotificationArray ==  %@",sharedInstance.onDemandPushNotificationArray);
        
        OnDemandDatePushNotificationViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"onDamndDatePushNotification"];
        
        [self.navigationController pushViewController:dateDetailsView animated:YES];
        
    } else {
        
    }
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
    if (imageDataArray.count)
        return [imageDataArray count];
    else
        return 0.0;
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
    //                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [cell.backgroundView addSubview:recipeImageView];
    if (cell.selected) {
        recipeImageView.layer.borderWidth = 2.0;
        recipeImageView.layer.borderColor = [UIColor whiteColor].CGColor; // highlight selection
    }
    else
    {
        recipeImageView.layer.borderColor = [UIColor clearColor].CGColor; // Default color
    }
    //    cell.selected = YES;
    //    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (imageDataArray.count) {
        [self.imageCollectionView setHidden:NO];
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [cell setSelected:YES];
        
        UIImageView *reciImageView = (UIImageView *)[cell viewWithTag:100];
        reciImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        reciImageView.layer.borderWidth = 2.0;
        reciImageView.layer.masksToBounds = YES;
        [self.dontHaveLabel setHidden:YES];
        [self.photosImageView setHidden:YES];
        [self.addPhotoLabel setHidden:YES];
        [self.previewImageView setHidden:NO];
        [makePrimaryButton setHidden:NO];
        [self.deleteButton setHidden:NO];
        [self.cropButton setHidden:NO];
        //previewImageView.image= [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        NSDictionary *dict = [imageDataArray objectAtIndex:indexPath.row];
        NSDictionary *dictOfStatus = [masterArray objectAtIndex:indexPath.row];
        photoStatus = [[dictOfStatus objectForKey:@"Status"] integerValue];
        NSString *statusValue = [NSString stringWithFormat:@"%@",[dictOfStatus valueForKey:@"Status"]];
        if ([statusValue isEqualToString:@"1"])
        {
            [_statusLabel setText:@"Approved"];
        }
        else{
            [_statusLabel setText:@"Pending"];
        }
        
        NSString *imageData = [dict valueForKey:@"PicUrl"];
        imageSelctedIndex =indexPath.row;
        
        NSURL *imageUrl = [NSURL URLWithString:imageData];
        [previewImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //    [previewImageView sd_setImageWithURL:imageUrl
        //                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        photoIdStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"ID"]];
        isPrimary = [NSString stringWithFormat:@"%@",[dict valueForKey:@"isPrimary"]];
        imageName = [NSString stringWithFormat:@"%@",[dict valueForKey:@"PicName"]];
        
        
        if ([isPrimary isEqualToString:@"1"]) {
            makePrimaryButton.backgroundColor = [UIColor whiteColor];
            makePrimaryButton.titleLabel.textColor = [UIColor grayColor];
            [makePrimaryButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [makePrimaryButton setTitle:@"PRIMARY PHOTO" forState:UIControlStateNormal];
            [_deleteButton setHidden:YES];
            [_cropButton setFrame:_deleteButton.frame];
            [_cropButtonLayer setFrame:_deleteButton.frame];
            [_arrowImageView setFrame:CGRectMake(_arrowImageView.frame.origin.x, _deleteButton.frame.origin.y+7, _arrowImageView.frame.size.width, _arrowImageView.frame.size.height)];
            
        }
        else {
            
            //makePrimaryButton.backgroundColor = [UIColor whiteColor];
            [makePrimaryButton setBackgroundColor:[UIColor colorWithRed:132/255.0 green:90/255.0 blue:140/255.0 alpha:1.0]];
            makePrimaryButton.titleLabel.textColor = [UIColor whiteColor];
            [makePrimaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [makePrimaryButton setTitle:@"MAKE PRIMARY" forState:UIControlStateNormal];
            [_deleteButton setHidden:NO];
            [_cropButton setFrame:CGRectMake(_deleteButton.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+10,_deleteButton.frame.size.width, _deleteButton.frame.size.height)];
            [_cropButtonLayer setFrame:CGRectMake(_deleteButton.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+10,_deleteButton.frame.size.width, _deleteButton.frame.size.height)];
            [_arrowImageView setFrame:CGRectMake(_arrowImageView.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+17, _arrowImageView.frame.size.width, _arrowImageView.frame.size.height)];
        }
        //  [self.imageCollectionView reloadData];
        
    }
    else{
        [self.dontHaveLabel setHidden:NO];
        [self.imageCollectionView setHidden:YES];
        [self.photosImageView setHidden:NO];
        [self.addPhotoLabel setHidden:NO];
        [self.previewImageView setHidden:YES];
        [makePrimaryButton setHidden:YES];
        [self.deleteButton setHidden:YES];
        [self.cropButton setHidden:YES];
        [self.imageCollectionView reloadData];
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
    UIImageView *recipeIView = (UIImageView *)[cell viewWithTag:100];
    recipeIView.layer.borderColor = [UIColor clearColor].CGColor;
    recipeIView.layer.borderWidth = 1.0;
    recipeIView.layer.masksToBounds = YES;
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark: Other Useful Methode
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
       // banner.hideAnimationDuration = 0.2;
       // [banner show];
    }
    UIViewController *vc = self.navigationController.visibleViewController;
    NSLog(@"Presented Controller %@",vc);
    
    if ([vc  isKindOfClass:[ProfileImageCropViewController class]])
    {
        [self userListPhotoAPICall];
    }
    else{
    }
}


#pragma mark: User Image List Api call
- (void)userListPhotoAPICall  {
    
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"UserID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlQA:APIGetUserListPhoto withParams:params CallBack:^(id responseObject, NSError *error) {
        [ProgressHUD dismiss];
        NSLog(@"response object Get Alert List %@",responseObject);
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                imageDataArray = [[NSMutableArray alloc]init];
                NSDictionary *userProfileDictionary = [responseObject objectForKey:@"result"];
                //   imageParseArray = [SingletonClass parseImageArrayForSelection:[userProfileDictionary objectForKey:@"MasterValues"]];
                
                masterArray = [userProfileDictionary objectForKey:@"MasterValues"];
                int count = 0;
                NSInteger arraowOriginvalue = _arrowImageView.frame.origin.y;
                NSLog(@" %ld",(long)arraowOriginvalue);
                
                for(NSDictionary *dictObj in masterArray)
                {
                    [imageDataArray addObject:dictObj];
                    [_statusLabel setHidden:NO];
                    
                    isPrimary = [NSString stringWithFormat:@"%@",[dictObj valueForKey:@"isPrimary"]];
                    NSDictionary *dict;
                    if(imageUpload) {
                        dict = [imageDataArray lastObject];
                    }
                    else {
                        dict = [imageDataArray objectAtIndex:0];
                    }
                    if ( primarySlectedValue == NO) {
                        if ([isPrimary isEqualToString:@"1"]) {
                            primarySlectedValue = YES;
                            NSString *statusValue = [NSString stringWithFormat:@"%@",[dictObj valueForKey:@"Status"]];
                            
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
                            imageSelctedIndex = count;
                            NSURL *imageUrl = [NSURL URLWithString:imageData];
                            [previewImageView.image setAccessibilityIdentifier:imageData];
                            [previewImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                            [self makePrimaryImage];
                            [_deleteButton setHidden:YES];
                            [_cropButton setFrame:_deleteButton.frame];
                            [_cropButtonLayer setFrame:_deleteButton.frame];
                            [_arrowImageView setFrame:CGRectMake(_arrowImageView.frame.origin.x, _deleteButton.frame.origin.y+7, _arrowImageView.frame.size.width, _arrowImageView.frame.size.height)];
                        }
                        else{
                            if (imageDataArray.count) {
                                NSDictionary *dictOfStatus = [masterArray objectAtIndex:0];
                                NSDictionary *dict = [imageDataArray objectAtIndex:0];
                                NSString *statusValue = [NSString stringWithFormat:@"%@",[dictOfStatus valueForKey:@"Status"]];
                                photoIdStr = [NSString stringWithFormat:@"%@",[dictOfStatus valueForKey:@"ID"]];

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
                            }
                        }

                    }
                                     count ++;
                }
                if (imageDataArray.count) {
                    
                    [self.dontHaveLabel setHidden:YES];
                    [self.photosImageView setHidden:YES];
                    [self.addPhotoLabel setHidden:YES];
                    [self.previewImageView setHidden:NO];
                    [makePrimaryButton setHidden:NO];
                    [self.imageCollectionView setHidden : NO];
                    [_statusLabel setHidden:NO];
                    _cropButtonLayer.hidden = NO;
                    _arrowImageView.hidden = NO;
                    if ([isPrimaryPhotoOrNot isEqualToString:@"1"]) {
                        [self.deleteButton setHidden:YES];
                    }
                    else{
                        [self.deleteButton setHidden:NO
                         ];
                        [_cropButton setFrame:CGRectMake(_deleteButton.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+10,_deleteButton.frame.size.width, _deleteButton.frame.size.height)];
                        [_cropButtonLayer setFrame:CGRectMake(_deleteButton.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+10,_deleteButton.frame.size.width, _deleteButton.frame.size.height)];
                        [_arrowImageView setFrame:CGRectMake(_arrowImageView.frame.origin.x, _deleteButton.frame.origin.y+_deleteButton.frame.size.height+17, _arrowImageView.frame.size.width, _arrowImageView.frame.size.height)];
                    }
                    [self viewDidLayoutSubviews];

                    [self.cropButton setHidden:NO];
                    
                }
                else
                {
                    [self.dontHaveLabel setHidden:NO];
                    [self.photosImageView setHidden:NO];
                    [self.addPhotoLabel setHidden:NO];
                    [self.previewImageView setHidden:YES];
                    [makePrimaryButton setHidden:YES];
                    [self.deleteButton setHidden:YES];
                    [self.imageCollectionView setHidden : YES];
                    [_statusLabel setHidden:YES];
                    _cropButtonLayer.hidden = YES;
                    _arrowImageView.hidden = YES;
                    [self.cropButton setHidden:YES];
                    
                }
                [self viewDidLayoutSubviews];

                [self.imageCollectionView reloadData];
                
            }
            else if (([[responseObject objectForKey:@"StatusCode"] intValue] == 2)){
                if (imageDataArray.count) {
                    
                    [self.dontHaveLabel setHidden:YES];
                    [self.photosImageView setHidden:YES];
                    [self.addPhotoLabel setHidden:YES];
                    [self.previewImageView setHidden:NO];
                    [makePrimaryButton setHidden:NO];
                    [self.deleteButton setHidden:NO];
                    [self.imageCollectionView setHidden : NO];
                    [_statusLabel setHidden:NO];
                    _cropButtonLayer.hidden = NO;
                    _arrowImageView.hidden = NO;
                    [self.cropButton setHidden:NO];
                    [self viewDidLayoutSubviews];
                    [self.imageCollectionView reloadData];

                }
                else{
                    [self.dontHaveLabel setHidden:NO];
                    [self.photosImageView setHidden:NO];
                    [self.addPhotoLabel setHidden:NO];
                    [self.previewImageView setHidden:YES];
                    [makePrimaryButton setHidden:YES];
                    [self.deleteButton setHidden:YES];
                    [self.imageCollectionView setHidden : YES];
                    [_statusLabel setHidden:YES];
                    _cropButtonLayer.hidden = YES;
                    _arrowImageView.hidden = YES;
                    [self.cropButton setHidden:YES];
                }
                [self viewDidLayoutSubviews];
          
                
            }
            else
            {
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
                [_statusLabel setHidden:YES];

                [self viewDidLayoutSubviews];
                [self.imageCollectionView reloadData];
            }
        }
    }];
}

#pragma Mark : Memory Managment methoe
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark: Uibutton Methode Action
- (IBAction)makePrimaryButton:(id)sender {
    if([isPrimary isEqualToString:@"1"]) {
        
    }
    else {
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
                                                                primarySlectedValue = NO;
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
    }
}

- (IBAction)deleteButton:(id)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"Are you sure you want to delete this photo?"
                                 andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                           if ([buttonTitle isEqualToString:@"Yes"]) {
                                               
                                               if ([photoIdStr length]) {
                                                    primarySlectedValue = NO;
                                                   NSString *userIdStr = sharedInstance.userId;
                                                   NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&picID=%@",APIDeleteUserPhoto,userIdStr,photoIdStr];
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
                                                           }
                                                           else
                                                           {
                                                               [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
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

- (IBAction)cropbutton:(id)sender {
    
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
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image1 withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.croppedFrame = cropRect;
    self.angle = angle;
    _croppedImage = image1;
    [self updateImageViewWithImage:_croppedImage fromCropViewController:cropViewController];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image1 withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.croppedFrame = cropRect;
    self.angle = angle;
    _croppedImage = image1;
    [self updateImageViewWithImage:_croppedImage fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)croppedImage fromCropViewController:(TOCropViewController *)cropViewController
{
    NSString *userIdStr = sharedInstance.userId;
    
    if (sharedInstance.IsCropPhotoDirect) {
         [ProgressHUD show:@"Please wait..." Interaction:NO];
      //  [self.previewImageView setImage:croppedImage];
        NSString *mimeType;
        NSString *fileName;
        NSData *fileData;
        NSArray *nameStr = [imageName componentsSeparatedByString:@"."];
        NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
        NSLog(@"%@",fileKey);
        
        fileName =[NSString stringWithFormat:@"%@",imageName];
        fileData =UIImageJPEGRepresentation(croppedImage, 1.0);
        mimeType =@"image/jpeg";
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@&Image=%@&picName=%@",@"http://api.doumees.com/api/ImgaeUploader/Post",userIdStr,@"UserImageUpdate",imageName,defaultImage];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        ;
        [manager POST:urlstr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
                              [ self doSharePhoto ];
                              
                          }
                      }];
                  }
                  else {
                      [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                  }
                  // callback(responseObject,nil);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
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
    //    NSString *userIdStr = sharedInstance.userId;
    //
    //    if (sharedInstance.IsCropPhotoDirect) {
    //        [self.previewImageView setImage:croppedImage];
    //        NSString *mimeType;
    //        NSString *fileName;
    //        NSData *fileData;
    //        NSArray *nameStr = [imageName componentsSeparatedByString:@"."];
    //        NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
    //        NSLog(@"%@",fileKey);
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
    //                      [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
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
    //    else{
    //        self.previewImageView.image = croppedImage;
    //
    //        // http://ondemandapp.flexsin.in/api/ImgaeUploader/Post	UserID,isPrimary, PicName
    //
    //        NSString *mimeType;
    //        NSString *fileName;
    //        NSData *fileData;
    //        NSArray *nameStr = [imageName componentsSeparatedByString:@"."];
    //        NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
    //        NSLog(@"%@",fileKey);
    //
    //        fileName =[NSString stringWithFormat:@"%@",imageName];
    //        fileData =UIImageJPEGRepresentation(self.previewImageView.image, 1.0);
    //        mimeType =@"image/jpeg";
    //        //    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&isPrimary=%@&Type=%@&PicName=%@",@"http://ondemandapinew.flexsin.in/api/ImgaeUploader/Post",userIdStr,isPrimary,@"UserImageUpdate",imageName];
    //
    //        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@&Image=%@",@"http://ondemandappv2.flexsin.in/api/ImgaeUploader/Post",userIdStr,@"UserImage",imageName];
    //
    //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    //        // [ProgressHUD show:@"Please wait..." Interaction:NO];
    //
    //        [manager POST:urlstr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //
    //            if(fileData){
    //
    //                [formData appendPartWithFileData:fileData
    //                                            name:@"Image"
    //                                        fileName:@"Image"
    //                                        mimeType:mimeType];
    //
    //            }
    //
    //        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //            [ProgressHUD dismiss];
    //
    //            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
    //                [ self doSharePhoto ];
    //
    //                //  [ProgressHUD dismiss];
    //                //[self userListPhotoAPICall];
    //
    //            } else {
    //
    //                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
    //            }
    //
    //            // callback(responseObject,nil);
    //        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //            [ProgressHUD dismiss];
    //            //  callback(nil,error);
    //        }];
    //
    //        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //            //[self updateEditButtonEnabled];
    //        }
    //    }
    
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
        [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"You can not add more than 10 photos. Please delete any previous photo to add a new photo." inController:self];
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

- (void)takeNewPhotoFromCamera
{
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

-(void)choosePhotoFromExistingImages
{
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
    NSString *userIdStr = sharedInstance.userId;
    

    if([info[UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)(kUTTypeImage)])
    {
        NSLog(@"Image");
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
       // previewImageView.image = image;
        img=[self scaleAndRotateImage:image];
        sharedInstance.IsCropPhotoDirect = NO;
        if (sharedInstance.IsCropPhotoDirect) {
             [ProgressHUD show:@"Please wait..." Interaction:NO];
            self.previewImageView.hidden = NO;
       ///     [self.previewImageView setImage:image];
            NSString *mimeType;
            NSString *fileName;
            NSData *fileData;
            NSArray *nameStr = [imageName componentsSeparatedByString:@"."];
            NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
            NSLog(@"fileKey %@",fileKey);
            
            fileName =[NSString stringWithFormat:@"%@",imageName];
            fileData =UIImageJPEGRepresentation(img, 1.0);
            mimeType =@"image/jpeg";
            //    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&isPrimary=%@&Type=%@&PicName=%@",@"http://ondemandapinew.flexsin.in/api/ImgaeUploader/Post",userIdStr,isPrimary,@"UserImageUpdate",imageName];
            //"http://doumeesApi.flexsin.in/API/"
            
            NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@&Image=%@&picName=%@",@"http://api.doumees.com/api/ImgaeUploader/Post",userIdStr,@"UserImageUpdate",imageName,defaultImage];
            
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
                      [picker dismissViewControllerAnimated:YES completion:nil];

                      if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                          [[AlertView sharedManager]presentAlertWithTitle:@"Alert!" message:@"Your photo uploaded successfully. Waiting for approval." andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                              if ([buttonTitle isEqualToString:@"OK"]) {
                                  [ self doSharePhoto ];
                                  
                              }
                          }];
                          
                      } else {
                          
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
        else {
            self.previewImageView.hidden = NO;
           [ProgressHUD show:@"Please wait..." Interaction:NO];
           // self.previewImageView.image = image;
            NSString *mimeType;
            NSString *fileName;
            NSData *fileData;
            img=[self scaleAndRotateImage:image];
            NSArray *nameStr = [imageName componentsSeparatedByString:@"."];
            NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
            NSLog(@"fileKey %@",fileKey);
            
            fileName =[NSString stringWithFormat:@"%@",imageName];
            fileData = UIImageJPEGRepresentation(img, 1.0);
            mimeType =@"image/jpeg";
            //    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&isPrimary=%@&Type=%@&PicName=%@",@"http://ondemandapinew.flexsin.in/api/ImgaeUploader/Post",userIdStr,isPrimary,@"UserImageUpdate",imageName];
            NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Type=%@&Image=%@",@"http://api.doumees.com/api/ImgaeUploader/Post",userIdStr,@"UserImage",imageName];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
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
                      [ProgressHUD dismiss];
                        [picker dismissViewControllerAnimated:YES completion:nil];
                      if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
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
        
    }
    else
    {
        NSLog(@"Video");
        [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Video is not suppoted." inController:self];
        
        //video
    }
    
    
}

@end
