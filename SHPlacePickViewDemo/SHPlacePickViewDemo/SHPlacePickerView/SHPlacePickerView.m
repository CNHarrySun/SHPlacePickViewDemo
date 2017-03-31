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


/**
 数据数组
 */
@property (nonatomic, strong) NSMutableArray *dataArray;


/**
 pickerView
 */
@property (nonatomic, strong) UIPickerView *pickerView;


/**
 工具视图
 */
@property (nonatomic, strong) UIView *toolView;


/**
 选中地区数组
 */
@property (nonatomic, strong) NSArray *selectArray;


/**
 存储数组
 */
@property (nonatomic, strong) NSArray *saveArray;

@end

@implementation SHPlacePickerView


- (instancetype)initWithIsRecordLocation:(BOOL)isrecordLocation SendPlaceArray:(SendPlaceArray)sendPlaceArray{
    
    self = [self init];
    self.sendPlaceArray = sendPlaceArray;
    self.isRecordLocation = isrecordLocation;
    
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


// 请求地区Plist文件
- (void)loadData{
    
    self.dataArray = [NSMutableArray arrayWithCapacity:34];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Place" ofType:@"plist"]];
    
    NSArray *provinceArray = [dict allKeys];
    
    for (int i = 0; i < provinceArray.count; i ++) {
        
        Province *provinceModel = [[Province alloc] init];
        provinceModel.provinceName = provinceArray[i];
        NSDictionary *cityDict = [[dict objectForKey:provinceArray[i]] firstObject];
        NSArray *cityArray = [cityDict allKeys];
        for (int j = 0; j < cityArray.count; j ++) {
            
            City *cityModel = [[City alloc] init];
            cityModel.cityName = cityArray[j];
            
            NSArray *districtAarray = [cityDict objectForKey:cityArray[j]];
            cityModel.districtAarray = districtAarray;
            
            [provinceModel.cityArray addObject:cityModel];
        }
        
        [self.dataArray addObject:provinceModel];
    }
}


// 绘制pickerView
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

#pragma mark - ToolViewAction
- (void)cancelAction{
    
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


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        
        return self.dataArray.count;
    }else if (component == 1){
        
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        Province *provinceModel = self.dataArray[rowProvince];
        return provinceModel.cityArray.count;
    }else{
        
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        Province *provinceModel = self.dataArray[rowProvince];
        
        if (rowCity < provinceModel.cityArray.count) {
            
            City *cityModel = provinceModel.cityArray[rowCity];
            return cityModel.districtAarray.count;
        }
        
        return 0;
    }
}


#pragma mark - UIPickerViewDelegate
// 自定义行
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        //        pickerLabel.adjustsFontSizeToFitWidth = YES;  // 是否根据宽度适应文字大小
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:17]];
    }
    
    if (component == 0) {
        Province *model = self.dataArray[row];
        pickerLabel.text = model.provinceName;
        [pickerView reloadComponent:1];
    }else if(component == 1){
        
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        Province *model = self.dataArray[rowProvince];
        
        if (row < model.cityArray.count) {
            City *cityModel = model.cityArray[row];
            pickerLabel.text = cityModel.cityName;
            [pickerView reloadComponent:2];
        }
    }else{
        
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        Province *model = self.dataArray[rowProvince];
        City *cityModel;
        
        if (rowCity < model.cityArray.count) {
            
            cityModel = model.cityArray[rowCity];
        }
        
        if (row < cityModel.districtAarray.count) {
            pickerLabel.text = cityModel.districtAarray[row];
        }
    }
    
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    if (component == 1){
        
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
    }
    
    NSInteger selectOne = [pickerView selectedRowInComponent:0];
    NSInteger selectTwo = [pickerView selectedRowInComponent:1];
    NSInteger selectThree = [pickerView selectedRowInComponent:2];
    
    // 存下当前选择的地区
    if(self.isRecordLocation){
        
        self.saveArray = @[[NSNumber numberWithInteger:selectOne],[NSNumber numberWithInteger:selectTwo],[NSNumber numberWithInteger:selectThree]];
    }
    
    Province *provinceModel = self.dataArray[selectOne];
    City *cityModel = provinceModel.cityArray[selectTwo];
    
    if (cityModel.cityName && cityModel.districtAarray[selectThree]) {
        
        // NSLog(@"省:%@ 市:%@ 区:%@",provinceModel.provinceName,cityModel.cityName,cityModel.districtAarray[selectThree]);
        self.selectArray = @[provinceModel.provinceName,cityModel.cityName,cityModel.districtAarray[selectThree]];
    }
}




@end
