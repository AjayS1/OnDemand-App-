
//  GetVerifiedViewController.m
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "GetVerifiedViewController.h"
@interface GetVerifiedViewController () {
    
    SingletonClass *sharedInstance;
    NSString *userIdStr;
}
@end

@implementation GetVerifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, 0, 0, 0)];
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    [self fetchGetVerifiedUserApiData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)photoVerificationButtonClicked:(id)sender {
    
    PhotoVerificationViewController *photoVerify = [self.storyboard instantiateViewControllerWithIdentifier:@"photoVerification"];
    [self.navigationController pushViewController:photoVerify animated:YES];
}

- (IBAction)idVerificationButtonCLicked:(id)sender {
    IDVerificationViewController *idVerify = [self.storyboard instantiateViewControllerWithIdentifier:@"idVerification"];
    [self.navigationController pushViewController:idVerify animated:YES];
}

- (IBAction)backgorundChecked:(id)sender {
    BackgroundCheckedViewController *idVerify = [self.storyboard instantiateViewControllerWithIdentifier:@"backgroundChecked"];
    [self.navigationController pushViewController:idVerify animated:YES];
}


#pragma mark--Get Verified User  API Call
- (void)fetchGetVerifiedUserApiData {
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlForQA:APIGetVerifyUserInfo withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"PhotoStatus"] isEqualToString:@"1"] ) {
                    
                    _photoVerifyImageView.image = [UIImage imageNamed:@"rgt.png"];
                    photoVerificationButton.userInteractionEnabled = NO;
                    
                    //  [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your photo verification is already verified." inController:self];
                    
                } else if ([[[responseObject objectForKey:@"result"]objectForKey:@"PhotoStatus"] isEqualToString:@"2"] ) {
                    
                    _photoVerifyImageView.image = [UIImage imageNamed:@"right_arrow.png"];
                    // [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your photo verification is rejected." inController:self];
                    
                } else if ([[[responseObject objectForKey:@"result"]objectForKey:@"PhotoStatus"] isEqualToString:@"0"] ) {
                    _photoVerifyImageView.image = [UIImage imageNamed:@"warng.png"];
                    photoVerificationButton.userInteractionEnabled = NO;
                    
                    //  [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your photo verification is waiting for a approval from Admin." inController:self];
                    
                } else if ([[[responseObject objectForKey:@"result"]objectForKey:@"PhotoStatus"] isEqualToString:@"10"] ) {
                    _photoVerifyImageView.image = [UIImage imageNamed:@"right_arrow.png"];
                    
                    //_photoVerifyImageView.image = [UIImage imageNamed:@"pending_icon.png"];
                }
                
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"DocumentStatus"] isEqualToString:@"1"]) {
                    _idVerificationImageView.image = [UIImage imageNamed:@"rgt.png"];
                    idVerificationButton.userInteractionEnabled = NO;
                    
                    //[CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your id verification is already verified." inController:self];
                    
                } else if ([[[responseObject objectForKey:@"result"]objectForKey:@"DocumentStatus"] isEqualToString:@"2"]) {
                    
                    _idVerificationImageView.image = [UIImage imageNamed:@"right_arrow.png"];
                    
                    //[CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your id verification is rejected." inController:self];
                    
                    
                } else if ([[[responseObject objectForKey:@"result"]objectForKey:@"DocumentStatus"] isEqualToString:@"0"]) {
                    
                    _idVerificationImageView.image = [UIImage imageNamed:@"warng.png"];
                    idVerificationButton.userInteractionEnabled = NO;
                    
                } else if ([[[responseObject objectForKey:@"result"]objectForKey:@"DocumentStatus"] isEqualToString:@"10"]) {
                    
                    _idVerificationImageView.image = [UIImage imageNamed:@"right_arrow.png"];
                }
                
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"BackGroundStatus"] isEqualToString:@"1"]) {
                    
                    backgroundCheckedButton.userInteractionEnabled = NO;
                    _backgroundCheckImageView.image = [UIImage imageNamed:@"rgt.png"];
                    
                }
                else if ([[[responseObject objectForKey:@"result"]objectForKey:@"BackGroundStatus"] isEqualToString:@"2"]) {
                    
                    _backgroundCheckImageView.image = [UIImage imageNamed:@"right_arrow.png"];
                    
                }
                else if ([[[responseObject objectForKey:@"result"]objectForKey:@"BackGroundStatus"] isEqualToString:@"0"]) {
                    
                    _backgroundCheckImageView.image = [UIImage imageNamed:@"warng.png"];
                    backgroundCheckedButton.userInteractionEnabled = NO;
                    
                    // [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your background verification is waiting for a approval from Admin." inController:self];
                    
                }
                else if ([[[responseObject objectForKey:@"result"]objectForKey:@"BackGroundStatus"] isEqualToString:@"10"]) {
                    
                    // _backgroundCheckImageView.image = [UIImage imageNamed:@"pending_icon.png"];
                    _backgroundCheckImageView.image = [UIImage imageNamed:@"right_arrow.png"];
                }
            }
            else {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        
    }];
}

@end
