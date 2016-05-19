//
//  FilterSubMenuViewController.m
//  JDSelectDemo
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "FilterSubMenuViewController.h"

#import "FilterSubTableViewCell.h"
#import "FilterSelectModel.h"

#define kMenuLeftSpace 100
//屏幕高度
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
//屏幕宽
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

@interface FilterSubMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * selectedRows;

@end

@implementation FilterSubMenuViewController

- (NSMutableArray *)selectedRows {
    if (!_selectedRows) {
        _selectedRows = [NSMutableArray array];
    }
    return _selectedRows;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"子菜单";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth-kMenuLeftSpace, kScreenHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back_red"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = cancelBarItem;
    
    UIBarButtonItem *sureBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureAction)];
    self.navigationItem.rightBarButtonItem = sureBarItem;
}

- (void)cancelAction {
    //记录 返回选择的行数
    if ([self.delegate respondsToSelector:@selector(rowDidSelectes:)]) {
        [self.delegate rowDidSelectes:nil];
    }
    [super navBackBarAction:nil];
}

//点击确认
- (void)sureAction {
    
    //记录 返回选择的行数
    if ([self.delegate respondsToSelector:@selector(rowDidSelectes:)]) {
        [self.delegate rowDidSelectes:self.selectedRows];
    }
    
    [self navBackBarAction:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FilterSubTableViewCell *cell = [FilterSubTableViewCell cellWithTableView:tableView];
    
    FilterSelectModel *model = _data[indexPath.row];
    
    UILabel *leftLabel = [cell viewWithTag:310];
    UIButton *rightBtn = [cell viewWithTag:311];
    
    leftLabel.text = model.title;
    rightBtn.selected = model.isSelected;
    
    __weak typeof(self) weakSelf = self;
    cell.cellClickBlock = ^{
        
        rightBtn.selected = !rightBtn.selected;
        model.isSelected = rightBtn.selected;
        NSString *indexStr = [NSString stringWithFormat:@"%ld",indexPath.row];
        if (rightBtn.selected) {
            [weakSelf.selectedRows addObject:indexStr];
        } else {
            [weakSelf.selectedRows removeObject:indexStr];
        }
    };
    
    return cell;
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
