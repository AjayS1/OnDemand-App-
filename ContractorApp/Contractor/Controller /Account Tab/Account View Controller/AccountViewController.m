
//  AccountViewController.m
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "AccountViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
//#import "FavoritesViewController.h"
#import "AccountInformationViewController.h"
#import "LegalViewController.h"
#import "PaymentMethodsViewController.h"
#import "SettingsViewController.h"
#import "UserProfileViewController.h"
#import "GetVerifiedViewController.h"
#import "ProfileImageCropViewController.h"
#import "InviteFriendViewController.h"
#import "ScheduleViewController.h"
#import "MobileNumberViewController.h"
#import "PreferenceViewController.h"
#import "ServerRequest.h"
#import <MessageUI/MessageUI.h>

#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height

@interface AccountViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,CLLocationManagerDelegate,UIActionSheetDelegate> {
    
    NSArray *dataArray;
    NSArray *dataImageArray;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    UIActionSheet *actionSheetView;
    NSString *referalCode;
    
}
@property(nonatomic, weak) IBOutlet UILabel *labelBuildNumber;
@property(nonatomic, weak) IBOutlet UILabel *labelVersionNumber;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    dataArray = [NSArray arrayWithObjects:@"Account",@"Profile",@"Photos",@"Mobile Number",@"Preferences",@"Settings",@"Get Verified",@"Payment Method",@"Invite Friends",@"Legal",@"Schedule",@"Sign Off", nil];
    
    dataImageArray = [NSArray arrayWithObjects:
                      @"account",
                      @"profile",
                      @"photos",
                      @"mobile_phone",
                      @"prefrnces",
                      @"setting",
                      @"get_verified",
                      @"pay_method",
                      @"invite_friend",
                      @"legal",
                      @"calender2",
                      @"sign_off",
                      nil];
}


