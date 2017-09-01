
//  DistanceFilterViewController.m
//  Customer
//  Created by Jamshed Ali on 24/11/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "DistanceFilterViewController.h"
#import "SingletonClass.h"
#import "TTRangeSlider.h"
#import "CommonUtils.h"
#import "AppDelegate.h"
@interface DistanceFilterViewController ()<TTRangeSliderDelegate> {
    
    SingletonClass *sharedInstance;
}
@property (strong, nonatomic) IBOutlet TTRangeSlider *rangeSlider1;
@property (weak,nonatomic) IBOutlet UILabel *seperatorLabel;

@end

@implementation DistanceFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (WIN_WIDTH == 320) {
        [self.rangeSlider1 setFrame:CGRectMake(10, 121, 300, 65)];
        [self.seperatorLabel setFrame:CGRectMake(0, 196, self.view.frame.size.width, 1)];
    }
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    sharedInstance = [SingletonClass sharedInstance];
    sharedInstance.IsDistanceFilter = YES;
    self.rangeSlider1.delegate = self;
    self.rangeSlider1.minValue = 0;
    self.rangeSlider1.maxValue = 100;
    self.rangeSlider1.minDistance = 0;
    self.rangeSlider1.handleBorderWidth = 2;
    self.rangeSlider1.handleColor = [UIColor lightGrayColor];
    self.rangeSlider1.lineHeight = 5;
    self.rangeSlider1.maxLabelColour = [UIColor clearColor];
    self.rangeSlider1.rightHandleSelected = NO;
    [self.rangeSlider1.rightHandle setFrame:CGRectMake(0, 0, 0, 0)];
    if (sharedInstance.distanceIntegerStr.length) {
        int minInt =(int)[sharedInstance.distanceIntegerStr intValue ];
        NSLog(@"Minium Int %d",minInt);
        self.rangeSlider1.selectedMinimum = minInt;
        distanceValueLabel.text = [NSString stringWithFormat:@"%d mi",minInt];
    }
    else
    {
        self.rangeSlider1.selectedMinimum =  100;
        self.rangeSlider1.selectedMaximum =  100;
        distanceValueLabel.text = @"100 mi";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)distanceSliderMethodCall:(UISlider *)sender {
    
    UISlider *slider=(UISlider *)sender;
    float sliderValue=(float)(slider.value );
    NSLog(@"sliderValue = %f",sender.value);
    int sliderIntValue = (int) sliderValue;
    NSLog(@"myInt ==== %d",sliderIntValue);
    sharedInstance.distanceIntegerStr =  [NSString stringWithFormat:@"%d",sliderIntValue];
    sharedInstance.distanceStr = [NSString stringWithFormat:@"%d mi",sliderIntValue];
    distanceValueLabel.text = [NSString stringWithFormat:@"%@",sharedInstance.distanceStr];
}

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum
{
    if (sender == self.rangeSlider1)
    {
        NSLog(@"Standard slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
        float minimumAge=(float)(selectedMinimum);
        NSLog(@" minimumAge sliderValue = %f",minimumAge);
        int minimumAgeIntValue = (int) minimumAge;
        distanceValueLabel.text = [NSString stringWithFormat:@"%d mi",minimumAgeIntValue];
        sharedInstance.distanceIntegerStr =  [NSString stringWithFormat:@"%d",minimumAgeIntValue];
        sharedInstance.distanceStr = [NSString stringWithFormat:@"%d mi",minimumAgeIntValue];
    }
}

@end
