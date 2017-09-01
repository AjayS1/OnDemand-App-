//
//  InterestViewController.h
//  Customer
//
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InterestViewController : UIViewController

@property(nonatomic,strong)NSString *userInterestedInStr;

@property (strong, nonatomic) IBOutlet UIImageView *maleImage;

@property (strong, nonatomic) IBOutlet UIImageView *femaleImage;

@property (strong, nonatomic) IBOutlet UIImageView *bothImage;




- (IBAction)backButtonClicked:(id)sender;
- (IBAction)maleButtonClicked:(id)sender;
- (IBAction)femaleButtonClciked:(id)sender;
- (IBAction)bothButtonClicked:(id)sender;

@end
