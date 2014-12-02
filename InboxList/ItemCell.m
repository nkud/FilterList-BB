//
//  Cell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/05/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ItemCell.h"
#import "Item.h"

#import "Header.h"

static NSString *kCheckedImageName = @"checked.png";
static NSString *kUncheckedImageName = @"unchecked.png";
static NSString *kBlueCheckedImageName = @"checked-blue.png";
static NSString *kBlueUncheckedImageName = @"unchecked-blue.png";
static NSString *kRedCheckedImageName = @"checked-red.png";
static NSString *kRedUncheckedImageName = @"unchecked-red.png";
static NSString *kYellowCheckedImageName = @"checked-yellow.png";
static NSString *kYellowUncheckedImageName = @"unchecked-yellow.png";


#pragma mark -

@implementation ItemCell

#pragma mark - 初期化 -

/**
 * @brief  初期化する
 *
 * @param style           スタイル
 * @param reuseIdentifier 識別子
 *
 * @return インスタンス
 */
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  /* superで初期化 */
  self = [super initWithStyle:style
              reuseIdentifier:reuseIdentifier];
  if (self)
  {
    LOG(@"タイトル・期限ラベルを追加する");
    // タイトルラベルを設定する
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    [self.contentView addSubview:self.titleLabel];
    
    // リマインダーラベルを設定する
    self.reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 100, 22)];
    self.reminderLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.reminderLabel];
    
    // チェックボックスを設定する
    self.checkBoxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    self.accessoryView = self.checkBoxImageView;
  }
  return self;
}

#pragma mark - ユーティリティ -

#pragma mark - チェックボックス

/**
 * @brief  チェックボックス用画像ファイル文字列を返す
 *
 * @param item  アイテム
 * @param check チェックマークの有無
 *
 * @return ファイル名
 */
- (NSString *)stringForCheckBoxImageWithItem:(Item *)item
                                       check:(BOOL)check
{
  // 期限が今日の場合
  // 黄色の画像名を返す
  if ([item isDueToToday]) {
    return check ? kYellowCheckedImageName : kYellowUncheckedImageName;
  }
  // 期限が超過している場合
  // 赤色の画像名を返す
  if ([item isOverDue]) {
    return check ? kRedCheckedImageName : kRedUncheckedImageName;
  }
  // 期限が明日以降の場合
  // 青色の画像名を返す
  if ([item hasDueDate]) {
    return check ? kBlueCheckedImageName : kBlueUncheckedImageName;
  }
  // 期限を持たない場合
  // 灰色(デフォルト)の画像名を返す
  return check ? kCheckedImageName : kUncheckedImageName;
}

/**
 * @brief  チェックボックスを更新する
 *
 * @param isChecked 設定したいチェックの状態
 *
 * @return 変更後のチェックの状態
 */
-(BOOL)updateCheckBoxWithItem:(Item *)item
{
  // 目的の状態を取得する
  BOOL check = ! item.state;
  
  // 変更先の状態に合わせて分岐する
  if (check) {
    [self setCheckedWithItem:item];
    return YES;
  } else {
    [self setUnCheckedWithItem:item];
    return NO;
  }
}

/**
 * チェックをつける
 */
-(void)setCheckedWithItem:(Item *)item
{
  NSString *imgname = [self stringForCheckBoxImageWithItem:item
                                                     check:YES];
  UIImage *img = [UIImage imageNamed:imgname];
  [self.checkBoxImageView setImage:img];
}

/**
 * チェックをはずす
 */
- (void)setUnCheckedWithItem:(Item *)item
{
  UIImage *img
  = [UIImage imageNamed:[self stringForCheckBoxImageWithItem:item
                                                       check:NO]];
  [self.checkBoxImageView setImage:img];
}


@end
