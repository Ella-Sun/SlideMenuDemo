//
//  FilterMenuView.m
//  YZFilterMenu
//
//  Created by IOS-Sun on 16/5/23.
//  Copyright © 2016年 Sunhong. All rights reserved.
//

#import "FilterMenuView.h"

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
    
    self.menuTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.menuTableView.backgroundColor = [UIColor clearColor];
    self.menuTableView.dataSource = self;
    self.menuTableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:self.menuTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *title = self.arrTitle[indexPath.row];
    cell.textLabel.text = title;
    
    NSString *detailText = [self.allData valueForKey:title];
    if (detailText.length == 0) {
        detailText = @"全部";
    }
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

@end
