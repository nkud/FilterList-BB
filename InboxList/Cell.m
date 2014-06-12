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

- (void)setRightField;

@end


@implementation Cell

/* ===  FUNCTION  ==============================================================
 *        Name: initWithStyle
 * Description: 初期化する
 * ========================================================================== */

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style
              reuseIdentifier:reuseIdentifier];

  if (self) {
    NSLog(@"%s", ">>> init Cell");

    // チェックボックスを初期化する
    int _checkbox_width = 40;
    checkBoxTrue = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            _checkbox_width,
                                                            _checkbox_width)];
    checkBoxFalse = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             _checkbox_width,
                                                             _checkbox_width)];
    // 背景を初期化する
    [checkBoxTrue setBackgroundColor:[UIColor redColor]];
    [checkBoxFalse setBackgroundColor:[UIColor blackColor]];
    self.checkBox = checkBoxFalse;

    // チェックボックスをビューに追加する
    [self.contentView addSubview:self.checkBox];

    // 右フィールドをビューに追加する
    // [self setRightField];

    UILabel *label
    = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                0,
                                                self.frame.size.width - 40,
                                                self.frame.size.height)];
    [label setBackgroundColor:[UIColor greenColor]];
    //        [self.contentView addSubview:label];
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
 *        Name: setRightField
 * Description: フィールドを追加する
 * ========================================================================== */
- (void)setRightField
{
  // ビューを作成
  self.rightField = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
  [self.rightField setBackgroundColor:[UIColor redColor]];

  // ビューにセットする
  [self.contentView addSubview:self.rightField];
}

/* ===  FUNCTION  ==============================================================
 *        Name: touchesBegan
 * Description: タッチされたときの処理
 * ========================================================================== */

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGFloat _left_side = 40;
  CGPoint location = [[touches anyObject] locationInView:self.contentView];

  NSLog(@"%f", location.x);
  if (location.x < _left_side) { // チェックボックスなら
    // チェックボックスを変更する
    [self turnChecked];

  } else {
    // デフォルトの処理をする
    [super touchesBegan:touches withEvent:event];

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