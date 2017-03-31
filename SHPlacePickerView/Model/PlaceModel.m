//
//  PlaceModel.m
//  SHPlacePickViewDemo
//
//  Created by HarrySun on 2017/3/31.
//  Copyright © 2017年 Mobby. All rights reserved.
//

#import "PlaceModel.h"

@implementation PlaceModel

@end



@implementation Province

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        self.cityArray = [NSMutableArray array];
    }
    return self;
}

@end


@implementation City

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.districtAarray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
