//
//  FilterMenuViewController.m
//  YZFilterMenu
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "FilterMenuViewController.h"

#import "FilterSubMenuViewController.h"
#import "FilterSelectModel.h"
#import "FilterMenuView.h"

#define kMenuLeftSpace 100
//屏幕高度
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
//屏幕宽
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

@interface FilterMenuViewController ()<UITableViewDelegate,FilterSelectedDelegate>

@property (nonatomic, strong) FilterMenuView *filterMenu;

/**
 *  默认显示筛选项
 */
@property (nonatomic, strong) NSArray *arrTitle;
/**
 *  菜单选中位置
 */
@property (nonatomic, assign) NSIndexPath *selectedIndexPath;
/**
 *  所有的子菜单汇总名称
 */
@property (nonatomic, strong) NSMutableDictionary * subTextTitles;

@end

@implementation FilterMenuViewController

- (NSMutableDictionary *)subTextTitles {
    if (!_subTextTitles) {
        _subTextTitles = [NSMutableDictionary dictionary];
        for (NSString *title in self.arrTitle) {
            [_subTextTitles setValue:@[] forKey:title];
        }
    }
    return _subTextTitles;
}

- (NSArray *)arrTitle {
    if (!_arrTitle) {
        _arrTitle = @[@"收支方向",@"全部公司",@"全部银行",@"账户性质",@"账户模式"];
        
    }
    return _arrTitle;
}

- (void)setRecordSelectedTexts:(NSDictionary *)recordSelectedTexts {
    _recordSelectedTexts = recordSelectedTexts;
    //刷新界面
    self.filterMenu.arrTitle = self.arrTitle;
    if (_recordSelectedTexts == 0) {
        NSMutableDictionary *filterDic = [NSMutableDictionary dictionary];
        for (NSString *title in self.arrTitle) {
            [filterDic setValue:@"全部" forKey:title];
        }
        _filterMenu.allData = filterDic;
    } else {
        self.filterMenu.allData = _recordSelectedTexts;
    }
}

/**
 *  当清空时，初始化tableview右侧：全部
 *
 */
- (NSDictionary *)createTableViewData{
    if (_recordSelectedTexts == 0) {
        NSMutableDictionary *filterDic = [NSMutableDictionary dictionary];
        for (NSString *title in self.arrTitle) {
            [filterDic setValue:@"全部" forKey:title];
        }
        _recordSelectedTexts = filterDic;
    }
    return _recordSelectedTexts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = cancelBarItem;
    
    UIBarButtonItem *sureBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureAction)];
    
    self.navigationItem.rightBarButtonItem = sureBarItem;
    
    CGRect menuFrame = CGRectMake(0,0, kScreenWidth-kMenuLeftSpace, kScreenHeight);
    self.filterMenu = [[FilterMenuView alloc] initWithFrame:menuFrame];
//    self.filterMenu.arrTitle = self.arrTitle;
    self.filterMenu.menuTableView.delegate = self;
    [self.view addSubview:self.filterMenu];
}

- (void)setSureBarItemHandle:(FilterBasicBlock)basicBlock{
    self.basicBlock = basicBlock;
}

/**
 *  点击了确定按钮回调block
 */
- (void)sureAction{
    
    //保存选项
    if (self.screeningBlock) {
        self.screeningBlock(_keepTradeDirIDs,_keepComIDs,_keepBanksIDs,_keepCountPropIDs,_keepCountModelIDs);
    }
    
    if (self.RecordSelectTexts) {
        self.RecordSelectTexts(self.filterMenu.allData);
    }
    
    if(self.basicBlock)
        self.basicBlock();
}

/**
 *  点击清空按钮回调block
 */
- (void)cancelAction{
    
    /**
     *  所有选项恢复默认，即全选
     */
    [self.subTextTitles removeAllObjects];
    _keepTradeDirIDs = nil;
    _keepComIDs = nil;
    _keepBanksIDs = nil;
    _keepCountPropIDs = nil;
    _keepCountModelIDs = nil;
    
    _recordSelectedTexts = nil;
    
    self.filterMenu.allData = [self createTableViewData];//[self transformFromOldDicToNewDic];
    [self.filterMenu.menuTableView reloadData];
    
    if (self.screeningDeleteBlock) {
        self.screeningDeleteBlock();
    }
}

/**
 *  把VC的字典转化成tableview的数据字典
 *
 */
