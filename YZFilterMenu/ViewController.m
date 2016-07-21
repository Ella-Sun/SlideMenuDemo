//
//  ViewController.m
//  YZFilterMenu
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 Sunhong. All rights reserved.
//

#import "ViewController.h"

#import "FilterMenuViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, weak) UIView *upView;

@property (nonatomic, strong) NSArray   * tradeIds;
@property (nonatomic, strong) NSArray   * companyIds;
@property (nonatomic, strong) NSArray   * bankIds;
@property (nonatomic, strong) NSArray   * propertyIds;
@property (nonatomic, strong) NSArray   * modelIds;
@property (nonatomic, strong) NSDictionary * recordFilter;

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
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth-kMenuLeftSpace, kScreenHeight)];
    window.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.7];
    window.windowLevel = UIWindowLevelNormal;
    window.hidden = NO;
//    [window makeKeyAndVisible];
    
    FilterMenuViewController *filterVC = [[FilterMenuViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:filterVC];
    filterVC.view.frame = window.bounds;
    window.rootViewController = nav;
    self.window = window;
    
    [self addSwipGestureWithClass:filterVC.view Method:@selector(handleSwipFrom:)];
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self addTapGestureWithClass:view Method:@selector(tapAction)];
    
    [self.view addSubview:view];
    self.upView = view;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect winFrame = self.window.frame;
                         winFrame.origin.x = kMenuLeftSpace;
                         self.window.frame = winFrame;
                     } completion:nil];
    
    //这些需要写在调用筛选框的viewController中
    __weak typeof(self) weak = self;
    filterVC.RecordSelectTexts = ^(NSDictionary *recordTexts){
        weak.recordFilter = recordTexts;
    };
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
    filterVC.keepTradeDirIDs = self.tradeIds;
    filterVC.keepComIDs = self.companyIds;
    filterVC.keepBanksIDs = self.bankIds;
    filterVC.keepCountPropIDs = self.propertyIds;
    filterVC.keepCountModelIDs = self.modelIds;
//    self.filterVC.arrTitle = @[@"全部公司",@"全部银行",@"账户性质",@"账户模式"];
    filterVC.recordSelectedTexts = self.recordFilter;
}


/**
 *  添加轻扫手势
 *
 */
- (void)addSwipGestureWithClass:(UIView *)view
                         Method:(SEL)method {
    
    UISwipeGestureRecognizer *swipRecognizer = [[UISwipeGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:method];
    swipRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [view addGestureRecognizer:swipRecognizer];
}

/**
 *  添加点击手势
 *
 */
- (void)addTapGestureWithClass:(UIView *)view
                        Method:(SEL)method {
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self
                                    action:method];
    [view addGestureRecognizer:tap];
}

//判断清扫手势方向
- (void)handleSwipFrom:(UISwipeGestureRecognizer *)swipRecognizer {
    
    if (swipRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self tapAction];
    }
}


/**
 *  筛选框向右消失
 */
- (void)tapSureFilterButton {
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect winFrame = self.window.frame;
                         winFrame.origin.x = kScreenWidth;
                         self.window.frame = winFrame;
                         self.upView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.upView removeFromSuperview];
                         [self.window resignKeyWindow];
                         self.window.hidden = YES;
                         self.window  = nil;
                         self.upView = nil;
//                         self.filterVC = nil;
                     }];
}

//没有点击确定按钮 都走这个方法
- (void)tapAction{
    
    [self tapSureFilterButton];
    
}




@end