-(void)viewWillAppear:(BOOL)animated {
    
    sharedInstance = [SingletonClass sharedInstance];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    self.navigationController.navigationBar.hidden=YES;
    
    if ( sharedInstance.strIsFromGetVerified) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabBarUpdate" object:nil userInfo:nil];
        sharedInstance.strIsFromGetVerified = NO;
    }
    else {
        
    }
    [self.tabBarController.tabBar setHidden:NO];
    
    if (_isFromOrderProcess) {
        _isFromOrderProcess = NO;
        GetVerifiedViewController *verifiedView = [self.storyboard instantiateViewControllerWithIdentifier:@"getVerified"];
        [self.navigationController pushViewController:verifiedView animated:NO];
        return;
    }
    if (_isFromCreditCardProcess) {
        _isFromCreditCardProcess = NO;
        PaymentMethodsViewController *paymentInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentMethod"];
        [self.navigationController pushViewController:paymentInfoView animated:NO];
        return;
    }
    
    if (self.isEmailVerifiedOrNotPage) {
        self.isEmailVerifiedOrNotPage = NO;
        AccountInformationViewController *accountInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"accountInformation"];
        [self.navigationController pushViewController:accountInfoView animated:NO];
        return;
    }
    
    if (_isFromUpdateMobileNumber) {
        _isFromUpdateMobileNumber = NO;
        MobileNumberViewController *imageCropController = [self.storyboard instantiateViewControllerWithIdentifier:@"MobileNumberViewController"];
        imageCropController.isForMobilenumber = YES;
        [self.navigationController pushViewController:imageCropController animated:NO];
        return;
    }
    [self fetchUserInfoApiData];
    [self.labelVersionNumber setText:[NSString stringWithFormat:@"Doumees %@",sharedInstance.VersionValue]];
    [self.labelBuildNumber setText:[NSString stringWithFormat:@"Build %@",sharedInstance.BuildValueStr]];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (void)checkSignalRReqest:(NSNotification*) noti {
    
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
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"tabBarUpdate"
                                                  object:nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //Creating View
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    //Creating Label
    UILabel *lineView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    [headerView addSubview:lineView];
    //Creating Label
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *MyIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell = nil;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
        
    }
    UILabel *lineView = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-1, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    [cell addSubview:lineView];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[dataImageArray objectAtIndex:indexPath.row]]]];
    NSString *titleStr = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = titleStr;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == [NSIndexPath indexPathForRow:[dataArray count]-1 inSection:0].row)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        //lineView.hidden = true;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //lineView.hidden = false;
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        AccountInformationViewController *accountInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"accountInformation"];
        [self.navigationController pushViewController:accountInfoView animated:YES];
        
    }
    else if (indexPath.row == 1) {
        UserProfileViewController *userProfileView = [self.storyboard instantiateViewControllerWithIdentifier:@"userProfile"];
        [self.navigationController pushViewController:userProfileView animated:YES];
        
    }
    else if (indexPath.row == 2) {
        ProfileImageCropViewController *imageCropController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileImageCrop"];
        [self.navigationController pushViewController:imageCropController animated:YES];
        
    }
    else if (indexPath.row == 3) {
        
        MobileNumberViewController *imageCropController = [self.storyboard instantiateViewControllerWithIdentifier:@"MobileNumberViewController"];
        imageCropController.isForMobilenumber = YES;
        [self.navigationController pushViewController:imageCropController animated:YES];
        
        
    }else if (indexPath.row == 4) {
        
        PreferenceViewController *prefernceView = [self.storyboard instantiateViewControllerWithIdentifier:@"preference"];
        [self.navigationController pushViewController:prefernceView animated:YES];
        
    }
    else if (indexPath.row == 5) {
        SettingsViewController *settingsView = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
        
        [self.navigationController pushViewController:settingsView animated:YES];
        
        
    }else if (indexPath.row == 6) {
        GetVerifiedViewController *verifiedView = [self.storyboard instantiateViewControllerWithIdentifier:@"getVerified"];
        [self.navigationController pushViewController:verifiedView animated:YES];
        
        
    }else if (indexPath.row == 7) {
        
        PaymentMethodsViewController *paymentInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentMethod"];
        [self.navigationController pushViewController:paymentInfoView animated:YES];
        
    }else if (indexPath.row == 8) {
        
        actionSheetView = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Message",@"Mail",nil];
        if(WIN_HEIGHT == 1024)
            [actionSheetView showInView:[[[UIApplication sharedApplication] delegate] window].rootViewController.view];
        else
            [actionSheetView showInView:[UIApplication sharedApplication].keyWindow];
        
        
    }else if (indexPath.row == 9) {
        
        LegalViewController *accountInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"legal"];
        
        [self.navigationController pushViewController:accountInfoView animated:YES];
        
        
        
    }else if (indexPath.row == 10) {
        
        ScheduleViewController *accountInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"schedule"];
        [self.navigationController pushViewController:accountInfoView animated:YES];
        
    }
    else if (indexPath.row == 11) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Sign Off" message:@"Are you sure you want to sign off? You will not be able to receive reservations after you sign off." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
        [alrtShow show];
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
    
    UILabel *buttonValue = [[UILabel alloc]init];
    [buttonValue setText:[actionSheet buttonTitleAtIndex:buttonIndex]];
    switch (buttonIndex) {
        case 0:{
            
            if(![MFMessageComposeViewController canSendText]) {
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
                return;
            }
            
            NSArray *recipents = nil;
            NSString *message;
            //referalCode
            
            NSString *emailBody = [NSString stringWithFormat:@"Hey, I recently joined Doumees and went on a paid date. It was awesome! Try Doumees and let me know when you go on your first date.\n%@",referalCode];
            
            if ([referalCode isKindOfClass:[NSNull class]]) {
                message = [NSString stringWithFormat:@"Hey, I recently joined Doumees and went on a paid date. It was awesome! Try Doumees and let me know when you go on your first date.\n%@",@""];
            }
            else
            {
                message = emailBody;
            }
            
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = self;
            [messageController setRecipients:recipents];
            [messageController setBody:message];
            // Present message view controller on screen
            [self presentViewController:messageController animated:YES completion:nil];
        }
            break;
            
        case 1:{
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                mail.mailComposeDelegate = self;
                [mail setSubject:@"Invitiation for the date"];
                NSString *emailBody = [NSString stringWithFormat:@"<html><body><b>Hey, I recently joined Doumees and went on a paid date. It was awesome! Try Doumees and let me know when you go on your first date.</b><br\\> <a href=referalCode>%@</a></body></html>",referalCode];
                
                if ([referalCode isKindOfClass:[NSNull class]]) {
                    [mail setMessageBody:[NSString stringWithFormat:@"Hey, I recently joined Doumees and went on a paid date. It was awesome! Try Doumees and let me know when you go on your first date.\n%@",@""] isHTML:NO];
                }
                else
                {
                    [mail setMessageBody:emailBody isHTML:YES];
                }
                
                [mail setToRecipients:@[@"http://www.doumees.com"]];
                [self presentViewController:mail animated:YES completion:NULL];
            }
            else
            {
                NSLog(@"This device cannot send email");
            }
        }
            break;
        default:
            return;
            break;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
        NSLog(@"Launching the store");
    }
    else {
        [self logoutApiCall];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-- User Account Details API Call

-(void)fetchUserInfoApiData {
    
    NSString *userIdString = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdString,@"userID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlQA:APIAccountUserInfo withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    NSDictionary *resultDict = [responseObject objectForKey:@"result"];
                    userNameLabel.text = [resultDict valueForKey:@"UserName"];
                    referalCode = [resultDict valueForKey:@"ReferralURL"];
                    sharedInstance.firstNameStr = [resultDict valueForKey:@"FirstName"];
                    sharedInstance.userId = [resultDict valueForKey:@"UserID"];
                    // UserID = Cr0074ee9;
                    sharedInstance.lastNameStr = [resultDict valueForKey:@"LastName"];
                    sharedInstance.isEditStr =       [resultDict valueForKey:@"IsVarEdit"];
                    sharedInstance.interestedGender = [resultDict valueForKey:@"InterestedIn"];
                    sharedInstance.mobileNumberStr = [resultDict valueForKey:@"MobileNumber"];
                    sharedInstance.countryCodeStr = [[resultDict valueForKey:@"MobileNumberCountryCode"] capitalizedString];
                    sharedInstance.countryCodeIDStr = [resultDict valueForKey:@"MobileNumberCountryCodeID"];
                    sharedInstance.isEmailVerifiedAlreadyOrNot = [[resultDict valueForKey:@"isEmailVerified"] boolValue];
                    ratingLabel.text = [NSString stringWithFormat:@"%.1f",[[resultDict valueForKey:@"Rating"] floatValue]];
                    NSString *imageurlStr = [resultDict valueForKey:@"UserPhoto"];
                    NSURL *imageUrl = [NSURL URLWithString:imageurlStr];
                    [profileImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_small"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    self.userInfoArr = [[NSMutableArray alloc]init];
                    [self.userInfoArr addObject:resultDict];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userInfoArr];
                    [defaults setObject:data forKey:@"UserInfoDataarr"];
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}

#pragma mark-- Logout Api Call
- (void)logoutApiCall {
    
    NSString *deviceTokenStr = sharedInstance.deviceToken;
    NSString *userIdString = sharedInstance.userId;
    NSString *urlstr=[NSString stringWithFormat:@"%@?UserID=%@&deviceID=%@",APIAccountSignout,userIdString,deviceTokenStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    // Remove all records from the NSUserDefaults
                    [self changeStatusWithValue:@"0" WithStringReservation:@"Both"];
                    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    // [self changeReservationStatusWithValue:@"0" WithStringReservation:@"Reservation"];
                    ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
                    [self.navigationController pushViewController:loginView animated:NO];
                    sharedInstance.isUserLoginManualyy = NO;
                    sharedInstance.isUserLogoutManualyy = YES;
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    if ([APPDELEGATE locationManager] != nil) {
                        [[APPDELEGATE locationManager] startUpdatingLocation];
                    }
                    else
                    {
                        APPDELEGATE.locationManager= [[CLLocationManager alloc] init];
                        APPDELEGATE.locationManager.delegate = self;
                        APPDELEGATE.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                        [APPDELEGATE.locationManager requestWhenInUseAuthorization];
                        [APPDELEGATE.locationManager startUpdatingLocation];
                    }
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
            else {
                NSLog(@"Error");
            }
        }
    }];
}

