
//  SelectIssueViewController.m
//  Customer
//  Created by Jamshed Ali on 30/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "SelectIssueViewController.h"

@interface SelectIssueViewController (){
    SingletonClass *sharedInstance;
}
@end
@implementation SelectIssueViewController
@synthesize dateIdStr;

- (void)viewDidLoad
{
    [super viewDidLoad];
  }

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    sharedInstance = [SingletonClass sharedInstance];

    if (sharedInstance.isFromReportSubmit) {
        sharedInstance.isFromReportSubmit = NO;
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    _userImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    _userImageView.layer.cornerRadius=_userImageView.frame.size.height/2;
    _userImageView.layer.borderWidth=2.0;
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
    NSString *setPrimaryImageUrlStr =  [NSString stringWithFormat:@"%@",self.userImagePicUrl];
    NSURL *imageUrl = [NSURL URLWithString:setPrimaryImageUrlStr];
    [_userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    contractorNamelabel.text = [NSString stringWithFormat:@"%@",self.userNameStr];
    priceLabel.text = [NSString stringWithFormat:@"%@",self.priceValueStr];
    [statusLabel setText:self.statusValueStr];
    if (_dateCompletedTimeStr == nil) {
        dateLabel.text = [NSString stringWithFormat:@"%@",@""];
    }
    else{
        dateLabel.text = [NSString stringWithFormat:@"%@",_dateCompletedTimeStr];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dateIssueButtonClicked:(id)sender {
    
    DateReportSubmitViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateReportSubmit"];
    dateReportView.self.requestType = @"pastDateDetails";
    dateReportView.self.dateIdStr = self.dateIdStr;
    dateReportView.self.issueIdStr = @"1";
    [self.navigationController pushViewController:dateReportView animated:YES];
}

- (IBAction)chargeIssueButtonClicked:(id)sender {
    
    DateReportSubmitViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateReportSubmit"];
    dateReportView.self.requestType = @"pastDateDetails";
    dateReportView.self.dateIdStr = self.dateIdStr;
    dateReportView.self.issueIdStr = @"1";
    [self.navigationController pushViewController:dateReportView animated:YES];
}

- (IBAction)diffrentIssueButtonClicked:(id)sender {
    
    DateReportSubmitViewController *dateReportView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateReportSubmit"];
    dateReportView.self.requestType = @"pastDateDetails";
    dateReportView.self.dateIdStr = self.dateIdStr;
    dateReportView.self.issueIdStr = @"1";
    [self.navigationController pushViewController:dateReportView animated:YES];
}


@end
