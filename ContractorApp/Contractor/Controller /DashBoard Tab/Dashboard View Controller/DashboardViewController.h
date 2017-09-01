//
//  DashboardViewController.h
//  Contractor
//
//  Created by Jamshed Ali on 13/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SignalR.h>
#import <SRConnection.h>
#import "SRWebSocket.h"
#import "ServerRequest.h"
#import "SRNegotiationResponse.h"

@interface DashboardViewController : UIViewController<SRConnectionDelegate> {
    
    IBOutlet UILabel *rateLabel;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UISwitch *profileHideShowSwitch;
}

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIButton *onlineOfflineButton;
@property (strong, nonatomic) IBOutlet UIView *circleOnlineOfflineView;
@property (strong, nonatomic) IBOutlet UIButton *showOnlineButton;

- (IBAction)onlineButtonClicked:(id)sender;
- (IBAction)profileHideShow:(id)sender;

@end
