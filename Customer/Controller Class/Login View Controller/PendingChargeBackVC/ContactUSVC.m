//
//  ContactUSVC.m
//  Customer
//
//  Created by Aditi on 09/02/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import "ContactUSVC.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
@interface ContactUSVC ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>{
    NSString *supportUrlString;
    NSString *billingUrlString;
}

@property(weak, nonatomic) IBOutlet UIView *cornerView;
@property(weak, nonatomic) IBOutlet UILabel *billingLabel;
@property(weak, nonatomic) IBOutlet UILabel *supportLabel;
@property(weak, nonatomic) IBOutlet UIButton *billingButton;
@property(weak, nonatomic) IBOutlet UIButton *supportButton;
- (IBAction)supportButtonAction:(id)sender;
- (IBAction)billingButtonAction:(id)sender;

@end

@implementation ContactUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat borderWidth = 1.0f;
    _cornerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _cornerView.layer.borderWidth = borderWidth;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    [self fetchUserAccountApiData];
}

#pragma mark-- User Account Details API Call
- (void)fetchUserAccountApiData {
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlForQA:APIAccountContactUs withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                supportUrlString = [responseObject objectForKey:@"TechnicalIssues"];
                billingUrlString = [responseObject objectForKey:@"BillingInquiries"];
//                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:nil];
//                NSRange linkRange = NSMakeRange(0, 20); // for the word "link" in the string above
//                NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0],
//                                                  NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
//                [attributedString setAttributes:linkAttributes range:linkRange];
//                // Assign attributedText to UILabel
//                _supportLabel.attributedText = attributedString;
//                _billingLabel.attributedText = attributedString;
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}



//http://ondemandapiqa.flexsin.in/API/Account/Contactus
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonMethode:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)supportButtonAction:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Issue with the date"];
        [mail setMessageBody:@"" isHTML:NO];
        [mail setToRecipients:@[supportUrlString]];
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
    
}

- (IBAction)billingButtonAction:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Issue with the date"];
        [mail setMessageBody:@"" isHTML:NO];
        [mail setToRecipients:@[billingUrlString]];
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
