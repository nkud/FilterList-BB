//
//  InputHeaderView.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/09/20.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "InputHeaderView.h"

#define kHeightForHeader 55
#define kHorizonMarginForHeader 20
#define kVerticalMarginForHeader 5

NSString *kPlaceholderForInputField = @"new item";

#pragma mark -

@implementation InputHeaderView

#pragma mark - 初期化

/**
 * @brief  初期化
 *
 * @param table 取り付けるテーブル
 *
 * @return インスタンス
 */
-(instancetype)initWithTable:(UITableView *)table
{
  CGRect headerRect = table.bounds;
  headerRect.origin.y -= kHeightForHeader;
  headerRect.size.height = kHeightForHeader;
  self = [super initWithFrame:headerRect];
  self.backgroundColor = [UIColor grayColor];
  if (self)
  {
    // テキストフィールドを初期化
    CGRect fieldRect = self.frame;
    fieldRect.size.width -= kHorizonMarginForHeader * 2;
    fieldRect.size.height -= kVerticalMarginForHeader * 2;
    fieldRect.origin.x = kHorizonMarginForHeader;
    fieldRect.origin.y = kVerticalMarginForHeader;
    self.inputField = [[UITextField alloc] initWithFrame: fieldRect];
    self.inputField.placeholder = kPlaceholderForInputField;
    self.inputField.delegate = self;
    [self addSubview:self.inputField];
  }
  return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self.inputField resignFirstResponder];
  return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
