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

///**
// * 初期化する
// */
//- (id)initWithStyle:(UITableViewCellStyle)style
//    reuseIdentifier:(NSString *)reuseIdentifier
//{
//  /* superで初期化 */
//  self = [super initWithStyle:style
//              reuseIdentifier:reuseIdentifier];
//  if (self)
//  {
//    self.reminderLabel.text = @"none";
//  }
//  return self;
//}

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
  if ([item isDueToToday]) {
    if (check) {
      return kYellowCheckedImageName;
    } else {
      return kYellowUncheckedImageName;
    }
  }
  if ([item isOverDue]) {
    if (check) {
      return kRedCheckedImageName;
    } else {
      return kRedUncheckedImageName;
    }
  }
  if ([item hasDueDate]) {
    if (check) {
      return kBlueCheckedImageName;
    } else {
      return kBlueUncheckedImageName;
    }
  }
  if (check) {
    return kCheckedImageName;
  } else {
    return kUncheckedImageName;
  }
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
  BOOL check = ! item.state;
  if (check) {
    [self setCheckedWithItem:item];
    return TRUE;
  } else {
    [self setUnCheckedWithItem:item];
    return FALSE;
  }
}

/**
 * チェックをつける
 */
-(void)setCheckedWithItem:(Item *)item
{
  LOG(@"チェックを付ける");
  NSString *imgname = [self stringForCheckBoxImageWithItem:item
                                                     check:YES];
  LOG(@"%@", imgname);
  UIImage *img = [UIImage imageNamed:imgname];
  [self.checkBoxImageView setImage:img];
}

/**
 * チェックをはずす
 */
- (void)setUnCheckedWithItem:(Item *)item
{
  LOG(@"チェックを外す");
  UIImage *img
  = [UIImage imageNamed:[self stringForCheckBoxImageWithItem:item
                                                       check:NO]];
  [self.checkBoxImageView setImage:img];
}


@end
