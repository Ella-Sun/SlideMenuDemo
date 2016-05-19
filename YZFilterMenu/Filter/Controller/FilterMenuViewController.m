//
//  FilterMenuViewController.m
//  JDSelectDemo
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "FilterMenuViewController.h"

#import "FilterSubMenuViewController.h"
//#import "FilterFirstView.h"
#import "FilterSelectModel.h"

#define kMenuLeftSpace 100
//屏幕高度
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
//屏幕宽
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

@interface FilterMenuViewController ()<UITableViewDataSource,UITableViewDelegate,FilterSelectedDelegate>


@property (nonatomic, strong) UITableView *tableView;

/**
 *  默认显示筛选项
 */
@property (nonatomic, strong) NSArray *arrTitle;
/**
 *  选中的支付方向
 */
@property (nonatomic, strong) NSArray * tradeDirections;
/**
 *  选中的公司名称
 */
@property (nonatomic, strong) NSArray * allComNames;
/**
 *  选中的银行名称
 */
@property (nonatomic, strong) NSArray * allBanksNames;
/**
 *  选中的账户性质
 */
@property (nonatomic, strong) NSArray * allCountPropNames;
/**
 *  选中的账户模式
 */
@property (nonatomic, strong) NSArray * allCountModelNames;
/**
 *  所有的子菜单汇总名称
 */
//@property (nonatomic, strong) NSMutableDictionary * subTextTitles;
/**
 *  菜单选中位置
 */
@property (nonatomic, assign) NSIndexPath *selectedIndexPath;

@end

@implementation FilterMenuViewController

- (NSMutableDictionary *)subTextTitles {
    if (!_subTextTitles) {
        _subTextTitles = [NSMutableDictionary dictionary];
    }
    return _subTextTitles;
}

//- (NSMutableDictionary *)selectTexts {
//    if (!_selectTexts) {
//        _selectTexts = [NSMutableDictionary dictionary];
//    }
//    return _selectTexts;
//}

- (NSArray *)arrTitle {
    if (!_arrTitle) {
        _arrTitle = @[@[@"收支方向"],@[@"全部公司",@"全部银行",@"账户性质",@"账户模式"]];
    }
    return _arrTitle;
}

/**
 * 更改状态栏颜色为白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/* 不好用
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.isSureBtnClicked = NO;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = cancelBarItem;
    
    UIBarButtonItem *sureBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureAction)];
    
    self.navigationItem.rightBarButtonItem = sureBarItem;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth-kMenuLeftSpace, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 没有点击确定按钮，直接点击的是导航栏上面的返回按钮,清空筛选条件
    if (!self.isSureBtnClicked) {
        self.tradeDirections = nil;
        self.allComNames = nil;
        self.allBanksNames = nil;
        self.allCountPropNames = nil;
        self.allCountModelNames = nil;
    }
}

- (void)setCancleBarItemHandle:(FilterBasicBlock)basicBlock{
    
    self.basicBlock = basicBlock;
}

/**
 *  点击清空按钮回调block
 */
- (void)cancelAction{
    
    self.subTextTitles = nil;
    [self.tableView reloadData];
    
    if(self.screeningNavBlock){ // 点击了返回按钮，清空所有筛选条件
        self.screeningNavBlock(nil,nil,nil,nil,nil);
    }
//    if(self.basicBlock)
//        self.basicBlock();
}

/**
 *  点击了确定按钮回调block
 */
- (void)sureAction{
    
    //保存选项
    self.isSureBtnClicked = YES;
    if (self.screeningBlock) {
        self.screeningBlock(_tradeDirections,_allComNames,_allBanksNames,_allCountPropNames,_allCountModelNames);
    }
    
    if (self.allFilterModelStatus) {
        self.allFilterModelStatus(self.subTextTitles);
    }
    
    
    if(self.basicBlock)
        self.basicBlock();
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
    if (self.subTextTitles.count == 0) {
        cell.detailTextLabel.text = detailText;
        return cell;
    }
    NSArray *detailAry = [self.subTextTitles valueForKey:title];
    for (FilterSelectModel *model in detailAry) {
        if (model.isSelected) {
            detailText = [detailText stringByAppendingFormat:@",%@",model.title];
        }
    }
    if (detailText.length > 0) {
        detailText = [detailText stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    
    cell.detailTextLabel.text = detailText;
    
    return cell;
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
    
    NSArray *childAry = self.arrTitle[indexPath.section];
    NSString *title = childAry[indexPath.row];
    
    NSArray *selSubTexts = [self.subTextTitles valueForKey:title];
    if (selSubTexts.count == 0) {
        
        NSMutableArray *subTexts = [NSMutableArray array];
        NSArray *subTextModels = @[];
        //最初的全部数据
        if ([title isEqualToString:@"收支方向"]) {
            subTextModels = @[@"收",@"支"];//经查询得到
        }
        if ([title isEqualToString:@"全部公司"]) {
            subTextModels = @[@"云资通汇",@"云资通汇分公司1",@"云资通汇分公司2"];
        }
        if ([title isEqualToString:@"全部银行"]) {
            subTextModels = @[@"招商银行股份有限公司福州分行",@"招商银行股份有限公司北京分行"];
        }
        
        if ([title isEqualToString:@"账户性质"]) {
            subTextModels = @[@"收支户",@"收入户",@"支出户"];
        }
        
        if ([title isEqualToString:@"账户模式"]) {
            subTextModels = @[@"人工",@"直连"];
        }
        
        for (NSString *subTitle in subTextModels) {
            FilterSelectModel *model = [[FilterSelectModel alloc] init];
            model.title = subTitle;
            [subTexts addObject:model];
        }
        [self.subTextTitles setValue:subTexts forKey:title];
    }
    //记录点击状态
    
    
    svc.data = [self.subTextTitles valueForKey:title];
    [self.navigationController pushViewController:svc animated:YES];
}


/**
 *  父类
 *
 */
- (void)rowDidSelectes:(NSArray *)rows {
    
    //标题数组
    NSArray *sectionAry = self.arrTitle[_selectedIndexPath.section];
    //标题
    NSString *title = sectionAry[_selectedIndexPath.row];
    //对应子数组(models)
    NSArray *childAry = [self.subTextTitles valueForKey:title];
    NSMutableArray *changeTexts = [NSMutableArray arrayWithArray:childAry];
    
    //直接点击返回 应清除
    if (rows.count == 0) {
        NSInteger i = 0;
        for (FilterSelectModel *model in childAry) {
            model.isSelected = NO;
            [changeTexts replaceObjectAtIndex:i++ withObject:model];
        }
    } else {
        //存点击的model
        for (NSString *indexSre in rows) {
            NSInteger index = [indexSre integerValue];
            FilterSelectModel *model = childAry[index];
            model.isSelected = YES;
            [changeTexts replaceObjectAtIndex:index withObject:model];
        }
    }
    //改变对应model的点击状态
    [self.subTextTitles setValue:changeTexts forKey:title];
    [self.tableView reloadData];
    
    if ([title isEqualToString:@"收支方向"]) {
        _tradeDirections = rows;
    }
    if ([title isEqualToString:@"全部公司"]) {
        _allComNames = rows;
    }
    if ([title isEqualToString:@"全部银行"]) {
        _allBanksNames = rows;
    }
    
    if ([title isEqualToString:@"账户性质"]) {
        _allCountPropNames = rows;
    }
    
    if ([title isEqualToString:@"账户模式"]) {
        _allCountModelNames = rows;
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
