//
//  FilterSubView.h
//  YZFilterMenu
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 Sunhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterSubView : UIView

@property (nonatomic, strong) NSArray * data;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, strong) NSMutableArray * selectedRows;

@end
