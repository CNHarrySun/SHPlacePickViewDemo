//
//  ViewController.m
//  SHPlacePickViewDemo
//
//  Created by HarrySun on 2017/3/31.
//  Copyright © 2017年 Mobby. All rights reserved.
//

#import "ViewController.h"
#import "SHPlacePickerView.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) SHPlacePickerView *shplacePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 选择/显示选中地区按钮
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(10, 200, self.view.bounds.size.width - 20, 50);
    selectButton.backgroundColor = [UIColor blackColor];
    selectButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [selectButton setTitle:@"选择" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectButton];
    self.selectButton = selectButton;
    
}

-(void)selectAction{
    
    __weak __typeof(self)weakSelf = self;
    self.shplacePicker = [[SHPlacePickerView alloc] initWithIsRecordLocation:YES SendPlaceArray:^(NSArray *placeArray) {
        
        NSLog(@"省:%@ 市:%@ 区:%@",placeArray[0],placeArray[1],placeArray[2]);
        [weakSelf.selectButton setTitle:[NSString stringWithFormat:@"省:%@ 市:%@ 区:%@",placeArray[0],placeArray[1],placeArray[2]] forState:UIControlStateNormal];

    }];
    [self.view addSubview:self.shplacePicker];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
