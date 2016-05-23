//
//  FilterMenuView.m
//  YZFilterMenu
//
//  Created by IOS-Sun on 16/5/23.
//  Copyright © 2016年 Sunhong. All rights reserved.
//

#import "FilterMenuView.h"

#import "FilterSelectModel.h"

@interface FilterMenuView ()

@end

@implementation FilterMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultViews];
    }
    return self;
}

- (void)setupDefaultViews {
    
    self.menuTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.menuTableView.dataSource = self;
    [self addSubview:self.menuTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.arrTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.arrTitle[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSArray *arr = self.arrTitle[indexPath.section];
    NSString *title = arr[indexPath.row];
    cell.textLabel.text = title;
    
    NSString *detailText = @"";
    if (self.allData.count == 0) {
        cell.detailTextLabel.text = detailText;
        return cell;
    }
    NSArray *detailAry = [self.allData valueForKey:title];
    for (FilterSelectModel *model in detailAry) {
        if (model.selected) {
            detailText = [detailText stringByAppendingFormat:@",%@",model.title];
        }
    }
    
    if (detailText.length > 0) {
        detailText = [detailText stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

@end
