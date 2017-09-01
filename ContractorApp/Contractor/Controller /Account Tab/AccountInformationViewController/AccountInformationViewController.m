
//  AccountInformationViewController.m
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "AccountInformationViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "EmailUpdateViewController.h"
#import "ChangePasswordViewController.h"
#import "InterestViewController.h"
#import "UpdateMobileNumberViewController.h"
#import "CloseAccountViewController.h"
#import "SingletonClass.h"
#import "NotificationTableViewCell.h"
#import "ServerRequest.h"
#import "AppDelegate.h"
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@interface AccountInformationViewController () {
    
    NSArray *titleArray;
    NSArray *dataArray;
    NSString *firstNameStr;
    NSString *emailStr;
    NSString *passwordStr;
    NSString *mobileNumberStr;
    NSString *interestedInStr;
    UIAlertView *alert;
    SingletonClass *sharedInstance;
    UITextField  *alertText ;
    UIDatePicker *picker;
    NSDateFormatter *dateFormat;
    NSDate *convertDate;
    NSString *userIdStr;
    BOOL isFromFisrtTimeLoad;
    
}

@end
#pragma mark: UIview Controller Life Cycle Methode

@implementation AccountInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isFromFisrtTimeLoad = true;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    tabledataArray = [[NSMutableArray alloc]init];
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"UserInfoDataarr"];
    tabledataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSDictionary *dictdata = [tabledataArray objectAtIndex:0];
    emailStr = [dictdata valueForKey:@"Email"];
   
    passwordStr = [dictdata valueForKey:@"Password"];
    firstNameStr = [dictdata valueForKey:@"FirstName"];
    NSString *lastNameStr = [dictdata valueForKey:@"LastName"];
    NSString *birthDateStr = [dictdata valueForKey:@"BirthDate"];
    NSString *birthMonthStr = [dictdata valueForKey:@"BirthMonth"];
    NSString *birthYearStr = [dictdata valueForKey:@"BirthYear"];
    NSString *dateOfBirthStr= [NSString stringWithFormat: @"%@/%@/%@",birthMonthStr,birthDateStr,birthYearStr];
    NSString *genderStr = [dictdata valueForKey:@"Gender"];
    interestedInStr = [dictdata valueForKey:@"InterestedIn"];
    mobileNumberStr = [dictdata valueForKey:@"MobileNumber"];
    titleArray = @[@"Email",@"Password",@"First Name",@"Last Name",@"Date of Birth",@"I am a"];
    dataArray = @[emailStr,passwordStr,firstNameStr,lastNameStr,dateOfBirthStr,genderStr];
    //accountTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    [self fetchUserInfoApiData];
    
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
}


