//
//  FilterSubTableViewCell.h
//  YZFilterMenu
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterSubTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^cellClickBlock)();

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
