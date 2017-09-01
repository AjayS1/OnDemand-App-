//
//  HomeTabBarViewController.m
//  Customer
//
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "HomeTabBarViewController.h"
#import "AppDelegate.h"
@interface HomeTabBarViewController ()

@end

@implementation HomeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Change Item" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Go Message" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClicked)];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}

- (void)leftBarButtonItemClicked {
    
    self.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover"];
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_discover_selected"];
    self.tabBarItem.title = @"Woo!";
}

- (void)rightBarButtonItemClicked {
    [(LCTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController setSelectedIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
