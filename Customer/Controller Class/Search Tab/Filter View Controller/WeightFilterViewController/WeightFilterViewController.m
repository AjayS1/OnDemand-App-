//
//  WeightFilterViewController.m
//  Customer
//
//  Created by Jamshed Ali on 24/11/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "WeightFilterViewController.h"
#import "SingletonClass.h"
#import "TTRangeSlider.h"
#import "CommonUtils.h"
#import "AppDelegate.h"

@interface WeightFilterViewController ()<TTRangeSliderDelegate> {
    SingletonClass *sharedInstance;
}

@property (strong, nonatomic) IBOutlet TTRangeSlider *rangeSlider;
@property (strong, nonatomic) IBOutlet UILabel *customLabel;
@property (weak,nonatomic) IBOutlet UILabel *seperatorLabel;

@end

@implementation WeightFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    sharedInstance = [SingletonClass sharedInstance];
    
    if (WIN_WIDTH == 320) {
        [self.rangeSlider setFrame:CGRectMake(10, 121, 300, 65)];
        [self.seperatorLabel setFrame:CGRectMake(0, 196, self.view.frame.size.width, 1)];
    }
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    self.rangeSlider.delegate = self;
    sharedInstance.IsDistanceFilter = NO;
    self.rangeSlider.minValue = 60;
    self.rangeSlider.maxValue = 300;
    
    if (sharedInstance.selectedStartWeightStr.length)
    {
        int minInt =(int)[sharedInstance.selectedStartWeightStr intValue ];
        NSLog(@"Minium Int %d",minInt);
        int MaXInt =(int)[sharedInstance.selectedEndWeightStr intValue ];
        NSLog(@"Minium Int %d",MaXInt);
        self.rangeSlider.selectedMinimum = minInt;
        self.rangeSlider.selectedMaximum = MaXInt;
        weightRangeLabel.text = [NSString stringWithFormat:@"%d lbs - %d lbs",minInt,MaXInt];
    }
    else
    {
        self.rangeSlider.selectedMinimum =  60;
        self.rangeSlider.selectedMaximum = 300;
        weightRangeLabel.text = [NSString stringWithFormat:@"%d lbs - %d lbs",60,300];
    }
    
    self.rangeSlider.minDistance = 5;
    self.rangeSlider.handleBorderWidth = 2;
    self.rangeSlider.handleColor = [UIColor lightGrayColor];
    self.rangeSlider.lineHeight = 5;
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    if (sender == self.rangeSlider)
    {
        NSLog(@"Standard slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
        float minimumAge=(float)(selectedMinimum);
        NSLog(@" minimumAge sliderValue = %f",minimumAge);
        int minimumAgeIntValue = (int) minimumAge;
        float maximumAge=(float)(selectedMaximum);
        NSLog(@"maximumAge sliderValue = %f",maximumAge);
        int maximumAgeIntValue = (int) maximumAge;
        weightRangeLabel.text = [NSString stringWithFormat:@"%d lbs - %d lbs",minimumAgeIntValue,maximumAgeIntValue];
        sharedInstance.selectedStartWeightStr = [NSString stringWithFormat:@"%d",minimumAgeIntValue];
        sharedInstance.selectedEndWeightStr = [NSString stringWithFormat:@"%d",maximumAgeIntValue];
        sharedInstance.weightSliderStr = [NSString stringWithFormat:@"%@ - %@ lbs.",sharedInstance.selectedStartWeightStr,sharedInstance.selectedEndWeightStr];
    }
}


@end
