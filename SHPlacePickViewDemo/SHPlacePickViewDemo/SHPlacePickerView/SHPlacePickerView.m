//
//  SHPlacePickerView.m
//  SHPlacePickViewDemo
//
//  Created by HarrySun on 2017/3/31.
//  Copyright © 2017年 Mobby. All rights reserved.
//

#import "SHPlacePickerView.h"
#import "PlaceModel.h"

@interface SHPlacePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>


@property (nonatomic, strong) NSMutableArray *dataArray;                // 存放model的数据数组
@property (nonatomic, strong) UIPickerView *pickerView;                 // pickerView
@property (nonatomic, strong) UIView *toolView;                         // 工具视图


// 存储索引数据
@property (nonatomic, strong) NSArray *selectedProvinceArray;
@property (nonatomic, strong) NSMutableArray *selectedCityArray;
@property (nonatomic, strong) NSMutableArray *selectedDistrictArray;
@property (nonatomic, strong) NSArray *saveArray;                       // 存储选中地区索引数组
@property (nonatomic, strong) NSArray *selectArray;                     // 存储选中地区数组
@property (nonatomic, strong) NSString *selectedProvince;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) NSString *selectedDistrict;


@end

@implementation SHPlacePickerView


- (instancetype)initWithIsRecordLocation:(BOOL)isrecordLocation SendPlaceArray:(SendPlaceArray)sendPlaceArray{
    
    self.sendPlaceArray = sendPlaceArray;
    self.isRecordLocation = isrecordLocation;
    
    self = [self init];
    
    if (self.isRecordLocation) {
        
        // 跳到上次选中位置
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"saveArray"]) {
            
            NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveArray"];
            [_pickerView selectRow:[array[0] integerValue] inComponent:0 animated:YES];
            [_pickerView selectRow:[array[1] integerValue] inComponent:1 animated:YES];
            [_pickerView selectRow:[array[2] integerValue] inComponent:2 animated:YES];
        }else{
            
            [_pickerView selectRow:0 inComponent:0 animated:YES];
        }
    }
    return self;
}



- (instancetype)init{
    
    self = [super initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 250, [UIScreen mainScreen].bounds.size.width, 250)];
    if (self) {
        
        [self loadData];
        [self drawView];
    }
    return self;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    [self getSelectedArray];
    
    switch (component) {
        case 0:
            return self.dataArray.count;
            break;
        case 1:
            return self.selectedCityArray.count;
            break;
        case 2:
            return self.selectedDistrictArray.count;
            break;
        default:
            return 0;
            break;
    }
}


#pragma mark - UIPickerViewDelegate
// 自定义行
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    [self getSelectedArray];
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // pickerLabel.adjustsFontSizeToFitWidth = YES;  // 是否根据宽度适应文字大小
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:17]];
    }
    
    NSString *text;
    
    switch (component) {
        case 0:
            text = self.selectedProvinceArray[row];
            break;
        case 1:
            text = self.selectedCityArray[row];
            break;
        case 2:
            text = self.selectedDistrictArray[row];
            break;
        default:
            text = @"";
            break;
    }
    pickerLabel.text = text;
    
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    switch (component) {
        case 0:{
            self.selectedProvince = self.selectedProvinceArray[row];
            self.selectedCity = [self.dataArray[row] cityArray][0];
            self.selectedDistrict = [self.dataArray[row] districtArray][0][0];
            [self getSelectedArray];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
        }
            break;
        case 1:{
            NSInteger provinceIndex = [self.selectedProvinceArray indexOfObject:self.selectedProvince];
            self.selectedCity = [self.dataArray[provinceIndex] cityArray][row];
            self.selectedDistrict = [self.dataArray[provinceIndex] districtArray][row][0];
            [self getSelectedArray];
            [pickerView reloadComponent:2];
        }
            break;
        case 2:{
            self.selectedDistrict = self.selectedDistrictArray[row];
        }
            break;
        default:
            break;
    }
    
    
    // 存下当前选择的地区
    if(self.isRecordLocation){
        
        NSInteger provinceIndex = [self.selectedProvinceArray indexOfObject:_selectedProvince];
        NSArray *selectedCityArray = [self.dataArray[provinceIndex] cityArray];
        NSInteger cityIndex = [selectedCityArray indexOfObject:_selectedCity];
        NSArray  *districtArray = [self.dataArray[provinceIndex] districtArray][cityIndex];
        NSInteger districtIndex = [districtArray indexOfObject:_selectedDistrict];
        
        self.saveArray = @[[NSNumber numberWithInteger:provinceIndex],[NSNumber numberWithInteger:cityIndex],[NSNumber numberWithInteger:districtIndex]];
    }
    
    
    if (self.selectedProvince && self.selectedCity && self.selectedDistrict) {
        
        self.selectArray = @[self.selectedProvince,self.selectedCity,self.selectedDistrict];
//        NSLog(@"省:%@ 市:%@ 区:%@",self.selectedProvince,self.selectedCity,self.selectedDistrict);
    }
}


