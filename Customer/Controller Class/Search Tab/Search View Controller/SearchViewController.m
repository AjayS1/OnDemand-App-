
//  SearchViewController.m
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "SearchViewController.h"

@interface SearchViewController () {
    UIView *doumeeRateView;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    NSIndexPath *indepathValue ;
}

@end

@implementation SearchViewController

@synthesize requestNowBtn;
@synthesize reserveHerBtn;

#pragma mark:- UIView Controller Life Cycle Method
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"AvailableNowValue"];
    requestNowBtn.layer.cornerRadius = 3;
    requestNowBtn.layer.borderWidth = 1;
    requestNowBtn.layer.borderColor = [UIColor colorWithRed:88/255.0 green:48/255.0 blue:106/255.0 alpha:1.0].CGColor;
    [requestNowBtn setTitleColor:[UIColor colorWithRed:109/255.0 green:69/255.0 blue:127/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    reserveHerBtn.layer.cornerRadius = 3;
    reserveHerBtn.layer.borderWidth = 1;
    reserveHerBtn.layer.borderColor = [UIColor colorWithRed:88/255.0 green:48/255.0 blue:106/255.0 alpha:1.0].CGColor;
    [reserveHerBtn setTitleColor:[UIColor colorWithRed:109/255.0 green:69/255.0 blue:127/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:@"ApplyFilter"];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    sharedInstance = [SingletonClass sharedInstance];
    checkOnlineStr = @"";
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    imageDataArray = [[NSMutableArray alloc]init];
    doumeeNotAvailableNowLabel.hidden = YES;
    noResultFoundLabel.hidden = YES;
    searchImageView.hidden = YES;
    userIdStr = sharedInstance.userId;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dateEndThenPaymentScreen:)
                                                 name:@"dateEndThenPaymentScreen"
                                               object:nil];
    NSLog(@"Search viewWillAppear method Call");
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    [self getContractorSearchFilterVlaueData];
    NSString *filterApplyStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"ApplyFilter"];
    
    if ([filterApplyStr isEqualToString:@"Yes"]) {
        availableNearbySegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
        [self fetchContractorSearchApiData];
        
    }
    else {
        
        NSString *strForAvailableNowData = [[NSUserDefaults standardUserDefaults]objectForKey:@"AvailableNowValue"];
        if ([strForAvailableNowData isEqualToString:@"1"]) {
            availableNearbySegmentedControl.selectedSegmentIndex = 0;
        } else {
            availableNearbySegmentedControl.selectedSegmentIndex = 1;
        }
        [self fetchContractorSearchApiData];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Search viewDidAppear method Call");
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"dateEndThenPaymentScreen"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [[KGModal sharedInstance] hideAnimated:YES];
}


#pragma mark:- UINotification Method
- (void)dateEndThenPaymentScreen:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    NSString *dateIDValueStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateId"]];
    PaymentDateCompletedViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentDateCompleted"];
    dateDetailsView.self.dateIdStr = dateIDValueStr;
    dateDetailsView.self.dateTypeStr = requestTypeStr;
    [self.navigationController pushViewController:dateDetailsView animated:YES];
    
}

-(void)updateBadges:(NSNotification*) noti {
    
    if (APPDELEGATE.tabBarC) {
        NSDictionary* responseObject = noti.userInfo;
        if ([[responseObject objectForKey:@"Dates"] isEqualToString:@"0"]) {
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
            
        }
        else {
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [responseObject objectForKey:@"Dates"];
        }
        
        if ([[responseObject  objectForKey:@"Mesages"] isEqualToString:@"0"]) {
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
            
        }
        else {
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue  = [responseObject objectForKey:@"Mesages"];
        }
        
        if ([[responseObject objectForKey:@"Notifications"] isEqualToString:@"0"]) {
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
            
        }
        else {
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue  = [responseObject objectForKey:@"Notifications"];
        }
    }
}

#pragma mark :- UITabBar Delegtae Method
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

- (void)leftBarButtonItemClicked {
    
    self.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover"];
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_discover_selected"];
    self.tabBarItem.title = @"Woo!";
    
}

- (void)rightBarButtonItemClicked {
    [(LCTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController setSelectedIndex:1];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
                                                      object:nil
                                                       queue:mainQueue
                                                  usingBlock:^(NSNotification *note) {
                                                      // executes after screenshot
                                                      UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Hey!"
                                                                                                       message:@" Touched end You're not allowed to do that"
                                                                                                      delegate:self
                                                                                             cancelButtonTitle:@"Cancel"
                                                                                             otherButtonTitles: nil];
                                                      [alert addButtonWithTitle:@"GO"];
                                                      [alert show];
                                                      return;
                                                  }];
    
}

#pragma mark :- Additional Useful Method

