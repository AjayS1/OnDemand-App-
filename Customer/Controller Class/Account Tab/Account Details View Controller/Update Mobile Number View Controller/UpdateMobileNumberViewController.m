//
//  UpdateMobileNumberViewController.m
//  Customer
//
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "UpdateMobileNumberViewController.h"
#import "CommonUtils.h"
@interface UpdateMobileNumberViewController ()<UIPickerViewDelegate,UIPickerViewDataSource> {
    
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    NSMutableArray *arrayOfCountry ;
    NSMutableArray *arrayOfParseCountry ;
    
    UIPickerView *objPickerView;
    UIToolbar *numberToolBar;
    NSInteger selectedIndexPicker;
    NSString *mobileNumberStr;
    NSString *countryID;
}

@property (strong, nonatomic) NSDictionary *countryCodeDict;
@end

@implementation UpdateMobileNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    objPickerView = [UIPickerView new];
    objPickerView.delegate = self;
    objPickerView.dataSource = self;
    mobileTextField.text = self.userMobileNmbrStr;
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    countryCodeButton.layer.borderWidth = 1.0;
    mobileTextField.layer.borderWidth = 1.0;
    countryCodeTextField.layer.borderWidth = 1.0;
    countryCodeButton.layer.borderColor =[CommonUtils colorWithHexString:@"CCCCCC"].CGColor;
    mobileTextField.layer.borderColor = [CommonUtils colorWithHexString:@"CCCCCC"].CGColor;
    countryCodeTextField.layer.borderColor = [CommonUtils colorWithHexString:@"CCCCCC"].CGColor;
    countryCodeTextField.layer.masksToBounds = YES;
    mobileTextField.layer.masksToBounds = YES;

    
    arrayOfCountry  = [[NSMutableArray alloc]init];
    arrayOfParseCountry = [[NSMutableArray alloc]init];
    //Initialize selected Picker Index
    selectedIndexPicker = 0;
    [countryCodeTextField setText:[NSString stringWithFormat:@"%@",sharedInstance.countryCodeStr]];
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    mobileTextField.keyboardType = UIKeyboardTypePhonePad;
    mobileTextField.inputAccessoryView = numberToolbar;
    [self getStateAbbrevationWithString];
    
    
}

-(void)doneWithNumberPad {
    [self.view endEditing:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-- Next Method Call
- (IBAction)nextButtonClicked:(id)sender {
    
    if([mobileTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please insert the mobile number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
    }
    else if(([countryCodeTextField.text isEqualToString:@"+"]) || ([countryCodeTextField.text length]==0)) {
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please select the country code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
    }
    
    else {
        [self updateMobileNumberApiCall];
    }
}

#pragma mark-- Update Mobile Number API Call

- (void)updateMobileNumberApiCall {
    
    
    NSString *str = [NSString stringWithFormat:@"%@ %@",self.countryID,mobileTextField.text];
    NSString *urlstr = [NSString stringWithFormat:@"%@?userID=%@&MobileNumber=%@",APIUpdateMobileNumber,userIdStr,str];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                ConfirmationViewController *confirmCodeView = [self.storyboard instantiateViewControllerWithIdentifier:@"activationCode"];
                confirmCodeView.mobileNumberString = str;
                [self.navigationController pushViewController:confirmCodeView animated:YES];
            }
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] == 0){
                [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Alert!" andMessage:[responseObject objectForKey:@"Message"] onController:self];
            }
            else {
                
                AccountViewController *confirmCodeView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                confirmCodeView.isFromUpdateMobileNumber = YES;
                confirmCodeView.isFromCreditCardProcess = NO;
                confirmCodeView.isFromOrderProcess = NO;
                confirmCodeView.isEmailVerifiedOrNotPage = NO;
             
                [self.navigationController pushViewController:confirmCodeView animated:NO];
            }
        }
    }];
}


#pragma mark:UIPickerView Delegate and Datasources Method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return arrayOfCountry.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    CountryCodeSuggestion *customCountry = [arrayOfCountry objectAtIndex:row];
    return [NSString stringWithFormat:@"%@",customCountry.countryName];
}


- (void)countryCodeButtonClicked {
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float pickerWidth = screenWidth * 3 / 4;
    // Calculate the starting x coordinate.
    float xPoint = screenWidth / 2 - pickerWidth / 2;
    objPickerView = [[UIPickerView alloc] init];
    [objPickerView setDelegate: self];
    [objPickerView setFrame: CGRectMake(xPoint, 50.0f, pickerWidth, 200.0f)];
    objPickerView.showsSelectionIndicator = YES;
    [countryCodeTextField setInputView:objPickerView];
    for (int j = 0; j<=arrayOfCountry.count; j++) {
        CountryCodeSuggestion *customCountryVlaue = [arrayOfCountry objectAtIndex:j];
        if ([customCountryVlaue.countryName isEqualToString:sharedInstance.countryCodeStr]) {
            selectedIndexPicker = j;
            [objPickerView selectRow:j inComponent:0 animated:YES];
            break;
        }
    }
    
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPicker:)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePicker:)]];
    
    [numberToolbar sizeToFit];
    countryCodeTextField.inputAccessoryView = numberToolbar;
}



-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //CountryCodeSuggestion *customCountry = [arrayOfCountry objectAtIndex:row];
    //countryCodeTextField.text= customCountry.countryCode;
    NSLog(@"INDEX PICKER %ld",(long)selectedIndexPicker);
    selectedIndexPicker = row;
}

-(void)cancelPicker:(id)sender{
    [countryCodeTextField resignFirstResponder];
}

