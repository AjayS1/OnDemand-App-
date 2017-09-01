//
//  AgeFilterViewController.m
//  Customer
//
//  Created by Jamshed Ali on 24/11/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "AgeFilterViewController.h"
#import "SingletonClass.h"
#import "TTRangeSlider.h"
#import "CommonUtils.h"
#import "AppDelegate.h"

@interface AgeFilterViewController ()<TTRangeSliderDelegate> {
    SingletonClass *sharedInstance;
}
@property (strong, nonatomic) IBOutlet TTRangeSlider *rangeSlider;
@property (weak,nonatomic) IBOutlet UILabel *seperatorLabel;
@end

@implementation AgeFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    sharedInstance = [SingletonClass sharedInstance];
    sharedInstance.IsDistanceFilter = NO;
    if (WIN_WIDTH == 320) {
        [self.rangeSlider setFrame:CGRectMake(10, 121, 300, 65)];
        [self.seperatorLabel setFrame:CGRectMake(0, 196, self.view.frame.size.width, 1)];
    }
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    self.rangeSlider.delegate = self;
    self.rangeSlider.minValue = 18;
    self.rangeSlider.maxValue = 99;
    if (sharedInstance.selectedStartAgeStr.length) {
        
        int minInt =(int)[sharedInstance.selectedStartAgeStr intValue ];
        NSLog(@"Minium Int %d",minInt);
        int MaXInt =(int)[sharedInstance.selectedEndAgeStr intValue ];
        NSLog(@"Minium Int %d",MaXInt);
        self.rangeSlider.selectedMinimum = minInt;
        self.rangeSlider.selectedMaximum = MaXInt;
        ageRangeLabel.text = [NSString stringWithFormat:@"%d - %d",minInt,MaXInt];
    }
    else {
        self.rangeSlider.selectedMinimum = 18;
        self.rangeSlider.selectedMaximum = 99;
        ageRangeLabel.text = [NSString stringWithFormat:@"%d - %d",18,99];
    }
    self.rangeSlider.minDistance = 1;
    self.rangeSlider.handleBorderWidth = 2;
    self.rangeSlider.handleColor = [UIColor lightGrayColor];
    self.rangeSlider.lineHeight = 5;
}

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    
    if (sender == self.rangeSlider){
        
        NSLog(@"Standard slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
        float minimumAge=(float)(selectedMinimum);
        NSLog(@" minimumAge sliderValue = %f",minimumAge);
        int minimumAgeIntValue = (int) minimumAge;
        float maximumAge=(float)(selectedMaximum);
        NSLog(@"maximumAge sliderValue = %f",maximumAge);
        int maximumAgeIntValue = (int) maximumAge;
        ageRangeLabel.text = [NSString stringWithFormat:@"%d - %d",minimumAgeIntValue,maximumAgeIntValue];
        sharedInstance.selectedStartAgeStr = [NSString stringWithFormat:@"%d",minimumAgeIntValue];
        sharedInstance.selectedEndAgeStr = [NSString stringWithFormat:@"%d",maximumAgeIntValue];
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
