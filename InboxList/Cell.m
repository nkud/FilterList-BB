//
//  Cell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/05/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "Cell.h"


@interface Cell () {
  UIView *checkBoxTrue;
  UIView *checkBoxFalse;
}

- (void)updateCheckBox;

@end


@implementation Cell

/* ===  FUNCTION  ==============================================================
 *        Name: updateCheckBox
 * Description:
 * ========================================================================== */
-(void)updateCheckBox
{
  NSLog(@"%s", __FUNCTION__);
  if (self.check == true) {
    UIImage *check_true = [UIImage imageNamed:@"CheckBox_True.png"];
    [self.imageView setImage:check_true];
  } else {
    UIImage *check_false = [UIImage imageNamed:@"CheckBox_False.png"];
    [self.imageView setImage:check_false];
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
  self = [super initWithStyle:style
              reuseIdentifier:reuseIdentifier];

  if (self)
  {
    /* チェックボックスを更新 */
    [self updateCheckBox];
  }
  return self;
}


/* ===  FUNCTION  ==============================================================
 *        Name: setFrame
 * Description: フレームをセットする
 * ========================================================================== */

-(void)setFrame:(CGRect)frame
{
  //    frame.origin.x += 40;
  //    frame.size.width -= 80;

  [super setFrame:frame];
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

  NSLog(@"%f", location.x);
  if (location.x < _left_side) {                                     // チェックボックスなら
    [self turnChecked];                                              // チェックボックスを変更する
  } else {                                                           // そうでなければ
    [super touchesBegan:touches withEvent:event];                    // デフォルトの処理をする

  }
}

/* ===  FUNCTION  ==============================================================
 *        Name: turnChecked
 * Description:
 * ========================================================================== */
- (void)turnChecked
{
  NSLog(@"%s", ">>> check");
  self.checkBox = checkBoxTrue;
}

/* ===  FUNCTION  ==============================================================
 *        Name: turnUnChecked
 * Description:
 * ========================================================================== */
- (void)turnUnchecked
{
  NSLog(@"%s", ">>> uncheck");
  self.checkBox = checkBoxFalse;
}


@end