-(void)donePicker:(id)sender{
    CountryCodeSuggestion *customCountry = [arrayOfCountry objectAtIndex:selectedIndexPicker];
    countryCodeTextField.text= [NSString stringWithFormat:@"%@",customCountry.countryName];
    self.countryID = customCountry.countryID;
    [countryCodeTextField resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField == countryCodeTextField){
        [self countryCodeButtonClicked];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == countryCodeTextField) {
        sharedInstance.countryCodeStr = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if(textField == countryCodeTextField){
        return NO;
    }
    return YES;
}

-(void)getStateAbbrevationWithString
{

    NSMutableDictionary *englanguageDict = [[NSMutableDictionary alloc]init];
    [englanguageDict setObject:@"Afghanistan +93" forKey:@"Value"];
    [englanguageDict setObject:@"1" forKey:@"ID"];
    
    NSMutableDictionary *spanlanguageDict = [[NSMutableDictionary alloc]init];
    [spanlanguageDict setObject:@"Albania +355" forKey:@"Value"];
    [spanlanguageDict setObject:@"2" forKey:@"ID"];
    
    NSMutableDictionary *frenchlanguageDict = [[NSMutableDictionary alloc]init];
    [frenchlanguageDict setObject:@"Algeria +213" forKey:@"Value"];
    [frenchlanguageDict setObject:@"3" forKey:@"ID"];
    
    NSMutableDictionary *dutchlanguageDict = [[NSMutableDictionary alloc]init];
    [dutchlanguageDict setObject:@"American Samoa +1684" forKey:@"Value"];
    [dutchlanguageDict setObject:@"4" forKey:@"ID"];
    
    NSMutableDictionary *chineselanguageDict = [[NSMutableDictionary alloc]init];
    [chineselanguageDict setObject:@"Andorra +376" forKey:@"Value"];
    [chineselanguageDict setObject:@"5" forKey:@"ID"];
    
    NSMutableDictionary *italianlanguageDict = [[NSMutableDictionary alloc]init];
    [italianlanguageDict setObject:@"Angola +244" forKey:@"Value"];
    [italianlanguageDict setObject:@"6" forKey:@"ID"];
    
    NSMutableDictionary *portugeselanguageDict = [[NSMutableDictionary alloc]init];
    [portugeselanguageDict setObject:@"Anguilla +1264" forKey:@"Value"];
    [portugeselanguageDict setObject:@"7" forKey:@"ID"];
    
    NSMutableDictionary *japaneselanguageDict = [[NSMutableDictionary alloc]init];
    [japaneselanguageDict setObject:@"Antarctica +0" forKey:@"Value"];
    [japaneselanguageDict setObject:@"8" forKey:@"ID"];
    
    NSMutableDictionary *koreanlanguageDict = [[NSMutableDictionary alloc]init];
    [koreanlanguageDict setObject:@"Antigua And Barbuda +1268" forKey:@"Value"];
    [koreanlanguageDict setObject:@"9" forKey:@"ID"];
    
    NSMutableDictionary *russianlanguageDict = [[NSMutableDictionary alloc]init];
    [russianlanguageDict setObject:@"Argentina +54" forKey:@"Value"];
    [russianlanguageDict setObject:@"10" forKey:@"ID"];
    
    NSMutableDictionary *nederlandslanguageDict = [[NSMutableDictionary alloc]init];
    [nederlandslanguageDict setObject:@"Armenia +374" forKey:@"Value"];
    [nederlandslanguageDict setObject:@"11" forKey:@"ID"];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
    [dict1 setObject:@"Aruba +297" forKey:@"Value"];
    [dict1 setObject:@"12" forKey:@"ID"];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
    [dict2 setObject:@"Australia +61" forKey:@"Value"];
    [dict2 setObject:@"13" forKey:@"ID"];
    
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]init];
    [dict3 setObject:@"Austria +43" forKey:@"Value"];
    [dict3 setObject:@"14" forKey:@"ID"];
    
    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]init];
    [dict4 setObject:@"Azerbaijan +994" forKey:@"Value"];
    [dict4 setObject:@"15" forKey:@"ID"];
    
    NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]init];
    [dict5 setObject:@"Bahamas +1242" forKey:@"Value"];
    [dict5 setObject:@"16" forKey:@"ID"];
    
    NSMutableDictionary *dict6= [[NSMutableDictionary alloc]init];
    [dict6 setObject:@"Bahrain +973" forKey:@"Value"];
    [dict6 setObject:@"17" forKey:@"ID"];
    
    NSMutableDictionary *dict7 = [[NSMutableDictionary alloc]init];
    [dict7 setObject:@"Bangladesh +880" forKey:@"Value"];
    [dict7 setObject:@"18" forKey:@"ID"];
    
    NSMutableDictionary *dict8= [[NSMutableDictionary alloc]init];
    [dict8 setObject:@"Barbados +1246" forKey:@"Value"];
    [dict8 setObject:@"19" forKey:@"ID"];
    
    NSMutableDictionary *dict9= [[NSMutableDictionary alloc]init];
    [dict9 setObject:@"Belarus +375" forKey:@"Value"];
    [dict9 setObject:@"20" forKey:@"ID"];
    
    NSMutableDictionary *dict10= [[NSMutableDictionary alloc]init];
    [dict10 setObject:@"Belgium +32" forKey:@"Value"];
    [dict10 setObject:@"21" forKey:@"ID"];
    
    NSMutableDictionary *dict11 = [[NSMutableDictionary alloc]init];
    [dict11 setObject:@"Belize +501" forKey:@"Value"];
    [dict11 setObject:@"22" forKey:@"ID"];
    
    NSMutableDictionary *dict12= [[NSMutableDictionary alloc]init];
    [dict12 setObject:@"Benin +229" forKey:@"Value"];
    [dict12 setObject:@"23" forKey:@"ID"];
    
    NSMutableDictionary *dict13 = [[NSMutableDictionary alloc]init];
    [dict13 setObject:@"Bermuda +1441" forKey:@"Value"];
    [dict13 setObject:@"24" forKey:@"ID"];
    
    NSMutableDictionary *dict14 = [[NSMutableDictionary alloc]init];
    [dict14 setObject:@"Bhutan +975" forKey:@"Value"];
    [dict14 setObject:@"25" forKey:@"ID"];
    
    NSMutableDictionary *dict15= [[NSMutableDictionary alloc]init];
    [dict15 setObject:@"Bolivia +591" forKey:@"Value"];
    [dict15 setObject:@"26" forKey:@"ID"];
    
    NSMutableDictionary *dict16 = [[NSMutableDictionary alloc]init];
    [dict16 setObject:@"Bosnia And Herzegovina +387" forKey:@"Value"];
    [dict16 setObject:@"27" forKey:@"ID"];
    
    NSMutableDictionary *dict17 = [[NSMutableDictionary alloc]init];
    [dict17 setObject:@"Botswana +267" forKey:@"Value"];
    [dict17 setObject:@"28" forKey:@"ID"];
    
    NSMutableDictionary *dict18= [[NSMutableDictionary alloc]init];
    [dict18 setObject:@"Bouvet Island +0" forKey:@"Value"];
    [dict18 setObject:@"29" forKey:@"ID"];
    
    NSMutableDictionary *dict19= [[NSMutableDictionary alloc]init];
    [dict19 setObject:@"Brazil +55" forKey:@"Value"];
    [dict19 setObject:@"30" forKey:@"ID"];
    
    NSMutableDictionary *dict20 = [[NSMutableDictionary alloc]init];
    [dict20 setObject:@"British Indian Ocean Territory +246" forKey:@"Value"];
    [dict20 setObject:@"31" forKey:@"ID"];
    
    NSMutableDictionary *dict21= [[NSMutableDictionary alloc]init];
    [dict21 setObject:@"Brunei Darussalam +673" forKey:@"Value"];
    [dict21 setObject:@"32" forKey:@"ID"];
    
    NSMutableDictionary *dict22= [[NSMutableDictionary alloc]init];
    [dict22 setObject:@"Bulgaria +359" forKey:@"Value"];
    [dict22 setObject:@"33" forKey:@"ID"];
    
    NSMutableDictionary *dict23= [[NSMutableDictionary alloc]init];
    [dict23 setObject:@"Burkina Faso +226" forKey:@"Value"];
    [dict23 setObject:@"34" forKey:@"ID"];
    
    NSMutableDictionary *dict24= [[NSMutableDictionary alloc]init];
    [dict24 setObject:@"Burundi +257" forKey:@"Value"];
    [dict24 setObject:@"35" forKey:@"ID"];
    
    NSMutableDictionary *dict25= [[NSMutableDictionary alloc]init];
    [dict25 setObject:@"Cambodia +855" forKey:@"Value"];
    [dict25 setObject:@"36" forKey:@"ID"];
    
    NSMutableDictionary *dict26 = [[NSMutableDictionary alloc]init];
    [dict26 setObject:@"Cameroon +237" forKey:@"Value"];
    [dict26 setObject:@"37" forKey:@"ID"];
    
    NSMutableDictionary *dict27= [[NSMutableDictionary alloc]init];
    [dict27 setObject:@"Canada +1" forKey:@"Value"];
    [dict27 setObject:@"38" forKey:@"ID"];
    
    NSMutableDictionary *dict28= [[NSMutableDictionary alloc]init];
    [dict28 setObject:@"Cape Verde +238" forKey:@"Value"];
    [dict28 setObject:@"39" forKey:@"ID"];
    
    NSMutableDictionary *dict29 = [[NSMutableDictionary alloc]init];
    [dict29 setObject:@"Central African Republic +236" forKey:@"Value"];
    [dict29 setObject:@"41" forKey:@"ID"];
    
    NSMutableDictionary *dictValue = [[NSMutableDictionary alloc]init];
    [dictValue setObject:@"Chad +235" forKey:@"Value"];
    [dictValue setObject:@"42" forKey:@"ID"];
    
    NSMutableDictionary *dict30 = [[NSMutableDictionary alloc]init];
    [dict30 setObject:@"Chad +235" forKey:@"Value"];
    [dict30 setObject:@"43" forKey:@"ID"];
    
    NSMutableDictionary *dict31= [[NSMutableDictionary alloc]init];
    [dict31 setObject:@"Chile +56" forKey:@"Value"];
    [dict31 setObject:@"44" forKey:@"ID"];
    
    NSMutableDictionary *dict32 = [[NSMutableDictionary alloc]init];
    [dict32 setObject:@"China +86" forKey:@"Value"];
    [dict32 setObject:@"45" forKey:@"ID"];
    
    NSMutableDictionary *dict33 = [[NSMutableDictionary alloc]init];
    [dict33 setObject:@"Christmas Island +61" forKey:@"Value"];
    [dict33 setObject:@"46" forKey:@"ID"];
    
    NSMutableDictionary *dict34= [[NSMutableDictionary alloc]init];
    [dict34 setObject:@"Cocos (Keeling) Islands +672" forKey:@"Value"];
    [dict34 setObject:@"45" forKey:@"ID"];
    
    NSMutableDictionary *dict35 = [[NSMutableDictionary alloc]init];
    [dict35 setObject:@"Colombia +57" forKey:@"Value"];
    [dict35 setObject:@"47" forKey:@"ID"];
    
    NSMutableDictionary *dict36= [[NSMutableDictionary alloc]init];
    [dict36 setObject:@"Comoros +269" forKey:@"Value"];
    [dict36 setObject:@"48" forKey:@"ID"];
    
    NSMutableDictionary *dict37= [[NSMutableDictionary alloc]init];
    [dict37 setObject:@"Congo +242" forKey:@"Value"];
    [dict37 setObject:@"49" forKey:@"ID"];
    
    NSMutableDictionary *dict38 = [[NSMutableDictionary alloc]init];
    [dict38 setObject:@"Congo, The Democratic Republic Of The +242" forKey:@"Value"];
    [dict38 setObject:@"50" forKey:@"ID"];
    
    NSMutableDictionary *dict39 = [[NSMutableDictionary alloc]init];
    [dict39 setObject:@"Cook Islands +682" forKey:@"Value"];
    [dict39 setObject:@"51" forKey:@"ID"];
    
    NSMutableDictionary *dict40= [[NSMutableDictionary alloc]init];
    [dict40 setObject:@"Costa Rica +506" forKey:@"Value"];
    [dict40 setObject:@"52" forKey:@"ID"];
    
    NSMutableDictionary *dict41 = [[NSMutableDictionary alloc]init];
    [dict41 setObject:@"Cote D'ivoire +225" forKey:@"Value"];
    [dict41 setObject:@"53" forKey:@"ID"];
    
    NSMutableDictionary *dict42 = [[NSMutableDictionary alloc]init];
    [dict42 setObject:@"Croatia +385" forKey:@"Value"];
    [dict42 setObject:@"54" forKey:@"ID"];
    
    NSMutableDictionary *dict43 = [[NSMutableDictionary alloc]init];
    [dict43 setObject:@"Cuba +53" forKey:@"Value"];
    [dict43 setObject:@"55" forKey:@"ID"];
    
    NSMutableDictionary *dict45= [[NSMutableDictionary alloc]init];
    [dict45 setObject:@"Cyprus +357" forKey:@"Value"];
    [dict45 setObject:@"56" forKey:@"ID"];
    
    NSMutableDictionary *dict46 = [[NSMutableDictionary alloc]init];
    [dict46 setObject:@"Czech Republic +420" forKey:@"Value"];
    [dict46 setObject:@"57" forKey:@"ID"];
    
    NSMutableDictionary *dict47 = [[NSMutableDictionary alloc]init];
    [dict47 setObject:@"Denmark +45" forKey:@"Value"];
    [dict47 setObject:@"58" forKey:@"ID"];
    
    NSMutableDictionary *dict48 = [[NSMutableDictionary alloc]init];
    [dict48 setObject:@"Djibouti +253" forKey:@"Value"];
    [dict48 setObject:@"59" forKey:@"ID"];
    
    NSMutableDictionary *dict49= [[NSMutableDictionary alloc]init];
    [dict49 setObject:@"Dominica +1767" forKey:@"Value"];
    [dict49 setObject:@"60" forKey:@"ID"];
    
    NSMutableDictionary *dict50 = [[NSMutableDictionary alloc]init];
    [dict50 setObject:@"Dominican Republic +1809" forKey:@"Value"];
    [dict50 setObject:@"61" forKey:@"ID"];
    
    NSMutableDictionary *dict51= [[NSMutableDictionary alloc]init];
    [dict51 setObject:@"Ecuador +593" forKey:@"Value"];
    [dict51 setObject:@"62" forKey:@"ID"];
    
    NSMutableDictionary *dict52= [[NSMutableDictionary alloc]init];
    [dict52 setObject:@"Egypt +20" forKey:@"Value"];
    [dict52 setObject:@"63" forKey:@"ID"];
    
    NSMutableDictionary *dict53= [[NSMutableDictionary alloc]init];
    [dict53 setObject:@"El Salvador +503" forKey:@"Value"];
    [dict53 setObject:@"64" forKey:@"ID"];
    
    NSMutableDictionary *dict54 = [[NSMutableDictionary alloc]init];
    [dict54 setObject:@"Equatorial Guinea +240" forKey:@"Value"];
    [dict54 setObject:@"65" forKey:@"ID"];
    
    NSMutableDictionary *dict55 = [[NSMutableDictionary alloc]init];
    [dict55 setObject:@"Eritrea +291" forKey:@"Value"];
    [dict55 setObject:@"66" forKey:@"ID"];
    
    NSMutableDictionary *dict56 = [[NSMutableDictionary alloc]init];
    [dict56 setObject:@"Estonia +372" forKey:@"Value"];
    [dict56 setObject:@"67" forKey:@"ID"];
    
    NSMutableDictionary *dict57 = [[NSMutableDictionary alloc]init];
    [dict57 setObject:@"Ethiopia +251" forKey:@"Value"];
    [dict57 setObject:@"68" forKey:@"ID"];
    
    NSMutableDictionary *dict58= [[NSMutableDictionary alloc]init];
    [dict58 setObject:@"Falkland Islands (Malvinas) +500" forKey:@"Value"];
    [dict58 setObject:@"69" forKey:@"ID"];
    
    NSMutableDictionary *dict59 = [[NSMutableDictionary alloc]init];
    [dict59 setObject:@"Faroe Islands +298" forKey:@"Value"];
    [dict59 setObject:@"70" forKey:@"ID"];
    
    NSMutableDictionary *dict60 = [[NSMutableDictionary alloc]init];
    [dict60 setObject:@"Fiji +679" forKey:@"Value"];
    [dict60 setObject:@"71" forKey:@"ID"];
    
    NSMutableDictionary *dict61= [[NSMutableDictionary alloc]init];
    [dict61 setObject:@"Finland +358" forKey:@"Value"];
    [dict61 setObject:@"72" forKey:@"ID"];
    
    NSMutableDictionary *dict62= [[NSMutableDictionary alloc]init];
    [dict62 setObject:@"France +33" forKey:@"Value"];
    [dict62 setObject:@"73" forKey:@"ID"];
    
    NSMutableDictionary *dict63 = [[NSMutableDictionary alloc]init];
    [dict63 setObject:@"French Guiana +594" forKey:@"Value"];
    [dict63 setObject:@"74" forKey:@"ID"];
    
    NSMutableDictionary *dict64= [[NSMutableDictionary alloc]init];
    [dict64 setObject:@"French Polynesia +689" forKey:@"Value"];
    [dict64 setObject:@"75" forKey:@"ID"];
    
    NSMutableDictionary *dict65= [[NSMutableDictionary alloc]init];
    [dict65 setObject:@"French Southern Territories +0" forKey:@"Value"];
    [dict65 setObject:@"76" forKey:@"ID"];
    
    NSMutableDictionary *dict66= [[NSMutableDictionary alloc]init];
    [dict66 setObject:@"Gabon +241" forKey:@"Value"];
    [dict66 setObject:@"77" forKey:@"ID"];
    
    NSMutableDictionary *dict67= [[NSMutableDictionary alloc]init];
    [dict67 setObject:@"Gambia +220" forKey:@"Value"];
    [dict67 setObject:@"78" forKey:@"ID"];
    
    NSMutableDictionary *dict68= [[NSMutableDictionary alloc]init];
    [dict68 setObject:@"Georgia +995" forKey:@"Value"];
    [dict68 setObject:@"79" forKey:@"ID"];
    
    NSMutableDictionary *dict69 = [[NSMutableDictionary alloc]init];
    [dict69 setObject:@"Germany +49" forKey:@"Value"];
    [dict69 setObject:@"80" forKey:@"ID"];
    
    NSMutableDictionary *dict70= [[NSMutableDictionary alloc]init];
    [dict70 setObject:@"Ghana +233" forKey:@"Value"];
    [dict70 setObject:@"81" forKey:@"ID"];
    
    NSMutableDictionary *dict71= [[NSMutableDictionary alloc]init];
    [dict71 setObject:@"Gibraltar +350" forKey:@"Value"];
    [dict71 setObject:@"82" forKey:@"ID"];
    
    NSMutableDictionary *dict72= [[NSMutableDictionary alloc]init];
    [dict72 setObject:@"Greece +30" forKey:@"Value"];
    [dict72 setObject:@"83" forKey:@"ID"];
    
    NSMutableDictionary *dict73 = [[NSMutableDictionary alloc]init];
    [dict73 setObject:@"Greenland +299" forKey:@"Value"];
    [dict73 setObject:@"84" forKey:@"ID"];
    
    NSMutableDictionary *dict74= [[NSMutableDictionary alloc]init];
    [dict74 setObject:@"Grenada +1473" forKey:@"Value"];
    [dict74 setObject:@"85" forKey:@"ID"];
    
    NSMutableDictionary *dict75 = [[NSMutableDictionary alloc]init];
    [dict75 setObject:@"Guadeloupe +590" forKey:@"Value"];
    [dict75 setObject:@"86" forKey:@"ID"];
    
    NSMutableDictionary *dict76 = [[NSMutableDictionary alloc]init];
    [dict76 setObject:@"Guam +1671" forKey:@"Value"];
    [dict76 setObject:@"87" forKey:@"ID"];
    
    NSMutableDictionary *dict77= [[NSMutableDictionary alloc]init];
    [dict77 setObject:@"Guatemala +502" forKey:@"Value"];
    [dict77 setObject:@"88" forKey:@"ID"];
    
    NSMutableDictionary *dict78 = [[NSMutableDictionary alloc]init];
    [dict78 setObject:@"Guinea +224" forKey:@"Value"];
    [dict78 setObject:@"89" forKey:@"ID"];
    
    NSMutableDictionary *dict79= [[NSMutableDictionary alloc]init];
    [dict79 setObject:@"Guinea-bissau +245" forKey:@"Value"];
    [dict79 setObject:@"90" forKey:@"ID"];
    
    NSMutableDictionary *dict80= [[NSMutableDictionary alloc]init];
    [dict80 setObject:@"Guyana +592" forKey:@"Value"];
    [dict80 setObject:@"91" forKey:@"ID"];
    
    NSMutableDictionary *dict81 = [[NSMutableDictionary alloc]init];
    [dict81 setObject:@"Haiti +509" forKey:@"Value"];
    [dict81 setObject:@"92" forKey:@"ID"];
    
    NSMutableDictionary *dict82 = [[NSMutableDictionary alloc]init];
    [dict82 setObject:@"Heard Island And Mcdonald Islands +0" forKey:@"Value"];
    [dict82 setObject:@"93" forKey:@"ID"];
    
    NSMutableDictionary *dict83= [[NSMutableDictionary alloc]init];
    [dict83 setObject:@"Holy See (vatican city state) +39" forKey:@"Value"];
    [dict83 setObject:@"94" forKey:@"ID"];
    
    NSMutableDictionary *dict84 = [[NSMutableDictionary alloc]init];
    [dict84 setObject:@"Honduras +504" forKey:@"Value"];
    [dict84 setObject:@"95" forKey:@"ID"];
    
    NSMutableDictionary *dict85 = [[NSMutableDictionary alloc]init];
    [dict85 setObject:@"Hong kong +852" forKey:@"Value"];
    [dict85 setObject:@"96" forKey:@"ID"];
    
    NSMutableDictionary *dict86 = [[NSMutableDictionary alloc]init];
    [dict86 setObject:@"Hungary +36" forKey:@"Value"];
    [dict86 setObject:@"97" forKey:@"ID"];
    
    NSMutableDictionary *dict87= [[NSMutableDictionary alloc]init];
    [dict87 setObject:@"Iceland +354" forKey:@"Value"];
    [dict87 setObject:@"98" forKey:@"ID"];
    
    NSMutableDictionary *dict88 = [[NSMutableDictionary alloc]init];
    [dict88 setObject:@"India +91" forKey:@"Value"];
    [dict88 setObject:@"99" forKey:@"ID"];
    
    NSMutableDictionary *dict89 = [[NSMutableDictionary alloc]init];
    [dict89 setObject:@"Indonesia +62" forKey:@"Value"];
    [dict89 setObject:@"100" forKey:@"ID"];
    
    NSMutableDictionary *dict91 = [[NSMutableDictionary alloc]init];
    [dict91 setObject:@"Iran, Islamic Republic of +98" forKey:@"Value"];
    [dict91 setObject:@"101" forKey:@"ID"];
    
    NSMutableDictionary *dict92= [[NSMutableDictionary alloc]init];
    [dict92 setObject:@"Iraq +964" forKey:@"Value"];
    [dict92 setObject:@"102" forKey:@"ID"];
    
    NSMutableDictionary *dict93= [[NSMutableDictionary alloc]init];
    [dict93 setObject:@"Ireland +353" forKey:@"Value"];
    [dict93 setObject:@"103" forKey:@"ID"];
    
    NSMutableDictionary *dict94= [[NSMutableDictionary alloc]init];
    [dict94 setObject:@"Israel +972" forKey:@"Value"];
    [dict94 setObject:@"104" forKey:@"ID"];
    
    NSMutableDictionary *dict95= [[NSMutableDictionary alloc]init];
    [dict95 setObject:@"Italy +39" forKey:@"Value"];
    [dict95 setObject:@"105" forKey:@"ID"];
    
    NSMutableDictionary *dict96= [[NSMutableDictionary alloc]init];
    [dict96 setObject:@"Jamaica +1876" forKey:@"Value"];
    [dict96 setObject:@"106" forKey:@"ID"];
    
    NSMutableDictionary *dict97 = [[NSMutableDictionary alloc]init];
    [dict97 setObject:@"Japan +81" forKey:@"Value"];
    [dict97 setObject:@"107" forKey:@"ID"];
    
    NSMutableDictionary *dict98= [[NSMutableDictionary alloc]init];
    [dict98 setObject:@"Jordan +962" forKey:@"Value"];
    [dict98 setObject:@"108" forKey:@"ID"];
    
    NSMutableDictionary *dict99 = [[NSMutableDictionary alloc]init];
    [dict99 setObject:@"Kazakhstan +7" forKey:@"Value"];
    [dict99 setObject:@"109" forKey:@"ID"];
    
    NSMutableDictionary *dict100 = [[NSMutableDictionary alloc]init];
    [dict100 setObject:@"Kenya +254" forKey:@"Value"];
    [dict100 setObject:@"110" forKey:@"ID"];
    
    NSMutableDictionary *dict101= [[NSMutableDictionary alloc]init];
    [dict101 setObject:@"Kiribati +686" forKey:@"Value"];
    [dict101 setObject:@"111" forKey:@"ID"];
    
    NSMutableDictionary *dict102 = [[NSMutableDictionary alloc]init];
    [dict102 setObject:@"Korea, Democratic People's Republic Of +850" forKey:@"Value"];
    [dict102 setObject:@"112" forKey:@"ID"];
    
    NSMutableDictionary *dict103 = [[NSMutableDictionary alloc]init];
    [dict103 setObject:@"Korea, Republic Of +82" forKey:@"Value"];
    [dict103 setObject:@"113" forKey:@"ID"];
    
    NSMutableDictionary *dict104= [[NSMutableDictionary alloc]init];
    [dict104 setObject:@"Kuwait +965" forKey:@"Value"];
    [dict104 setObject:@"114" forKey:@"ID"];
    
    NSMutableDictionary *dict105= [[NSMutableDictionary alloc]init];
    [dict105 setObject:@"Kyrgyzstan +996" forKey:@"Value"];
    [dict105 setObject:@"115" forKey:@"ID"];
    
    NSMutableDictionary *dict106 = [[NSMutableDictionary alloc]init];
    [dict106 setObject:@"Lao People's Democratic Republic +856" forKey:@"Value"];
    [dict106 setObject:@"116" forKey:@"ID"];
    
    NSMutableDictionary *dict107= [[NSMutableDictionary alloc]init];
    [dict107 setObject:@"Latvia +371" forKey:@"Value"];
    [dict107 setObject:@"117" forKey:@"ID"];
    
    NSMutableDictionary *dict108 = [[NSMutableDictionary alloc]init];
    [dict108 setObject:@"Lebanon +961" forKey:@"Value"];
    [dict108 setObject:@"118" forKey:@"ID"];
    
    NSMutableDictionary *dict109= [[NSMutableDictionary alloc]init];
    [dict109 setObject:@"Lesotho +266" forKey:@"Value"];
    [dict109 setObject:@"119" forKey:@"ID"];
    
    NSMutableDictionary *dict110= [[NSMutableDictionary alloc]init];
    [dict110 setObject:@"Liberia +231" forKey:@"Value"];
    [dict110 setObject:@"120" forKey:@"ID"];
    
    NSMutableDictionary *dict111= [[NSMutableDictionary alloc]init];
    [dict111 setObject:@"Libyan Arab Jamahiriya +218" forKey:@"Value"];
    [dict111 setObject:@"121" forKey:@"ID"];
    
    NSMutableDictionary *dict112 = [[NSMutableDictionary alloc]init];
    [dict112 setObject:@"Liechtenstein +423" forKey:@"Value"];
    [dict112 setObject:@"122" forKey:@"ID"];
    
    NSMutableDictionary *dict113= [[NSMutableDictionary alloc]init];
    [dict113 setObject:@"Lithuania +370" forKey:@"Value"];
    [dict113 setObject:@"123" forKey:@"ID"];
    
    NSMutableDictionary *dict114= [[NSMutableDictionary alloc]init];
    [dict114 setObject:@"Luxembourg +352" forKey:@"Value"];
    [dict114 setObject:@"124" forKey:@"ID"];
    
    NSMutableDictionary *dict115 = [[NSMutableDictionary alloc]init];
    [dict115 setObject:@"Macao +853" forKey:@"Value"];
    [dict115 setObject:@"125" forKey:@"ID"];
    
    NSMutableDictionary *dict116 = [[NSMutableDictionary alloc]init];
    [dict116 setObject:@"Macedonia, The Former Yugoslav Republic Of +389" forKey:@"Value"];
    [dict116 setObject:@"126" forKey:@"ID"];
    
    NSMutableDictionary *dict117= [[NSMutableDictionary alloc]init];
    [dict117 setObject:@"Madagascar +261" forKey:@"Value"];
    [dict117 setObject:@"127" forKey:@"ID"];
    
    NSMutableDictionary *dict118 = [[NSMutableDictionary alloc]init];
    [dict118 setObject:@"Malawi +265" forKey:@"Value"];
    [dict118 setObject:@"128" forKey:@"ID"];
    
    NSMutableDictionary *dict119 = [[NSMutableDictionary alloc]init];
    [dict119 setObject:@"Malaysia +60" forKey:@"Value"];
    [dict119 setObject:@"129" forKey:@"ID"];
    
    NSMutableDictionary *dict120= [[NSMutableDictionary alloc]init];
    [dict120 setObject:@"Maldives +960" forKey:@"Value"];
    [dict120 setObject:@"130" forKey:@"ID"];
    
    NSMutableDictionary *dict121 = [[NSMutableDictionary alloc]init];
    [dict121 setObject:@"Mali +223" forKey:@"Value"];
    [dict121 setObject:@"131" forKey:@"ID"];
    
    NSMutableDictionary *dict122= [[NSMutableDictionary alloc]init];
    [dict122 setObject:@"Malta +356" forKey:@"Value"];
    [dict122 setObject:@"132" forKey:@"ID"];
    
    NSMutableDictionary *dict123= [[NSMutableDictionary alloc]init];
    [dict123 setObject:@"Marshall Islands +692" forKey:@"Value"];
    [dict123 setObject:@"133" forKey:@"ID"];
    
    NSMutableDictionary *dict124= [[NSMutableDictionary alloc]init];
    [dict124 setObject:@"Martinique +596" forKey:@"Value"];
    [dict124 setObject:@"134" forKey:@"ID"];
    
    NSMutableDictionary *dict125 = [[NSMutableDictionary alloc]init];
    [dict125 setObject:@"Mauritania +222" forKey:@"Value"];
    [dict125 setObject:@"135" forKey:@"ID"];
    
    NSMutableDictionary *dict126= [[NSMutableDictionary alloc]init];
    [dict126 setObject:@"Mauritius +230" forKey:@"Value"];
    [dict126 setObject:@"136" forKey:@"ID"];
    
    NSMutableDictionary *dict127 = [[NSMutableDictionary alloc]init];
    [dict127 setObject:@"Mayotte +269" forKey:@"Value"];
    [dict127 setObject:@"137" forKey:@"ID"];
    
    NSMutableDictionary *dict128 = [[NSMutableDictionary alloc]init];
    [dict128 setObject:@"Mexico +52" forKey:@"Value"];
    [dict128 setObject:@"138" forKey:@"ID"];
    
    NSMutableDictionary *dict129 = [[NSMutableDictionary alloc]init];
    [dict129 setObject:@"Micronesia, Federated States Of +691" forKey:@"Value"];
    [dict129 setObject:@"139" forKey:@"ID"];
    
    NSMutableDictionary *dict130= [[NSMutableDictionary alloc]init];
    [dict130 setObject:@"Moldova, Republic Of +373" forKey:@"Value"];
    [dict130 setObject:@"140" forKey:@"ID"];
    
    NSMutableDictionary *dict131 = [[NSMutableDictionary alloc]init];
    [dict131 setObject:@"Monaco +377" forKey:@"Value"];
    [dict131 setObject:@"141" forKey:@"ID"];
    
    NSMutableDictionary *dict132 = [[NSMutableDictionary alloc]init];
    [dict132 setObject:@"Mongolia +976" forKey:@"Value"];
    [dict132 setObject:@"142" forKey:@"ID"];
    
    NSMutableDictionary *dict133 = [[NSMutableDictionary alloc]init];
    [dict133 setObject:@"Montserrat +1664" forKey:@"Value"];
    [dict133 setObject:@"143" forKey:@"ID"];
    
    NSMutableDictionary *dict134= [[NSMutableDictionary alloc]init];
    [dict134 setObject:@"Morocco +212" forKey:@"Value"];
    [dict134 setObject:@"144" forKey:@"ID"];
    
    NSMutableDictionary *dict135 = [[NSMutableDictionary alloc]init];
    [dict135 setObject:@"Mozambique +258" forKey:@"Value"];
    [dict135 setObject:@"145" forKey:@"ID"];
    
    NSMutableDictionary *dict136= [[NSMutableDictionary alloc]init];
    [dict136 setObject:@"Myanmar +95" forKey:@"Value"];
    [dict136 setObject:@"146" forKey:@"ID"];
    
    NSMutableDictionary *dict137= [[NSMutableDictionary alloc]init];
    [dict137 setObject:@"Namibia +264" forKey:@"Value"];
    [dict137 setObject:@"147" forKey:@"ID"];
    
    NSMutableDictionary *dict138   = [[NSMutableDictionary alloc]init];
    [dict138 setObject:@"Nauru +674" forKey:@"Value"];
    [dict138 setObject:@"148" forKey:@"ID"];
    
    NSMutableDictionary *dict139 = [[NSMutableDictionary alloc]init];
    [dict139 setObject:@"Nepal +977" forKey:@"Value"];
    [dict139 setObject:@"149" forKey:@"ID"];
    
    NSMutableDictionary *dict140= [[NSMutableDictionary alloc]init];
    [dict140 setObject:@"Netherlands +31" forKey:@"Value"];
    [dict140 setObject:@"150" forKey:@"ID"];
    
    NSMutableDictionary *dict141 = [[NSMutableDictionary alloc]init];
    [dict141 setObject:@"Netherlands Antilles +599" forKey:@"Value"];
    [dict141 setObject:@"151" forKey:@"ID"];
    
    NSMutableDictionary *dict142 = [[NSMutableDictionary alloc]init];
    [dict142 setObject:@"New Caledonia +687" forKey:@"Value"];
    [dict142 setObject:@"152" forKey:@"ID"];
    
    NSMutableDictionary *dict143= [[NSMutableDictionary alloc]init];
    [dict143 setObject:@"New Zealand +64" forKey:@"Value"];
    [dict143 setObject:@"153" forKey:@"ID"];
    
    NSMutableDictionary *dict144 = [[NSMutableDictionary alloc]init];
    [dict144 setObject:@"Nicaragua +505" forKey:@"Value"];
    [dict144 setObject:@"154" forKey:@"ID"];
    
    NSMutableDictionary *dict145 = [[NSMutableDictionary alloc]init];
    [dict145 setObject:@"Niger +227" forKey:@"Value"];
    [dict145 setObject:@"155" forKey:@"ID"];
    
    NSMutableDictionary *dict146= [[NSMutableDictionary alloc]init];
    [dict146 setObject:@"Nigeria +234" forKey:@"Value"];
    [dict146 setObject:@"156" forKey:@"ID"];
    
    NSMutableDictionary *dict147= [[NSMutableDictionary alloc]init];
    [dict147 setObject:@"Niue +683" forKey:@"Value"];
    [dict147 setObject:@"157" forKey:@"ID"];
    
    NSMutableDictionary *dict148 = [[NSMutableDictionary alloc]init];
    [dict148 setObject:@"Norfolk Island +672" forKey:@"Value"];
    [dict148 setObject:@"158" forKey:@"ID"];
    
    NSMutableDictionary *dict149= [[NSMutableDictionary alloc]init];
    [dict149 setObject:@"Northern Mariana Islands +1670" forKey:@"Value"];
    [dict149 setObject:@"159" forKey:@"ID"];
    
    NSMutableDictionary *dict150= [[NSMutableDictionary alloc]init];
    [dict150 setObject:@"Norway +47" forKey:@"Value"];
    [dict150 setObject:@"160" forKey:@"ID"];
    
    NSMutableDictionary *dict151= [[NSMutableDictionary alloc]init];
    [dict151 setObject:@"Oman +968" forKey:@"Value"];
    [dict151 setObject:@"161" forKey:@"ID"];
    
    NSMutableDictionary *dict152= [[NSMutableDictionary alloc]init];
    [dict152 setObject:@"Pakistan +92" forKey:@"Value"];
    [dict152 setObject:@"162" forKey:@"ID"];
    
    NSMutableDictionary *dict153= [[NSMutableDictionary alloc]init];
    [dict153 setObject:@"Palau +680" forKey:@"Value"];
    [dict153 setObject:@"163" forKey:@"ID"];
    
    NSMutableDictionary *dict154 = [[NSMutableDictionary alloc]init];
    [dict154 setObject:@"Palestinian Territory, Occupied +970" forKey:@"Value"];
    [dict154 setObject:@"164" forKey:@"ID"];
    
    NSMutableDictionary *dict155= [[NSMutableDictionary alloc]init];
    [dict155 setObject:@"Panama +507" forKey:@"Value"];
    [dict155 setObject:@"165" forKey:@"ID"];
    
    NSMutableDictionary *dict156= [[NSMutableDictionary alloc]init];
    [dict156 setObject:@"Papua New Guinea +675" forKey:@"Value"];
    [dict156 setObject:@"166" forKey:@"ID"];
    
    NSMutableDictionary *dict157 = [[NSMutableDictionary alloc]init];
    [dict157 setObject:@"Paraguay +595" forKey:@"Value"];
    [dict157 setObject:@"167" forKey:@"ID"];
    
    NSMutableDictionary *dict158 = [[NSMutableDictionary alloc]init];
    [dict158 setObject:@"Peru +51" forKey:@"Value"];
    [dict158 setObject:@"168" forKey:@"ID"];
    
    NSMutableDictionary *dict159= [[NSMutableDictionary alloc]init];
    [dict159 setObject:@"Philippines +63" forKey:@"Value"];
    [dict159 setObject:@"169" forKey:@"ID"];
    
    NSMutableDictionary *dict160 = [[NSMutableDictionary alloc]init];
    [dict160 setObject:@"Pitcairn +0" forKey:@"Value"];
    [dict160 setObject:@"170" forKey:@"ID"];
    
    NSMutableDictionary *dict161 = [[NSMutableDictionary alloc]init];
    [dict161 setObject:@"Poland +48" forKey:@"Value"];
    [dict161 setObject:@"171" forKey:@"ID"];
    
    NSMutableDictionary *dict162= [[NSMutableDictionary alloc]init];
    [dict162 setObject:@"Portugal +351" forKey:@"Value"];
    [dict162 setObject:@"172" forKey:@"ID"];
    
    NSMutableDictionary *dict163 = [[NSMutableDictionary alloc]init];
    [dict163 setObject:@"Puerto Rico +1787" forKey:@"Value"];
    [dict163 setObject:@"173" forKey:@"ID"];
    
    NSMutableDictionary *dict164= [[NSMutableDictionary alloc]init];
    [dict164 setObject:@"Qatar +974" forKey:@"Value"];
    [dict164 setObject:@"174" forKey:@"ID"];
    
    NSMutableDictionary *dict165= [[NSMutableDictionary alloc]init];
    [dict165 setObject:@"Reunion +262" forKey:@"Value"];
    [dict165 setObject:@"175" forKey:@"ID"];
    
    NSMutableDictionary *dict166 = [[NSMutableDictionary alloc]init];
    [dict166 setObject:@"Romania +40" forKey:@"Value"];
    [dict166 setObject:@"176" forKey:@"ID"];
    
    NSMutableDictionary *dict167 = [[NSMutableDictionary alloc]init];
    [dict167 setObject:@"Russian Federation +70" forKey:@"Value"];
    [dict167 setObject:@"177" forKey:@"ID"];
    
    NSMutableDictionary *dict168= [[NSMutableDictionary alloc]init];
    [dict168 setObject:@"Rwanda +250" forKey:@"Value"];
    [dict168 setObject:@"178" forKey:@"ID"];
    
    NSMutableDictionary *dict169 = [[NSMutableDictionary alloc]init];
    [dict169 setObject:@"Saint Helena +290" forKey:@"Value"];
    [dict169 setObject:@"179" forKey:@"ID"];
    
    NSMutableDictionary *dict170 = [[NSMutableDictionary alloc]init];
    [dict170 setObject:@"Saint Kitts And Nevis +1869" forKey:@"Value"];
    [dict170 setObject:@"180" forKey:@"ID"];
    
    NSMutableDictionary *dict171 = [[NSMutableDictionary alloc]init];
    [dict171 setObject:@"Saint Lucia +1758" forKey:@"Value"];
    [dict171 setObject:@"181" forKey:@"ID"];
    
    NSMutableDictionary *dict172 = [[NSMutableDictionary alloc]init];
    [dict172 setObject:@"Saint Pierre And Miquelon +508" forKey:@"Value"];
    [dict172 setObject:@"182" forKey:@"ID"];
    
    NSMutableDictionary *dict173 = [[NSMutableDictionary alloc]init];
    [dict173 setObject:@"Saint Vincent And The Grenadines +1784" forKey:@"Value"];
    [dict173 setObject:@"183" forKey:@"ID"];
    
    NSMutableDictionary *dict174 = [[NSMutableDictionary alloc]init];
    [dict174 setObject:@"Samoa +684" forKey:@"Value"];
    [dict174 setObject:@"184" forKey:@"ID"];
    
    NSMutableDictionary *dict175 = [[NSMutableDictionary alloc]init];
    [dict175 setObject:@"San Marino +378" forKey:@"Value"];
    [dict175 setObject:@"185" forKey:@"ID"];
    
    NSMutableDictionary *dict176= [[NSMutableDictionary alloc]init];
    [dict176 setObject:@"Sao Tome And Principe +239" forKey:@"Value"];
    [dict176 setObject:@"186" forKey:@"ID"];
    
    NSMutableDictionary *dict177 = [[NSMutableDictionary alloc]init];
    [dict177 setObject:@"Saudi Arabia +966" forKey:@"Value"];
    [dict177 setObject:@"187" forKey:@"ID"];
    
    NSMutableDictionary *dict178= [[NSMutableDictionary alloc]init];
    [dict178 setObject:@"Senegal +221" forKey:@"Value"];
    [dict178 setObject:@"188" forKey:@"ID"];
    
    NSMutableDictionary *dict179= [[NSMutableDictionary alloc]init];
    [dict179 setObject:@"Serbia And Montenegro +381" forKey:@"Value"];
    [dict179 setObject:@"189" forKey:@"ID"];
    
    NSMutableDictionary *dict180= [[NSMutableDictionary alloc]init];
    [dict180 setObject:@"Seychelles +248" forKey:@"Value"];
    [dict180 setObject:@"190" forKey:@"ID"];
    
    NSMutableDictionary *dict181 = [[NSMutableDictionary alloc]init];
    [dict181 setObject:@"Sierra Leone +232" forKey:@"Value"];
    [dict181 setObject:@"191" forKey:@"ID"];
    
    NSMutableDictionary *dict182= [[NSMutableDictionary alloc]init];
    [dict182 setObject:@"Singapore +65" forKey:@"Value"];
    [dict182 setObject:@"192" forKey:@"ID"];
    
    NSMutableDictionary *dict183 = [[NSMutableDictionary alloc]init];
    [dict183 setObject:@"Slovakia +421" forKey:@"Value"];
    [dict183 setObject:@"193" forKey:@"ID"];
    
    NSMutableDictionary *dict184 = [[NSMutableDictionary alloc]init];
    [dict184 setObject:@"Slovenia +386" forKey:@"Value"];
    [dict184 setObject:@"194" forKey:@"ID"];
    
    NSMutableDictionary *dict185= [[NSMutableDictionary alloc]init];
    [dict185 setObject:@"Solomon Islands +677" forKey:@"Value"];
    [dict185 setObject:@"195" forKey:@"ID"];
    
    NSMutableDictionary *dict186 = [[NSMutableDictionary alloc]init];
    [dict186 setObject:@"Somalia +252" forKey:@"Value"];
    [dict186 setObject:@"196" forKey:@"ID"];
    
    NSMutableDictionary *dict187 = [[NSMutableDictionary alloc]init];
    [dict187 setObject:@"South Africa +27" forKey:@"Value"];
    [dict187 setObject:@"197" forKey:@"ID"];
    
    NSMutableDictionary *dict188= [[NSMutableDictionary alloc]init];
    [dict188 setObject:@"South Georgia And The South Sandwich Islands +0" forKey:@"Value"];
    [dict188 setObject:@"198" forKey:@"ID"];
    
    NSMutableDictionary *dict189= [[NSMutableDictionary alloc]init];
    [dict189 setObject:@"Spain +34" forKey:@"Value"];
    [dict189 setObject:@"199" forKey:@"ID"];
    
    NSMutableDictionary *dict190 = [[NSMutableDictionary alloc]init];
    [dict190 setObject:@"Sri Lanka +94" forKey:@"Value"];
    [dict190 setObject:@"200" forKey:@"ID"];
    
    NSMutableDictionary *dict191= [[NSMutableDictionary alloc]init];
    [dict191 setObject:@"Sudan +249" forKey:@"Value"];
    [dict191 setObject:@"201" forKey:@"ID"];
    
    NSMutableDictionary *dict192= [[NSMutableDictionary alloc]init];
    [dict192 setObject:@"Suriname +597" forKey:@"Value"];
    [dict192 setObject:@"202" forKey:@"ID"];
    
    NSMutableDictionary *dict193= [[NSMutableDictionary alloc]init];
    [dict193 setObject:@"Svalbard And Jan Mayen +47" forKey:@"Value"];
    [dict193 setObject:@"203" forKey:@"ID"];
    
    NSMutableDictionary *dict194= [[NSMutableDictionary alloc]init];
    [dict194 setObject:@"Swaziland +268" forKey:@"Value"];
    [dict194 setObject:@"204" forKey:@"ID"];
    
    NSMutableDictionary *dict195= [[NSMutableDictionary alloc]init];
    [dict195 setObject:@"Sweden +46" forKey:@"Value"];
    [dict195 setObject:@"205" forKey:@"ID"];
    
    NSMutableDictionary *dict196 = [[NSMutableDictionary alloc]init];
    [dict196 setObject:@"Switzerland +41" forKey:@"Value"];
    [dict196 setObject:@"206" forKey:@"ID"];
    
    NSMutableDictionary *dict197= [[NSMutableDictionary alloc]init];
    [dict197 setObject:@"Syrian Arab Republic +963" forKey:@"Value"];
    [dict197 setObject:@"207" forKey:@"ID"];
    
    NSMutableDictionary *dict198= [[NSMutableDictionary alloc]init];
    [dict198 setObject:@"Taiwan, Province Of China +886" forKey:@"Value"];
    [dict198 setObject:@"208" forKey:@"ID"];
    
    NSMutableDictionary *dict199 = [[NSMutableDictionary alloc]init];
    [dict199 setObject:@"Tajikistan +992" forKey:@"Value"];
    [dict199 setObject:@"209" forKey:@"ID"];
    
    NSMutableDictionary *dict200 = [[NSMutableDictionary alloc]init];
    [dict200 setObject:@"Tanzania, United Republic Of +255" forKey:@"Value"];
    [dict200 setObject:@"210" forKey:@"ID"];
    
    NSMutableDictionary *dict201= [[NSMutableDictionary alloc]init];
    [dict201 setObject:@"Thailand +66" forKey:@"Value"];
    [dict201 setObject:@"211" forKey:@"ID"];
    
    NSMutableDictionary *dict202 = [[NSMutableDictionary alloc]init];
    [dict202 setObject:@"Timor-leste +670" forKey:@"Value"];
    [dict202 setObject:@"212" forKey:@"ID"];
    
    NSMutableDictionary *dict203 = [[NSMutableDictionary alloc]init];
    [dict203 setObject:@"Togo +228" forKey:@"Value"];
    [dict203 setObject:@"213" forKey:@"ID"];
    
    NSMutableDictionary *dict204= [[NSMutableDictionary alloc]init];
    [dict204 setObject:@"Tokelau +690" forKey:@"Value"];
    [dict204 setObject:@"214" forKey:@"ID"];
    
    NSMutableDictionary *dict205 = [[NSMutableDictionary alloc]init];
    [dict205 setObject:@"Tonga +676" forKey:@"Value"];
    [dict205 setObject:@"215" forKey:@"ID"];
    
    NSMutableDictionary *dict206= [[NSMutableDictionary alloc]init];
    [dict206 setObject:@"Trinidad And Tobago +1868" forKey:@"Value"];
    [dict206 setObject:@"216" forKey:@"ID"];
    
    NSMutableDictionary *dict207= [[NSMutableDictionary alloc]init];
    [dict207 setObject:@"Tunisia +216" forKey:@"Value"];
    [dict207 setObject:@"217" forKey:@"ID"];
    
    NSMutableDictionary *dict208 = [[NSMutableDictionary alloc]init];
    [dict208 setObject:@"Turkey +90" forKey:@"Value"];
    [dict208 setObject:@"218" forKey:@"ID"];
    
    NSMutableDictionary *dict209 = [[NSMutableDictionary alloc]init];
    [dict209 setObject:@"Turkmenistan +7370" forKey:@"Value"];
    [dict209 setObject:@"219" forKey:@"ID"];
    
    NSMutableDictionary *dict210= [[NSMutableDictionary alloc]init];
    [dict210 setObject:@"Turks And Caicos Islands +1649" forKey:@"Value"];
    [dict210 setObject:@"220" forKey:@"ID"];
    
    NSMutableDictionary *dict211 = [[NSMutableDictionary alloc]init];
    [dict211 setObject:@"Tuvalu +688" forKey:@"Value"];
    [dict211 setObject:@"221" forKey:@"ID"];
    
    NSMutableDictionary *dict212 = [[NSMutableDictionary alloc]init];
    [dict212 setObject:@"Uganda +256" forKey:@"Value"];
    [dict212 setObject:@"222" forKey:@"ID"];
    
    NSMutableDictionary *dict213 = [[NSMutableDictionary alloc]init];
    [dict213 setObject:@"Ukraine +380" forKey:@"Value"];
    [dict213 setObject:@"223" forKey:@"ID"];
    
    NSMutableDictionary *dict214= [[NSMutableDictionary alloc]init];
    [dict214 setObject:@"United Arab Emirates +971" forKey:@"Value"];
    [dict214 setObject:@"224" forKey:@"ID"];
    
    NSMutableDictionary *dict215 = [[NSMutableDictionary alloc]init];
    [dict215 setObject:@"United Kingdom +44" forKey:@"Value"];
    [dict215 setObject:@"225" forKey:@"ID"];
    
    NSMutableDictionary *dict216 = [[NSMutableDictionary alloc]init];
    [dict216 setObject:@"United States +1" forKey:@"Value"];
    [dict216 setObject:@"226" forKey:@"ID"];
    
    NSMutableDictionary *dict217 = [[NSMutableDictionary alloc]init];
    [dict217 setObject:@"United States Minor Outlying Islands +1" forKey:@"Value"];
    [dict217 setObject:@"227" forKey:@"ID"];
    
    NSMutableDictionary *dict218= [[NSMutableDictionary alloc]init];
    [dict218 setObject:@"Uruguay +598" forKey:@"Value"];
    [dict218 setObject:@"228" forKey:@"ID"];
    
    NSMutableDictionary *dict219 = [[NSMutableDictionary alloc]init];
    [dict219 setObject:@"Uzbekistan +998" forKey:@"Value"];
    [dict219 setObject:@"229" forKey:@"ID"];
    
    NSMutableDictionary *dict220= [[NSMutableDictionary alloc]init];
    [dict220 setObject:@"Vanuatu +678" forKey:@"Value"];
    [dict220 setObject:@"230" forKey:@"ID"];
    
    NSMutableDictionary *dict221= [[NSMutableDictionary alloc]init];
    [dict221 setObject:@"Venezuela +58" forKey:@"Value"];
    [dict221 setObject:@"231" forKey:@"ID"];
    
    NSMutableDictionary *dict222= [[NSMutableDictionary alloc]init];
    [dict222 setObject:@"Viet Nam +84" forKey:@"Value"];
    [dict222 setObject:@"232" forKey:@"ID"];
    
    NSMutableDictionary *dict223 = [[NSMutableDictionary alloc]init];
    [dict223 setObject:@"Virgin Islands, British +1284" forKey:@"Value"];
    [dict223 setObject:@"233" forKey:@"ID"];
    
    NSMutableDictionary *dict224= [[NSMutableDictionary alloc]init];
    [dict224 setObject:@"Virgin Islands, U.S. +1340" forKey:@"Value"];
    [dict224 setObject:@"234" forKey:@"ID"];
    
    NSMutableDictionary *dict225 = [[NSMutableDictionary alloc]init];
    [dict225 setObject:@"Wallis And Futuna +681" forKey:@"Value"];
    [dict225 setObject:@"235" forKey:@"ID"];
    
    NSMutableDictionary *dict226= [[NSMutableDictionary alloc]init];
    [dict226 setObject:@"Western Sahara +212" forKey:@"Value"];
    [dict226 setObject:@"236" forKey:@"ID"];
    
    NSMutableDictionary *dict227= [[NSMutableDictionary alloc]init];
    [dict227 setObject:@"Yemen +967" forKey:@"Value"];
    [dict227 setObject:@"237" forKey:@"ID"];
    
    NSMutableDictionary *dict228 = [[NSMutableDictionary alloc]init];
    [dict228 setObject:@"Zambia +260" forKey:@"Value"];
    [dict228 setObject:@"238" forKey:@"ID"];
    
    NSMutableDictionary *dict229 = [[NSMutableDictionary alloc]init];
    [dict229 setObject:@"Zimbabwe +263" forKey:@"Value"];
    [dict229 setObject:@"239" forKey:@"ID"];
    
    arrayOfParseCountry = [[NSMutableArray alloc]initWithObjects:englanguageDict,spanlanguageDict,frenchlanguageDict,dutchlanguageDict,chineselanguageDict,italianlanguageDict,portugeselanguageDict,japaneselanguageDict,koreanlanguageDict,russianlanguageDict,nederlandslanguageDict,dict1,dict2,dict3,dict4,dict5,dict6,dict7,dict8,dict9,dict10,dict11,dict12,dict13,dict14,dict15,dict16,dict17,dict18,dict19,dict20,dict21,dict22,dict23,dict24,dict25,dict26,dict27,dict28,dict29,dictValue,dict30,dict31,dict32,dict33,dict34,dict35,dict36,dict37,dict38,dict39,dict40,dict41,dict42,dict43,dict144,dict45,dict46,dict47,dict48,dict49,dict50,dict51,dict52,dict53,dict54,dict55,dict56,dict57,dict58,dict59,dict60,dict61,dict62,dict63,dict64,dict65,dict66,dict67,dict68,dict69,dict70,dict71,dict72,dict73,dict74,dict75,dict76,dict77,dict78,dict79,dict80,dict81,dict82,dict83,dict84,dict85,dict86,dict87,dict88,dict89,dict91,dict92,dict93,dict94,dict95,dict96,dict97,dict98,dict99,dict100,dict101,dict102,dict103
                           ,dict104,dict105,dict106,dict107,dict108,dict109,dict110,dict111,dict112,dict113,dict114,dict115,dict116,dict116,dict117,dict118,dict119,dict120,dict121,dict122,dict123,dict124,dict125,dict126,dict127,dict128,dict129,dict130,dict131,dict132,dict133,dict134,dict135,dict136,dict137,dict138,dict139,dict140,dict141,dict141,dict142,dict143,dict144,dict145,dict146,dict147,dict148,dict149,dict150,dict151,dict152,dict153,dict154,dict155,dict156,dict157,dict158,dict159,dict160,dict161,dict162,dict163,dict164,dict165,dict166,dict167,dict168,dict169,dict170,dict172,dict173,dict174,dict175,dict176,dict177,dict178,dict179,dict180,dict181,dict182,dict183,dict184,dict185,dict186,dict187,dict188,dict189,dict190,dict191,dict192,dict193,dict194,dict195,dict196,dict197,dict198,dict199,dict200,dict201,dict202,dict203,dict204,dict205,dict206,dict207,dict208,dict209,dict210,dict211,dict212,dict213,dict214,dict215,dict216,dict217,dict218,dict219,dict220,dict221,dict222,dict223,dict224,dict225,dict226,dict227,dict228,dict229,nil];
    
    
    [arrayOfCountry addObjectsFromArray:[CountryCodeSuggestion getSearchInfoFromDict:arrayOfParseCountry]];
    NSLog(@"Country Array %lu",(unsigned long)arrayOfCountry.count);
    
}

@end
