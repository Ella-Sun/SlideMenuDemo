//
//  FilterSubMenuViewController.h
//  JDSelectDemo
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "FilterBaseViewController.h"

@protocol FilterSelectedDelegate <NSObject>

- (void)rowDidSelectes:(NSArray *)rows;

@end

@interface FilterSubMenuViewController : FilterBaseViewController

@property (nonatomic, strong) NSArray * data;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, weak) id<FilterSelectedDelegate> delegate;

@end
