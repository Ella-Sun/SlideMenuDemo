//
//  ViewController.m
//  YZFilterMenu
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 Sunhong. All rights reserved.
//

#import "ViewController.h"

#import "FilterMenuViewController.h"

#define kMenuLeftSpace 100
//屏幕高度
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
//屏幕宽
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

@interface ViewController ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, weak) UIView *upView;

@property (nonatomic, strong) NSArray   * tradeIds;
@property (nonatomic, strong) NSArray   * companyIds;
@property (nonatomic, strong) NSArray   * bankIds;
@property (nonatomic, strong) NSArray   * propertyIds;
@property (nonatomic, strong) NSArray   * modelIds;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 100, 100, 40);
    [btn addTarget:self action:@selector(actionBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"filter" forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)actionBtn{
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth-100, kScreenHeight)];
    window.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.7];
    window.windowLevel = UIWindowLevelNormal;
    window.hidden = NO;
    [window makeKeyAndVisible];
    
    FilterMenuViewController *filterVC = [[FilterMenuViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:filterVC];
    filterVC.view.frame = window.bounds;
    window.rootViewController = nav;
    self.window = window;
    
    filterVC.keepTradeDirIDs = self.tradeIds;
    filterVC.keepComIDs = self.companyIds;
    filterVC.keepBanksIDs = self.bankIds;
    filterVC.keepCountPropIDs = self.propertyIds;
    filterVC.keepCountModelIDs = self.modelIds;
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [view addGestureRecognizer:tap];
    [self.view addSubview:view];
    self.upView = view;
    
    __weak typeof(self) weak = self;
    //点击确定按钮
    [filterVC setSureBarItemHandle:^{
        [weak tapSureFilterButton];
    }];
    
    //点击清除按钮
    filterVC.screeningDeleteBlock = ^(){
        //清除标记
    };
    
    filterVC.screeningBlock = ^(NSArray *tradeDirectIDs,NSArray *companyIDs,NSArray *bankIDs,NSArray *countPropIDs,NSArray *countModelIDs){
        weak.tradeIds = tradeDirectIDs;
        weak.companyIds = companyIDs;
        weak.bankIds = bankIDs;
        weak.propertyIds = countPropIDs;
        weak.modelIds = countModelIDs;
    };
}


- (void)tapSureFilterButton {
    [self.upView removeFromSuperview];
    [self.window resignKeyWindow];
    self.window.hidden = YES;
    self.window  = nil;
    self.upView = nil;
}

- (void)tapAction{
    self.tradeIds = nil;
    self.companyIds = nil;
    self.bankIds = nil;
    self.propertyIds = nil;
    self.modelIds = nil;
    
    [self tapSureFilterButton];
}

@end
