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

- (UIView *)createCheckBox;
- (UILabel *)createTitleLabel;

@end


@implementation Cell

/* ===  FUNCTION  ==============================================================
 *        Name: createCheckBox
 * Description:
 * ========================================================================== */
-(UIView *)createCheckBox
{
  NSLog(@"%s", __FUNCTION__);
  UIView *newCheckBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
  if (self.check == true) {
    [newCheckBox setBackgroundColor:[UIColor redColor]];
  } else {
    [newCheckBox setBackgroundColor:[UIColor greenColor]];
  }
  return newCheckBox;
}
/* ===  FUNCTION  ==============================================================
 *        Name: createTitleLabel
 * Description:
 * ========================================================================== */
-(UILabel *)createTitleLabel
{
  NSLog(@"%s", __FUNCTION__);
  UILabel *newTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 40)];
  return newTitleLabel;
}

/* ===  FUNCTION  ==============================================================
 *        Name: initWithStyle
 * Description: 初期化する
 * ========================================================================== */

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  /* superで初期化 */
  self = [super initWithStyle:style
              reuseIdentifier:reuseIdentifier];

  if (self) {
    NSLog(@"%s", ">>> init Cell");

    /* チェックボックスを作成 */
    self.checkBox = [self createCheckBox];
    [self.contentView addSubview:self.checkBox];

    /* タイトルラベルを作成 */
    self.titleLabel = [self createTitleLabel];
    [self.contentView addSubview:self.titleLabel];
//    int _checkbox_width = 40;
//    checkBoxTrue = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                            0,
//                                                            _checkbox_width,
//                                                            _checkbox_width)];
//    checkBoxFalse = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                             0,
//                                                             _checkbox_width,
//                                                             _checkbox_width)];
//
//    [checkBoxTrue setBackgroundColor:[UIColor redColor]];
//    [checkBoxFalse setBackgroundColor:[UIColor blackColor]];
//    self.checkBox = checkBoxFalse;

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