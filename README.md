# SHPlacePickerViewDemo
## 一行代码实现三级地区选择器


## 4月1日更新 修改model类型以及SHPlacePickerView的内部实现


#### 具体修改请查看代码


#### [[简书]iOS开发_一行代码实现三级地区选择器](http://www.jianshu.com/p/fe039f8e2492)



---

## 3月31日 封装三级地区选择器SHPlacePickerView


### 效果图：

![三级地区选择器](http://oixwuce1i.bkt.clouddn.com/SH%E5%9C%B0%E5%8C%BA%E9%80%89%E6%8B%A9%E5%99%A8.gif)


### 方法简介：
```objc

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
```


### 方法使用：
#### 1.下载SHPlacePickerViewDemo，将文件中的SHPlacePickerView文件夹拖到自己的工程中，并在需要使用的文件中导入头文件 #import "SHPlacePickerView.h"

#### 2.使用自定义的创建方式创建地区选择器
```objc

    __weak __typeof(self)weakSelf = self;
    
    self.shplacePicker = [[SHPlacePickerView alloc] initWithIsRecordLocation:YES SendPlaceArray:^(NSArray *placeArray) {
        
        [weakSelf.selectButton setTitle:[NSString stringWithFormat:@"省:%@ 市:%@ 区:%@",placeArray[0],placeArray[1],placeArray[2]] forState:UIControlStateNormal];
    }];
    [self.view addSubview:self.shplacePicker];

```

也可以不使用自定义的创建方法创建

```objc
/**
	self.shplacePicker = [[SHPlacePickerView alloc] init];
    self.shplacePicker.isRecordLocation = YES;
    self.shplacePicker.sendPlaceArray = ^(NSArray *placeArray){
        
        NSLog(@"省:%@ 市:%@ 区:%@",placeArray[0],placeArray[1],placeArray[2]);
        
        [weakSelf.selectButton setTitle:[NSString stringWithFormat:@"省:%@ 市:%@ 区:%@",placeArray[0],placeArray[1],placeArray[2]] forState:UIControlStateNormal];
    };
    
    [self.view addSubview:self.shplacePicker];
```


#### [iOS开发_一行代码实现三级地区选择器](http://www.jianshu.com/p/fe039f8e2492)