    //
    //  PlaceModel.h
    //  SHPlacePickViewDemo
    //
    //  Created by HarrySun on 2017/3/31.
    //  Copyright © 2017年 Mobby. All rights reserved.
    //

    #import <Foundation/Foundation.h>

    @interface PlaceModel : NSObject

    @end


    // 省
    @interface Province : NSObject

    /**
     省名称
     */
    @property (nonatomic, strong) NSString *provinceName;

    /**
     本省的市数组
     */
    @property (nonatomic, strong) NSMutableArray *cityArray;

    @end


    // 市
    @interface City : NSObject

    /**
     市名称
     */
    @property (nonatomic, strong) NSString *cityName;

    /**
     本市的区数组
     */
    @property (nonatomic, strong) NSArray *districtAarray;

    @end