#pragma mark: SignalR request recieved Methde
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
    else {
        
    }
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
    return titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 62.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell;
    cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
    cell.nameLbl.text = [titleArray objectAtIndex:indexPath.row];
      if (indexPath.row == 0 ||indexPath.row == 1) {
        cell.userInteractionEnabled = YES;
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 1) {
            NSString *myPickerValue = [dataArray objectAtIndex:indexPath.row];
            cell.dateLbl.text = [@"" stringByPaddingToLength: [myPickerValue length] withString: @"*" startingAtIndex:0];
        }
    }
    else{
        cell.userInteractionEnabled = NO;
    }
    
    
    if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4) {
        if ([sharedInstance.isEditStr isEqualToString:@"0"]) {
            [cell setUserInteractionEnabled:NO];
        }
        else{
            [cell setUserInteractionEnabled:YES];
        }
    }
    if (indexPath.row == 4){
        dateFormat = [[NSDateFormatter alloc]init];
        //   [dateFormat setDateStyle:NSDateFormatterMediumStyle];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        convertDate = [dateFormat dateFromString:[dataArray objectAtIndex:indexPath.row]];
    }
    if (indexPath.row == 0) {
        cell.dateLbl.text = [dataArray objectAtIndex:indexPath.row];
        cell.emailVerifiedImageView.hidden = NO;
        [cell.dateLbl adjustsFontSizeToFitWidth];
        cell.dateLbl.minimumScaleFactor = 12;
        cell.dateLbl.numberOfLines = 0;
        cell.dateLbl.lineBreakMode = NSLineBreakByWordWrapping;
        cell.dateLbl.textAlignment = NSTextAlignmentLeft;
        //[cell.dateLbl sizeToFit];
        if (isFromFisrtTimeLoad) {
            isFromFisrtTimeLoad = false;
            if (WIN_WIDTH == 320) {
                cell.dateLbl.frame = CGRectMake(cell.dateLbl.frame.origin.x, cell.dateLbl.frame.origin.y, cell.dateLbl.frame.size.width-110, cell.dateLbl.frame.size.height);
                cell.emailVerifiedImageView.frame = CGRectMake(cell.dateLbl.frame.origin.x+cell.dateLbl.frame.size.width+3, cell.dateLbl.frame.origin.y+10, 15, 15);
            }
            else if (WIN_WIDTH == 375){
                cell.dateLbl.frame = CGRectMake(cell.dateLbl.frame.origin.x, cell.dateLbl.frame.origin.y+3, cell.dateLbl.frame.size.width-60, cell.dateLbl.frame.size.height-5);
                cell.emailVerifiedImageView.frame = CGRectMake(cell.dateLbl.frame.origin.x+cell.dateLbl.frame.size.width+4, cell.dateLbl.frame.origin.y+8, 15, 15);
            }
            else if (WIN_WIDTH == 414){
                cell.dateLbl.frame = CGRectMake(cell.dateLbl.frame.origin.x, cell.dateLbl.frame.origin.y+3, cell.dateLbl.frame.size.width-10, cell.dateLbl.frame.size.height-5);
                cell.emailVerifiedImageView.frame = CGRectMake(cell.dateLbl.frame.origin.x+cell.dateLbl.frame.size.width+4, cell.dateLbl.frame.origin.y+7, 15, 15);
            }
        }
     
        if (sharedInstance.isEmailVerifiedAlreadyOrNot == true) {
            //
           cell.emailVerifiedImageView.image = [UIImage imageNamed:@"verified"];
        }
        else{
            cell.emailVerifiedImageView.image = [UIImage imageNamed:@"not_verified"];
        }
    }
    else{
        cell.dateLbl.text = [dataArray objectAtIndex:indexPath.row];
        cell.emailVerifiedImageView.hidden = YES;

    }
    if (indexPath.row == 1) {

        NSString *myPickerValue = [dataArray objectAtIndex:indexPath.row];
        cell.dateLbl.text = [@"" stringByPaddingToLength: [myPickerValue length] withString: @"*" startingAtIndex:0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            
            EmailUpdateViewController *emailView = [self.storyboard instantiateViewControllerWithIdentifier:@"emailUpdate"];
            emailView.self.userEmailStr = emailStr;
            emailView.self.userFirstNameStr = firstNameStr;
            [self.navigationController pushViewController:emailView animated:YES];
        }
            break;
        case 1:
        {
            
            ChangePasswordViewController *changePasswordView = [self.storyboard instantiateViewControllerWithIdentifier:@"changePassword"];
            //changePasswordView.self.userPasswordStr = passwordStr;
            [self.navigationController pushViewController:changePasswordView animated:YES];
        }
            break;
        case 2:
        {
            
            alert = [[UIAlertView alloc ] initWithTitle:@"First Name" message:@"Enter Your First Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = ALERT_TYPE_FIRSTNAME;
            alertText = [alert textFieldAtIndex:0];
            [alertText setText:[dataArray objectAtIndex:indexPath.row]];
            [alertText setPlaceholder:@"Enter Your First Name"];
            [alert addButtonWithTitle:@"Update"];
            [alert show];
            
        }
            break;
        case 3:
        {
            
            alert = [[UIAlertView alloc ] initWithTitle:@"Last Name" message:@"Enter Your Last Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertText = [alert textFieldAtIndex:0];
            [alertText setText:[dataArray objectAtIndex:indexPath.row]];
            alert.tag = ALERT_TYPE_LASTNAME;
            [alertText setPlaceholder:@"Enter Your Last Name"];
            [alert addButtonWithTitle:@"Update"];
            [alert show];
        }
            break;
        case 4:
        {
            
            alert = [[UIAlertView alloc ] initWithTitle:@"Date Of Birth" message:@"Select Your DOB" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10, alert.bounds.size.height, 320, 216)];
            picker.datePickerMode = UIDatePickerModeDate;
            [picker setDate:convertDate];
            alertText = [alert textFieldAtIndex:0];
            [alertText setText:[dataArray objectAtIndex:indexPath.row]];
           // [self setMinAndMaxDateForPicker:picker];
            alertText.inputView=picker;
            [picker addTarget:self action:@selector(firstTF) forControlEvents:UIControlEventValueChanged];
            [alertText setPlaceholder:@"Select Your DOB"];
            
            alert.tag = ALERT_TYPE_DOB;
            [alert addButtonWithTitle:@"Update"];
            [alert show];
        }
            break;
        default:
            break;
    }
}

#pragma mark: Other UseFule Method
-(void)setMinAndMaxDateForPicker:(UIDatePicker *)pickerSelected{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:30];
    //  NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-90];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    pickerSelected.minimumDate = minDate;
    pickerSelected.maximumDate = [NSDate date];
}

- (void)firstTF
{
    
    NSDate *date = picker.date;
    dateFormat = [[NSDateFormatter alloc]init];
    //   [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *date1 = [[NSDateFormatter alloc]init];
    [date1 setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [dateFormat stringFromDate:date];
    alertText.text = [self changeDateINString:str WithFormate:@"yyyy-mm-dd"];
    
}

-(NSString *)changeDateINString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM/dd/yyyy"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
    
}

