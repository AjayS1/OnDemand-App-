
//  RequestSentViewController.m
//  Customer
//  Created by Jamshed Ali on 09/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "RequestSentViewController.h"

@interface RequestSentViewController () {
    BOOL checkTab;
}
@end

@implementation RequestSentViewController
@synthesize averageTimeStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    _avarageTimeLabel.text = self.averageTimeStr;
    checkTab = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"Search ViewController viewWillAppear Call");
    [super viewWillAppear:YES];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (checkTab) {
        SearchViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
        [self.navigationController pushViewController:notiView animated:NO ];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closeBtnClicked:(id)sender {
    SearchViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [self.navigationController pushViewController:notiView animated:NO];
}

- (IBAction)viewReservationBtnClicked:(id)sender {
    
    for ( UINavigationController *controller in self.tabBarController.viewControllers ) {
        if ( [[controller.childViewControllers objectAtIndex:0] isKindOfClass:[DatesViewController class]]) {
            checkTab = YES;
            self.tabBarController.selectedIndex = 1;
            [self.tabBarController setSelectedViewController:controller];
            break;
        }
    }
}


@end
