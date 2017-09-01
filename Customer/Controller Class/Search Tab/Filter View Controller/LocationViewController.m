
//  LocationViewController.m
//  Customer
//  Created by Jamshed on 8/3/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "LocationViewController.h"

@interface LocationViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *objPickerView;
    UIToolbar *numberToolBar;
    NSInteger selectedIndexPicker;
    NSMutableArray *arrayOfCountry;
}
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sliderView = [[UISlider alloc] init];
    sliderView.minimumValue = 20.0f;
    sliderView.maximumValue = 100.0f;
    sliderView.continuous = YES;
    titleLabel.text = self.titleStr;
    [self setTextFieldValue];
    arrayOfCountry = [[NSMutableArray alloc] init];
    objPickerView = [UIPickerView new];
    objPickerView.delegate = self;
    objPickerView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)setTextFieldValue
{
    NSString *strForCountry = [[NSUserDefaults standardUserDefaults]objectForKey:@"CountryDataValue"];
    NSString *strForState = [[NSUserDefaults standardUserDefaults]objectForKey:@"StateDataValue"];
    NSString *strForCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"CityDataValue"];
    NSString *strForzip = [[NSUserDefaults standardUserDefaults]objectForKey:@"ZipCodeDataValue"];
    NSString *sliderValueData = [[NSUserDefaults standardUserDefaults]objectForKey:@"SliderValueDataValue"];
    countryTextFld.text = strForCountry;
    stateTextFld.text = strForState;
    cityTextFld.text = strForCity;
    zipCodeTextFld.text = strForzip;
    sliderVlaueLbl.text = sliderValueData;
    if ([countryTextFld.text length]==0){
        sliderMaximumVlaueLbl.hidden = NO;
    }
    else
    {
        sliderMaximumVlaueLbl.hidden = YES;
    }
    [sliderView setValue:[[NSUserDefaults standardUserDefaults] floatForKey:@"SliderViewValue"]];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonClicked:(id)sender
{
    if ([countryTextFld.text length]==0){
        [[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter Country Name" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    }
    else if([stateTextFld.text length]==0)
    {
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please Enter State Name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
    }
    else if([cityTextFld.text length]==0)
    {
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please Enter City Name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
    }
    else if([zipCodeTextFld.text length]==0)
    {
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please Enter Zip Code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
    }
    else
    {
        locationStr = [NSString stringWithFormat:@"%@,%@,%@,%@",countryTextFld.text,stateTextFld.text,cityTextFld.text,zipCodeTextFld.text];
        [[NSUserDefaults standardUserDefaults]setObject:locationStr forKey:@"LocationDataValue"];
        [[NSUserDefaults standardUserDefaults]setObject:countryTextFld.text forKey:@"CountryDataValue"];
        [[NSUserDefaults standardUserDefaults]setObject:stateTextFld.text forKey:@"StateDataValue"];
        [[NSUserDefaults standardUserDefaults]setObject:cityTextFld.text forKey:@"CityDataValue"];
        [[NSUserDefaults standardUserDefaults]setObject:zipCodeTextFld.text forKey:@"ZipCodeDataValue"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)sliderButtonClicked:(UISlider *)sender {
    sliderMaximumVlaueLbl.hidden = YES;
    progressAsInt = (int)(sender.value);
    sliderValueStr =  [NSString stringWithFormat:@"%d", progressAsInt];
    sliderVlaueLbl.text = sliderValueStr;
    [[NSUserDefaults standardUserDefaults]setObject:sliderValueStr forKey:@"SliderValueDataValue"];
    
}

#pragma mark:UIPickerView Delegate and Datasources Method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return arrayOfCountry.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //    CountryCodeSuggestion *customCountry = [arrayOfCountry objectAtIndex:row];
    //    return [NSString stringWithFormat:@"%@",customCountry.countryName];
    return nil;
}


-(void)doneWithNumberPad {
    [self.view endEditing:YES];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //CountryCodeSuggestion *customCountry = [arrayOfCountry objectAtIndex:row];
    //countryCodeTextField.text= customCountry.countryCode;
    selectedIndexPicker = row;
}

-(void)cancelPicker:(id)sender{
    //  [countryCodeTextField resignFirstResponder];
}

-(void)donePicker:(id)sender{
    //    CountryCodeSuggestion *customCountry = [arrayOfCountry objectAtIndex:selectedIndexPicker];
    //    countryCodeTextField.text= [NSString stringWithFormat:@"%@",customCountry.countryName];
    //    countryID = customCountry.countryID;
    //    [countryCodeTextField resignFirstResponder];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField == countryTextFld){
        //[self countryCodeButtonClicked];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == countryTextFld) {
        // sharedInstance.countryCodeStr = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if(textField == countryTextFld){
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