-(void)changeStatusWithValue:(NSString *)onlineValue WithStringReservation:(NSString *)flagValue{
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
    NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
    NSString *deviceTokenStr = sharedInstance.deviceToken;
    if (!deviceTokenStr) {
        deviceTokenStr = @"";
    }
    NSString *urlstr=[NSString stringWithFormat:@"%@?contractorID=%@&onlineStatus=%@&HideStatus=%@&latitude=%@&longitude=%@&deviceID=%@&flag=%@",APIContractorChangeProfileShownStatus,userIdStr,onlineValue,@"0",latitudeStr,lonitudeStr,deviceTokenStr,flagValue];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ServerRequest AFNetworkPostRequestUrlForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
            {
                NSLog(@"STATUS CHANGE SUCCESFULLY");
            }
        }
    }];
}

-(void)changeStatus {
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
    NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
    NSString *deviceTokenStr = sharedInstance.deviceToken;
    if (!deviceTokenStr) {
        deviceTokenStr = @"";
    }
    NSString *urlstr=[NSString stringWithFormat:@"%@?contractorID=%@&onlineStatus=%@&HideStatus=%@&latitude=%@&longitude=%@&deviceID=%@&flag=%@",APIContractorChangeProfileShownStatus,userIdStr,@"0",@"0",latitudeStr,lonitudeStr,deviceTokenStr,@"Online"];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ServerRequest AFNetworkPostRequestUrlForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
            {
                NSLog(@"STATUS CHANGE SUCCESFULLY");
            }
        }
    }];
}

@end
