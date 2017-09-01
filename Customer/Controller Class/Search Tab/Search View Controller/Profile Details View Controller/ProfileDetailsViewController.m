
//  ProfileDetailsViewController.m
//  Customer
//  Created by Jamshed Ali on 08/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "ProfileDetailsViewController.h"

#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height

@interface ProfileDetailsViewController () {
    
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    NSMutableArray *imageArray;
    NSDictionary *dataDictionary;
    UIView *dateBottomlineView;
    UIView *profileBottomlineView;
    NSString *customerIdStr;
    NSString *isFavouriteStr;
    NSString *hourlyRateStr;
    NSString *minimumHourStr;
    NSString *isOnlineStr;
    NSString *paymentMethodStr;
    NSString *rateAfterMinimumHourStr;
    NSString *contractorTypeStr;
    NSString *setPrimaryUrlStr;
    NSString *OnlineStrValue;
    BOOL favourite;
    BOOL online;
    NSString *rewardYesOrNo;
    UIView *doumeeRateView;
    NSString *numberOfPictureCountStr;
    UICollectionViewFlowLayout *colectionViewFlow;
}
@property (nonatomic,retain)PEARImageSlideViewController * slideImageViewController;
@end

@implementation ProfileDetailsViewController
@synthesize imageCountLabel,contractorIdStr,isOnlineStr,genderTypeStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tabBarController.tabBar setHidden:YES];
    NSLog(@"Tab Bar Height %f",self.tabBarController.tabBar.frame.size.height);
    [self.tabBarController.tabBar setFrame:CGRectMake(0, 0, 0, 0)];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    NSLog(@"view will appear method Call");
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    rewardYesOrNo = @"";
    colectionViewFlow =[[UICollectionViewFlowLayout alloc]init];
    numberOfPictureCountStr = @"";
    sharedInstance = [SingletonClass sharedInstance];
    sharedInstance.imagePopupCondition = @"no";
    userIdStr = sharedInstance.userId;
    
    dateBottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, dateInfoButton.frame.size.height - 1.0f, dateInfoButton.frame.size.width, 1)];
    dateBottomlineView.backgroundColor = [UIColor purpleColor];
    [dateInfoButton addSubview:dateBottomlineView];
    
    profileBottomlineView = [[UIView alloc] initWithFrame:CGRectMake(0, profileButton.frame.size.height - 1.0f, profileButton.frame.size.width, 1)];
    profileBottomlineView.backgroundColor = [UIColor purpleColor];
    [profileButton addSubview:profileBottomlineView];
    
    dateBottomlineView.hidden = NO;
    profileBottomlineView.hidden = YES;
    [self viewDidLayoutSubviews];
    [self contractorProfileDetailsApiCall];
    
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


