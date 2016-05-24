//
//  FilterSubMenuViewController.m
//  YZFilterMenu
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "FilterSubMenuViewController.h"

#import "FilterSubView.h"
#import "FilterSelectModel.h"

#define kMenuLeftSpace 100
//屏幕高度
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
//屏幕宽
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

@interface FilterSubMenuViewController ()

@property (nonatomic, strong) FilterSubView *subSelectView;

@end

@implementation FilterSubMenuViewController

- (FilterSubView *)subSelectView {
    if (!_subSelectView) {
        CGRect selFrame = CGRectMake(0,0, kScreenWidth-kMenuLeftSpace, kScreenHeight);
        _subSelectView = [[FilterSubView alloc] initWithFrame:selFrame];
        [self.view addSubview:_subSelectView];
    }
    return _subSelectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.subTitle;

    UIImage *cancelBarImage = [UIImage imageNamed:@"icon_back"];
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc]
                                      initWithImage:cancelBarImage
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = cancelBarItem;
    
    UIBarButtonItem *sureBarItem = [[UIBarButtonItem alloc]
                                    initWithTitle:@"确定"
                                    style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(sureAction)];
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
        [self.delegate rowDidSelectes:self.subSelectView.selectedRows];
    }
    
    [self navBackBarAction:nil];
}

- (void)setData:(NSArray *)data {
    _data = data;
    NSMutableArray *tableData = [NSMutableArray array];
    for (FilterSelectModel *model in _data) {
        NSMutableArray *indexData = [NSMutableArray array];
        [indexData addObject:model.title];
        [indexData addObject:[NSNumber numberWithBool:model.selected]];
        [tableData addObject:indexData];
    }
    
    if (self.subSelectView) {
        self.subSelectView.subTitle = self.subTitle;
        self.subSelectView.data = tableData;
    }
}

@end
