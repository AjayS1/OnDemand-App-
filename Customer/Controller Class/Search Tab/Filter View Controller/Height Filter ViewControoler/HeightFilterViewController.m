
//  HeightFilterViewController.m
//  Customer
//  Created by Jamshed Ali on 24/11/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "HeightFilterViewController.h"
#import "SingletonClass.h"
#import "TTRangeSlider.h"
#import "CommonUtils.h"
#import "AppDelegate.h"

@interface HeightFilterViewController ()<TTRangeSliderDelegate> {
    
    SingletonClass *sharedInstance;
}
@property (strong, nonatomic) IBOutlet TTRangeSlider *rangeAgeSlider;
@property (weak,nonatomic) IBOutlet UILabel *seperatorLabel;

@end

@implementation HeightFilterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (WIN_WIDTH == 320) {
        [self.rangeAgeSlider setFrame:CGRectMake(10, 121, 300, 65)];
        [self.seperatorLabel setFrame:CGRectMake(0, 196, self.view.frame.size.width, 1)];
    }
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    sharedInstance = [SingletonClass sharedInstance];
    sharedInstance.heightSliderValue =  YES;
    sharedInstance.IsDistanceFilter = NO;
    
    self.rangeAgeSlider.delegate = self;
    if ([sharedInstance.strUnityTypeValue isEqualToString:@"1"]) {
        
        self.rangeAgeSlider.minValue = 48;
        self.rangeAgeSlider.maxValue = 96;
        
    }
    else{
        self.rangeAgeSlider.minValue = 122;
        self.rangeAgeSlider.maxValue = 244;
        
    }
    
    [self.rangeAgeSlider setMinLabelColour:[UIColor clearColor]];
    [self.rangeAgeSlider setMaxLabelColour:[UIColor clearColor]];
    
    if (sharedInstance.selectedStartHeightStr.length) {
        int minInt =(int)[sharedInstance.selectedStartHeightStr intValue ];
        NSLog(@"Minium Int %d",minInt);
        int MaXInt =(int)[sharedInstance.selectedEndHeightStr intValue ];
        NSLog(@"Minium Int %d",MaXInt);
        
        NSInteger startHeight =[sharedInstance.selectedStartHeightStr integerValue];
        NSInteger endHeight =[sharedInstance.selectedEndHeightStr integerValue];
        
        if ([sharedInstance.strUnityTypeValue isEqualToString:@"1"]) {
            
            self.rangeAgeSlider.selectedMinimum = minInt;
            self.rangeAgeSlider.selectedMaximum = MaXInt;
            
            if (startHeight>=48 && endHeight <=96) {
                
                heightLabel.text =[NSString stringWithFormat:@"%@ - %@",[CommonUtils ChangeIncheTofit:startHeight ],[CommonUtils ChangeIncheTofit:endHeight]];
                //heightLabel.text =[NSString stringWithFormat:@"%ld - %ld",startHeight,endHeight];
            }
            else{
                NSInteger startHeight =[CommonUtils ChangeCmToInche:[sharedInstance.selectedStartHeightStr integerValue] ];
                NSInteger endHeight =[CommonUtils ChangeCmToInche:[sharedInstance.selectedStartHeightStr integerValue] ];
                heightLabel.text=[NSString stringWithFormat:@"%@ - %@",[CommonUtils ChangeIncheTofit:startHeight ],[CommonUtils ChangeIncheTofit:endHeight]];
                
                
            }
            
        }
        else {
            
            NSInteger startHeightInCm =[CommonUtils ChangeIncheToCm:[sharedInstance.selectedStartHeightStr integerValue] ];
            NSInteger endHeightInCm =[CommonUtils ChangeIncheToCm:[sharedInstance.selectedEndHeightStr integerValue] ];
            self.rangeAgeSlider.selectedMinimum = startHeightInCm;
            self.rangeAgeSlider.selectedMaximum = endHeightInCm;
            if (startHeight>=48 && endHeight <=96) {
                
                heightLabel.text =[NSString stringWithFormat:@"%ld cm - %ld cm",(long)startHeightInCm,endHeightInCm];
            }
            else{
                self.rangeAgeSlider.selectedMinimum = startHeight;
                self.rangeAgeSlider.selectedMaximum = endHeight;
                
                heightLabel.text =[NSString stringWithFormat:@"%ld cm - %ld cm",(long)startHeight,endHeight];
            }
        }
        
        // [self updateRangeTextWithMinimumValue:self.rangeAgeSlider.selectedMinimum maxvalue:self.rangeAgeSlider.selectedMaximum];
        
    }
    else {
        
        if ([sharedInstance.strUnityTypeValue isEqualToString:@"1"]) {
            
            self.rangeAgeSlider.selectedMinimum = 48;
            self.rangeAgeSlider.selectedMaximum = 96;
        }
        else {
            
            self.rangeAgeSlider.selectedMinimum = (48.0*2.54);
            self.rangeAgeSlider.selectedMaximum = (96.0*2.54);
            
        }
        
        [self updateRangeTextWithMinimumValue:self.rangeAgeSlider.selectedMinimum maxvalue:self.rangeAgeSlider.selectedMaximum] ;
    }
    self.rangeAgeSlider.minDistance = 1;
    self.rangeAgeSlider.handleBorderWidth = 2;
    self.rangeAgeSlider.handleColor = [UIColor lightGrayColor];
    self.rangeAgeSlider.lineHeight = 5;
    
}

