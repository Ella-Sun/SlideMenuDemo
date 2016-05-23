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
    }
    return _subTextTitles;
}

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
        _keepTradeDirIDs = nil;
        _keepComIDs = nil;
        _keepBanksIDs = nil;
        _keepCountPropIDs = nil;
        _keepCountModelIDs = nil;
    }
}

- (void)setSureBarItemHandle:(FilterBasicBlock)basicBlock{
    
    self.basicBlock = basicBlock;
}

/**
 *  点击清空按钮回调block
 */
- (void)cancelAction{
    
    /**
     *  所有选项恢复默认，即全选
     */
    [self.subTextTitles removeAllObjects];
    [self.tableView reloadData];
    
    if(self.screeningNavBlock){ // 点击了返回按钮，清空所有筛选条件
        self.screeningNavBlock(nil,nil,nil,nil,nil);
    }
}

/**
 *  点击了确定按钮回调block
 */
- (void)sureAction{
    
    //保存选项
    self.isSureBtnClicked = YES;
    if (self.screeningBlock) {
        self.screeningBlock(_keepTradeDirIDs,_keepComIDs,_keepBanksIDs,_keepCountPropIDs,_keepCountModelIDs);
    }    
    
    if(self.basicBlock)
        self.basicBlock();
}

- (NSMutableArray *)addNotSelectRowsIndexWithMax:(NSInteger)maxIndex {
    NSMutableArray *indexAry = [NSMutableArray array];
    for (NSInteger i = 0; i < maxIndex; i++) {
        [indexAry addObject:@(i)];
    }
    return indexAry;
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
        
        NSArray *subTextModels = @[];
        NSArray *keepIndexs = @[];
        //最初的全部数据
        if ([title isEqualToString:@"收支方向"]) {
            subTextModels = @[@"收",@"支"];//经查询得到
            keepIndexs = _keepTradeDirIDs;
        }
        if ([title isEqualToString:@"全部公司"]) {
            subTextModels = @[@"云资通汇",@"云资通汇分公司1",@"云资通汇分公司2"];
            keepIndexs = _keepComIDs;
        }
        if ([title isEqualToString:@"全部银行"]) {
            subTextModels = @[@"招商银行股份有限公司福州分行",@"招商银行股份有限公司北京分行"];
            keepIndexs = _keepBanksIDs;
        }
        
        if ([title isEqualToString:@"账户性质"]) {
            subTextModels = @[@"收支户",@"收入户",@"支出户"];
            keepIndexs = _keepCountPropIDs;
        }
        
        if ([title isEqualToString:@"账户模式"]) {
            subTextModels = @[@"人工",@"直连"];
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


#pragma mark - set

- (void)setKeepTradeDirIDs:(NSArray *)keepTradeDirIDs {
    _keepTradeDirIDs = keepTradeDirIDs;
    if (_keepTradeDirIDs.count == 0) {
        return;
    }
    NSArray *childAry = [self.subTextTitles valueForKey:@"收支方向"];
    if (childAry.count == 0) {
        childAry = @[@"收",@"支"];//查询数据库
    }
    //选择全部
    if (_keepTradeDirIDs.count == childAry.count) {
        return;
    }
    //需显示 //此处处理可以避免点击单元格 再进行数据库处理
    if (_keepTradeDirIDs.count <= childAry.count) {
        [self insertModelDataWithSubTitleAry:childAry
                               orSelectedAry:_keepTradeDirIDs
                               andTotleTitle:@"收支方向"];
        [self.tableView reloadData];
    }
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


/**
 *  代理
 *
 */
- (void)rowDidSelectes:(NSArray *)rows {
    
    //标题数组
    NSArray *sectionAry = self.arrTitle[_selectedIndexPath.section];
    //标题
    NSString *title = sectionAry[_selectedIndexPath.row];
    //对应子数组(models)
    NSArray *childAry = [self.subTextTitles valueForKey:title];
    NSMutableArray *changeTexts = [NSMutableArray array];
    
    //直接点击返回 应清除
    if (rows.count == 0) {
//        NSInteger i = 0;
//        for (FilterSelectModel *model in childAry) {
//            model.selected = NO;
//            [changeTexts replaceObjectAtIndex:i++ withObject:model];
//        }
        return;
    } else {
        //未被点击设为NO
        NSInteger index = 0;
        for (FilterSelectModel *model in childAry) {
            NSString *indexStr = [NSString stringWithFormat:@"%ld",index];
            if ([rows containsObject:indexStr]) {
                [changeTexts addObject:model];
            } else {
                model.selected = NO;
                [changeTexts replaceObjectAtIndex:index withObject:model];
            }
            index++;
        }
        //存点击的model
//        for (NSString *indexSre in rows) {
//            NSInteger index = [indexSre integerValue];
//            FilterSelectModel *model = childAry[index];
//            model.selected = YES;
//            [changeTexts replaceObjectAtIndex:index withObject:model];
//        }
    }
    //改变对应model的点击状态
    [self.subTextTitles setValue:changeTexts forKey:title];
    [self.tableView reloadData];
    
    if ([title isEqualToString:@"收支方向"]) {
        _keepTradeDirIDs = rows;
    }
    if ([title isEqualToString:@"全部公司"]) {
        _keepComIDs = rows;
    }
    if ([title isEqualToString:@"全部银行"]) {
        _keepBanksIDs = rows;
    }
    
    if ([title isEqualToString:@"账户性质"]) {
        _keepCountPropIDs = rows;
    }
    
    if ([title isEqualToString:@"账户模式"]) {
        _keepCountModelIDs = rows;
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
