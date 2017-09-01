
//  OnDemandDateRequestViewController.m
//  Contractor
//  Created by Jamshed Ali on 19/07/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "OnDemandDateRequestViewController.h"
#import "PEARImageSlideViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "KGModal.h"
#import "CommonUtils.h"
#import "SingletonClass.h"
#import "ServerRequest.h"
#import "KGModal.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AppDelegate.h"
@interface OnDemandDateRequestViewController () {
    
    SingletonClass *sharedInstance;
    NSMutableArray *imageArray;
    NSDictionary *dataDictionary;
    UIView *kgModalView;
    UIView *dateBottomlineView;
    UIView *profileBottomlineView;
    NSString *customerIdStr;
    UIDatePicker *picker;
    NSDateFormatter *dateFormat;
    
}

@property (nonatomic,retain)PEARImageSlideViewController * slideImageViewController;

@end

@implementation OnDemandDateRequestViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    profileView.hidden = YES;
    dateInforamtionView.hidden = NO;
    
    dateBottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, dateInfoButton.frame.size.height +3, dateInfoButton.frame.size.width, 5)];
    dateBottomlineView.backgroundColor = [UIColor purpleColor];
    [dateInfoButton addSubview:dateBottomlineView];
    
    profileBottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, profileButton.frame.size.height +3, profileButton.frame.size.width, 5)];
    profileBottomlineView.backgroundColor = [UIColor purpleColor];
    [profileButton addSubview:profileBottomlineView];
    
    
    dateBottomlineView.hidden = NO;
    profileBottomlineView.hidden = YES;
    
    [self dateRequestReceviedApiCall];
    
    sharedInstance = [SingletonClass sharedInstance];
    sharedInstance.imagePopupCondition = @"no";
    
    
    
    likeDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
    likeDetailsLbl.numberOfLines = 0;
    [likeDetailsLbl sizeToFit];
    
    datingTitleLbl.frame = CGRectMake(15, likeDetailsLbl.frame.origin.y+likeDetailsLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
    
    datingDetailsLbl.frame = CGRectMake(15, datingTitleLbl.frame.origin.y+datingTitleLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
    
    datingDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
    datingDetailsLbl.numberOfLines = 0;
    [datingDetailsLbl sizeToFit];
    
    imageCountLabel.layer.cornerRadius = 5;
    availaibleLabel.layer.cornerRadius = 5;
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    NSLog(@"view will appear method Call");
}

-(void)viewDidLayoutSubviews
{
    bgScrollView.contentSize = CGSizeMake(320, 800);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    cell =nil;
    
    if(cell ==nil) {
        
        cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    }
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    NSString *imageUrlStr = [imageArray objectAtIndex:indexPath.row];
    //    NSString *imageData = [dict valueForKey:@"PicUrl"];
    NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
    [recipeImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    [recipeImageView sd_setImageWithURL:imageUrl
    //                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [cell.backgroundView addSubview:recipeImageView];
    
    
    return cell;
    
}

- (void)setSlideViewWithImageCountData:(NSInteger)imageCount {
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([sharedInstance.imagePopupCondition  isEqualToString: @"no"]) {
        
        [_slideImageViewController setImageLists:[imageArray mutableCopy]];
        [_slideImageViewController showAtIndex:0];
        
        sharedInstance.imagePopupCondition = @"yes";
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, 225);
}

-(void)doumeePrice:(UIButton *)sender {
    
    [self productWeightPricePopupButtonPushed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)requestBtnClicked:(id)sender {
}

- (IBAction)reserveHerBrnClicked:(id)sender {
}

- (IBAction)profileImageClicked:(id)sender {
    
    if ([sharedInstance.imagePopupCondition  isEqualToString: @"no"]) {
        _slideImageViewController = [PEARImageSlideViewController new];
        NSArray *imageLists = @[
                                [UIImage imageNamed:@"banner_img1.png"],
                                [UIImage imageNamed:@"banner_img1.png"],
                                [UIImage imageNamed:@"banner_img1.png"],
                                [UIImage imageNamed:@"banner_img1.png"],
                                [UIImage imageNamed:@"banner_img1.png"]
                                ].copy;
        [_slideImageViewController setImageLists:imageLists];
        [_slideImageViewController showAtIndex:0];
        sharedInstance.imagePopupCondition = @"yes";
    }
}

- (IBAction)doumeePriceButtonClicked:(id)sender {
    
    [self productWeightPricePopupButtonPushed];
}

- (IBAction)settingsButtonClicked:(id)sender {
    
    [self productWeightPricePopupButtonPushed];
}

- (IBAction)dateInformationAction:(id)sender {
    
    profileView.hidden = YES;
    dateInforamtionView.hidden = NO;
    
    dateBottomlineView.hidden = NO;
    profileBottomlineView.hidden = YES;
}

- (IBAction)profileAction:(id)sender {
    
    profileView.hidden = NO;
    dateInforamtionView.hidden = YES;
    
    dateBottomlineView.hidden = YES;
    profileBottomlineView.hidden = NO;
}




#pragma mark Product Weight Price Popup

-(void)productWeightPricePopupButtonPushed {
    
    kgModalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    kgModalView.backgroundColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:0.8];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height/2-20, self.view.frame.size.width-100, 100)];
    
    //  UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, self.view.frame.size.width-100, 100)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 5, contentView.frame.size.width-2, 94)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    
    UILabel *titleTextLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 10, whiteView.frame.size.width, 25) andTitle:@"Settings" andTextColor:[UIColor darkGrayColor]];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [contentView addSubview:titleTextLabel];
    
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+12, whiteView.frame.size.width, .5)];
    firstLineView.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:firstLineView];
    
    UILabel *priceLabel = [CommonUtils createLabelWithRect:CGRectMake(0, firstLineView.frame.origin.y+firstLineView.frame.size.height+5, whiteView.frame.size.width, 30) andTitle:@"Report" andTextColor:[UIColor darkGrayColor]];
    priceLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    //  [contentView addSubview:priceLabel];
    
    UIButton *blockButton = [CommonUtils createButtonWithRect:CGRectMake(20, firstLineView.frame.origin.y+firstLineView.frame.size.height+8, whiteView.frame.size.width-40, 30) andText:@"Block" andTextColor:[UIColor whiteColor] andFontSize:@"" andImgName:@""];
    [blockButton addTarget:self action:@selector(blockMethodCall) forControlEvents:UIControlEventTouchUpInside];
    [blockButton setBackgroundColor:[UIColor colorWithRed:101/255.0 green:53/255.0 blue:123/255.0 alpha:1.0]];
    blockButton.layer.cornerRadius = 3.0;
    [contentView addSubview:blockButton];
    [kgModalView addSubview:contentView];
    [self.view addSubview : kgModalView];
    
    UILabel *minimumHourPriceLabel = [CommonUtils createLabelWithRect:CGRectMake(0, priceLabel.frame.origin.y+priceLabel.frame.size.height, whiteView.frame.size.width, 30) andTitle:@"Issue" andTextColor:[UIColor darkGrayColor]];
    minimumHourPriceLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    minimumHourPriceLabel.textAlignment = NSTextAlignmentCenter;
    // [contentView addSubview:minimumHourPriceLabel];
    
    contentView.hidden = NO;
    contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration : 0.3/1.5 animations:^{
        contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3/2 animations:^{
                contentView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    
    //  [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
    
}

-(void)blockMethodCall {
    
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    
    self.dateIdStr = @"Date7";
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userIDTO=%@&userIDFrom=%@",APIAddBlcokUser,customerIdStr,userIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}



-(void)cancelButtonPushed{
    
    [kgModalView removeFromSuperview];
    [[KGModal sharedInstance] hideAnimated:YES];
}

- (void)dateRequestReceviedApiCall {
    
    self.dateIdStr = @"Date7";
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?LoginID=%@&DateID=%@",APIDateRequestDetails,@"Cu00e2618",self.dateIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                dataDictionary = [responseObject objectForKey:@"result"];
                
                NSArray *imageDataArray = [dataDictionary objectForKey:@"ContractorPictureList"];
                
                customerNameLabel.text =  [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"UserName"];
                customerNameLabel.numberOfLines = 0;
                customerNameLabel.lineBreakMode =NSLineBreakByWordWrapping;
                [customerNameLabel sizeToFit];
                
                
                //  customerIdStr
                
                int imgProductRatingWidth = customerNameLabel.frame.origin.x+customerNameLabel.frame.size.width+5;
                
                bodySizeLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Height"];
                favouriteImageView.frame = CGRectMake(imgProductRatingWidth, 5, 24, 22);
                distanceLabel.text =  [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"location"];
                
                bodyTypeLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"BodyType"];
                weightLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Weight"];
                hairLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"HairColor"];
                eyeColorLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"EyeColor"];
                smokingLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Smoking"];
                drinkingLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Drinking"];
                educationLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Education"];
                languageLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Language"];
                
                
                if ([[dataDictionary objectForKey:@"MettUplocation"] isKindOfClass:[NSDictionary class]]) {
                    
                    dateTimeLabel.text = [[dataDictionary objectForKey:@"MettUplocation"]objectForKey:@"RequestTime"];
                    addressLabel.text = [[dataDictionary objectForKey:@"MettUplocation"]objectForKey:@"Location"];
                    notesLabel.text = [[dataDictionary objectForKey:@"MettUplocation"]objectForKey:@"Notes"];
                }
                
                NSString *photoVerifiedCheck = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorVerifiedItem"]objectForKey:@"PhotoStatus"]];
                NSString *idVerifiedCheck = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorVerifiedItem"]objectForKey:@"DocumentStatus"]];
                NSString *backgroundVerifiedCheck = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorVerifiedItem"]objectForKey:@"BackGroundStatus"]];
                
                if ([photoVerifiedCheck isEqualToString:@"1"]) {
                    
                    photoVerified.image = [UIImage imageNamed:@"check_icon.png"];
                    
                } else {
                    
                    photoVerified.image = [UIImage imageNamed:@"block-icon.png"];
                }
                
                if ([idVerifiedCheck isEqualToString:@"1"]) {
                    
                    idVerified.image = [UIImage imageNamed:@"check_icon.png"];
                    
                } else {
                    
                    idVerified.image = [UIImage imageNamed:@"block-icon.png"];
                }
                
                if ([backgroundVerifiedCheck isEqualToString:@"1"]) {
                    
                    backgroundVerified.image = [UIImage imageNamed:@"check_icon.png"];
                    
                } else {
                    
                    backgroundVerified.image = [UIImage imageNamed:@"block-icon.png"];
                }
                
                NSMutableArray *getImageArray;
                imageArray = [[NSMutableArray alloc]init];
                getImageArray = [[NSMutableArray alloc]init];
                
                for(NSDictionary *imagedataDictionary in imageDataArray) {
                    
                    NSString *imageUrlStr = [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"PicUrl"]];
                    [imageArray addObject:imageUrlStr];
                }
                
                [imageCollectionView reloadData];
                
            } else {
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

@end
