//
//  FilterSubView.m
//  YZFilterMenu
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 Sunhong. All rights reserved.
//

#import "FilterSubView.h"

#import "FilterSubTableViewCell.h"

@interface FilterSubView ()<UITableViewDataSource, UITableViewDelegate> {
    BOOL close[1];//NO:表示展开 YES:表示收起
    
    BOOL sectionClose[1];//NO:表示不全选 YES:表示全选
}

@property (nonatomic, strong) UITableView *subTableView;

@property (nonatomic, strong) NSMutableArray * allSelBtns;

@end

@implementation FilterSubView

- (NSMutableArray *)allSelBtns {
    if (!_allSelBtns) {
        _allSelBtns = [NSMutableArray array];
    }
    return _allSelBtns;
}

- (NSMutableArray *)selectedRows {
    if (!_selectedRows) {
        _selectedRows = [NSMutableArray array];
    }
    return _selectedRows;
}

- (void)setData:(NSArray *)data {
    _data = data;
    BOOL isAllSelected = data.count==0?NO:YES;
    for (NSArray *model in data) {
        BOOL isSelected = [model[1] boolValue];
        if (!isSelected) {
            isAllSelected = NO;
        }
    }
    sectionClose[0] = isAllSelected;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultViews];
    }
    return self;
}

- (void)setupDefaultViews {
    
    CGRect tableFrame = CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height);
    self.subTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    self.subTableView.delegate = self;
    self.subTableView.dataSource = self;
    self.subTableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:self.subTableView];
}

#pragma mark - tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    BOOL isClose = close[section];
    if (isClose) {
        return 0;
    }
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FilterSubTableViewCell *cell = [FilterSubTableViewCell cellWithTableView:tableView];
    
    UILabel *leftLabel = [cell viewWithTag:310];
    UIButton *rightBtn = [cell viewWithTag:311];
    
    NSString *titleText = self.data[indexPath.row][0];
    NSNumber *selectedNumber = self.data[indexPath.row][1];
    BOOL isSelected = [selectedNumber boolValue];
    
    leftLabel.text = titleText;
    rightBtn.selected = isSelected;
    NSString *indexStr = [NSString stringWithFormat:@"%ld",indexPath.row];
    if (rightBtn.selected) {
        if (![self.selectedRows containsObject:indexStr]) {
            [self.selectedRows addObject:indexStr];
        }
    } else {
        [self.selectedRows removeObject:indexStr];
    }
    __weak typeof(self) weakSelf = self;
    cell.cellClickBlock = ^{
        
        rightBtn.selected = !rightBtn.selected;
        if (rightBtn.selected) {
            if (![weakSelf.selectedRows containsObject:indexStr]) {
                [weakSelf.selectedRows addObject:indexStr];
            }
        } else {
            [weakSelf.selectedRows removeObject:indexStr];
        }
        
        //改变全选按钮的状态
        BOOL isSelectedAll = (weakSelf.data.count == weakSelf.selectedRows.count)?YES:NO;
        UIButton *leftBtn = (UIButton *)weakSelf.allSelBtns[indexPath.section];
        leftBtn.selected = isSelectedAll;
        sectionClose[indexPath.section] = isSelectedAll;
    };
    
    leftLabel.lineBreakMode = NSLineBreakByWordWrapping;
    leftLabel.numberOfLines = 0;
    leftLabel.font = [UIFont systemFontOfSize:14.0];
    UIFont *labelFont = [UIFont systemFontOfSize:14.0];
    NSDictionary *attributes = @{NSFontAttributeName:labelFont};
    CGSize constraintSize = CGSizeMake(leftLabel.bounds.size.width, MAXFLOAT);
    CGSize labelSize = [leftLabel.text boundingRectWithSize:constraintSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:attributes
                                                    context:nil].size;
    CGRect labelFrame = leftLabel.frame;
    labelFrame.size.height = labelSize.height;
    labelFrame.origin.y = ((labelSize.height + 20) - leftLabel.frame.size.height) * 0.5;
    leftLabel.frame = labelFrame;
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat screenWidth = self.bounds.size.width;
    CGFloat spaceMargin = 10;
    CGFloat tempHeight = 44;
    
    CGFloat selectWidth = 30;
    CGFloat selectYpiex = (tempHeight - selectWidth) * 0.5;
    
    CGFloat labelXpiex = selectWidth + spaceMargin + 10;;
    CGFloat labelWidth = screenWidth * 0.4;
    
    CGFloat arrowWidth = 30;
    CGFloat arrowXpiex = screenWidth - spaceMargin - arrowWidth;
    CGFloat arrowYpiex = (tempHeight - arrowWidth)*0.5;
    
    UIButton *viewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    viewBtn.tag = 400 + section;
    viewBtn.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    [viewBtn addTarget:self action:@selector(unfoldAllCells:) forControlEvents:UIControlEventTouchUpInside];
    
    //全选按钮
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    selectBtn.frame = CGRectMake(spaceMargin, selectYpiex, selectWidth, selectWidth);
    selectBtn.tag = 100 + section;
    [selectBtn setImage:[UIImage imageNamed:@"checkbox_deafault"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(allItembtnClick:) forControlEvents:UIControlEventTouchUpInside];
    BOOL isSelected = sectionClose[section];
    selectBtn.selected = isSelected;
    
    [self.allSelBtns removeAllObjects];
    [self.allSelBtns addObject:selectBtn];
    
    [viewBtn addSubview:selectBtn];
    
    //标题
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    leftLabel.frame = CGRectMake(labelXpiex, 0, labelWidth, tempHeight);
    leftLabel.tag = 200 + section;
    leftLabel.text = _subTitle;
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.font = [UIFont systemFontOfSize:17.0];
    [viewBtn addSubview:leftLabel];
    
    //右侧显示展开还是收起
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowView.frame = CGRectMake(arrowXpiex, arrowYpiex, arrowWidth, arrowWidth);
    arrowView.tag = 300 + section;
    arrowView.image = [UIImage imageNamed:@"btn_back_red"];
    CGFloat rotationProp = -M_PI/2;
    if (close[0]) {
        rotationProp = M_PI;
    }
    CGAffineTransform rotationAf = CGAffineTransformMakeRotation(rotationProp);
    arrowView.transform = rotationAf;
    [viewBtn addSubview:arrowView];
    
    return viewBtn;
}


//设置组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}

/**
 *  全选按钮被点击
 *
 */
- (void)allItembtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    NSInteger tag = sender.tag - 100;
    sectionClose[tag] = sender.selected;
    
    NSInteger index = 0;
    NSMutableArray *newData = [NSMutableArray arrayWithArray:self.data];
    for (NSArray *model in self.data) {
        NSMutableArray *newModel = [NSMutableArray arrayWithArray:model];
        NSNumber *selectNumber = [NSNumber numberWithBool:sender.selected];
        [newModel replaceObjectAtIndex:1 withObject:selectNumber];
        [newData replaceObjectAtIndex:index++ withObject:newModel];
    }
    self.data = newData;
    [self.subTableView reloadData];
}

/**
 *  折叠按钮被点击
 *
 */
- (void)unfoldAllCells:(UIButton *)sender {
    
    NSInteger section = sender.tag - 400;
    //取得点击的组
    close[section] = !close[section];
    
    //刷新制定的组
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [self.subTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];

}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
