//
//  BodyTypeVC.m
//  Customer
//
//  Created by Jamshed on 7/7/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "BodyTypeVC.h"
@interface BodyTypeVC ()

@end

@implementation BodyTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    bodyTypeArray = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
