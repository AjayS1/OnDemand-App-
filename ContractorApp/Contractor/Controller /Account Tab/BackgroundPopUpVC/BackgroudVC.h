//
//  BackgroudVC.h
//  Contractor
//
//  Created by Aditi on 08/03/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BackgroundPopupDelegate <NSObject>
@optional 
- (void)dataFromController;
@end

@interface BackgroudVC : UIViewController
@property (strong ,nonatomic) IBOutlet UILabel *userInfoLabel;
@property (strong ,nonatomic) IBOutlet UILabel *userLocationLabel;
@property (strong ,nonatomic) IBOutlet UIButton *declineButton;
@property (strong ,nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) NSDictionary *notificationDictionary;
@property (nonatomic, weak) id<BackgroundPopupDelegate> delegate;

- (IBAction)acceptButtonAction:(id)sender;
- (IBAction)declineButtonAction:(id)sender;
@end