#pragma mark - getSelectedArray
- (void)getSelectedArray{
    
    NSInteger provinceIndex = [self.selectedProvinceArray indexOfObject:self.selectedProvince];
    self.selectedCityArray = [self.dataArray[provinceIndex] cityArray];
    NSInteger cityIndex = [self.selectedCityArray indexOfObject:self.selectedCity];
    self.selectedDistrictArray = [self.dataArray[provinceIndex] districtArray][cityIndex];
    
}


#pragma mark - 绘制pickerView
- (void)drawView{
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 34, self.frame.size.width, 216)];
    [self.pickerView setBackgroundColor:[UIColor whiteColor]];
    [self.pickerView setDataSource:self];
    [self.pickerView setDelegate:self];
    [self addSubview:self.pickerView];
    
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 34)];
    [self addSubview:self.toolView];
    
    UIView *belowLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 33, self.frame.size.width, 1)];
    belowLineView.backgroundColor = [UIColor grayColor];
    [self.toolView addSubview:belowLineView];
    
    UIView *aboveLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    aboveLineView.backgroundColor = [UIColor grayColor];
    [self.toolView addSubview:aboveLineView];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(10, 2, 40, 28);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:cancelButton];
    
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(self.bounds.size.width - 50, 2, 40, 28);
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:sureButton];
    
}



#pragma mark - 请求地区Plist文件
- (void)loadData{
    
    self.dataArray = [NSMutableArray arrayWithCapacity:34];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Place" ofType:@"plist"]];
    
    NSArray *provinceArray = [dict allKeys];
    self.selectedProvinceArray = provinceArray;
    
    for (int i = 0; i < provinceArray.count; i ++) {
        
        PlaceModel *placeModel = [[PlaceModel alloc] init];
        placeModel.provinceName = provinceArray[i];
        NSDictionary *cityDict = [[dict objectForKey:provinceArray[i]] firstObject];
        [cityDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            [placeModel.cityArray addObject:key];
            [placeModel.districtArray addObject:obj];
        }];
        [self.dataArray addObject:placeModel];
    }
    
    if (self.isRecordLocation && [[NSUserDefaults standardUserDefaults] objectForKey:@"saveArray"]) {
        
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveArray"];
        
        PlaceModel *placeModel = self.dataArray[[array[0] integerValue]];
        self.selectedProvince = placeModel.provinceName;
        self.selectedCity = placeModel.cityArray[[array[1] integerValue]];
        self.selectedDistrict = placeModel.districtArray[[array[1] integerValue]][[array[2] integerValue]];

    }else{
        
        PlaceModel *placeModel = self.dataArray[0];
        self.selectedProvince = placeModel.provinceName;
        self.selectedCity = placeModel.cityArray[0];
        self.selectedDistrict = placeModel.districtArray[0][0];
    }
    [self getSelectedArray];
}


#pragma mark - ToolViewAction
- (void)cancelAction{
    
    if (!_isRecordLocation) {
        
        self.saveArray = nil;
    }
    [self removeFromSuperview];
}

- (void)sureAction{
    
    
    // 存下当前选择的地区
    if(self.isRecordLocation){
        
        [[NSUserDefaults standardUserDefaults] setObject:self.saveArray forKey:@"saveArray"];
    }
    
    if(self.selectArray){
        
        _sendPlaceArray(self.selectArray);
        [self removeFromSuperview];
        
    }else{
        
        NSString *title = NSLocalizedString(@"未选择地区", nil);
        NSString *message = NSLocalizedString(@"请您选择或者更改地区后再点击确定。", nil);
        NSString *OKButtonTitle = NSLocalizedString(@"OK", nil);
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:OKButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertVC addAction:OKAction];
        [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
    }
}



@end
