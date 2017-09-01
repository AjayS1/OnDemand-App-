//
//  MobileNumberViewController.m
//  Contractor
//
//  Created by Aditi on 21/12/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "MobileNumberViewController.h"
#import "AccountInformationViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "EmailUpdateViewController.h"
#import "ChangePasswordViewController.h"
#import "InterestViewController.h"
#import "UpdateMobileNumberViewController.h"
#import "CloseAccountViewController.h"
#import "SingletonClass.h"
#import "NotificationTableViewCell.h"
#import "EmailUpdateViewController.h"
#import "ChangePasswordViewController.h"
#import "InterestViewController.h"
#import "UpdateMobileNumberViewController.h"
#import "CloseAccountViewController.h"
#import "ServerRequest.h"
#import "NotificationTableViewCell.h"
#import "AppDelegate.h"

@interface MobileNumberViewController (){
    
    NSArray *titleArray;
    NSArray *dataArray;
    NSString *firstNameStr;
    NSString *emailStr;
    NSString *passwordStr;
    NSString *mobileNumberStr;
    NSString *interestedInStr;
    NSMutableArray *tabledataArray;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
}

@property (weak, nonatomic) IBOutlet UITableView *mobilePhoneTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MobileNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    [super viewWillAppear:YES];
    sharedInstance = [SingletonClass sharedInstance];

    userIdStr = sharedInstance.userId;
    
    if (_isForMobilenumber) {
        [self.titleLabel setText:@"MOBILE NUMBER"];
    }
    else{
        [self.titleLabel setText:@"PREFERENCES"];
    }
    
    [self fetchUserInfoApiData ];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    tabledataArray = [[NSMutableArray alloc]init];
    sharedInstance = [SingletonClass sharedInstance];
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
    NSString *dateOfBirthStr= [NSString stringWithFormat: @"%@/%@/%@", birthDateStr, birthMonthStr,birthYearStr];
    NSString *genderStr = [dictdata valueForKey:@"Gender"];
    interestedInStr = [dictdata valueForKey:@"InterestedIn"];
    sharedInstance.interestedGender = [dictdata valueForKey:@"InterestedIn"];
    mobileNumberStr = [dictdata valueForKey:@"MobileNumber"];
    sharedInstance.mobileNumberStr = mobileNumberStr;
    titleArray = @[@"Email",@"Password",@"First Name",@"Last Name",@"Date of Birth",@"I am a",@"I am interested in",@"Mobile Number"];
    dataArray = @[emailStr,passwordStr,firstNameStr,lastNameStr,dateOfBirthStr,genderStr,interestedInStr,mobileNumberStr];
    _mobilePhoneTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
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
        
    } else {
        
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell;
    cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"mobilePhone_Cell"];
    if (_isForMobilenumber) {
        
        //cell.nameLbl.text = @"Mobile Number";
        NSArray *splitCode = [sharedInstance.countryCodeStr componentsSeparatedByString:@" "];
        NSString *splitCodeStr = [splitCode lastObject];
        cell.nameLbl.text =[NSString stringWithFormat:@"%@ %@",splitCodeStr,sharedInstance.mobileNumberStr];
        cell.dateLbl.text = sharedInstance.mobileNumberStr;
        cell.dateLbl.hidden = YES;
        cell.nameLbl.frame = CGRectMake(cell.nameLbl.frame.origin.x, cell.nameLbl.frame.origin.y, self.view.frame.size.width, cell.nameLbl.frame.size.height);
       // cell.dateLbl.text = sharedInstance.mobileNumberStr;
    }
    else{
        cell.nameLbl.text = @"I am interested in";
        cell.dateLbl.text = sharedInstance.interestedGender;
    }
    
    if (indexPath.row == 0 ||indexPath.row == 1 || indexPath.row == 6 || indexPath.row == 7) {
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            if (_isForMobilenumber) {
                UpdateMobileNumberViewController *updateMobileView = [self.storyboard instantiateViewControllerWithIdentifier:@"mobile"];
                updateMobileView.userMobileNmbrStr = sharedInstance.mobileNumberStr;
                updateMobileView.countryID =sharedInstance.countryCodeIDStr;

                [self.navigationController pushViewController:updateMobileView animated:YES];
            }
            else{
                InterestViewController *interestView = [self.storyboard instantiateViewControllerWithIdentifier:@"interest"];
                interestView.self.userInterestedInStr = interestedInStr;
                [self.navigationController pushViewController:interestView animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma maek : UIButton Action Method
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark-- User Account Details API Call
- (void)fetchUserInfoApiData {
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
                sharedInstance.firstNameStr = [resultDict valueForKey:@"FirstName"];
                sharedInstance.lastNameStr = [resultDict valueForKey:@"LastName"];
                //sharedInstance.isEditStr =       [resultDict valueForKey:@"IsVarEdit"];
                sharedInstance.interestedGender = [resultDict valueForKey:@"InterestedIn"];
                sharedInstance.mobileNumberStr = [resultDict valueForKey:@"MobileNumber"];
                self.userInfoArr = [[NSMutableArray alloc]init];
                [self.userInfoArr addObject:resultDict];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userInfoArr];
                [defaults setObject:data forKey:@"UserInfoDataarr"];
                [_mobilePhoneTableView reloadData];
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