#pragma mark  Promotional- Actions


#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    if (sender == self.rangeAgeSlider){
        
        NSLog(@"Standard slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
        float minimumAge=(float)(selectedMinimum);
        NSLog(@" minimumAge sliderValue = %f",minimumAge);
        int minimumAgeIntValue = (int) minimumAge;
        
        float maximumAge=(float)(selectedMaximum);
        NSLog(@"maximumAge sliderValue = %f",maximumAge);
        int maximumAgeIntValue = (int) maximumAge;
        sharedInstance.selectedStartHeightStr = [NSString stringWithFormat:@"%d",minimumAgeIntValue];
        sharedInstance.selectedEndHeightStr = [NSString stringWithFormat:@"%d",maximumAgeIntValue];
        [self updateRangeTextWithMinimumValue:minimumAgeIntValue maxvalue:maximumAgeIntValue] ;
        
    }
    
}

- (void)updateRangeTextWithMinimumValue:(NSInteger)minValue maxvalue:(NSInteger)maxvalue
{
    float minimumRange=(float)(minValue);
    NSLog(@" minimum sliderValue = %f",minimumRange);
    float maximumRange=(float)(maxvalue );
    NSLog(@"maximumAge sliderValue = %f",maximumRange);
    NSLog(@"myInt ==== %.1f",maximumRange);
    sharedInstance.selectedStartHeightStr = [NSString stringWithFormat:@"%f",minimumRange];
    sharedInstance.selectedEndHeightStr = [NSString stringWithFormat:@"%f",maximumRange];
    if ([sharedInstance.strUnityTypeValue isEqualToString:@"1"]) {
        maximumRange = maximumRange/12;
        minimumRange = minimumRange/12;
        NSString *maximumValue = [NSString stringWithFormat:@"%f",maximumRange];
        NSArray *maxArray = [maximumValue componentsSeparatedByString:@"."];
        NSString *maxFeetValue = [NSString stringWithFormat:@"%@",[maxArray objectAtIndex:0]];
        NSString *decimalMaxFeet = [NSString stringWithFormat:@".%@",[maxArray objectAtIndex:1]];
        maximumRange = [decimalMaxFeet floatValue]*12;
        NSString *maxInchStr = [NSString stringWithFormat:@"%.0f",maximumRange];
        
        NSString *minimumValue = [NSString stringWithFormat:@"%f",minimumRange];
        NSArray *minArray = [minimumValue componentsSeparatedByString:@"."];
        NSString *minFeetValue = [NSString stringWithFormat:@"%@",[minArray objectAtIndex:0]];
        NSString *decimalFeet = [NSString stringWithFormat:@".%@",[minArray objectAtIndex:1]];
        //decimalFeet = .970297
        minimumRange = [decimalFeet floatValue]*12;
        //minimumRange = 11.6435642
        NSString *minInchStr = [NSString stringWithFormat:@"%.0f",minimumRange];
        // minInchStr = 12
        
        if ([minInchStr isEqualToString:@"12"]) {
            minInchStr = @"0";
            minFeetValue = [NSString stringWithFormat:@"%d",[minFeetValue intValue]+1];
            NSLog(@"minFeetValue ==== %@",minFeetValue);
        }
        
        if ([maxInchStr isEqualToString:@"12"]) {
            
            maxInchStr = @"0";
            maxFeetValue = [NSString stringWithFormat:@"%d",[maxFeetValue intValue]+1];
            NSLog(@"MaxFeetValue ==== %@",maxFeetValue);
        }
        
        NSString *inchStr =@"''";
        heightLabel.text = [NSString stringWithFormat:@"%@'%@%@ - %@'%@%@",minFeetValue,minInchStr,inchStr,maxFeetValue,maxInchStr,inchStr];
        sharedInstance.heightSliderStr = heightLabel.text;
    }
    else {
        
        NSInteger minHeightInCm = ([[NSString stringWithFormat:@"%f",minimumRange]integerValue ]);
        NSInteger maxHeightInCm = ([[NSString stringWithFormat:@"%f",maximumRange]integerValue ]);
        NSLog(@"Min Height%ld",(long)minHeightInCm);
        NSLog(@"Max Height%ld",(long)maxHeightInCm);
        sharedInstance.selectedStartHeightStr = [NSString stringWithFormat:@"%ld",(long)minHeightInCm];
        sharedInstance.selectedEndHeightStr = [NSString stringWithFormat:@"%ld",(long)maxHeightInCm];
        heightLabel.text = [NSString stringWithFormat:@"%ld cm - %ld cm",(long)minHeightInCm,(long)maxHeightInCm];
        sharedInstance.heightSliderStr = heightLabel.text;
        NSLog(@"Value Of Height%@",sharedInstance.heightSliderStr);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
