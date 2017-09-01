//
//  ViewController.h
//  Contractor
//
//  Created by Jamshed Ali on 13/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTabBarController.h"

#import <SignalR.h>
#import <SRConnection.h>
#import "SRWebSocket.h"
#import "ServerRequest.h"
#import "SRNegotiationResponse.h"

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController<UIScrollViewDelegate,SRConnectionDelegate> {
    
    IBOutlet UIButton *btnRememberMe;
    //LCTabBarController *tabBarC ;
    IBOutlet UIScrollView *scrollView;
}

//@property (strong, nonatomic)  LCTabBarController *tabBarC;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property(nonatomic,strong) NSMutableArray *userTypeArr;


- (IBAction)forgotButtonClicked:(id)sender;

- (IBAction)signUpButtonClicked:(id)sender;
- (IBAction)RememberMeBtnClicked:(id)sender;



@property (strong, nonatomic)  UIView *viewOrange;
@property (strong, nonatomic)  UIView *viewBlack;
@property (strong, nonatomic)  UIView *viewGreen;


@end

