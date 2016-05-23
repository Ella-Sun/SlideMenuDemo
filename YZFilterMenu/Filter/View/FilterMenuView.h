//
//  FilterMenuView.h
//  YZFilterMenu
//
//  Created by IOS-Sun on 16/5/23.
//  Copyright © 2016年 Sunhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterMenuView : UIView<UITableViewDataSource>

@property (nonatomic, strong) UITableView *menuTableView;

@property (nonatomic, strong) NSArray *arrTitle;

@property (nonatomic, strong) NSMutableDictionary * allData;

@end
