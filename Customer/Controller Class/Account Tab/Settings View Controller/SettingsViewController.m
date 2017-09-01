
//  SettingsViewController.m
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "SettingsViewController.h"

@interface SettingsViewController () {
    
    NSArray *titleArray;
    NSInteger lastCount;

}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    titleArray = @[@"Notifications",@"Units",@"Language"];
    settingsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //Creating View
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    //Creating Label
    UILabel *lineView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    [headerView addSubview:lineView];
    //Creating Label
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTableViewCell *cell;
    cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;

    cell.nameLbl.text = [titleArray objectAtIndex:indexPath.row];
    lastCount = titleArray.count - 1;
    if (indexPath.row == lastCount) {
       // [cell.seperatorLabelValue setHidden:YES];
    }
    else{
       // [cell.seperatorLabelValue setHidden:NO];
    }
    cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        NotificationOptionViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"notificationType"];
        [self.navigationController pushViewController:notiView animated:YES];
        
    } else if (indexPath.row == 1) {
        
        UnitsViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"units"];
        [self.navigationController pushViewController:notiView animated:YES];
        
    } else if (indexPath.row == 2) {
        
        LanguageViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"language"];
        [self.navigationController pushViewController:notiView animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
