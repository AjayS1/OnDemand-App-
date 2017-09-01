//
//  CreditCardDeclinedVC.m
//  Contractor
//
//  Created by Aditi on 09/02/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import "CreditCardDeclinedVC.h"
#import "Define.h"
#import "AppDelegate.h"
#import "PayNowViewController.h"
#import "ServerRequest.h"
#import "AlertView.h"
#import "RatingViewController.h"
#import "DatesViewController.h"
@interface CreditCardDeclinedVC ()
@property (weak, nonatomic) IBOutlet UITextView *creditCardDeclinedMessage;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;
@end

@implementation CreditCardDeclinedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

//    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
//                            stringForKey:@"tryAgainButtonValue"];
//    if ([savedValue isEqualToString:@"1"]) {
//        [_tryAgainButton setEnabled:NO];
//        [self.tryAgainButton setBackgroundColor:[UIColor colorWithRed:203.0/255.0 green:171.0/255.0 blue:207.0/255.0 alpha:1.0]];
//
//    }
//    else{
//        [_tryAgainButton setEnabled:YES];
//        [self.tryAgainButton setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:143.0/255.0 alpha:1.0]];
//    }

    [_creditCardDeclinedMessage setText:self.creditCradDeclinedMsg];
}

-(IBAction)tryAgainActionMethode:(id)sender{
        [self tryAgainBankAccountMethode];
       [self.tryAgainButton setBackgroundColor:[UIColor colorWithRed:203.0/255.0 green:171.0/255.0 blue:207.0/255.0 alpha:1.0]];
        [_tryAgainButton setEnabled:NO];
}

-(IBAction)useDifferentCardActionMethode:(id)sender{
    PayNowViewController *payNowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PayNowViewController"];
    payNowVC.totalAmountStr = self.totalAmountToBePaid;
    payNowVC.amountPaidForDateID = self.dateIDStr;
    payNowVC.isFromCreditCardDeclined = YES;
    payNowVC.isFromCancelDateByCustomer = YES;
    payNowVC.dateDetailsDictionaryFromDecline = _dateDetailsDictionary;
    [self.navigationController pushViewController:payNowVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tryAgainBankAccountMethode{
    {
        if ([_bankDetailsWithUrl length]) {
            NSString *valueToSave = @"1";
            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"tryAgainButtonValue"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrlForQA:_bankDetailsWithUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                [ProgressHUD dismiss];
                
                if(!error){
                    
                    NSLog(@"Response is --%@",responseObject);
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                        if (self.isFromCaneclDateByContractor) {
                            
                            [self.tabBarController.tabBar setHidden:NO];
                            DatesViewController *dateView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                            dateView.isFromDateDetails = YES;
                            [self.tabBarController setSelectedIndex:1];
                            [self.navigationController pushViewController:dateView animated:NO];
                        }
                        else
                        {
                        RatingViewController *rateViewCall = [self.storyboard instantiateViewControllerWithIdentifier:@"rating"];
                        if (self.isFromLoginCreditView) {
                            rateViewCall.isFromLoginViewController = YES;
                        }
                        else{
                            rateViewCall.isFromLoginViewController = NO;

                        }
                        rateViewCall.isFromCreditCardView = YES;

                        rateViewCall.self.dateIdStr = self.dateIDStr;
                        rateViewCall.isFromDateDetails = NO;
                        rateViewCall.self.nameStr = [[_dateDetailsDictionary objectForKey:@"EndDateCustomer"] objectForKey:@"UserName"];
                        rateViewCall.self.imageUrlStr = [NSString stringWithFormat:@"%@",[[_dateDetailsDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"PicUrl"]];
                        NSString *requestTimeStr = [NSString stringWithFormat:@"%@", [[_dateDetailsDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"EndTime"]];
                        NSString *requestDate = [CommonUtils convertUTCTimeToLocalTime:requestTimeStr WithFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                        // [endTimeLabel setText:[NSString stringWithFormat:@"%@",requestDate]];
                        rateViewCall.self.dateCompletedTimeStr = [CommonUtils changeDateInParticularFormateWithString:requestDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                        [self.navigationController pushViewController:rateViewCall animated:YES];
                     }
                    }
                    else {
                        [CommonUtils showAlertWithTitle:@"Credit Card Declined" withMsg:@"Your card has been declined." inController:self];
                    }
                }
            }];
        }
        }
}

@end
