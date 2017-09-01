
//  AccountViewController.m
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "AccountViewController.h"



#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height

@interface AccountViewController ()<UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,CLLocationManagerDelegate> {
    
    NSArray *dataArray;
    NSArray *dataImageArray;
    NSString *mobileNumberStr;
    NSString *userIdStr;
    SingletonClass *sharedInstance;
    UIActionSheet *actionSheetView;
    NSString *referalCode;

    
}
@property(nonatomic, weak) IBOutlet UILabel *labelBuildNumber;
@property(nonatomic, weak) IBOutlet UILabel *labelVersionNumber;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    
    self.userInfoArr = [[NSMutableArray alloc]init];
    dataArray = [NSArray arrayWithObjects:@"Favorites",@"Alerts",@"Account",@"Profile",@"Photos",@"Mobile Number",@"Preferences",@"Settings",@"Get Verified",@"Payment Methods",@"Invite Friends",@"Legal",@"Sign Off", nil];
    dataImageArray = [NSArray arrayWithObjects:@"fav",@"alert-1",@"account-1",@"profile",@"photos",@"mobile_phone",@"prefrnces",@"setting-1",@"get_verified",@"pay_method",@"invite_friend",@"legal",@"sign_off", nil];
    
    // [self fetchUserInfoApiData];
    [self.labelVersionNumber setText:[NSString stringWithFormat:@"Doumees %@",sharedInstance.strVersionValue]];
    [self.labelBuildNumber setText:[NSString stringWithFormat:@"Build %@",sharedInstance.strBuildValue]];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dateEndThenPaymentScreen:)
                                                 name:@"dateEndThenPaymentScreen"
                                               object:nil];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
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
    if (_isFromUpdateMobileNumber) {
        _isFromUpdateMobileNumber = NO;
        MobilePhoneViewController   *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"MobilePhoneViewController"];
        notiView.isMobilePhoneSelected = YES;
        [self.navigationController pushViewController:notiView animated:NO];
        return;
    }
    
    if (self.isEmailVerifiedOrNotPage) {
        self.isEmailVerifiedOrNotPage = NO;
        AccountInformationViewController *accountInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"accountInformation"];
        [self.navigationController pushViewController:accountInfoView animated:NO];
        return;
    }
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    [self fetchUserInfoApiData];
    
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