- (void)viewDidLayoutSubviews {
    if (WIN_WIDTH == 320) {
        bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    }
    else
    {
        bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (imageArray.count)
        return [imageArray count];
    else
        return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    cell =nil;
    
    if(cell ==nil) {
        cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    }
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    UILabel *imageCountLbl = (UILabel *)[cell viewWithTag:299];
    UIView *doumeeCameraBgView = (UIView *)[cell viewWithTag:789];
    UILabel *userOnlineLbl = (UILabel *)[cell viewWithTag:777];
    [recipeImageView setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height+10)];

    if (imageArray.count) {
        NSString *imageUrlStr = [imageArray objectAtIndex:indexPath.row];
        NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
        
        [recipeImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //    [recipeImageView sd_setImageWithURL:imageUrl
        //                       placeholderImage:[UIImage imageNamed:@"placeholder_bg.png"]];
        [cell addSubview:recipeImageView];

    }
    else{
        [recipeImageView setImage:[UIImage imageNamed:@"placeholder_bg.png"]];
        [cell addSubview:recipeImageView];

    }
    
    
    doumeeCameraBgView.backgroundColor = [UIColor blackColor];
    doumeeCameraBgView.layer.cornerRadius = 4;
    doumeeCameraBgView.alpha =  0.5;
    doumeeCameraBgView.layer.masksToBounds = YES;
    
    UIImageView *camreraImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(6, 6, 15, 11)];
    camreraImage.backgroundColor = [UIColor clearColor];
    camreraImage.image = [UIImage imageNamed:@"camera.png"];
    [doumeeCameraBgView addSubview:camreraImage];
    
    //    numberOfPictureCountStr
    
    NSString *countStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    NSString *imageCountStr = [NSString stringWithFormat:@"%ld",(unsigned long)imageArray.count];
    imageCountLbl.text = [NSString stringWithFormat:@"%@/%@",countStr,imageCountStr];
    imageCountLbl.backgroundColor = [UIColor clearColor];
    imageCountLbl.textColor = [UIColor whiteColor];
    
    NSLog(@"%@",imageCountLbl.text);
    [doumeeCameraBgView addSubview:imageCountLbl];
    [cell addSubview:doumeeCameraBgView];
    
    BOOL onlineUser = [self.isOnlineStr boolValue];
    
    if (onlineUser) {
        userOnlineLbl.backgroundColor = [UIColor colorWithRed:108.0/255.0 green:161.0/255.0 blue:77.0/255.0 alpha:1.0];
    } else {
        
        userOnlineLbl.backgroundColor = [UIColor clearColor];
    }
    userOnlineLbl.layer.cornerRadius=userOnlineLbl.frame.size.height/2;
    userOnlineLbl.layer.masksToBounds = YES;
    [cell addSubview:userOnlineLbl];
    return cell;
}

