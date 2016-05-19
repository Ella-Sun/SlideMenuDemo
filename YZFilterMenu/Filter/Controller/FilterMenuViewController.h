//
//  FilterMenuViewController.h
//  JDSelectDemo
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "FilterBaseViewController.h"

typedef void (^FilterBasicBlock)();

@interface FilterMenuViewController : FilterBaseViewController

@property (nonatomic, copy) FilterBasicBlock basicBlock;

//确定block
@property (nonatomic, copy) void (^screeningBlock)(NSArray *,NSArray *,NSArray *,NSArray *,NSArray *);
//清空block
//@property (nonatomic, copy) void (^screeningDeleteBlock)();
//点击了导航栏上的block
@property (nonatomic, copy) void (^screeningNavBlock)(NSArray *,NSArray *,NSArray *,NSArray *,NSArray *);

@property (nonatomic, copy) void(^allFilterModelStatus)(NSDictionary *);


//判断是否点击了确定按钮（如果选完条件，但直接点击导航栏的返回按钮则不保存筛选条件）
@property (nonatomic, assign) BOOL isSureBtnClicked;

/**
 *  所有的子菜单汇总名称
 */
@property (nonatomic, strong) NSMutableDictionary * subTextTitles;


- (void)setCancleBarItemHandle:(FilterBasicBlock)basicBlock;

@end
