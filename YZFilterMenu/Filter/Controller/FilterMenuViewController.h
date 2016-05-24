//
//  FilterMenuViewController.h
//  YZFilterMenu
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

@property (nonatomic, strong) NSDictionary * recordSelectedTexts;

//确定block
@property (nonatomic, copy) void (^screeningBlock)(NSArray *,NSArray *,NSArray *,NSArray *,NSArray *);
//清空block
@property (nonatomic, copy) void (^screeningDeleteBlock)();

@property (nonatomic, copy) void (^RecordSelectTexts)(NSDictionary *);
//点击了导航栏上的block
//@property (nonatomic, copy) void (^screeningNavBlock)(NSArray *,NSArray *,NSArray *,NSArray *,NSArray *);


- (void)setSureBarItemHandle:(FilterBasicBlock)basicBlock;

@end
