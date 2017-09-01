
//  ViewController.h
//  Customer
//  Created by Jamshed Ali on 01/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import  <CoreLocation/CoreLocation.h>
#import <SignalR.h>
#import <SRConnection.h>
#import "SRWebSocket.h"
#import "ServerRequest.h"
#import "SRNegotiationResponse.h"

@class GradientProgressView;
@interface ViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,SRConnectionDelegate,CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIButton *rememberMeButton;
    IBOutlet UIScrollView *scrollView;
     GradientProgressView *progressView;
    NSString *latitude_Reg;
    NSString *longitude_Reg;
}

@property(nonatomic,strong) NSMutableArray *userTypeArr;

- (IBAction)signInBtnClicked:(id)sender;
- (IBAction)signUpBtnClicked:(id)sender;
- (IBAction)forgotPasswordButtonClicked:(id)sender;
- (IBAction)rememberMeButtonClicked:(id)sender;



@end