- (void)dateEndThenPaymentScreen:(NSNotification*) noti {
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    NSString *dateIDValueStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateId"]];
    PaymentDateCompletedViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentDateCompleted"];
    dateDetailsView.isFromLoginView = NO;
    dateDetailsView.self.dateIdStr = dateIDValueStr;
    dateDetailsView.self.dateTypeStr = requestTypeStr;
    [self.navigationController pushViewController:dateDetailsView animated:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"dateEndThenPaymentScreen"
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    [cell.imageView setImage:[UIImage imageNamed:[dataImageArray objectAtIndex:indexPath.row]]];
    NSString *titleStr = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = titleStr;
    
    // cell.textLabel.frame.origin.x == cell.imageView.frame.origin.x+cell.imageView.frame.size.width+5;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == [NSIndexPath indexPathForRow:[dataArray count]-1 inSection:0].row)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
      //  lineView.hidden = true;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       // lineView.hidden = false;

    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            FavoritesViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"favorites"];
            [self.navigationController pushViewController:notiView animated:YES];
        }
            break;
        case 1:{
            AlertsViewController *alertView = [self.storyboard instantiateViewControllerWithIdentifier:@"alerts"];
            [self.navigationController pushViewController:alertView animated:YES];
        }
            break;
        case 2:{
            AccountInformationViewController *accountInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"accountInformation"];
            [self.navigationController pushViewController:accountInfoView animated:YES];
        }
            break;
        case 3:{
            UserProfileViewController *userProfileView = [self.storyboard instantiateViewControllerWithIdentifier:@"userProfile"];
            [self.navigationController pushViewController:userProfileView animated:YES];
        }
            break;
            
        case 4:{
            ProfileImageCropViewController *imageCropController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileImageCrop"];
            [self.navigationController pushViewController:imageCropController animated:YES];
        }
            break;
        case 5:{
            MobilePhoneViewController   *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"MobilePhoneViewController"];
            notiView.isMobilePhoneSelected = YES;
            [self.navigationController pushViewController:notiView animated:YES];
        }
            break;
        case 6:{
            MobilePhoneViewController   *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"MobilePhoneViewController"];
            notiView.isMobilePhoneSelected = NO;
            [self.navigationController pushViewController:notiView animated:YES];
        }
            break;
        case 7:{
            SettingsViewController *settingsView = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
            
            [self.navigationController pushViewController:settingsView animated:YES];
        }
            break;
        case 8:{
            GetVerifiedViewController *verifiedView = [self.storyboard instantiateViewControllerWithIdentifier:@"getVerified"];
            [self.navigationController pushViewController:verifiedView animated:YES];
        }
            break;
        case 9:{
            PaymentMethodsViewController *paymentInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentMethod"];
            
            [self.navigationController pushViewController:paymentInfoView animated:YES];
        }
            break;
        case 10:{
            actionSheetView = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Message",@"Mail",nil];
            if(WIN_HEIGHT == 1024)
                [actionSheetView showInView:[[[UIApplication sharedApplication] delegate] window].rootViewController.view];
            else
                [actionSheetView showInView:[UIApplication sharedApplication].keyWindow];
        }
            break;
        case 11:
        {
            LegalViewController *accountInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"legal"];
            [self.navigationController pushViewController:accountInfoView animated:YES];
        }
            break;
        case 12:
        {
            UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Sign Off" message:@"Are you sure you want to sign off?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
            [alrtShow show];
        }
            break;
        default:
            break;
    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
    
    UILabel *buttonValue = [[UILabel alloc]init];
    [buttonValue setText:[actionSheet buttonTitleAtIndex:buttonIndex]];
    switch (buttonIndex)
    {
        case 0:
        {
            if(![MFMessageComposeViewController canSendText]) {
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
                return;
            }
            NSString *message;
            NSArray *recipents = nil;
            NSString *emailBody = [NSString stringWithFormat:@"Hey, I joined Doumees and found a date. Try Doumees and let me know when you go on your first date.\n%@",referalCode];
            

            if ([referalCode isKindOfClass:[NSNull class]]) {
                message = [NSString stringWithFormat:@"Hey, I joined Doumees and found a date. Try Doumees and let me know when you go on your first date.\n%@",@""];
            }
            else
            {
                message = emailBody;
            }
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = self;
            [messageController setRecipients:recipents];
            [messageController setBody:message];
            [self presentViewController:messageController animated:YES completion:nil];
      }
            break;
        case 1:
        {
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                mail.mailComposeDelegate = self;
                [mail setSubject:@"Invitiation for the date"];
                // Fill out the email body text
                NSString *emailBody = [NSString stringWithFormat:@"<html><body><b>Hey, I joined Doumees and found a date. Try Doumees and let me know when you go on your first date.</b><br\\> <a href=referalCode>%@</a></body></html>",referalCode];

                if ([referalCode isKindOfClass:[NSNull class]]) {
                    [mail setMessageBody:[NSString stringWithFormat:@"Hey, I joined Doumees and found a date. Try Doumees and let me know when you go on your first date.\n%@",@""] isHTML:NO];
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
/*
 - (void) sendEventInEmail
 {
 MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
 picker.mailComposeDelegate = self;
 
 [picker setSubject:@"Email Subject"];
 
 // Fill out the email body text
 NSString *iTunesLink = @"--------Link to iTune App link----";
 NSString *content = [eventDictionary objectForKey:@"Description"];
 NSString *imageURL = [eventDictionary objectForKey:@"Image URL"];
 NSString *findOutMoreURL = [eventDictionary objectForKey:@"Link"];
 
 NSString *emailBody = [NSString stringWithFormat:@"<br /> <a href = '%@'> <img src='%@' align=left  style='margin:5px' /> </a> <b>%@</b> <br /><br />%@ <br /><br />Sent using <a href = '%@'>What's On Reading</a> for the iPhone.</p>", findOutMoreURL, imageURL, emailSubject, content, iTunesLink];
 
 [picker setMessageBody:emailBody isHTML:YES];
 
 [self presentModalViewController:picker animated:YES];
 
 [picker release];
 }

 */

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
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
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

#pragma mark-- Logout Api Call
-(void)logoutApiCall {
    
    NSString *deviceTokenStr = sharedInstance.deviceToken;
    NSString *userIdString = sharedInstance.userId;
    NSString *urlstrr=[NSString stringWithFormat:@"%@?UserID=%@&deviceID=%@",APIAccountSignout,userIdString,deviceTokenStr];
    NSString *encodedUrl = [urlstrr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                // Remove all records from the NSUserDefaults
                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
                ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
                sharedInstance.isUserLogoutManualyy = YES;
                sharedInstance.isUserLoginManualyy = NO;
                [self.navigationController pushViewController:loginView animated:YES];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                if ([APPDELEGATE locationManager] != nil) {
                    [[APPDELEGATE locationManager] startUpdatingLocation];
                    
                }
                else {
                    APPDELEGATE.locationManager= [[CLLocationManager alloc] init];
                    APPDELEGATE.locationManager.delegate = self;
                    APPDELEGATE.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                    [APPDELEGATE.locationManager requestWhenInUseAuthorization];
                    [APPDELEGATE.locationManager startUpdatingLocation];
                }
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


#pragma mark-- User Account Details API Call
- (void)fetchUserInfoApiData {
    
    NSString *userIdString = sharedInstance.userId;
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdString,@"userID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlForQA:APIAccountUserInfo withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                
                NSDictionary *resultDict = [responseObject objectForKey:@"result"];
                if ([[resultDict valueForKey:@"UserName"] length]) {
                    nameLabel.text = [resultDict valueForKey:@"UserName"];
                }
                else
                {
                    nameLabel.text = [resultDict valueForKey:@"FirstName"];
                }
                ratingLabel.text = [NSString stringWithFormat:@"%.1f",[[resultDict valueForKey:@"Rating"] floatValue]];
                NSString *imageurlStr = [resultDict valueForKey:@"UserPhoto"];
                referalCode = [resultDict valueForKey:@"ReferralURL"];
                sharedInstance.firstNameStr = [resultDict valueForKey:@"FirstName"];
                sharedInstance.lastNameStr = [resultDict valueForKey:@"LastName"];
                sharedInstance.isEditStr =       [resultDict valueForKey:@"IsVarEdit"];
                sharedInstance.interestedGender = [resultDict valueForKey:@"InterestedIn"];
                sharedInstance.mobileNumberStr = [resultDict valueForKey:@"MobileNumber"];
                sharedInstance.countryCodeStr = [[resultDict valueForKey:@"MobileNumberCountryCode"] capitalizedString];
                sharedInstance.countryCodeIDStr = [resultDict valueForKey:@"MobileNumberCountryCodeID"];
                sharedInstance.isEmailVerifiedAlreadyOrNot = [[resultDict valueForKey:@"isEmailVerified"] boolValue];

                NSURL *imageUrl = [NSURL URLWithString:imageurlStr];
                [profileImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_small"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                //  [profileImageView sd_setImageWithURL:imageUrl
                //placeholderImage:[UIImage imageNamed:@"placeholder_small"]];
                
                self.userInfoArr = [[NSMutableArray alloc]init];
                [self.userInfoArr addObject:resultDict];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userInfoArr];
                [defaults setObject:data forKey:@"UserInfoDataarr"];
                [accountTable reloadData];
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
