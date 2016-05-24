//
//  FilterSubTableViewCell.m
//  YZFilterMenu
//
//  Created by IOS-Sun on 16/5/19.
//  Copyright © 2016年 mark. All rights reserved.
//

#import "FilterSubTableViewCell.h"

@interface FilterSubTableViewCell ()

@property (nonatomic, weak) UILabel *leftLabel;

@property (nonatomic, weak) UIButton *rightButton;

@end

@implementation FilterSubTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"filter";
    FilterSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[FilterSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.tag = 310;
        leftLabel.textAlignment = NSTextAlignmentLeft;
//        leftLabel.textColor = kColorWithRGB(51, 51, 51);
        leftLabel.font = [UIFont systemFontOfSize:14];
        self.leftLabel = leftLabel;
        [self addSubview:leftLabel];
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"checkbox_deafault"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
        button.tag = 311;
        self.rightButton = button;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    return self;
}

- (void)btnClick:(UIButton *)btn{
    
    if(self.cellClickBlock) {
        self.cellClickBlock();
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat leftLabelX = 10;
    CGFloat leftLabelY = 0;
    CGFloat leftLabelW = self.bounds.size.width * 0.8;
    CGFloat leftLabelH = self.bounds.size.height;
    self.leftLabel.frame = CGRectMake(leftLabelX, leftLabelY, leftLabelW, leftLabelH);
    
    CGFloat buttonW = 30;
    CGFloat buttonH = self.bounds.size.height;
    CGFloat buttonY = 0;
    CGFloat buttonX = self.bounds.size.width - buttonW - 10;
    self.rightButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
}

@end