- (NSDictionary *)transformFromOldDicToNewDic {
    
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    NSArray *keysAry = self.subTextTitles.allKeys;
    if (keysAry.count == 0) {
        return self.recordSelectedTexts;
    }
    for (NSString *title in keysAry) {
        NSArray *detailAry = [self.subTextTitles valueForKey:title];
        NSString *detailText = @"";
        NSInteger selCount = 0;
        for (FilterSelectModel *model in detailAry) {
            if (model.selected) {
                selCount++;
                detailText = [detailText stringByAppendingFormat:@",%@",model.title];
            }
        }
        if (detailText.length > 0) {
            detailText = [detailText stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        if (detailText.length == 0) {
            detailText = [self.filterMenu.allData valueForKey:title];
            if (detailText.length == 0) {
                detailText = @"全部";
            }
        }
        if ((selCount != 0) && (detailAry.count == selCount)) {
            detailText = @"全部";
        }
//        NSLog(@"%@",detailText);
        [newDic setValue:detailText forKey:title];
    }
    return newDic;
}

- (NSMutableArray *)addNotSelectRowsIndexWithMax:(NSInteger)maxIndex {
    NSMutableArray *indexAry = [NSMutableArray array];
    for (NSInteger i = 0; i < maxIndex; i++) {
        [indexAry addObject:@(i)];
    }
    return indexAry;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001f;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10.0f;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //记录点击的位置
    _selectedIndexPath = indexPath;
    
    FilterSubMenuViewController *svc = [[FilterSubMenuViewController alloc] init];
    svc.delegate = self;
    
    NSString *title = self.arrTitle[indexPath.row];
    
    NSArray *selSubTexts = [self.subTextTitles valueForKey:title];
    if (selSubTexts.count == 0) {
        
        NSArray *subTextModels = @[];
        NSArray *keepIndexs = @[];
        //最初的全部数据
        if ([title isEqualToString:@"收支方向"]) {
            subTextModels = @[@"收",@"支"];//可修改为查询数据库得到
            keepIndexs = _keepTradeDirIDs;
        }
        if ([title isEqualToString:@"全部公司"]) {
            subTextModels = @[@"SOHU",@"Alibaba",@"Baidu"];
            keepIndexs = _keepComIDs;
        }
        if ([title isEqualToString:@"全部银行"]) {
            subTextModels = @[@"招商银行股份有限公司",@"建设银行股份有限公司北京分行",@"工商银行股份有限公司"];
            keepIndexs = _keepBanksIDs;
        }
        
        if ([title isEqualToString:@"账户性质"]) {
            subTextModels = @[@"收支户",@"收入户",@"支出户"];
            keepIndexs = _keepCountPropIDs;
        }
        
        if ([title isEqualToString:@"账户模式"]) {
            subTextModels = @[@"人工",@"人工1"];
            keepIndexs = _keepCountModelIDs;
        }
        
        [self insertModelDataWithSubTitleAry:subTextModels
                               orSelectedAry:keepIndexs
                               andTotleTitle:title];
    }
    //记录点击状态
    
    svc.subTitle = title;
    svc.data = [self.subTextTitles valueForKey:title];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - public
/**
 *  在总的数据记录字典里插入数据
 *
 *  @param subTitleAry 子菜单中的所有选项
 *  @param selectedAry 被选的子菜单项
 *  @param title       子菜单的title
 */
- (void)insertModelDataWithSubTitleAry:(NSArray *)subTitleAry
                      orSelectedAry:(NSArray *)selectedAry
                   andTotleTitle:(NSString *)title {
    
    BOOL keepSelected = NO;
    if (selectedAry.count == 0) {
        keepSelected = YES;
    }
    
    NSMutableArray *subTexts = [NSMutableArray array];
    NSInteger index = 0;
    for (NSString *subTitle in subTitleAry) {
        BOOL isSelected, finalResult = YES;
        NSString *indexStr = [NSString stringWithFormat:@"%ld",index++];
        isSelected = [selectedAry containsObject:indexStr];
        
        finalResult = (keepSelected || isSelected);
        
        FilterSelectModel *model = [[FilterSelectModel alloc] init];
        model.title = subTitle;
        model.selected = finalResult;
        [subTexts addObject:model];
    }
    [self.subTextTitles setValue:subTexts forKey:title];
}


#pragma mark - 代理
- (void)rowDidSelectes:(NSArray *)rows {
    
    //标题
    NSString *title = self.arrTitle[_selectedIndexPath.row];
    //对应子数组(models)
    NSArray *childAry = [self.subTextTitles valueForKey:title];
    NSMutableArray *changeTexts = [NSMutableArray array];
    
    //都未选择 默认全选
    if (rows.count == 0) {
        for (FilterSelectModel *model in childAry) {
            model.selected = YES;
            [changeTexts addObject:model];
        }
    } else {
        //未被点击设为NO
        NSInteger index = 0;
        for (FilterSelectModel *model in childAry) {
            NSString *indexStr = [NSString stringWithFormat:@"%ld",index];
            if ([rows containsObject:indexStr]) {
                model.selected = YES;
            } else {
                model.selected = NO;
            }
            [changeTexts addObject:model];
            index++;
        }
    }
    //改变对应model的点击状态
    [self.subTextTitles setValue:changeTexts forKey:title];
    //记录选择之后detailText的状态
    self.filterMenu.allData = [self transformFromOldDicToNewDic];
    [self.filterMenu.menuTableView reloadData];
    
    if ([title isEqualToString:@"收支方向"]) {
        _keepTradeDirIDs = rows;
        if (rows.count == childAry.count) {
            _keepTradeDirIDs = nil;
        }
    }
    if ([title isEqualToString:@"全部公司"]) {
        _keepComIDs = rows;
        if (rows.count == childAry.count) {
            _keepComIDs = nil;
        }
    }
    if ([title isEqualToString:@"全部银行"]) {
        _keepBanksIDs = rows;
        if (rows.count == childAry.count) {
            _keepBanksIDs = nil;
        }
    }
    
    if ([title isEqualToString:@"账户性质"]) {
        _keepCountPropIDs = rows;
        if (rows.count == childAry.count) {
            _keepCountPropIDs = nil;
        }
    }
    
    if ([title isEqualToString:@"账户模式"]) {
        _keepCountModelIDs = rows;
        if (rows.count == childAry.count) {
            _keepCountModelIDs = nil;
        }
    }
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
