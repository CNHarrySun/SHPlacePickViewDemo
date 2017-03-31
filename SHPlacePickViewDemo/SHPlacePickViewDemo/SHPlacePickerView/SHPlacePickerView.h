//
//  SHPlacePickerView.h
//  SHPlacePickViewDemo
//
//  Created by HarrySun on 2017/3/31.
//  Copyright © 2017年 Mobby. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendPlaceArray)(NSArray *placeArray);
@interface SHPlacePickerView : UIView


/**
 传出选中数组
 */
@property (nonatomic,strong) SendPlaceArray sendPlaceArray;


/**
 是否定位到上次选中位置
 */
@property (nonatomic, assign) BOOL isRecordLocation;


/**
 创建SHPlacePickerView
 
 @param isrecordLocation 是否定位到上次选中地区
 @param sendPlaceArray 传出选中的地区数组
 @return SHPlacePickerView
 */
- (instancetype)initWithIsRecordLocation:(BOOL)isrecordLocation SendPlaceArray:(SendPlaceArray)sendPlaceArray;

@end
