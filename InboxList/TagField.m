//
//  TagField.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/27.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "TagField.h"

/**
 *  グローバル変数
 */
NSString *place_holter = @"input filter...";

/**
 *  実装
 */
@implementation TagField

/**
 *  初期化
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
      [self setPlaceholder:place_holter]; // プレースホルダを設定
      [self setBorderStyle:UITextBorderStyleRoundedRect]; // 境界を設定
      self.duration = 0.2f;
    }
    return self;
}

/**
 *  バックスペースが押された時の処理
 */
-(void)deleteBackward
{
  [self.delegate backspaceWillDown:self];
  [super deleteBackward];
}

/**
 *  入力状態
 */
- (void)stateInput
{
  [self setBackgroundColor:[UIColor whiteColor]];
  [self setTextColor:[UIColor blackColor]];
//  [UIView animateWithDuration:self.duration
//                   animations:^{
//                     [self setBackgroundColor:[UIColor whiteColor]];
//                     [self setTextColor:[UIColor blackColor]];
//                   } completion:^(BOOL finished) {
//                     NSLog(@"%@", @"入力状態");
//                   }];
//
}

/**
 *  確定状態
 */
- (void)stateFixed
{
  [self setBackgroundColor:[UIColor blueColor]];
  [self setTextColor:[UIColor whiteColor]];
//  [UIView animateWithDuration:self.duration
//                   animations:^{
//                     [self setBackgroundColor:[UIColor blueColor]];
//                     [self setTextColor:[UIColor whiteColor]];
//                   } completion:^(BOOL finished) {
//                     NSLog(@"%@", @"確定状態");
//                   }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