#pragma mark:Memory MAngement Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark: Button Action Methode

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)saveInformationButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeAccountButtonClicked:(id)sender {
    
    CloseAccountViewController *closeAccountView = [self.storyboard instantiateViewControllerWithIdentifier:@"closeAccount"];
    [self.navigationController pushViewController:closeAccountView animated:YES];
}


#pragma mark:Alert View Delgate Method

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"Alert Tag %ld",(long)alertView.tag);
    switch (alertView.tag) {
            
        case 100:{
            NSLog(@"Button Index =%ld",(long)buttonIndex);
            if (buttonIndex == 1) {
                UITextField *username = [alertView textFieldAtIndex:0];
                NSLog(@"username: %@", username.text);
                if([username.text length]==0) {
                    
                    UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please insert the firstname." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alrtShow show];
                    
                }
                else
                {
                    [self  callChangeProfieApiwithAttributeType:@"FirstName" withValue:username.text];
                    
                }
            }
            
        }
            break;
        case 101:{
            
            NSLog(@"Button Index =%ld",(long)buttonIndex);
            if (buttonIndex == 1) {
                UITextField *username = [alertView textFieldAtIndex:0];
                NSLog(@"username: %@", username.text);
                if([username.text length]==0) {
                    
                    UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please insert the lastname." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alrtShow show];
                    
                } else
                {
                    [self  callChangeProfieApiwithAttributeType:@"LastName" withValue:username.text];
                }
            }
            
        }
            break;
        case 102:{
            
            NSLog(@"Button Index =%ld",(long)buttonIndex);
            if (buttonIndex == 1) {
                
                UITextField *username = [alertView textFieldAtIndex:0];
                NSLog(@"username: %@", username.text);
                if([username.text length]==0) {
                    UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select the DOB." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alrtShow show];
                    
                } else
                {
                    [self  callChangeProfieApiwithAttributeType:@"DateOfBirth" withValue:alertText.text];
                }
            }
            
        }
            break;
        default:
            break;
    }
}
#pragma mark:- Call Api For Update
-(void)callChangeProfieApiwithAttributeType:(NSString *)attribute withValue:(NSString *)attributeValue {
    
    NSString *urlstr =[NSString stringWithFormat:@"%@?userID=%@&attributeType=%@&attributeValue=%@",APIChangeProfileData,userIdStr,attribute,attributeValue];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
            {
                [self fetchUserInfoApiData];
                [accountTableView reloadData];
            }
            else
            {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

- (void)fetchUserInfoApiData {
    
    //NSString *userIdStr = sharedInstance.userId;
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlQA:APIAccountUserInfo withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
           // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    NSDictionary *resultDict = [responseObject objectForKey:@"result"];
                    sharedInstance.firstNameStr = [resultDict valueForKey:@"FirstName"];
                    sharedInstance.lastNameStr = [resultDict valueForKey:@"LastName"];
                    sharedInstance.isEditStr =       [resultDict valueForKey:@"IsVarEdit"];
                    sharedInstance.isEmailVerifiedAlreadyOrNot = [[resultDict valueForKey:@"isEmailVerified"] boolValue];

                    userInfoArr = [[NSMutableArray alloc]init];
                    [userInfoArr addObject:resultDict];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfoArr];
                    [defaults setObject:data forKey:@"UserInfoDataarr"];
                    
                    NSData *dataObject = [defaults objectForKey:@"UserInfoDataarr"];
                    tabledataArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataObject];
                    
                    NSDictionary *dictdata = [tabledataArray objectAtIndex:0];
                    emailStr = [dictdata valueForKey:@"Email"];
                    passwordStr = [dictdata valueForKey:@"Password"];
                    firstNameStr = [dictdata valueForKey:@"FirstName"];
                    
                    NSString *lastNameStr = [dictdata valueForKey:@"LastName"];
                    NSString *birthDateStr = [dictdata valueForKey:@"BirthDate"];
                    NSString *birthMonthStr = [dictdata valueForKey:@"BirthMonth"];
                    NSString *birthYearStr = [dictdata valueForKey:@"BirthYear"];
                    NSString *dateOfBirthStr= [NSString stringWithFormat: @"%@/%@/%@",birthMonthStr,birthDateStr,birthYearStr];
                    NSString *genderStr = [dictdata valueForKey:@"Gender"];
                    interestedInStr = [dictdata valueForKey:@"InterestedIn"];
                    mobileNumberStr = [dictdata valueForKey:@"MobileNumber"];
                    titleArray = @[@"Email",@"Password",@"First Name",@"Last Name",@"Date of Birth",@"I am a"];
                    dataArray = @[emailStr,passwordStr,firstNameStr,lastNameStr,dateOfBirthStr,genderStr];
                    [accountTableView reloadData];
                    
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}


@end