- (void)setSlideViewWithImageCountData:(NSInteger)imageCount {
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([sharedInstance.imagePopupCondition  isEqualToString: @"no"]) {
        sharedInstance.imagePopupCondition = @"yes";
        _slideImageViewController = [PEARImageSlideViewController new];
        [_slideImageViewController setImageLists:[imageArray mutableCopy]];
        [_slideImageViewController showAtIndex:0];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Collection View Width %f",collectionView.frame.size.width);
    if (self.view.frame.size.width == 414)
        return CGSizeMake(self.view.frame.size.width, 385);
    else
        return CGSizeMake(self.view.frame.size.width, 385);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Request Now Method Call
- (IBAction)requestBtnClicked:(id)sender {
    
    if (online) {
        
        RequestNowViewController *requestNowView = [self.storyboard instantiateViewControllerWithIdentifier:@"requestNow"];
        requestNowView.self.requestNowDataDictionary = [dataDictionary mutableCopy];
        requestNowView.self.imageUrlStr = setPrimaryUrlStr;
        requestNowView.self.contractorId = self.contractorIdStr;
        requestNowView.self.checkControllerStr =@"search";
        [self.navigationController pushViewController:requestNowView animated:YES];
    }
    else {
    }
}


#pragma mark Reserve Her Method Call
- (IBAction)reserveHerBrnClicked:(id)sender {
    
    ReserveViewController *reserveView = [self.storyboard instantiateViewControllerWithIdentifier:@"reserve"];
    reserveView.self.reserveDataDictionary = [dataDictionary mutableCopy];
    reserveView.self.imageUrlStr = setPrimaryUrlStr;
    reserveView.self.contractorId = self.contractorIdStr;
    reserveView.self.checkControllerStr =@"search";
    reserveView.self.rewardOnOff = rewardYesOrNo;
    [self.navigationController pushViewController:reserveView animated:YES];
    
}

#pragma Doumee Price Method Call
- (IBAction)doumeePriceButtonClicked:(id)sender {
    
    if ([sharedInstance.imagePopupCondition  isEqualToString: @"no"]) {
        [self doumeePricePopupButtonPushed];
    }
}

- (IBAction)settingsButtonClicked:(id)sender {
    
    UIButton *btn =(UIButton *)sender;
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Alert"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(alertItem:)],
      
      [KxMenuItem menuItem:@"Report"
                     image:nil
                    target:self
                    action:@selector(reportItem:)],
      
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor whiteColor];
    first.alignment = NSTextAlignmentCenter;
    [KxMenu showMenuInView:self.view
                  fromRect:btn.frame
                 menuItems:menuItems];
    
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


#pragma mark Add Favourite Mark
- (IBAction)favouriteClicked:(id)sender {
    
    if(favourite) {
        
        /*
         NSString *urlstr=[NSString stringWithFormat:@"%@?userIDTO=%@&userIDFrom=%@",APIDeleteFavouriteUser,self.contractorIdStr,userIdStr];
         
         NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         
         [ProgressHUD show:@"Please wait..." Interaction:NO];
         [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
         NSLog(@"response object Get UserInfo List %@",responseObject);
         
         [ProgressHUD dismiss];
         
         if(!error){
         
         NSLog(@"Response is --%@",responseObject);
         
         if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
         
         favouriteImageView.image = [UIImage imageNamed:@"heart_light"];
         favourite = FALSE;
         
         } else {
         
         [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
         }
         }
         }];
         
         */
        
    }
    else {
        
        NSString *urlstr=[NSString stringWithFormat:@"%@?userIDTO=%@&userIDFrom=%@",APIAddFavouriteUser,self.contractorIdStr,userIdStr];
        
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrlForQAPurpose:urlstr withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    favouriteImageView.image = [UIImage imageNamed:@"heart"];
                    favourite = TRUE;
                    
                } else {
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
        
    }
}

- (void)cancelButtonPushed {
    [[KGModal sharedInstance] hideAnimated:YES];
}

- (void)contractorProfileDetailsApiCall {
    [self.tabBarController.tabBar setHidden:YES];
    
    NSString *latitudeStr;
    NSString *lonitudeStr;
    if ( sharedInstance.checkLocationAutoOrGPS == NO) {
        //         sharedInstance.latiValueStr = @"28.648781";
        //        sharedInstance.longiValueStr = @"77.315540";
        latitudeStr = sharedInstance.latiValueStr;
        lonitudeStr = sharedInstance.longiValueStr;
        //  latitudeStr = sharedInstance.customLatiValueStr;
        if (!latitudeStr) {
            latitudeStr = @"28.648781";
        }
        
        //  lonitudeStr = sharedInstance.customLongiValueStr;
        if (!lonitudeStr) {
            lonitudeStr =  @"77.315540";
        }
        
        NSLog(@"Latitude Value %@",latitudeStr);
        NSLog(@"Longtitude Value %@",lonitudeStr);
    }
    else
    {
        latitudeStr = sharedInstance.customLatiValueStr;
        if (!latitudeStr) {
            latitudeStr = @"28.648781";
        }
        
        lonitudeStr = sharedInstance.customLongiValueStr;
        if (!lonitudeStr) {
            lonitudeStr = @"77.315540";
        }
        NSLog(@"Latitude Value %@",latitudeStr);
        NSLog(@"Longtitude Value %@",lonitudeStr);
    }
    
    if ([self.isOnlineStr isEqualToString:@"1"]) {
        OnlineStrValue = @"True";
    }
    else{
        OnlineStrValue = @"False";
        
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setObject:self.contractorIdStr forKey:@"UserID"];
    [param setObject:OnlineStrValue forKey:@"isOnline"];
    [param setObject:userIdStr forKey:@"LoginID"];
    
    [param setObject:latitudeStr forKey:@"Lat1"];
    [param setObject:lonitudeStr forKey:@"Long1"];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApiForQA:APISearchContractorProfile withParams:param CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            UIImageView *placeHolderView = (UIImageView *)[self.view viewWithTag:400];
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                dataDictionary = [responseObject objectForKey:@"result"];
                [placeHolderView setHidden:YES];
                NSArray *imageDataArray;
                
                if ([[dataDictionary objectForKey:@"ContractorPictureList"] isKindOfClass:[NSArray class]]) {
                    
                    imageDataArray = [dataDictionary objectForKey:@"ContractorPictureList"];
                }
                titleNameLabel.text = [[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"UserName"] uppercaseString];
                customerNameLabel.text =  [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"UserName"];
                customerNameLabel.numberOfLines = 0;
                customerNameLabel.lineBreakMode =NSLineBreakByWordWrapping;
                [customerNameLabel sizeToFit];
                BOOL reservationn = [[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"isReservationAllowed"] boolValue];
                if (reservationn) {
                    [reserveHerButton setUserInteractionEnabled:YES];
                    reserveHerButton.layer.borderColor = [UIColor colorWithRed:88/255.0 green:48/255.0 blue:106/255.0 alpha:1.0].CGColor;
                    [reserveHerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [reserveHerButton setBackgroundColor:[UIColor colorWithRed:99.0/255.0 green:57.0/255.0 blue:110.0/255.0 alpha:1.0]];
                    [requestNowButton setBackgroundColor:[UIColor colorWithRed:99.0/255.0 green:57.0/255.0 blue:110.0/255.0 alpha:1.0]];
                    
                }
                else {
                    
                    [reserveHerButton setUserInteractionEnabled:NO];
                    reserveHerButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    [reserveHerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [reserveHerButton setBackgroundColor:[UIColor whiteColor]];
                }
                
                online = [[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"IsOnline"] boolValue];
                
                if (online) {
                    
                }
                else {
                    requestNowButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    requestNowButton.backgroundColor = [UIColor whiteColor];
                    [requestNowButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                }
                
                if ([self.genderTypeStr isEqualToString:@"1"]) {
                    [reserveHerButton setTitle:@"RESERVE HIM" forState:UIControlStateNormal];
                    
                }
                else {
                    
                    [reserveHerButton setTitle:@"RESERVE HER" forState:UIControlStateNormal];
                }
                
                
                isFavouriteStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"isFavourite"]];
                hourlyRateStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"HourlyRate"]];
                minimumHourStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"MinimumHours"]];
                isOnlineStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"IsOnline"]];
                paymentMethodStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"PaymentMethod"]];
                rateAfterMinimumHourStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"RateAfterMinimumHour"]];
                int imgProductRatingWidth = customerNameLabel.frame.origin.x+customerNameLabel.frame.size.width+5;
                favourite = [[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"isFavourite"] boolValue];
                bodySizeLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Ethnicity"],[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"AGE"],[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Height"]];
                favouriteImageView.frame = CGRectMake(imgProductRatingWidth, 5, 24, 22);
                favouriteButton.frame = CGRectMake(imgProductRatingWidth, 5, 40, 40);
                if (favourite) {
                    
                    favouriteImageView.image = [UIImage imageNamed:@"heart"];
                } else {
                    
                    favouriteImageView.image = [UIImage imageNamed:@"heart_light"];
                }
                
                distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", [[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"location"] floatValue]];
                
                bodyTypeLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"BodyType"];
                weightLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Weight"];
                hairLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"HairColor"];
                eyeColorLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"EyeColor"];
                smokingLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Smoking"];
                
                numberOfPictureCountStr = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"NumberofPicture"]];
                
                
                drinkingLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Drinking"];
                educationLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Education"];
                if ([[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Language"] length]) {
                    NSString *languageValue = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Language"];
                    if ([languageValue length] > 0) {
                        languageValue = [languageValue substringToIndex:[languageValue length] - 1];
                    }
                    else {
                        //no characters to delete... attempting to do so will result in a crash
                    }
                    languageLabel.text = languageValue;
                }
                //languageLabel.text = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Language"];
                
                dateTimeLabel.text = [[dataDictionary objectForKey:@"MettUplocation"]objectForKey:@"RequestTime"];
                addressLabel.text = [[dataDictionary objectForKey:@"MettUplocation"]objectForKey:@"Location"];
                notesLabel.text = [[dataDictionary objectForKey:@"MettUplocation"]objectForKey:@"Notes"];
                
                NSString *contractorType = [[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"ContractorTypeName"];
                
                contractorTypeStr = contractorType;
                
                [contractorTypeButton setTitle:contractorType forState:UIControlStateNormal];
                
                NSString *photoVerifiedCheck = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorVerifiedItem"]objectForKey:@"PhotoStatus"]];
                NSString *idVerifiedCheck = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorVerifiedItem"]objectForKey:@"DocumentStatus"]];
                NSString *backgroundVerifiedCheck = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorVerifiedItem"]objectForKey:@"BackGroundStatus"]];
                
                if ([photoVerifiedCheck isEqualToString:@"1"]) {
                    
                    photoVerified.image = [UIImage imageNamed:@"verified.png"];
                    [photoVerificationLabel setTextColor:[UIColor colorWithRed:109.0/255.0 green:162.0/255.0 blue:79.0/255.0 alpha:1.0]];
                    
                    
                } else {
                    
                    photoVerified.image = [UIImage imageNamed:@"not_verified.png"];
                    [photoVerificationLabel setTextColor:[UIColor darkGrayColor]];
                }
                
                if ([idVerifiedCheck isEqualToString:@"1"]) {
                    
                    idVerified.image = [UIImage imageNamed:@"verified.png"];
                    [idVerificationLabel setTextColor:[UIColor colorWithRed:109.0/255.0 green:162.0/255.0 blue:79.0/255.0 alpha:1.0]];
                    
                    
                } else {
                    
                    idVerified.image = [UIImage imageNamed:@"not_verified.png"];
                    [idVerificationLabel setTextColor:[UIColor darkGrayColor]];
                    
                }
                
                if ([backgroundVerifiedCheck isEqualToString:@"1"]) {
                    
                    backgroundVerified.image = [UIImage imageNamed:@"verified.png"];
                    [backgroundVerificationLabel setTextColor:[UIColor colorWithRed:109.0/255.0 green:162.0/255.0 blue:79.0/255.0 alpha:1.0]];
                    
                    
                    
                } else {
                    
                    backgroundVerified.image = [UIImage imageNamed:@"not_verified.png"];
                    [backgroundVerificationLabel setTextColor:[UIColor darkGrayColor]];
                    
                }
                
                
                NSMutableArray *getImageArray;
                imageArray = [[NSMutableArray alloc]init];
                getImageArray = [[NSMutableArray alloc]init];
                
                likeDetailsLbl.text = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"Description"]];
                
                likeDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
                likeDetailsLbl.numberOfLines = 0;
                [likeDetailsLbl sizeToFit];
                
                datingTitleLbl.frame = CGRectMake(15, likeDetailsLbl.frame.origin.y+likeDetailsLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
                
                datingDetailsLbl.frame = CGRectMake(15, datingTitleLbl.frame.origin.y+datingTitleLbl.frame.size.height+10, self.view.frame.size.width-30, 25);
                
                datingDetailsLbl.text = [NSString stringWithFormat:@"%@",[[dataDictionary objectForKey:@"ContractorProfile"]objectForKey:@"PrefrencesDescription"]];
                
                datingDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
                datingDetailsLbl.numberOfLines = 0;
                [datingDetailsLbl sizeToFit];
                
                imageCountLabel.layer.cornerRadius = 5;
                availaibleLabel.layer.cornerRadius = 5;
                
                if ([[dataDictionary objectForKey:@"Reward"] isKindOfClass:[NSArray class]]) {
                    
                    rewardYesOrNo = @"Yes";
                } else {
                    
                    rewardYesOrNo = @"No";
                }
                
                NSString *primaryCheckStr = @"";
                
                if (imageDataArray.count>0) {
                    
                    for(NSDictionary *imagedataDictionary in imageDataArray) {
                        
                        NSString *checkPrimaryImage = [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"isPrimary"]];
                        
                        if ([checkPrimaryImage isEqualToString:@"1"]) {
                            primaryCheckStr = @"yes";
                            setPrimaryUrlStr =  [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"PicUrl"]];
                            [imageArray insertObject:setPrimaryUrlStr atIndex:0];
                        }
                        else
                        {
                            NSString *imageUrlStr = [NSString stringWithFormat:@"%@",[imagedataDictionary objectForKey:@"PicUrl"]];
                            [imageArray addObject:imageUrlStr];
                        }
                        
                     }
                    
                    if ([primaryCheckStr isEqualToString:@""]) {
                        
                    }
                    
                    [imageCollectionView reloadData];
                    
                }
                
            } else {
                [placeHolderView setHidden:NO];
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        } else {
            
        }
    }];
}