- (void)screenshotDetected {
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
                                                      object:nil
                                                       queue:mainQueue
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      // executes after screenshot
                                                      UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Hey!"
                                                                                                       message:@"You're not allowed to do that"
                                                                                                      delegate:self
                                                                                             cancelButtonTitle:@"Cancel"
                                                                                             otherButtonTitles: nil];
                                                      [alert addButtonWithTitle:@"GO"];
                                                      [alert show];
                                                      return;
                                                  }];
}


#pragma mark AvailableNow Segment Controll Method Call
- (IBAction)currentHistorySegmentControlBtnClicked:(UISegmentedControl *)availableNearbySegmentControl {
    
    switch (availableNearbySegmentControl.selectedSegmentIndex) {
        case 0:
        {
            availableNearbySegmentedControl.selectedSegmentIndex = availableNearbySegmentControl.selectedSegmentIndex;
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"AvailableNowValue"];
            [self fetchContractorSearchApiData];
        }
            break;
        case 1:
        {
            availableNearbySegmentedControl.selectedSegmentIndex = availableNearbySegmentControl.selectedSegmentIndex;
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"AvailableNowValue"];
            [self fetchContractorSearchApiData];
        }
        default:
            break;
    }
}

#pragma mark :- UICollection View Delegate Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    UIActivityIndicatorView *imageActivityIndicator = (UIActivityIndicatorView *)[cell viewWithTag:567];
    UIView *dataView = (UIView *)[cell viewWithTag:444];
    UILabel *userNameLbl = (UILabel *)[cell viewWithTag:111];
    UILabel *distanceLbl = (UILabel *)[cell viewWithTag:222];
    UILabel *userHeightLbl = (UILabel *)[cell viewWithTag:333];
    UILabel *userOnlineLbl = (UILabel *)[cell viewWithTag:777];
    UILabel *imageCountLbl = (UILabel *)[cell viewWithTag:999];
    UILabel *doumeeTypeLabel = (UILabel *)[cell viewWithTag:77];
    UIView *doumeeCameraBgView = (UIView *)[cell viewWithTag:789];
    UIButton *rateButton = (UIButton *)[cell viewWithTag:555];
    UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[cell viewWithTag:900];
    [indicatorView startAnimating];
    [imageActivityIndicator setHidden:YES];
    [rateButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // [imageActivityIndicator startAnimating];
    dictForTable = [[NSMutableDictionary alloc]init];
    NSLog(@"IndexPath %ld",(long)indexPath.row);
    dictForTable = [imageDataArray objectAtIndex:indexPath.row];
    NSString *imageData = [dictForTable valueForKey:@"PrimaryPicURL"];
    NSURL *imageUrl = [NSURL URLWithString:imageData];
    
    [recipeImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if (recipeImageView.image) {
        [indicatorView removeFromSuperview];
    }
    recipeImageView.contentMode = UIViewContentModeScaleAspectFit;
    //  recipeImageView.image = [self resizeImage:(UIImage *)recipeImageView.image];
    
    NSString *firstNameStr = [dictForTable valueForKey:@"FirstName"];
    userNameLbl.text = firstNameStr;
    NSString *distanceStr = [dictForTable valueForKey:@"Distance"];
    
    if ([distanceStr isEqual: [NSNull null]]) {
        NSString *locationValueStr = [NSString stringWithFormat:@"%@",[dictForTable valueForKey:@"location"]];
        if ([locationValueStr isEqual:@"<null>"]|| [locationValueStr isEqual: [NSNull null]] ||[locationValueStr isEqual: @"(null)"]) {
            userHeightLbl.text = @"0.00 mi";
            
        }
        else {
            userHeightLbl.text = [NSString stringWithFormat:@"%@",[dictForTable valueForKey:@"location"]];
        }
    }
    else {
        userHeightLbl.text = [NSString stringWithFormat:@"%.2f mi",[distanceStr floatValue]];
    }
    
    NSString *heightStr = [NSString stringWithFormat:@"%@ | %@ | %@",[dictForTable valueForKey:@"Ethnicity"],[dictForTable valueForKey:@"AGE"],[dictForTable valueForKey:@"Height"]];
    distanceLbl.text = heightStr;
    
    NSString *doumeeType = [dictForTable objectForKey:@"ContractorTypeName"];
    doumeeTypeLabel.text = doumeeType;
    rateButton.tag = indexPath.row;
    
    doumeeCameraBgView.backgroundColor = [UIColor blackColor];
    doumeeCameraBgView.layer.cornerRadius = 4;
    doumeeCameraBgView.alpha =  0.5;
    doumeeCameraBgView.layer.masksToBounds = YES;
    
    UIImageView *camreraImage = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(6, 6, 15, 11)];
    camreraImage.backgroundColor = [UIColor clearColor];
    camreraImage.image = [UIImage imageNamed:@"camera.png"];
    [doumeeCameraBgView addSubview:camreraImage];
    
    NSString *countStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    NSString *imageCountStr = [NSString stringWithFormat:@"%@",[dictForTable valueForKey:@"NumberofPicture"]];
    imageCountLbl.text = [NSString stringWithFormat:@"%@",imageCountStr];
    imageCountLbl.backgroundColor = [UIColor clearColor];
    imageCountLbl.textAlignment = NSTextAlignmentCenter;
    if (indexPath.row == 0) {
        numberOfUsersLabel.text = [NSString stringWithFormat:@"%@/%lu",countStr,(unsigned long)imageDataArray.count];
    }
    
    NSString *genderTypeStr = [dictForTable valueForKey:@"Gender"];
    if ([genderTypeStr isEqualToString:@"1"]) {
        [reserveHerBtn setTitle:@"RESERVE HIM" forState:UIControlStateNormal];
    }
    else {
        [reserveHerBtn setTitle:@"RESERVE HER" forState:UIControlStateNormal];
    }
    
    BOOL online = [[dictForTable valueForKey:@"IsOnline"] boolValue];
    BOOL reservationn = [[dictForTable valueForKey:@"isReservationAllowed"] boolValue];
    
    if (online) {
        checkOnlineStr = @"1";
        userOnlineLbl.backgroundColor = [UIColor colorWithRed:108.0/255.0 green:161.0/255.0 blue:77.0/255.0 alpha:1.0];
        requestNowBtn.layer.borderColor = [UIColor colorWithRed:88/255.0 green:48/255.0 blue:106/255.0 alpha:1.0].CGColor;
        [requestNowBtn setTitleColor:[UIColor colorWithRed:109/255.0 green:69/255.0 blue:127/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else {
        
        checkOnlineStr = @"0";
        userOnlineLbl.backgroundColor = [UIColor clearColor];
        requestNowBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [requestNowBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    if (reservationn) {
        [reserveHerBtn setUserInteractionEnabled:YES];
        reserveHerBtn.layer.borderColor = [UIColor colorWithRed:88/255.0 green:48/255.0 blue:106/255.0 alpha:1.0].CGColor;
        [reserveHerBtn setTitleColor:[UIColor colorWithRed:109/255.0 green:69/255.0 blue:127/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else {
        
        [reserveHerBtn setUserInteractionEnabled:NO];
        reserveHerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [reserveHerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    userOnlineLbl.layer.cornerRadius=userOnlineLbl.frame.size.height/2;
    userOnlineLbl.layer.masksToBounds = YES;
    [cell.backgroundView addSubview:recipeImageView];
    [cell.backgroundView addSubview:dataView];
    [dataView addSubview:rateButton];
    [dataView addSubview:doumeeTypeLabel];
    [dataView addSubview:userNameLbl];
    [dataView addSubview:distanceLbl];
    [dataView addSubview:userHeightLbl];
    
    //  [cell.backgroundView addSubview:imageCountLbl];
    [cell.backgroundView addSubview:userOnlineLbl];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    swipeRight.delegate = self;
    swipeRight.numberOfTouchesRequired = 1;
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipeLeft.delegate = self;
    swipeLeft.numberOfTouchesRequired = 1;
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [doumeeCollectionView addGestureRecognizer:swipeLeft];
    [doumeeCollectionView addGestureRecognizer:swipeRight];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, self.view.frame.size.height-170);
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath.row ==%ld",(long)indexPath.row);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = doumeeCollectionView.frame.size.width;
    float currentPage = doumeeCollectionView.contentOffset.x / pageWidth;
    APPDELEGATE.searchCountString = [NSString stringWithFormat:@"%f",currentPage];
    if (0.0f != fmodf(currentPage, 1.0f))
    {
        NSLog(@"indexPath.row currentPage ==%f",currentPage + 1);
        NSString *imageCountStr = [NSString stringWithFormat:@"%.0f",(float)currentPage+1];
        NSString *countStr = [NSString stringWithFormat:@"%ld",(long)imageDataArray.count];
        NSLog(@"street %@,%@",imageCountStr,countStr);
    }
    else {
        
        NSLog(@"indexPath.row == currentPage %f",currentPage);
        NSLog(@"finishPage currentPage: %ld", (long)currentPage);
        
        dictForTable = [[NSMutableDictionary alloc]init];
        dictForTable = [imageDataArray objectAtIndex:(long)currentPage];
        NSString *imageCountStr = [NSString stringWithFormat:@"%ld",(long)currentPage+1];
        NSString *countStr = [NSString stringWithFormat:@"%ld",(long)imageDataArray.count];
        numberOfUsersLabel.text = [NSString stringWithFormat:@"%@/%@",imageCountStr,countStr];
        NSString *genderTypeStr = [dictForTable valueForKey:@"Gender"];
        
        if ([genderTypeStr isEqualToString:@"1"]) {
            [reserveHerBtn setTitle:@"RESERVE HIM" forState:UIControlStateNormal];
        }
        else {
            [reserveHerBtn setTitle:@"RESERVE HER" forState:UIControlStateNormal];
        }
        
        BOOL online = [[dictForTable valueForKey:@"IsOnline"] boolValue];
        
        if (online) {
            checkOnlineStr = @"1";
            requestNowBtn.layer.borderColor = [UIColor colorWithRed:88/255.0 green:48/255.0 blue:106/255.0 alpha:1.0].CGColor;
            [requestNowBtn setTitleColor:[UIColor colorWithRed:109/255.0 green:69/255.0 blue:127/255.0 alpha:1.0] forState:UIControlStateNormal];
            
        }
        else {
            checkOnlineStr = @"0";
            requestNowBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [requestNowBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
        BOOL reservationn = [[dictForTable valueForKey:@"isReservationAllowed"] boolValue];
        if (reservationn) {
            [reserveHerBtn setUserInteractionEnabled:YES];
            reserveHerBtn.layer.borderColor = [UIColor colorWithRed:88/255.0 green:48/255.0 blue:106/255.0 alpha:1.0].CGColor;
            [reserveHerBtn setTitleColor:[UIColor colorWithRed:109/255.0 green:69/255.0 blue:127/255.0 alpha:1.0] forState:UIControlStateNormal];
        } else {
            
            [reserveHerBtn setUserInteractionEnabled:NO];
            reserveHerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [reserveHerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
    NSLog(@"finishPage currentPage: %ld", (long)currentPage);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *contractorId = [NSString stringWithFormat:@"%@",[[imageDataArray objectAtIndex:indexPath.row]valueForKey:@"UserID"]];
    ProfileDetailsViewController *profileDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"contractorProfile"];
    profileDetailsView.self.contractorIdStr = contractorId;
    [profileDetailsView.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([[[imageDataArray objectAtIndex:indexPath.row]valueForKey:@"IsOnline"]isEqualToString:@"False"]) {
        profileDetailsView.self.isOnlineStr = @"0";
    }
    else
    {
        profileDetailsView.self.isOnlineStr = @"1";
    }
    profileDetailsView.self.genderTypeStr = [NSString stringWithFormat:@"%@",[[imageDataArray objectAtIndex:indexPath.row]valueForKey:@"Gender"]];
    [self.navigationController pushViewController:profileDetailsView animated:YES];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Resize Image
- (UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 800.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 1.0;//50 percent compression
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    return [UIImage imageWithData:imageData];
}


- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationMedium);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UIButton Action Clicked Call
- (IBAction)requestNowBtnClicked:(id)sender {
    if ([sharedInstance.isPastDuePayment isEqualToString:@"1"]) {
        [[AlertView sharedManager] presentAlertWithTitle:@"Cannot Send Request" message:@"You cannot send request because your account is On Hold status."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                            //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                               //   [self performSelector:@selector(obj) withObject:self afterDelay:3];
                                           }];
    }
    else{
    if ([checkOnlineStr isEqualToString:@"1"]) {
        if ([dictForTable isKindOfClass:[NSDictionary class]]) {
            RequestNowViewController *requestNowView = [self.storyboard instantiateViewControllerWithIdentifier:@"requestNow"];
            requestNowView.requestNowDataDictionary = dictForTable;
            requestNowView.self.imageUrlStr = [dictForTable objectForKey:@"PrimaryPicURL"];
            [self.navigationController pushViewController:requestNowView animated:YES];
        }
        else {
            NSLog(@"data not found");
            [CommonUtils showAlertWithTitle:@"Alert!" withMsg:@"Result not found." inController:self];
        }
     }
    }
}

- (IBAction)reserveHerBtnClicked:(id)sender {
    if ([sharedInstance.isPastDuePayment isEqualToString:@"1"]) {
        [[AlertView sharedManager] presentAlertWithTitle:@"Cannot Send Request" message:@"You cannot send request because your account is On Hold status."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                               //   [self performSelector:@selector(obj) withObject:self afterDelay:3];
                                           }];
    }
    else{
    if ([dictForTable isKindOfClass:[NSDictionary class]]) {
        ReserveViewController *reserveView = [self.storyboard instantiateViewControllerWithIdentifier:@"reserve"];
        reserveView.reserveDataDictionary = dictForTable;
        reserveView.self.imageUrlStr = [dictForTable objectForKey:@"PrimaryPicURL"];
        [self.navigationController pushViewController:reserveView animated:YES];
    }
    else {
    }
    }
}

- (IBAction)refreshSearchBtnClicked:(id)sender {
    [self fetchContractorSearchApiData];
}

- (void)buttonPressed:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    CGPoint rootPoint = [button convertPoint:CGPointZero toView:doumeeCollectionView];
    NSIndexPath *indexPath = [doumeeCollectionView indexPathForItemAtPoint:rootPoint];
    dictionaryForDoumeerateCard = [imageDataArray objectAtIndex:indexPath.row];
    [self doumeePricePopupButtonPushed];
}

- (IBAction)filterBtnClicked:(id)sender {
    FilterViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"fliter"];
    [self.navigationController pushViewController:notiView animated:YES];
}


#pragma mark Doumee Price Method Call
-(void)doumeePrice:(UIButton *)sender {
    [self doumeePricePopupButtonPushed];
}

#pragma mark Doumee Price Popup

- (void)doumeePricePopupButtonPushed {
    
    doumeeRateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    doumeeRateView.backgroundColor = [UIColor clearColor];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height/2-78, self.view.frame.size.width-100, 155)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0;
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(1, 5, contentView.frame.size.width-2, 149)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    NSString *contractorTypeStr = [NSString stringWithFormat:@"%@ Rate Card",[dictionaryForDoumeerateCard valueForKey:@"ContractorTypeName"]];
    UILabel *titleTextLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 15, whiteView.frame.size.width, 14) andTitle:contractorTypeStr andTextColor:[UIColor darkGrayColor]];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [contentView addSubview:titleTextLabel];
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleTextLabel.frame.origin.y+titleTextLabel.frame.size.height+12, whiteView.frame.size.width, .5)];
    firstLineView.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:firstLineView];
    NSString *strForPerHourRate = [dictionaryForDoumeerateCard valueForKey:@"HourlyRate"];
    UILabel *priceLabel = [CommonUtils createLabelWithRect:CGRectMake(0, firstLineView.frame.origin.y+firstLineView.frame.size.height+5, whiteView.frame.size.width, 30) andTitle:[NSString stringWithFormat:@"$%@ / hour",[CommonUtils getFormateedNumberWithValue:strForPerHourRate]] andTextColor:[UIColor darkGrayColor]];
    priceLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:priceLabel];
    NSString *minimumHourstr = [dictionaryForDoumeerateCard valueForKey:@"MinimumHours"];
    UILabel *minimumHourPriceLabel = [CommonUtils createLabelWithRect:CGRectMake(0, priceLabel.frame.origin.y+priceLabel.frame.size.height, whiteView.frame.size.width, 30) andTitle:[NSString stringWithFormat:@"%@ hour minimum",minimumHourstr] andTextColor:[UIColor darkGrayColor]];
    minimumHourPriceLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    minimumHourPriceLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:minimumHourPriceLabel];
    
    NSString *minuteAfterstr = [dictionaryForDoumeerateCard valueForKey:@"RateAfterMinimumHour"];
    UILabel *timeLabel = [CommonUtils createLabelWithRect:CGRectMake(0, minimumHourPriceLabel.frame.origin.y+minimumHourPriceLabel.frame.size.height, whiteView.frame.size.width, 30) andTitle:[NSString stringWithFormat:@"$%@ / Minute After",[CommonUtils getFormateedNumberWithValue:minuteAfterstr]] andTextColor:[UIColor darkGrayColor]];
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


- (void)cancelButtonPushed {
    [[KGModal sharedInstance] hideAnimated:YES];
}

-(void)getContractorSearchFilterVlaueData {
    
    dictForTypeDataValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedTypeDataValue"];
    dictForBodyTypeDataValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedBodyTypeDataValue"];
    dictForEthnicityValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedEthnicityDataValue"];
    dictForEyeColorValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedEyeColorDataValue"];
    dictForHairValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedHairColorDataValue"];
    dictForEducationValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedEducationDataValue"];
    dictForSmokingValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedSmokingDataValue"];
    dictForDrinkingValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedDrinkingDataValue"];
    dictForLanguageValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedLanguageDataValue"];
    dictForWeightValue= [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedWeightDataValue"];
    dictForHeightValue= [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedHeightDataValue"];
}


#pragma mark-- ContractorSearch API

- (void) fetchContractorSearchApiData {
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    if (locationAllowed) {
        
        NSString *strForSortByValuedata = [[NSUserDefaults standardUserDefaults]objectForKey:@"SortByValue"];
        if (!strForSortByValuedata) {
            strForSortByValuedata = @"Nearest";
        }
        
        NSString *  strForSortByDirectiondata= [[NSUserDefaults standardUserDefaults]objectForKey:@"SortDirectionValue"];
        if (!strForSortByDirectiondata) {
            strForSortByDirectiondata = @"Nearest";
        }
        //        NSString *strForSortByValuedata = @"Nearest";
        //        NSString *strForSortByDirectiondata = @"Nearest";
        NSString *strForAvailableNowData = @"0";
        NSString *strForBodyTypeDataValue = @"-1";
        NSString *strForEthnicityDataValue = @"-1";
        NSString *strForEyeColorDataValue = @"-1";
        NSString *strForHairColorDataValue =@"-1";
        NSString *strForSmokingDataValue = @"-1";
        NSString *strForDrinkingDataValue = @"-1";
        NSString *strForEducationDataValue = @"-1";
        NSString *strForLanguageDataValue = @"-1";
        NSString *strForMinWeightDataValue = @"60";
        NSString *strForMaxAgeDataValue = @"99";
        NSString *strForMaxWeightDataValue = @"300";
        NSString *strForMinHeightDataValue;
        NSString *strForMaxHeightDataValue;
        
        if ([sharedInstance.strUnityTypeValue isEqualToString:@"1"]) {
            strForMinHeightDataValue = @"48";
            strForMaxHeightDataValue = @"96";
        }
        else {
            strForMinHeightDataValue = @"122";
            strForMaxHeightDataValue = @"244";
        }
        
        NSString *strForMinAgeDataValue = @"18";
        NSString *strForCountryDataValue = @"";
        NSString *strForStateDataValue = @"";
        NSString *strForCityDataValue = @"";
        NSString *strForzipCodeDataValue = @"";
        NSString *strForDistance = @"100";
        NSString *contractorType = @"-1";
        NSString *strForTypeDataValue = @"-1";
        NSString *isOnlineValue = @"0";
        NSString *latitudeStr;
        NSString *lonitudeStr;
        if ( sharedInstance.checkLocationAutoOrGPS == NO) {
            latitudeStr = sharedInstance.latiValueStr;
            lonitudeStr = sharedInstance.longiValueStr;
            if (!latitudeStr) {
                latitudeStr = @"28.648781";
            }
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
                latitudeStr =  @"28.648781";
            }
            
            lonitudeStr = sharedInstance.customLongiValueStr;
            if (!lonitudeStr) {
                lonitudeStr = @"77.315540";
            }
            NSLog(@"Latitude Value %@",latitudeStr);
            NSLog(@"Longtitude Value %@",lonitudeStr);
        }
        
        NSString *filterApplyStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"ApplyFilter"];
        
        if ([filterApplyStr isEqualToString:@"Yes"]) {
            
            strForSortByValuedata= [[NSUserDefaults standardUserDefaults]objectForKey:@"SortByValue"];
            if (!strForSortByValuedata) {
                strForSortByValuedata = @"Nearest";
            }
            
            strForSortByDirectiondata= [[NSUserDefaults standardUserDefaults]objectForKey:@"SortDirectionValue"];
            if (!strForSortByDirectiondata) {
                strForSortByDirectiondata = @"Nearest";
            }
            
            strForAvailableNowData = sharedInstance.isOnlineFiltering;
            if (!strForAvailableNowData) {
                strForAvailableNowData = @"0";
            }
            
            if([strForAvailableNowData isEqualToString:@"1"])
            {
                isOnlineValue = @"1";
            }
            else
            {
                isOnlineValue = @"0";
            }
            
            // strForTypeDataValue = [dictForTypeDataValue valueForKey:@"TypeValue"];
            strForTypeDataValue = sharedInstance.strContractorTypeFilter;
            
            if (!strForTypeDataValue || [strForEthnicityDataValue isEqualToString:@"Any"]) {
                strForTypeDataValue = @"-1";
            }
            strForBodyTypeDataValue = sharedInstance.strContractorBodyTypeFilter ;
            
            if (!strForBodyTypeDataValue || [strForBodyTypeDataValue isEqualToString:@"Any"]) {
                strForBodyTypeDataValue = @"-1";
            }
            
            strForEthnicityDataValue = sharedInstance.strContractorEthencityTypeFilter;
            if (!strForEthnicityDataValue || [strForEthnicityDataValue isEqualToString:@""] || [strForEthnicityDataValue isEqualToString:@"Any"]) {
                strForEthnicityDataValue = @"-1";
            }
            strForEyeColorDataValue = sharedInstance.strContractorEyeColorTypeFilter ;
            if (!strForEyeColorDataValue || [strForEyeColorDataValue isEqualToString:@"Any"]) {
                strForEyeColorDataValue = @"-1";
            }
            strForHairColorDataValue = sharedInstance.strContractorHairColorTypeFilter ;
            if (!strForHairColorDataValue || [strForHairColorDataValue isEqualToString:@"Any"]) {
                strForHairColorDataValue = @"-1";
            }
            strForSmokingDataValue = sharedInstance.strContractorSmokingTypeFilter;
            if (!strForSmokingDataValue || [strForSmokingDataValue isEqualToString:@"Any"]) {
                strForSmokingDataValue = @"-1";
            }
            strForDrinkingDataValue = sharedInstance.strContractorDrinkingTypeFilter;
            if (!strForDrinkingDataValue || [strForDrinkingDataValue isEqualToString:@"Any"]) {
                strForDrinkingDataValue = @"-1";
            }
            strForEducationDataValue = sharedInstance.strContractorEducationTypeFilter ;
            if (!strForEducationDataValue || [strForEducationDataValue isEqualToString:@"Any"]) {
                strForEducationDataValue = @"-1";
            }
            strForLanguageDataValue = sharedInstance.strContractorLanguageTypeFilter;
            if (!strForLanguageDataValue || [strForLanguageDataValue isEqualToString:@"Any"]) {
                strForLanguageDataValue = @"-1";
                
            }
            strForMinWeightDataValue = sharedInstance.selectedStartWeightStr;
            if (!strForMinWeightDataValue) {
                strForMinWeightDataValue = @"60";
            }
            strForMaxWeightDataValue = sharedInstance.selectedEndWeightStr;
            if (!strForMaxWeightDataValue) {
                strForMaxWeightDataValue = @"300";
            }
            strForMinAgeDataValue = sharedInstance.selectedStartAgeStr;
            if (!strForMinAgeDataValue) {
                strForMinAgeDataValue = @"18";
            }
            strForMaxAgeDataValue = sharedInstance.selectedEndAgeStr;
            if (!strForMaxAgeDataValue) {
                strForMaxAgeDataValue = @"99";
            }
            if ([sharedInstance.selectedStartHeightStr length]) {
                strForMinHeightDataValue = [NSString stringWithFormat:@"%ld",(long)[sharedInstance.selectedStartHeightStr integerValue]];
                
            }
            else{
                strForMinHeightDataValue =sharedInstance.selectedStartHeightStr;
            }
            if (!strForMinHeightDataValue) {
                if ([sharedInstance.strUnityTypeValue isEqualToString:@"1"]) {
                    strForMinHeightDataValue = @"48";
                }
                else{
                    strForMinHeightDataValue = @"122";
                }
            }
            if ([sharedInstance.selectedEndHeightStr  length]) {
                strForMaxHeightDataValue = [NSString stringWithFormat:@"%ld",(long)[sharedInstance.selectedEndHeightStr integerValue]];
                
            }
            else{
                strForMaxHeightDataValue = sharedInstance.selectedEndHeightStr;
            }
            
            if (!strForMaxHeightDataValue) {
                if ([sharedInstance.strUnityTypeValue isEqualToString:@"1"]) {
                    strForMaxHeightDataValue = @"96";
                }
                else{
                    strForMaxHeightDataValue = @"244";
                }
            }
            strForCountryDataValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"CountryDataValue"];
            if (!strForCountryDataValue) {
                strForCountryDataValue = @"-1";
            }
            
            strForStateDataValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"StateDataValue"];
            if (!strForStateDataValue) {
                strForStateDataValue = @"-1";
            }
            
            strForCityDataValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"CityDataValue"];
            if (!strForCityDataValue) {
                strForCityDataValue = @"-1";
            }
            strForzipCodeDataValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"ZipCodeDataValue"];
            if (!strForzipCodeDataValue) {
                strForzipCodeDataValue = @"-1";
            }
            strForDistance = sharedInstance.distanceIntegerStr;
            if (!strForDistance) {
                strForDistance = @"100";
            }
            NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERTYPEDATA"];
            contractorType = [array componentsJoinedByString:@","];
            contractorType = @"";
        }
        
        NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",strForTypeDataValue,@"ContractorType",latitudeStr,@"Lat1" ,lonitudeStr, @"Long1",strForSortByDirectiondata,@"sortBy",strForDrinkingDataValue,@"Drinking",strForBodyTypeDataValue,@"BodyType",strForMinAgeDataValue,@"MinAge",strForMaxAgeDataValue,@"MaxAge",strForDistance,@"Distance",strForMinHeightDataValue,@"MinHeight",strForMaxHeightDataValue,@"MaxHeight",strForMinWeightDataValue,@"MinWeight",strForMaxWeightDataValue,@"MaxWeight",strForEthnicityDataValue,@"Ethencity",isOnlineValue,@"IsOnline",strForHairColorDataValue,@"HairColor",strForEyeColorDataValue,@"EyeColor",strForSmokingDataValue,@"Smoking",strForEducationDataValue,@"Education",strForLanguageDataValue,@"Language",nil];
        
        NSLog(@" Post Contractor Search List params %@",params);
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        
        [ServerRequest AFNetworkPostRequestUrlForAddNewApiForQA:APIContractorSearch withParams:params CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Post Contractor Search List %@",responseObject);
            
            [ProgressHUD dismiss];
            if ([responseObject  isKindOfClass:[NSString class]]) {
                
                requestNowBtn.hidden = YES;
                reserveHerBtn.hidden = YES;
                imageDataArray = [[NSMutableArray alloc]init];
                numberOfUsersLabel.text = @"";
                
                if([strForAvailableNowData isEqualToString:@"Yes"])
                {
                    doumeeNotAvailableNowLabel.hidden = NO;
                    noResultFoundLabel.hidden = NO;
                    searchImageView.hidden = NO;
                }
                else {
                    doumeeNotAvailableNowLabel.hidden = NO;
                    noResultFoundLabel.hidden = NO;
                    searchImageView.hidden = NO;
                }
                [self.view setBackgroundColor:[UIColor whiteColor]];
                [doumeeCollectionView setBackgroundColor:[UIColor whiteColor]];
                [doumeeCollectionView setContentOffset:CGPointZero];
                [doumeeCollectionView reloadData];
            }
            else {
                
                if(!error){
                    
                    NSLog(@"Response is --%@",responseObject);
                    
                    if ([[responseObject objectForKey:@"Status"] intValue] ==1) {
                        doumeeNotAvailableNowLabel.hidden = YES;
                        noResultFoundLabel.hidden = YES;
                        searchImageView.hidden = YES;
                        [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                        [doumeeCollectionView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                        imageDataArray = [[NSMutableArray alloc]init];
                        NSArray *contractorListingArray = [responseObject objectForKey:@"ContractorListing"];
                        for(NSDictionary *dictObj in contractorListingArray)
                        {
                            requestNowBtn.hidden = NO;
                            reserveHerBtn.hidden = NO;
                            [imageDataArray addObject:dictObj];
                        }
                        
                        NSString *imageCountStr = [NSString stringWithFormat:@"%d", ([APPDELEGATE.searchCountString integerValue] + 1)];
                        NSString *countStr = [NSString stringWithFormat:@"%ld",(long)imageDataArray.count];
                        numberOfUsersLabel.text = [NSString stringWithFormat:@"%@/%@",imageCountStr,countStr];
                        [doumeeCollectionView setContentOffset:CGPointZero];
                        if ([imageDataArray count] > [APPDELEGATE.searchCountString integerValue] && [imageDataArray objectAtIndex:[APPDELEGATE.searchCountString integerValue]] !=nil){
                            if (APPDELEGATE.searchCountString != nil) {
                                //                            indepathValue = [NSIndexPath indexPathForRow:[APPDELEGATE.searchCountString integerValue] inSection:
                                //                                             0];
                                indepathValue = [NSIndexPath indexPathForItem:[APPDELEGATE.searchCountString integerValue] inSection:0];
                                
                            }
                            else{
                                indepathValue = [NSIndexPath indexPathForItem:0 inSection:
                                                 0];
                            }
                        }
                        else{
                            indepathValue = [NSIndexPath indexPathForItem:0 inSection:
                                             0];

                        }

                        NSLog(@"index vlaue %ld",(long)indepathValue.item);
                        [doumeeCollectionView reloadData];
                        if (indepathValue)
                        {
                        [doumeeCollectionView scrollToItemAtIndexPath:indepathValue atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                        }
                        

                    }
                    else {
                        
                        requestNowBtn.hidden = YES;
                        reserveHerBtn.hidden = YES;
                        imageDataArray = [[NSMutableArray alloc]init];
                        numberOfUsersLabel.text = @"";
                        if([strForAvailableNowData isEqualToString:@"Yes"]) {
                            doumeeNotAvailableNowLabel.hidden = NO;
                            noResultFoundLabel.hidden = NO;
                            searchImageView.hidden = NO;
                        } else {
                            doumeeNotAvailableNowLabel.hidden = NO;
                            noResultFoundLabel.hidden = NO;
                            searchImageView.hidden = NO;
                        }
                        [self.view setBackgroundColor:[UIColor whiteColor]];
                        [doumeeCollectionView setBackgroundColor:[UIColor whiteColor]];
                        [doumeeCollectionView setContentOffset:CGPointZero];
                        [doumeeCollectionView reloadData];
                    }
                }
            }
        }];
        
    }
    else
    {
        sharedInstance.latiValueStr = NULL;
        sharedInstance.longiValueStr = NULL;
        [[AlertView sharedManager] presentAlertWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                               //   [self performSelector:@selector(obj) withObject:self afterDelay:3];
                                           }];
    }
}

-(void)obj{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loactionUpdate" object:nil userInfo:nil];
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark: UIScroll View Method
- (void)didSwipeLeft:(UISwipeGestureRecognizer *) sender {
    NSLog(@"didSwipeLeft");
}

- (void)didSwipeRight:(UISwipeGestureRecognizer *) sender {
    NSLog(@"didSwipeRight");
}

@end
