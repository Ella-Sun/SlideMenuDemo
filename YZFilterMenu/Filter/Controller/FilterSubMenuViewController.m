//
//  FilterSubMenuViewController.m
//  YZFilterMenu
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 Sunhong. All rights reserved.
//

#import "FilterSubMenuViewController.h"

#import "FilterSubView.h"
#import "FilterSelectModel.h"

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
        CGFloat cellHeight = [self cellHeightWithText:model.title];
        [indexData addObject:[NSString stringWithFormat:@"%f",cellHeight]];
        [tableData addObject:indexData];
    }
    
    if (self.subSelectView) {
        self.subSelectView.subTitle = self.subTitle;
        self.subSelectView.data = tableData;
    }
}

- (CGFloat)cellHeightWithText:(NSString *)text {
    
    CGFloat labelWidth = (kScreenWidth - kMenuLeftSpace)*0.8;
    CGFloat marginSpace = 8;
    
    UIFont *labelFont = [UIFont systemFontOfSize:14.0];
    NSDictionary *attributes = @{NSFontAttributeName:labelFont};
    CGSize constraintSize = CGSizeMake(labelWidth, MAXFLOAT);
    CGSize labelSize = [text boundingRectWithSize:constraintSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:attributes
                                                    context:nil].size;
    CGFloat cellHeight = labelSize.height + marginSpace*2;
    return cellHeight;
}

@end
