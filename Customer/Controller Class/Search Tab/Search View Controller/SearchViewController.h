
//  SearchViewController.h
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import "LCTabBarCONST.h"
#import "LCTabBarController.h"
@interface SearchViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NSURLConnectionDelegate,UIGestureRecognizerDelegate> {
    
    NSString *checkOnlineStr;
    
   IBOutlet UICollectionView *doumeeCollectionView;
    NSMutableData *responceData;
    NSMutableArray *imageDataArray;
    NSMutableDictionary *dictionaryForDoumeerateCard;
    NSMutableDictionary *dictForTable;
    NSMutableDictionary *dictForTypeDataValue;
    NSMutableDictionary *dictForBodyTypeDataValue;
    NSMutableDictionary *dictForEthnicityValue;
    NSMutableDictionary *dictForEyeColorValue;
    NSMutableDictionary *dictForHairValue;
    NSMutableDictionary *dictForSmokingValue;
    NSMutableDictionary *dictForDrinkingValue;
    NSMutableDictionary *dictForEducationValue;
    NSMutableDictionary *dictForLanguageValue;
    NSMutableDictionary *dictForWeightValue;
    NSMutableDictionary *dictForHeightValue;
    IBOutlet UISegmentedControl *availableNearbySegmentedControl;
    IBOutlet UILabel *numberOfUsersLabel;
    IBOutlet UIImageView *searchImageView;
    IBOutlet UILabel *doumeeNotAvailableNowLabel;
    IBOutlet UILabel *noResultFoundLabel;
    
}

@property (strong, nonatomic) IBOutlet UIButton *requestNowBtn;
@property (strong, nonatomic) IBOutlet UIButton *reserveHerBtn;

- (IBAction)filterBtnClicked:(id)sender;
- (IBAction)requestNowBtnClicked:(id)sender;
- (IBAction)reserveHerBtnClicked:(id)sender;
- (IBAction)refreshSearchBtnClicked:(id)sender;



//- (IBAction)doumeePriceButtonClicked:(id)sender;
- (IBAction)currentHistorySegmentControlBtnClicked:(UISegmentedControl *)currentHistoryControl;

@end
