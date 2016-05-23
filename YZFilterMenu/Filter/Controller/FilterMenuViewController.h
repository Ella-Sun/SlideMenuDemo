//
//  FilterMenuViewController.h
//  JDSelectDemo
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 mark. All rights reserved.
//

/**
 *  当直接点击确定按钮时，返回为空
 *  当有选择时，返回所选，无，返回nil
 */

#import "FilterBaseViewController.h"

typedef void (^FilterBasicBlock)();

@interface FilterMenuViewController : FilterBaseViewController

@property (nonatomic, copy) FilterBasicBlock basicBlock;

/**
 *  选中的支付方向
 */
@property (nonatomic, strong) NSArray * keepTradeDirIDs;
/**
 *  选中的公司名称
 */
@property (nonatomic, strong) NSArray * keepComIDs;
/**
 *  选中的银行名称
 */
@property (nonatomic, strong) NSArray * keepBanksIDs;
/**
 *  选中的账户性质
 */
@property (nonatomic, strong) NSArray * keepCountPropIDs;
/**
 *  选中的账户模式
 */
@property (nonatomic, strong) NSArray * keepCountModelIDs;

//确定block
@property (nonatomic, copy) void (^screeningBlock)(NSArray *,NSArray *,NSArray *,NSArray *,NSArray *);
//清空block
//@property (nonatomic, copy) void (^screeningDeleteBlock)();
//点击了导航栏上的block
@property (nonatomic, copy) void (^screeningNavBlock)(NSArray *,NSArray *,NSArray *,NSArray *,NSArray *);


//判断是否点击了确定按钮（如果选完条件，但直接点击导航栏的返回按钮则不保存筛选条件）
@property (nonatomic, assign) BOOL isSureBtnClicked;

- (void)setSureBarItemHandle:(FilterBasicBlock)basicBlock;

@end
