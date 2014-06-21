//
//  Cell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/05/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "Cell.h"


@interface Cell ()

-(void)setChecked;
-(void)setUnChecked;

@end


@implementation Cell


/* ===  FUNCTION  ==============================================================
 *        Name: updateCheckBox
 * Description: チェックボックスを更新
 * ========================================================================== */
-(BOOL)updateCheckBox:(BOOL)isChecked
{
  if (isChecked) {
    [self setChecked];
    return TRUE;
  } else {
    [self setUnChecked];
    return FALSE;
  }
}

/* ===  FUNCTION  ==============================================================
 *        Name: initWithStyle
 * Description: 初期化する
 * ========================================================================== */

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  NSLog(@"%s", ">>> init Cell");

  /* superで初期化 */
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

  if (self)
  {
    /* initialize */
  }
  return self;
}

/* ===  FUNCTION  ==============================================================
 *        Name: touchesBegan
 * Description: タッチされたときの処理
 * ========================================================================== */

-(void)touchesBegan:(NSSet *)touches
          withEvent:(UIEvent *)event
{
  CGFloat _left_side = 50; // チェックボックスの範囲
  CGPoint location = [[touches anyObject] locationInView:self.contentView];
  UITouch *touch = [touches anyObject]; // ここらへん分からん

  NSLog(@"%s", __FUNCTION__);
  NSLog(@"%f", location.x);
  if (location.x < _left_side) {                                     // チェックボックスなら
//    [self turnChecked];                                              // チェックボックスを変更する
    [self.delegate tappedCheckBox:self touch:touch]; // 自分と場所を渡す
  } else {                                                           // そうでなければ
    [super touchesBegan:touches withEvent:event];                    // デフォルトの処理をする

  }
}

/* ===  FUNCTION  ==============================================================
 *        Name: setChecked
 * Description:
 * ========================================================================== */
-(void)setChecked
{
  NSLog(@"%s", ">>> check");
  UIImage *check_true = [UIImage imageNamed:@"CheckBox_True.png"];
  [self.imageView setImage:check_true];
}

/* ===  FUNCTION  ==============================================================
 *        Name: setUnChecked
 * Description:
 * ========================================================================== */
- (void)setUnChecked
{
  NSLog(@"%s", ">>> uncheck");
  UIImage *check_false = [UIImage imageNamed:@"CheckBox_False.png"];
  [self.imageView setImage:check_false];
}


@end
