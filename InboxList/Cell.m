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


/**
 * 初期化する
 */
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  /* superで初期化 */
  self = [super initWithStyle:UITableViewCellStyleSubtitle
              reuseIdentifier:reuseIdentifier];

  if (self)
  {
    self.detailTextLabel.text = @"none";
  }
  return self;
}

/**
 * チェックボックスを更新する
 */
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

/**
 * タッチされた時の処理
 */
-(void)touchesBegan:(NSSet *)touches
          withEvent:(UIEvent *)event
{
  CGFloat _left_side = 50; // チェックボックスの範囲
  CGPoint location = [[touches anyObject] locationInView:self.contentView];
  UITouch *touch = [touches anyObject]; // ここらへん分からん

  if (location.x < _left_side) {                                     // チェックボックスなら
    [self.delegate tappedCheckBox:self touch:touch]; // 自分と場所を渡す
  } else {                                                           // そうでなければ
    [super touchesBegan:touches withEvent:event];                    // デフォルトの処理をする

  }
}

/**
 * チェックをつける
 */
-(void)setChecked
{
  UIImage *check_true = [UIImage imageNamed:@"CheckBox_True.png"];
  [self.imageView setImage:check_true];
}

/**
 * チェックをはずす
 */
- (void)setUnChecked
{
  UIImage *check_false = [UIImage imageNamed:@"CheckBox_False.png"];
  [self.imageView setImage:check_false];
}


@end
