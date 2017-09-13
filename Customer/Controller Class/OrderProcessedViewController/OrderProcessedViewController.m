//
//  OrderProcessedViewController.m
//  Customer
//
//  Created by Aditi on 23/12/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "OrderProcessedViewController.h"
#import "SingletonClass.h"
#import "GetVerifiedViewController.h"
#import "AccountViewController.h"
#import "LCTabBarController.h"
#import "AppDelegate.h"

@interface OrderProcessedViewController (){
    SingletonClass *sharedInstance;
}
@property(weak, nonatomic) IBOutlet UILabel *orderDetailLabel;
@property(weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@end

@implementation OrderProcessedViewController

#pragma mark: UIViewController Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    sharedInstance = [SingletonClass sharedInstance];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self.orderDetailLabel setText:[NSString stringWithFormat:@"Thank you for your order.Your order number is %@. We charged %@ to your credit card %@.Below is your background check results from checkr.",sharedInstance.orderNumberStr,sharedInstance.productTotal,sharedInstance.productCardName]];
    
    [self.orderDetailLabel setFrame:CGRectMake(self.orderDetailLabel.frame.origin.x, self.orderDetailLabel.frame.origin.y, self.view.frame.size.width-36, self.orderDetailLabel.frame.size.height)];
    
    if ([sharedInstance.checkRResultStr isEqualToString:@"Passed"])
    {
        [self.orderStatusLabel setText:@"Passed"];
        [self.orderStatusLabel setTextColor:[UIColor colorWithRed:19.0/255.0 green:145.0/255.0 blue:72.0/255 alpha:1.0]];
    }
    else
    {
        [self.orderStatusLabel setText:@"Not Pass"];
        [self.orderStatusLabel setTextColor:[UIColor colorWithRed:191.0/255 green:41.0/255.0 blue:50.0/255 alpha:1.0]];
    }
    
    [self.orderStatusLabel setText:sharedInstance.checkRResultStr];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}

#pragma mark: Button Action
-(IBAction)backButtonMethodClicked:(id)sender {
}

-(IBAction)doneMethodClicked:(id)sender
{
    AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
    accountView.isFromOrderProcess = YES;
    accountView.isEmailVerifiedOrNotPage = NO;
    accountView.isFromUpdateMobileNumber = NO;
    accountView.isFromCreditCardProcess = NO;
    [self.navigationController pushViewController:accountView animated:NO];
}

#pragma mark: Memory Management Methode
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
