
//  RequestSentViewController.h
//  Customer
//  Created by Jamshed Ali on 09/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface RequestSentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *avarageTimeLabel;

@property(nonatomic,strong)NSString *averageTimeStr;

- (IBAction)closeBtnClicked:(id)sender;

- (IBAction)viewReservationBtnClicked:(id)sender;


@end