- (void)doumeePricePopupButtonPushed {
    
    NSString *contractorType = [NSString stringWithFormat:@"%@ Rate Card",contractorTypeStr];
    
    doumeeRateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    doumeeRateView.backgroundColor = [UIColor whiteColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height/2-78, self.view.frame.size.width-100, 155)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 5, contentView.frame.size.width-2, 149)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    
    UILabel *titleTextLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 15, whiteView.frame.size.width, 14) andTitle:contractorType andTextColor:[UIColor darkGrayColor]];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [contentView addSubview:titleTextLabel];
    
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+12, whiteView.frame.size.width, .5)];
    firstLineView.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:firstLineView];
    
    
    UILabel *priceLabel = [CommonUtils createLabelWithRect:CGRectMake(0, firstLineView.frame.origin.y+firstLineView.frame.size.height+5, whiteView.frame.size.width, 30) andTitle:[NSString stringWithFormat:@"%@ / hour",[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",hourlyRateStr]]] andTextColor:[UIColor darkGrayColor]];
    priceLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:priceLabel];
    
    UILabel *minimumHourPriceLabel = [CommonUtils createLabelWithRect:CGRectMake(0, priceLabel.frame.origin.y+priceLabel.frame.size.height, whiteView.frame.size.width, 30) andTitle:[NSString stringWithFormat:@"%@ hour minimum",minimumHourStr] andTextColor:[UIColor darkGrayColor]];
    minimumHourPriceLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    minimumHourPriceLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:minimumHourPriceLabel];
    
    UILabel *timeLabel = [CommonUtils createLabelWithRect:CGRectMake(0, minimumHourPriceLabel.frame.origin.y+minimumHourPriceLabel.frame.size.height, whiteView.frame.size.width, 30) andTitle:[NSString stringWithFormat:@"%@ / Minute After",[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%@",rateAfterMinimumHourStr]]] andTextColor:[UIColor darkGrayColor]];
    timeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:timeLabel];
    
    [doumeeRateView addSubview:contentView];
    
    [self.view addSubview:doumeeRateView];
    
    contentView.hidden = NO;
    
    contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
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
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [doumeeRateView removeFromSuperview];
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)alertItem:(id)sender {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@",APIAddContractorInAlertList,userIdStr,self.contractorIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApiForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue]  ==1) {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
            else {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        else {
            NSLog(@"Error");
        }
    }];
}


- (void)reportItem:(id)sender {
    
    NSLog(@"%@", sender);
    
    DateReportSubmitViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateReportSubmit"];
    dateReportView.self.requestType = @"ProfileReport";
    dateReportView.self.contractorIdStr = self.contractorIdStr;
    dateReportView.self.dateIdStr = @"";
    [self.navigationController pushViewController:dateReportView animated:YES];
}

@end
